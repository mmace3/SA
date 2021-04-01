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

       # fyear  = fyear,
       # lyear  = lyear,
       # nyears = nyears,
       # years  = years,
       # fage   = fage,
       # lage   = lage,
       # ages   = ages,
       # nages  = nages,
       # M      = M,
       # Csd    = Csd,
       # Ceffn  = Ceffn,
       # C_obs  = C_obs,
       # C_obs_total    = C_obs_total,
       # C_ageprop_obs  = C_ageprop_obs,
       # Isd    = Isd,
       # Ieffn  = Ieffn,
       # I_obs  = I_obs,
       # I_obs_total    = I_obs_total,
       # I_ageprop_obs  = I_ageprop_obs

SCAA_1_ADMB_data <-
  list(
      SCAA_1_sim_data$fyear,
      SCAA_1_sim_data$lyear,
      SCAA_1_sim_data$fage,
      SCAA_1_sim_data$lage,
      SCAA_1_sim_data$M,
      SCAA_1_sim_data$Csd,
      SCAA_1_sim_data$Ceffn,
      SCAA_1_sim_data$C_obs_total,
      SCAA_1_sim_data$C_ageprop_obs,
      SCAA_1_sim_data$Isd,
      SCAA_1_sim_data$Ieffn,
      SCAA_1_sim_data$I_obs_total,
      SCAA_1_sim_data$I_ageprop_obs,
      eofcheck <- 1234
  )

# Create list with short description for each piece of data in SCAA_1_sim_data
# This text will be included in .dat file along with simulated data.

SCAA_1_ADMB_text <-
  list(
       "first year",
       "last year",
       "first age",
       "last age",
       "natural mortality",
       "standard deviation for total catch",
       "effective sample size for fishery proportion at age in catch",
       "total catch for fishery",
       "proportion at age in catch each year",
       "standard deviation for survey index",
       "effective sample size for survey proportion at age in catch",
       "index for survey",
       "proportion at age in survey each year",
       "eof check"
      )


# Create .data file using create_dat_file() function


create_dat_file(SCAA_1_ADMB_data, SCAA_1_ADMB_text,
                meta = c("SCAA One Model", "Marvin Mace III"),
                f = "SCAA_1", d = paste(getwd(), sep = ""))






