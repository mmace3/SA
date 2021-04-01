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
  init_vector C(1,nyears) // catch at age in fishery
  init_matrix C_ageprop_obs(1,nyears,fage,lage) //proportion at age in fishery
  init_number I_sd //standard deviation for survey index
  init_number I_effn //effective sample size for survey index  at age props
  init_vector I(1,nyears) //observed index
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
    cout << "C" << endl; cout << C << endl;
    cout << "C_ageprop_obs" << endl; cout << C_ageprop_obs << endl;
    cout << "I_sd" << endl; cout << I_sd << endl;
    cout << "I_effn" << endl; cout << I_effn << endl;
    cout << "I" << endl; cout << I << endl;
    cout << "I_ageprop_obs" << endl; cout << I_ageprop_obs << endl;
    cout << "eofcheck" << endl; cout << eofcheck << endl;

    exit(1);
  }




 END_CALCS

PARAMETER_SECTION
  // The parameter section is where we specify the parameters to be estimated (init)
  // and any other values that will depend on the estimated parameters (i.e., variables)


  objective_function_value neg_LL  //value we are going to minimize



  LOCAL_CALCS
  // This local calcs section is used to execute code in the parameter section.
  // Functions defined below are available in this local calcs section.

  
 END_CALCS

INITIALIZATION_SECTION
  // Section that can be used to provide starting values for parameters

PRELIMINARY_CALCS_SECTION
  // Calculations to do before entering the procedure section

  
PROCEDURE_SECTION
  // In the procedure section we specify the model and the likelihood.


REPORT_SECTION
  // The report section is used to write output to the standard output "filename.rep"

RUNTIME_SECTION
  // This section is used to modify the convergence criteria such as the 
  // maximum number of iterations and the maximum gradient component

  // Leave at least one empty line below here

