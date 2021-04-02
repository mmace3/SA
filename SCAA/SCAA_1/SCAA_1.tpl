// SCAA_1 - Statistical Catch at Age Model One
// CREATED BY: Marvin Mace
// DATE CREATED: 23 March 2021

// Minimal catch at age model implemented in ADMB.

// Data sources: catch at age, one fishery independent index

GLOBALS_SECTION
  // The globals section is used to refer to other C++ code or can
  // be used to create string variables


TOP_OF_MAIN_SECTION
  // The top of main section is used to modify defaults of variables like the 
  // maximum number of parameters and the amount of memory to allocate for
  // the program


DATA_SECTION
  // The data section is where we read in data 
  // and specify any constants (or randomly generated numbers)
 
  init_int fyear
  init_int lyear
  int nyears
  !!nyears = lyear - fyear + 1;
  init_int fage
  init_int lage
  init_number M //instantaneous natural mortality rate
  init_number C_sd //standard deviation for catch
  init_number C_effn //effective sample size for catch at age props
  init_vector C_obs(1,nyears) // catch at age in fishery
  init_matrix C_ageprop_obs(1,nyears,fage,lage) //proportion at age in fishery
  init_number I_sd //standard deviation for survey index
  init_number I_effn //effective sample size for survey index  at age props
  init_vector I_obs(1,nyears) //observed index
  init_matrix I_ageprop_obs(1,nyears,fage,lage) //proportion at age in survey
  init_int eofcheck //end of file check for data

  // looping variables
  int y // year
  int a // age

 LOCAL_CALCS
  // The local calcs section is used to execute code in the data section.
  // Functions defined below are not available in this local calcs section.

  // Make sure data is begin read in properly
  
  if(eofcheck != 1234)
  {
  
    cout << "Input not reading properly!" << endl;
    cout << "fyear" << endl; cout << fyear << endl;
    cout << "lyear" << endl; cout << lyear << endl;
    cout << "nyrs" << endl; cout << nyears << endl;
    cout << "fage" << endl; cout << fage << endl;
    cout << "lage" << endl; cout << lage << endl;
    cout << "M" << endl; cout << M << endl;
    cout << "C_sd" << endl; cout << C_sd << endl;
    cout << "C_effn" << endl; cout << C_effn << endl;
    cout << "C_obs" << endl; cout << C_obs << endl;
    cout << "C_ageprop_obs" << endl; cout << C_ageprop_obs << endl;
    cout << "I_sd" << endl; cout << I_sd << endl;
    cout << "I_effn" << endl; cout << I_effn << endl;
    cout << "I_obs" << endl; cout << I_obs << endl;
    cout << "I_ageprop_obs" << endl; cout << I_ageprop_obs << endl;
    cout << "eofcheck" << endl; cout << eofcheck << endl;

    exit(1);
  }




 END_CALCS

PARAMETER_SECTION
  // The parameter section is where we specify the parameters to be estimated (init)
  // and any other values that will depend on the estimated parameters (i.e., variables)

  init_number log_mean_R(1) // mean recruitment
  init_bounded_dev_vector log_R_devs(1,nyears,-20,20,1)//recruitment deviations for each year
  init_number log_mean_N0(1)  //abundance at age in first year
  init_bounded_dev_vector log_N0_devs(fage+1,lage,-20,20,1)
  init_number log_mean_F(1)
  init_bounded_dev_vector log_F_devs(1,nyears,-10,10,1)

  init_vector log_selfp(1,2,1) //log of fishery selectivity parameters
  init_vector log_selsp(1,2,1) //log of survey selectivity parameters
  init_number log_q(1)  //catchability


  matrix N(1,nyears,fage,lage) //abundance at age matrix
  matrix F(1,nyears,fage,lage) //fishing mortality at age matrix
  matrix Z(1,nyears,fage,lage) //total mortality
  matrix C(1,nyears,fage,lage) //catch at age matrix
  matrix I(1,nyears,fage,lage) //index matrix
  vector C_est(1,nyears) //estimated total catch
  matrix C_ageprop_est(1,nyears,fage,lage) //catch age proportions
  vector I_est(1,nyears) //estimated index
  matrix I_ageprop_est(1,nyears,fage,lage) //index age proportions
  vector self(fage,lage) //fishing selectivity
  number q //survey catchability
  vector sels(fage,lage) // survey selectivity
  number nLL1
  number nLL2
  number nLL3
  number nLL4
  
  objective_function_value neg_LL  //value we are going to minimize



  LOCAL_CALCS
  // This local calcs section is used to execute code in the parameter section.
  // Functions defined below are available in this local calcs section.

  //set starting values

  log_mean_R=log(1000);

  log_mean_N0=log(1000);

  log_selfp(1)=log(1.5);
  log_selfp(2)=log(3);
  
  log_selsp(1)=log(1);
  log_selsp(2)=log(1.5);

  log_q=log(0.0001);

  log_mean_F=log(0.4);

 END_CALCS

INITIALIZATION_SECTION
  // Section that can be used to provide starting values for parameters

PRELIMINARY_CALCS_SECTION
  // Calculations to do before entering the procedure section

  
PROCEDURE_SECTION
  // In the procedure section we specify the model and the likelihood.

  backtransform();
  calc_mortality();
  calc_abundance();
  calc_catch();
  calc_survey();
  calc_nLL();

FUNCTION backtransform

  for(a=fage;a<=lage;a++)
  {
    self(a)=1.0/(1.0+exp(-exp(log_selfp(1))*(double(a)-exp(log_selfp(2)))));
    sels(a)=1.0/(1.0+exp(-exp(log_selsp(1))*(double(a)-exp(log_selsp(2)))));
  }
  //cout << self << endl << sels << endl;
  //exit(1);
  q=exp(log_q);


FUNCTION calc_mortality

  for(y=fyear;y<=lyear;y++)
  {
    F(y)=self*exp(log_mean_F+log_F_devs(y));
  }
  //F=outer_prod(f,self); //vectors to matrix
  Z=F+M;

FUNCTION calc_abundance
  N(1)(fage+1,lage)=exp(log_mean_N0+log_N0_devs);

  for(y=fyear;y<=nyears;y++)
  {
  
    N(y,fage)=exp(log_mean_R+log_R_devs(y));

  }

  for(y=fyear;y<nyears;y++)
  {
    for(a=fage;a<lage;a++)
    {

      N(y+1,a+1)=N(y,a)*exp(-Z(y,a));

    }

    N(y+1,lage)+=N(y,lage)*exp(-Z(y,lage));

  }

FUNCTION calc_catch

  C=elem_prod(elem_div(F,Z),elem_prod(1.0-exp(-1.0*Z),N));

  C_est=rowsum(C);

  for(y=fyear;y<=nyears;y++)
  {

    C_ageprop_est(y)=C(y)/C_est(y);
  
  }

FUNCTION calc_survey

  for(y=fyear;y<=nyears;y++)
  {

    I(y)=q*elem_prod(sels,N(y));

  }

  I_est=rowsum(I);

  for(y=fyear;y<=nyears;y++)
  {

     I_ageprop_est(y)=I(y)/I_est(y);

  }

FUNCTION calc_nLL

  //nLL for total catch

  nLL1=(0.5/square(C_sd))*norm2(log(C_obs)-log(C_est));

  //nLL for catch at age props

  nLL2=-C_effn*sum(elem_prod(C_ageprop_obs,log(C_ageprop_est)));

  //nLL for total index catch

  nLL3=(0.5/square(I_sd))*norm2(log(I_obs)-log(I_est));

  //nLL for index catch age props

  nLL4=-I_effn*sum(elem_prod(I_ageprop_obs,log(I_ageprop_est)));

  //nLL total
  neg_LL=nLL1+nLL2+nLL3+nLL4;


REPORT_SECTION
  // The report section is used to write output to the standard output "filename.rep"

RUNTIME_SECTION
  // This section is used to modify the convergence criteria such as the 
  // maximum number of iterations and the maximum gradient component

  // Leave at least one empty line below here

