
#clean environment
rm(list = setdiff(ls(), lsf.str()))

#0. set working directory to the folder this file is saved in
setwd("C:/Chishio/02_Research/01_Active/01_Publication Bias/01_Input/03_numerical/replication/03_simulation/")

#install stem-based method from the folder it is saved in
# download from https://github.com/Chishio318/stem-based_method/
setwd("../../../../../../03_Software/02_stem-based method/code and data/")
source("stem_method.R")
setwd("../../../01_Active/01_Publication Bias/01_Input/03_numerical/replication/03_simulation/")

# other correction methods
source("naive_method.R")
source("topN_method.R")
library(metafor) 
library(weightr)

# generate data
source("simulate_data.R")

# apply bias correction methods and assess their performance
source("estimate_evaluate.R")
