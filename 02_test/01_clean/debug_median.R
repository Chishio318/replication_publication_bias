
#4. auxiliary function
install.packages("data.table")
library("data.table")

# data, id_var, main_var, additional_var)

data <- data_merged
  
  #1. drop rows with any NA
  complete_data <- na.omit(data)
  id_var <- "studyno"
  main_var <- "partialr"
  additional_var <- "se"
  
  #2. rename columns
  column_id <- eval((substitute(complete_data[a], list(a = id_var))))
  colnames(column_id)[1] <- "id"
  column_main <- eval((substitute(complete_data[a], list(a = main_var))))
  colnames(column_main)[1] <- "main"
  column_additional <- eval((substitute(complete_data[a], list(a = additional_var))))
  colnames(column_additional)[1] <- "additional"
  
  columns_main_merged <- merge(column_id, column_main, by=0, all=TRUE) 
  columns_additional_merged <- merge(column_id, column_additional, by=0, all=TRUE) 
  
  #3. choose median of main_var along with id
  median_only <- aggregate(main~id,columns_main_merged,median)
  
  #4. merge with complete data
  median_together <- merge(median_only, columns_main_merged, by.x="id", by.y="id")
  median_all <- merge(median_together, columns_additional_merged, by.x="Row.names", by.y="Row.names")
  
  #5. choose data closest to the computed median
  median_all$diff_squared <- (median_all$main.x - median_all$main.y)^2
  table_form <- data.table(median_all)
  median_combined <- table_form[ , .SD[which.min(diff_squared)], by = id.x]
  
  #6. clean before output
  median_combined2 <- median_combined[order(median_combined$id.x),]
  median_combined3 <- median_combined2[, c("id.x", "main.x", "additional")]
  colnames(median_combined3)[1] <- "ID"
  colnames(median_combined3)[2] <- "coefficient"
  colnames(median_combined3)[3] <- "standard_error"
  Y <- median_combined3
  
  return(Y)
}

