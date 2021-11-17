Skip to content
Search or jump to…
Pull requests
Issues
Marketplace
Explore
 
@NeeluBegum 
NeeluBegum
/
Meteor_Fungi
Public
1
0
0
Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights
More
Meteor_Fungi/bin/downstream_fungi.r
@NeeluBegum
NeeluBegum Update downstream_fungi.r
Latest commit a7e7e8c 5 days ago
 History
 1 contributor
67 lines (60 sloc)  2.44 KB
   
#!/usr/bin/Rscript
#memory.limit(9999999999)
require('dplyr')  
require('momr')

args = commandArgs(trailingOnly=TRUE)
gctFile = args[1]
indexedCatalog = args[2]
mspdownload = args[3]
#name = args[4]

## for testing only
gctFile = '/proj/snic2020-6-153/nobackup/private/fungalnftest/gct.tsv'
mspdownload = "/proj/uppstore2019028/projects/metagenome/dataverse_fungi_files/Fungi.twins.tsv"
indexedCatalog = "/crex/proj/uppstore2019028/projects/metagenome/meteor_ref/fungal_catalog/database/fungal_catalog_lite_annotation"
gctFile = "/proj/snic2020-6-153/nobackup/private/fungalnftest/gct.tsv"
mspdownload = "/proj/uppstore2019028/projects/metagenome/ddataverse_fungi_files/Fungi.twins.tsv"
indexedCatalog = "/crex/proj/uppstore2019028/projects/metagenome/meteor_ref/fungal_catalog/database/fungal_catalog_lite_annotation"
reference="/proj/uppstore2019028/projects/metagenome/meteor_ref/fungal_catalog/reference.txt"

#attaching fungal gene annotation
#column count
awk '{print NF}' geneCount2.txt | sort -nu | tail -n 1
#remove double quotes
sed 's/"//g' geneCount.txt -> geneCount2.txt
#adjust rowname
sed -i '1s/^/row.name       /' geneCount2.txt
#attach functional gene names using reference.txt
head -n1 geneCount2.txt; awk 'FNR==NR {a[$1]; next} $1 in a' reference.txt geneCount2.txt > report_species3.txt

print("gct loading")
gctTab = read.delim(gctFile, row.names=1, sep="\t", stringsAsFactors=F, header=T)
#gctNorm10m = read.csv(gctFile, row.names=1, stringsAsFactors=F, header=T)
print("gct loaded")

print("gct info saving")
sampleSum = colSums(gctTab)
print(min(sampleSum))
print(quantile(sampleSum,0.25))
print(quantile(sampleSum,0.75))
print(max(sampleSum))
#write.csv(sampleSum, quote=F, file=gzfile(paste(outDir, "samplesum.csv.gz",sep='/')))
write.csv(sampleSum, quote=F, file="samplesum.csv")
rm(sampleSum)
gc()
print("gct info saved")

#print("downsizing begin")
#depth = 10000000
#gctdown10m = momr::downsizeMatrix(gctTab, level=depth, repetitions=1, silent=F)
#rm(gctTab)
#gc()
#print("downsizing finished")
gctdown10m <- gctTab

print("norm begin")
sizeTab = read.table(indexedCatalog, sep="\t", stringsAsFactors=F)
names(sizeTab) <- c('gene_id', 'gene_size')
genesizes = sizeTab$gene_size
names(genesizes) = sizeTab$gene_id
#print('length of genesizes')
#print(length(genesizes))
#print('number of rows of gctdown10m')
#print(nrow(gctdown10m))
gctNorm10m = momr::normFreqRPKM(dat=gctdown10m, cat=genesizes)
write.csv(gctNorm10m, quote=F, file="norm.csv")
print("norm finished")
