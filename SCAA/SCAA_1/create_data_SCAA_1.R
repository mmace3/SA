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

# parameters for selectivity curve
alpha <- 0.2

# beta
beta <- 0.45

# fishery selectivity (logistic for ages <= 5, 1 for ages > 5)
f_sel <- ifelse(ages <= 5, exp(alpha + beta*ages)/(1 + exp(alpha + beta*ages)), 1)

# Fishing mortality
F <- F_full*f_sel

# natural mortality rate
M <- 0.2

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

# create matrix for catch at age in fishery independent survey
I_obs <- matrix(0, nrow = nyears, ncol = nages)

# catchability for fishery independent survey
I_q <- 0.001

for(i in 1:(nyears))
{

  I_obs[i,] <- I_q*f_sel*N_pop[i,]

}

I_obs_total <- rowSums(I_obs)

# create proportion at age for fishery independent survey

I_ageprop_obs <- matrix(0, nrow = nyears, ncol = nages)


for(i in 1:(nyears))
{

  I_ageprop_obs[i,] <- rmultinom(1, size = 100, prob = (I_obs[i,]/I_obs_total[i]))

}


# Need to create age proportion for catch at age in fishery using rmultinom()

# I think that is about all that needs to be done to create all data needed for now



