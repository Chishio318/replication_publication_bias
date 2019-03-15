#-------------------#
# estimate_evaluate
# This R file contains additional functions to 
# (1) run various bias correction methods on simulated data; and
# (2) compute coverage probability and average interval length
# across the methods.
# The structure is as follows:
#
##1. outer algorithm
#    - naive
#    - naive_converge
##2. inner algorithm
#    - naive_compute


#-------------------#

##0 prepare for simulation
# set simulation parameters
n_methods = 4 #run 4 different estimation methods
n_data = 3 #run on 3 different sets of data
n_store = 4 #store 4 different values from each estimation

# percentN = 0.1, if run top10 percent

# combine simulated data
data_beta <- array(c(beta_noselection, beta_uniform, beta_extremum), dim=c(N_sim,N_study,n_data))
data_se <- array(c(se_noselection, se_uniform, se_extremum), dim=c(N_sim,N_study,n_data))

# storage of estimates
store_estimates <- array(0, dim=c(N_sim,n_store,n_methods,n_data))
# storage of statistics
coverage_probabilities <- matrix(0,n_data,n_methods)
interval_length <- matrix(0,n_data,n_methods)
measure_one <- matrix(0,n_data,n_methods)
measure_two <- matrix(0,n_data,n_methods)
uniform_error <- matrix(0,n_data,1)

##1 run estimation methods
start.time <-Sys.time()
for (k in 1:n_data){
  # take data
  beta_sample <- data_beta[,,k]
  se_sample <- data_se[,,k]
  var_sample <- se_sample^2
  
  count_uniform <- 1
  
  for (i in 1:N_sim){

    #1) naive (without bias correction)
    naive_id = 1
    Y <- naive(beta_sample[i,],se_sample[i,], param)
    store_estimates[i,1,naive_id,k] <- Y[1]-qnorm(alpha_level)*Y[2] #lower_bound
    store_estimates[i,2,naive_id,k] <- Y[1]+qnorm(alpha_level)*Y[2] #upper_bound
    store_estimates[i,3,naive_id,k] <- Y[3] #between study standard deviation
    store_estimates[i,4,naive_id,k] <- Y[4] #n_studies

    
    
    #2) stem estimate
    stem_id = 2
    Y <- stem(beta_sample[i,],se_sample[i,], param)$estimates
    store_estimates[i,1,stem_id,k] <- Y[1]-qnorm(alpha_level)*Y[2] #lower_bound
    store_estimates[i,2,stem_id,k] <- Y[1]+qnorm(alpha_level)*Y[2] #upper_bound
    store_estimates[i,3,stem_id,k] <- Y[3] #between study standard deviation
    store_estimates[i,4,stem_id,k] <- Y[4] #n_studies
    
    #3) uniform estimate
    uniform_id = 3
    weightr_output <- try(weightfunct(beta_sample[i,], var_sample[i,], steps=c(0.025, 0.975)))
    if (inherits(weightr_output, "try-error")){
      store_estimates[i,4,uniform_id,k] <- 1
    } else {
      param_estimates <- weightr_output[[2]]$`par`
      Hessian_estimates <- weightr_output[[2]]$hessian
      var_beta <- try(solve(Hessian_estimates))
      if (inherits(var_beta, "try-error")){
        store_estimates[i,4,uniform_id,k] <- 1
      } else{
        if (var_beta < 0) {
          store_estimates[i,4,uniform_id,k] <- 1
        } else {
          se_betaestimate <- sqrt(var_beta[2,2])
          store_estimates[i,1,uniform_id,k] <- param_estimates[2]-qnorm(alpha_level)*se_betaestimate
          store_estimates[i,2,uniform_id,k] <- param_estimates[2]+qnorm(alpha_level)*se_betaestimate
          store_estimates[i,3,uniform_id,k] <- param_estimates[3]
        }
      }
      
      #4) trimfill estimate
      trimfill_id = 4
      res <-  rma(yi = beta_sample[i,], vi = var_sample[i,], method="DL")
      temp_save <- try(trimfill(res))
      if (inherits(temp_save, "try-error")){
        store_estimates[i,4,trimfill_id,k] <- 1
      } else {
        store_estimates[i,1,trimfill_id,k] <- as.numeric(temp_save[6])
        store_estimates[i,2,trimfill_id,k] <- as.numeric(temp_save[7])
        store_estimates[i,3,trimfill_id,k] <- as.numeric(temp_save[12])
      }
    }
    


    # #5) top N estimate
    # top_id = 5
    # Y <- topN(beta_sample[i,],se_sample[i,],percentN)
    # store_estimates[i,1,top_id,k] <- Y[1]-qnorm(alpha_level)*Y[2] #lower_bound
    # store_estimates[i,2,top_id,k] <- Y[1]+qnorm(alpha_level)*Y[2] #upper_bound
    # store_estimates[i,3,top_id,k] <- Y[3]


  }
  
#3. measure statistics
  examineerror_id = 3
  #computing summary statistics for each method
  for (j in 1:n_methods){ 
    covered <- (b0_true > store_estimates[,1,j,k]) & (b0_true < store_estimates[,2,j,k])
    coverage_probability <- sum(covered, na.rm=TRUE)
    interval = store_estimates[,2,j,k] - store_estimates[,1,j,k]
    if (j < examineerror_id){
      coverage_probabilities[k,j] <- coverage_probability/ N_sim
      interval_length[k,j] <- mean(interval)
      measure_one[k,j] <- mean(store_estimates[,3,j,k])
      measure_two[k,j] <- mean(store_estimates[,4,j,k])
      
    } else {
      N_error <- sum(store_estimates[,4,j,k])
      coverage_probabilities[k,j] <- coverage_probability/(N_sim - N_error)
      interval_length[k,j] <- sum(interval)/(N_sim - N_error)
      measure_one[k,j] <- sum(store_estimates[,3,j,k])/(N_sim - N_error)
      measure_two[k,j] <- N_error
    }
  }
  
  
}
end.time <-Sys.time()
time.taken <-round(end.time - start.time, 2)

