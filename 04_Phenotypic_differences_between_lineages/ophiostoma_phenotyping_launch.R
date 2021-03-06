#
# Image analyses for Ophiostoma 
#
# 

library(EBImage)
library(dplyr)
library(tidyr)
library(ggplot2)
source("ophiostoma_phenotyping_picture_analysis_function.R")

# get a list of all picture
f_list <- list.files("./input_files", pattern = ".JPG", full.names = T)

# time at the begining of the loop
start.time <- Sys.time()

# for all file in the list, run the function
for (f in f_list){
  print(f)
  Ophiotoma_image2shape_12pos_PixIntens(f)
}

# time at the end of the loop, so we can estimate the runing time
end.time <- Sys.time()
time.taken <- end.time - start.time
running.time <- paste0("It took ", time.taken, " to analyse ", length(f_list), " images")
running.time

# The ouput of interest is store in the file "14_info" of each picture directory
InfoFile_list <- list.files("./input_files", pattern = "14_info", full.names = T, recursive = T)


# Merge alle outpu file in one data frame
Info_tot <- as.data.frame(matrix(nrow = length(InfoFile_list)*12, ncol = 5))
i=1
for (info in InfoFile_list){
  print(info)
  tmp <- read.table(info, header = T)
  tmp$picture_path <- as.character(tmp$picture_path)
  tmp$picture_name <- as.character(tmp$picture_name)
  tmp$pos <- as.character(tmp$pos)
  tmp$version <- as.character(tmp$version)
  Info_tot[i:(i+11),] <- tmp %>% select(picture_path, picture_name, pos, version, s.area)
  i = i+12
}

colnames(Info_tot) <- c("picture_path", "picture_name", "pos", "version", "s.area")


Info_tot_cust <- Info_tot %>% separate(picture_name, c("runName", "temperature", "plate", "date", "hour"), "_", remove = F) %>% mutate(hour = gsub(".JPG", "", hour))
Info_tot_cust$Key=paste(Info_tot_cust$plate,Info_tot_cust$pos,sep="")
setwd("./input_files")
write.table(Info_tot_cust,"table_pixintens.txt", row.names = F, col.names = T, sep="\t")









