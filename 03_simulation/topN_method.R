#-------------------#
# topN method
# This R file contains functions necessary to compute
# the meta-analysis estimates by using N percents of
# most precise studies.
# This code allows to examine the top 10 estimator proposed in
# -----
# Stanley, T. D., Stephen B. Jarrell, and Hristos Doucouliagos. 2010. 
# "Could It Be Better to Discard 90% of the Data? A Statistical Paradox."
# The American Statistician 64 (1): 70???77. 
# -----
#
# Note that the computation process uses some inputs
# from the stem-based method since the structure of the code
# resembles with one another. In particular, it uses the following:
#    - variance_b
#    - variance_0
#    - weighted_mean
#-------------------#

topN <- function(beta,se,percentN){
  
  N_study <- length(beta)
  beta_equal <- mean(beta)
  
  sigma_initial <- 0
  beta_initial <- weighted_mean(beta, se, sigma_initial)

  var0 = variance_0(N_study, beta, se, beta_initial)
  sigma0 = sqrt(var0)
  
  #Sorting data by SE
  data1 <- cbind(beta,se)
  data_sorted <- data1[order(data1[,2]),]
  beta_sorted <- data_sorted[,1]
  se_sorted <- data_sorted[,2]
  
  Eb_all = weighted_mean(beta_sorted, se_sorted, sigma0)
  Var_all = variance_b(se, sigma0)
  
  N_include = floor(N_study*percentN)
  beta_topN <- Eb_all[N_include]
  se_topN = Var_all[N_include]^(0.5)
  var_topN = variance_0(N_include, beta_sorted, se_sorted, beta_topN)
  sigma_topN = sqrt(var_topN)
  
  Y = c(beta_topN, se_topN, sigma_topN)
  return(Y)
  
}