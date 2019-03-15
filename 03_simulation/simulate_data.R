#-------------------#
# simulate data
# This R file contains functions necessary to generate
# meta-analyses data sets with simulation
# that assumes each publication selection processes:
# 
# 
# The structure is as follows:
#
##1. input parameters


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

# 1. input parameters
N_sim = 1000
N_study = 80

# underlying distribution
b0_true = 0.4
sigma0_true = 0.3
degree_of_freedom <- 2
max_range <- 4

# selection models
alpha_level = 0.975

inclusion_probability = 0.3
beta_cutoff = -0.1

# auxiliary variables
sim_scaleup = 15
Y_dim = 3
seed_number = 1

# organize statistics
total_N_sim <- sim_scaleup*N_study*N_sim
t_stat = qnorm(alpha_level)
max_pvalue <- pchisq(max_range, df = degree_of_freedom)

# 2. generate random estimates
set.seed(seed_number)
pvalue_distribution = runif(total_N_sim,0,1)*max_pvalue #CDF method to generate Chi2 distribution
var_original2 <- matrix(0,total_N_sim,1)
for (i in 1:total_N_sim) {
  pvalue_value <- pvalue_distribution[i]
  var_original2[i] <- qchisq(pvalue_value, df = degree_of_freedom)/qchisq(max_pvalue, df = degree_of_freedom)
}
se_original <- sqrt(var_original2)
beta_original <- rnorm(total_N_sim,b0_true,(se_original^2+sigma0_true^2)^0.5)

# 3. selection by criteria
# (a) no selection
beta_noselection <- matrix(0,N_sim,N_study)
se_noselection <- matrix(0,N_sim,N_study)
for (i in 0:N_sim-1) {
  beta_noselection[i+1,] <- beta_original[((i*N_study)+1):((i+1)*N_study)]
  se_noselection[i+1,] <- se_original[((i*N_study)+1):((i+1)*N_study)]
}

# (b) uniform and extremum selection
t_original <- beta_original/se_original

beta_uniform <- matrix(0,N_sim,N_study)
se_uniform <- matrix(0,N_sim,N_study)
index_uniform = 1

beta_extremum <- matrix(0,N_sim,N_study)
se_extremum <- matrix(0,N_sim,N_study)
index_extremum = 1

for (i in 1:N_sim){
  for (j in 1:N_study){
    filled_uniform = FALSE
    while (!filled_uniform){
      tval <- abs(t_original[index_uniform])
      inout <- runif(1,0,1)
      if ((tval > t_stat)|(inout < inclusion_probability)){
        beta_uniform[i,j] <- beta_original[index_uniform]
        se_uniform[i,j] <- se_original[index_uniform]
        filled_uniform = TRUE
      }
      index_uniform = index_uniform + 1
    }
    filled_extremum = FALSE
    while (!filled_extremum){
      if (beta_original[index_extremum]>beta_cutoff) {
        beta_extremum[i,j] <- beta_original[index_extremum]
        se_extremum[i,j] <- se_original[index_extremum]
        filled_extremum = TRUE
      }
      index_extremum = index_extremum + 1
    }
  }
}


## saving some data for illustration of stem-based method
# choose_id = 169
# data_sample0 <- rbind(beta_uniform[choose_id,],se_uniform[choose_id,])
# data_sample <- t(data_sample0)
# colnames(data_sample) <- c("coefficient", "standard_error")
# write.csv(data_sample, file = "simulated_data.csv",row.names=FALSE)