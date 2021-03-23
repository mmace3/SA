//PROGRAM NAME AND PURPOSE
//CREATED BY:
//DATE CREATED:
//MODIFIED BY:
//LAST MODIFIED


GLOBALS_SECTION
//The globals section is used to refer to other C++ code or can
//be used to create string variables


TOP_OF_MAIN_SECTION
//The top of main section is used to modify defaults of variables like the 
//maximum number of parameters and the amount of memory to allocate for
//the program


DATA_SECTION
//The data section is where we read in data 
//and specify any constants (or randomly generated numbers)

  int nyrs
  int fage
  int lage
  init_vector c_obs(0,nyears)
  init_matrix Cageprop_obs(0,nyears,fage,lage)
  init_vector Iobs(0,nyears) //observed index
  init_matrix Iageprop_obs(0,nyears,fage,lage)
  init_number Csd //standard deviation for catch
  init_number Ceffn //effective sample size for catch at age props
  init_number Isd //standard deviation for survey index
  init_number Ieffn //effective sample size for survey index  at age props
  init_number M
  init_int eofcheck //end of file check for data


  int y //looping
  int a 

 LOCAL_CALCS
  //the local calcs section is used to execute code in the data section.
  //Functions defined below are not available in this local calcs section.
  
 END_CALCS

PARAMETER_SECTION
  //The parameter section is where we specify the parameters to be estimated (init)
  //and any other values that will depend on the estimated parameters (i.e., variables)

  objective_function_value neg_LL  //value we are going to minimize

  LOCAL_CALCS
  //This local calcs section is used to execute code in the parameter section.
  //Functions defined below are available in this local calcs section.
  
  
 END_CALCS

INITIALIZATION_SECTION
//Section that can be used to provide starting values for parameters

PRELIMINARY_CALCS_SECTION
//Calculations to do before entering the procedure section

PROCEDURE_SECTION
//In the procedure section we specify the model and the likelihood.


REPORT_SECTION
//The report section is used to write output to the standard output "filename.rep"

RUNTIME_SECTION
//This section is used to modify the convergence criteria such as the 
//maximum number of iterations and the maximum gradient component

//Leave at least one empty line below here

