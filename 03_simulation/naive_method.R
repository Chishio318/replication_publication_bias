#-------------------#
# naive method
# This R file contains additional functions to compute
# the meta-analysis estimates without bias correction.
# The structure is as follows:
#
##1. outer algorithm
#    - naive
#    - naive_converge
##2. inner algorithm
#    - naive_compute
#
# Note that the computation process uses some inputs
# from the stem-based method since the structure of the code
# resembles with one another. In particular, it uses the following:
#    - param (vector)
#    - variance_b
#    - variance_0
#    - weighted_mean
#    - weighted_mean_squared
#-------------------#

##0 set naive parameter
tolerance = 10^(-4) #set level of sufficiently small stem to determine convergence
max_N_count = 10^3 #set maximum number of iteration before termination
naive_param <- c(tolerance, max_N_count)

##1 outer algorithm
naive <- function(beta, se, param){
  #Initial Values
  N_study <- length(beta)
  
  # sending sigma0->infinity implies equal weights to all studies
  beta_equal <- mean(beta)
  max_sigma_squared <- variance_0(N_study, beta, se, beta_equal)
  max_sigma = sqrt(max_sigma_squared)
  min_sigma = 0
  tolerance = param[1]
  
  #Sorting data by ascending order of standard error
  data1 <- cbind(beta,se)
  data_sorted <- data1[order(data1[,2]),]
  beta_sorted <- data_sorted[,1]
  se_sorted <- data_sorted[,2]
  
  #Compute naive estimates until convergence from max and min of sigma
  Y_max <- naive_converge(max_sigma, beta_sorted, se_sorted, param)
  Y_min <- naive_converge(min_sigma, beta_sorted, se_sorted, param)
  
  
  #Check whether max and min agree
  diff_sigma <- abs(Y_max[3] -  Y_min[3])
  if (diff_sigma > (2*tolerance)){
    multiple = 1
  }
  else{
    multiple = 0
  }
  
  #information in sample
  n_naive <- Y_max[4]
  sigma0 <- Y_max[3]
  inv_var <- 1/(se_sorted^2+sigma0^2)
  info_in_sample = sum(inv_var[1:n_naive])/sum(inv_var)
  
  #Return
  Y = c(Y_max, multiple, info_in_sample)
  return(Y)
}

naive_converge <- function(initial_sigma, beta_sorted, se_sorted, param){
  converged = 0
  N_count = 0
  tolerance = param[1]
  max_N_count = param[2]
  sigma0 = initial_sigma
  
  while (converged == 0){
    Y_naive <- naive_compute(beta_sorted, se_sorted, sigma0)
    sigma = Y_naive[3]
    evolution = abs(sigma0 - sigma)
    N_count = N_count + 1
    
    if (evolution<tolerance){
      converged = 1
    }
    else if (N_count > max_N_count){
      converged = 1
    }
    else{
      sigma0 = sigma
    }
  }
  Y <- c(Y_naive, N_count)
  return(Y)
}

##2 inner algorithm
naive_compute <- function(beta, se, sigma0){
  
  N_study = length(beta)
  
  # mean
  Eb_all = weighted_mean(beta, se, sigma0)
  
  # variance
  Var_all = variance_b(se, sigma0)
  
  
  # assign values
  beta_naive = Eb_all[N_study]
  se_naive = Var_all[N_study]^(0.5)
  var_naive = variance_0(N_study, beta, se, beta_naive)
  sigma_naive = sqrt(var_naive)
  
  
  # stack outputs
  Y <- cbind(beta_naive,se_naive,sigma_naive,N_study)
  return(Y)
}

