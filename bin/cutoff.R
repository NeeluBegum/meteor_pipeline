#!/usr/bin/Rscript
#memory.limit(9999999999)
require('dplyr')  
require('reshape2')
require('data.table')

args = commandArgs(trailingOnly=TRUE)
gctCount = args[1]

#geneCount="/proj/uppstore2019028/projects/metagenome/meteor_ref/fungal_catalog/geneCount.txt"


#Cut off 

input_melted<-melt(geneCount, id="row.name")
final_geneCount<-input_melted[ input_melted$value > quantile(input_melted$value , 0.62 ) , ]
  # And check the value of the bottom 25% quantile...
  quantile(cut_off_input$value, 0.62)
  
write.csv(final_geneCount, quote=F, file="final_geneCount.csv")
print("cut-off finished")
