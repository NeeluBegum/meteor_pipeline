#!/usr/bin/bash

gctFile = $1

######attaching fungal gene annotation

## files
#gctFile = '/proj/snic2020-6-153/nobackup/private/fungalnftest/gct.tsv'
#mspdownload = "/proj/uppstore2019028/projects/metagenome/dataverse_fungi_files/Fungi.twins.tsv"
indexedCatalog = "/crex/proj/uppstore2019028/projects/metagenome/meteor_ref/fungal_catalog/database/fungal_catalog_lite_annotation"
gctFile = "/proj/snic2020-6-153/nobackup/private/fungalnftest/gct.tsv"
#mspdownload = "/proj/uppstore2019028/projects/metagenome/ddataverse_fungi_files/Fungi.twins.tsv"
#indexedCatalog = "/crex/proj/uppstore2019028/projects/metagenome/meteor_ref/fungal_catalog/database/fungal_catalog_lite_annotation"
reference="/proj/uppstore2019028/projects/metagenome/meteor_ref/fungal_catalog/reference.txt"
norm='/proj/snic2020-6-153/nobackup/private/fungalnftest/norm.csv'


#column count
awk '{print NF}' norm | sort -nu | tail -n 1

#adjust rowname
sed -i '1s/^/row.name       /' norm

#attach functional gene names using reference.txt
head -n1 norm; awk 'FNR==NR {a[$1]; next} $1 in a' reference.txt norm > geneCount.txt
