#-------------------------------------------------------------------------------
# INFO FOR CODE IN THIS FILE
#-------------------------------------------------------------------------------

# Date Created: 31 March 2021
# Created By: Marvin Mace

# Code in this file is for creating a .dat file for the ADMB version of
# SCAA_1.

#-------------------------------------------------------------------------------
# Load packages, set options
#-------------------------------------------------------------------------------

library(ADMBtools) # for writing out .dat file for ADMB model


#-------------------------------------------------------------------------------
# Read in data
#-------------------------------------------------------------------------------

# Need to read in list with simulated data for SCAA_1
# (This list with simulated data is created in create_data_SCAA.R)

SCAA_1_sim_data <- readRDS("SCAA_1_sim_data.RDS")

#-------------------------------------------------------------------------------


# Create list with short description for each piece of data in SCAA_1_sim_data
# This text will be included in .dat file along with simulated data.

SCAA_1_sim_data_text <-
  list(
       "first year",
       "last year",
       "number of years",
       "vector of years",
       "first age",
       "last age",
       "vector of ages",
       "number of ages",
       "natural mortality",
       "standard deviation for total catch",
       "effective sample size for fishery proportion at age in catch",
       "catch at age matrix for fishery",
       "total catch by year",
       "proportion at age in catch each year",
       "standard deviation for survey index",
       "effective sample size for survey proportion at age in catch",
       "catch at age matrix for survey",
       "total catch by year in survey",
       "proportion at age in survey each year"
      )


# Create .data file using create_dat_file() function


create_dat_file(SCAA_1_sim_data, SCAA_1_sim_data_text,
                meta = c("SCAA One Model", "Marvin Mace III"),
                f = "SCAA_1", d = paste(getwd(), "/SCAA_1", sep = ""))






