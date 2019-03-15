# note: user must specify correct path names
execute <- function(){

  file_path <- path_specify()
  install_stem(file_path$`stem`)
  median_data <- select_median(file_path$`data`)
  data_cleaned <- merge_data(median_data, file_path$`data`)
  save_file(data_cleaned, file_path$`output`, "cleaned.csv")
}

path_specify <- function(){
  
  ## modify here ##
  data_path <- "../../../../05_data/01_data"
  stem_path <- "../../../../../../../03_Software/02_stem-based method/code and data"
  output_path <- "../02_intermediate_data"
  #################
  
  file_path <- list("data" = data_path, "stem" = stem_path, "output" = output_path)
  return(file_path)
}

install_stem <- function(stem_file){
  stem_file <-  paste(stem_file, "stem_method.R", sep="/")
  source(stem_file)
  
}

select_median <- function(data_file){
  
  original_data <-  paste(data_file, "original.csv", sep="/")
  original <- read.csv(original_data, header=T, fileEncoding="utf-8")
  
  data_relevant <- original[,c("studyno","partialr","se")]
  
  library("data.table")
  median_data <- data_median(data_relevant, "studyno", "partialr", "se")
  return(median_data)
  
}


merge_data <- function(median_data, data_file){
  
  classification_data <-  paste(data_file, "classification.csv", sep="/")
  classification <- read.delim(classification_data, header=T, fileEncoding="utf-8")
  data_merged <- merge(median_data, classification, by.x = "ID", by.y = "paper_ID", sort = TRUE)
  data_cleaned <- data_merged[,c("ID","coefficient","standard_error", "Unique", "Classification1", "Classification2")]
  
  return(data_cleaned)
  
}

save_file <- function(data, path, output_title){
  file_name <-  paste(path, output_title, sep="/")
  write.table(data, file = file_name, sep = ",", row.names = FALSE, na = "", qmethod = "double")
  
}

save_file(data_cleaned, file_path$`output`, "cleaned.csv")

execute()
