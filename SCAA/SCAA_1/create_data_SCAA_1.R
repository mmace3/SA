#-------------------------------------------------------------------------------
# INFO FOR CODE IN THIS FILE
#-------------------------------------------------------------------------------

# Date Created: 23 March 2021
# Created By: Marvin Mace

# Code in this file is for creating simulated data to use in fitting a
# relatively simple statistical catch at age model (SCAA_1). The primary types
# of data created are catch at age data and a fishery independent index of
# abundance.

#-------------------------------------------------------------------------------
# Load packages, set options
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------

# set random seed for reproducibility
set.seed(1235)

# first year
fyear <- 1

# last year
lyear <- 20

# number of years
nyears <- lyear - fyear + 1

# vector of years
years <- c(fyear:lyear)

# first age
fage <- 1

# last age (with plus group)
lage <- 10

# vector of ages
ages <- c(fage:lage)

# number of ages
nages <- lage - fage + 1

# fully selected fishing mortality rate by year
F_full <- 0.6

# parameters for selectivity curve (logistic)
f_sel_pars <- c(1.5, 3)

# fishery selectivity (logistic)
f_sel <- 1/(1 + exp(-fsel_pars[1]*(ages - fsel_pars[2])))

# fishing mortality
F <- F_full*f_sel

# natural mortality rate
M <- 0.15

# total mortality
Z <- F + M

# median recruitment
med_R <- 1000

# standard deviation for log normal recruitment deviations
R_sd <- 0.9

# vector of recruitment deviations
R_devs <- rnorm(nyears, 0, R_sd)

# vector of abundance deviations for age > 1
N_devs <- rnorm(nages, 0, R_sd)

# matrix for population abundance data
N_pop <- matrix(0, nrow = nyears, ncol = nages)

# fill in recruitment for each year

N_pop[,1] <- med_R*exp(R_devs)

# age 2 first in first year
N_pop[1,2] <- N_pop[1,1]*exp(-Z[1])

# age 3 to final age in first year
for(a in 2:(nages-2))
{
  N_pop[1,a+1] <- N_pop[1,a]*exp(-Z[a])
}

# final age (plus group) in first year
N_pop[1,lage] <- N_pop[1,lage-1]*exp(-Z[lage-1])/(1-exp(-Z[lage]))

# add in random noise to first year abundance
N_pop[1,(fage+1):lage] <- N_pop[1,(fage+1):lage]*exp(N_devs[-1])

# fill in rest of ages/years
for(i in 1:(nyears-1))
{

  for(j in 1:(nages-1))
  {
    #print(paste("This is year", i, " age ", j, sep = ""))


    N_pop[i+1,j+1] <- N_pop[i,j]*exp(-Z[j])
  }

  N_pop[i+1,lage] <- N_pop[i+1,lage] + (N_pop[i,lage]*exp(-Z[lage]))

}

# create catch at age matrix
C_obs <- matrix(0, nrow = nyears, ncol = nages)

# fill in catch at age matrix
for(i in 1:(nyears))
{

  for(j in 1:(nages))
  {

    C_obs[i,j] <- (F[j]/Z[j]) * (1-exp(-Z[j])) * N_pop[i,j]

  }

}

# standard deviation for fishery catch
Csd <- 0.1

# total catch each year
C_obs_total <- rowSums(C_obs)*exp(Csd)

# effective sample size for fishery catch at age
Ceffn <- 100

# create proportion at age for catch matrix
C_ageprop_obs <- matrix(0, nrow = nyears, ncol = nages)

# fill in proportion at age for catch matrix
for(i in 1:(nyears))
{

  C_ageprop_obs[i,] <- rmultinom(1, size = Ceffn, prob = (C_obs[i,]/C_obs_total[i]))/Ceffn

}


# create matrix for catch at age in survey
I_obs <- matrix(0, nrow = nyears, ncol = nages)

# catchability for survey
I_q <- 0.001

# selectivity for survey (logistic)

s_sel_pars <- c(1, 1.5)

# survey selectivity (logistic)
s_sel <- 1/(1 + exp(-s_sel_pars[1]*(ages - s_sel_pars[2])))

for(i in 1:(nyears))
{

  I_obs[i,] <- I_q*s_sel*N_pop[i,]

}

# standard deviation for survey index
Isd <- 0.4

# calculate survey index for each year
I_obs_total <- rowSums(I_obs)*exp(Isd)

# create proportion at age for survey
I_ageprop_obs <- matrix(0, nrow = nyears, ncol = nages)

# effective sample size for survey catch at age
Ieffn <- 100

# fill in proportion at age for survey
for(i in 1:(nyears))
{

  I_ageprop_obs[i,] <- rmultinom(1, size = Ieffn, prob = (I_obs[i,]/I_obs_total[i]))/Ieffn

}


# create list to hold all simulated data

SCAA_1_sim_data <-
  list(
       fyear  = fyear,
       lyear  = lyear,
       nyears = nyears,
       years  = years,
       fage   = fage,
       lage   = lage,
       ages   = ages,
       nages  = nages,
       M      = M,
       Csd    = Csd,
       Ceffn  = Ceffn,
       C_obs  = C_obs,
       C_obs_total    = C_obs_total,
       C_ageprop_obs  = C_ageprop_obs,
       Isd    = Isd,
       Ieffn  = Ieffn,
       I_obs  = I_obs,
       I_obs_total    = I_obs_total,
       I_ageprop_obs  = I_ageprop_obs
      )


# save list with simulated to file
saveRDS(SCAA_1_sim_data, file = "SCAA_1_sim_data.RDS")

