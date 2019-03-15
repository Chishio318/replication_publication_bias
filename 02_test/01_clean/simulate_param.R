


# set simulation parameter
N_laborsim <- 500

# set relevant paths
datafile <- "../01_data/laborunion_clean.csv"
stemfile <- "../../10_stem/estimation.R"
output_bootstrapfile <- "../01_data/simulated_param.csv"
output_mainfile <- "../01_data/main_param.csv"

"C:/Chishio/02_Research/01_Active/01_Publication Bias/01_Input/03_numerical/replication/02_test/01_clean"

# import data
laborunion <- read.csv(datafile, header=T)
N_laborstudy <- nrow(laborunion)
# install stem based method
source(stemfile)

# stem estimate only
stem_main <- stem(laborunion$partialr,laborunion$se,stem_param)$estimates

# simulate indeces
labor_simulated <- matrix(0,N_laborsim,N_laborstudy)

for (i in 1:N_laborsim) {
  labor_simulated[i,] <- sample(N_laborstudy, N_laborstudy, replace=TRUE)
  }

# loop over indeces
partialr_sim <- matrix(0,N_laborsim,N_laborstudy)
se_sim <- matrix(0,N_laborsim,N_laborstudy)

for (i in 1:N_laborsim) {
  for (j in 1:N_laborstudy){
    k <- labor_simulated[i,j]
    partialr_sim[i,j] <- laborunion$partialr[k]
    se_sim[i,j] <- laborunion$se[k]
  }
}

# stem estimates
stem_bootstrap <- matrix(0,N_laborsim,2)
for (i in 1:N_laborsim) {
  data_labor <- rbind(partialr_sim[i,], se_sim[i,])
  data_labor_entry <- t(data_labor)
  Y <- stem(data_labor_entry[,1],data_labor_entry[,2],stem_param)$estimates
  stem_bootstrap[i,1] <- Y[1]
  stem_bootstrap[i,2] <- Y[3]
}

# output intermediate table
write.table(stem_bootstrap, file = output_bootstrapfile, sep = ",", col.names = NA, qmethod = "double")
write.table(stem_main, file = output_mainfile, sep = ",", col.names = NA, qmethod = "double")

