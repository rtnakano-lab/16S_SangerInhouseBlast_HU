# R script to modify blast results
# Ryohei Thomas Nakano; rtnakano@sci.hokudai.ac.jp
# last modified: 14 Nov 2023

rm(list=ls())

# packages
library(stringr)

# dir
dir <- commandArgs(trailingOnly=TRUE)[1]
map_dir <- commandArgs(trailingOnly=TRUE)[2]
map_rhizo    <- paste0(map_dir, "/mapping_new.txt")
map_atsphere <- paste0(map_dir, "/mapping.txt")

# import
df <- read.table(paste(dir, "/blast_rhizobia.results.txt", sep=""), header=T, sep="\t")
map <- read.table(map_rhizo, sep="\t", header=T)

# mod
df$ID <- str_sub(df$sseqid, start=1, end=4)
idx <- match(df$ID, map$ID)
df <- data.frame(df, map[idx,])

# out
write.table(df, file=paste(dir, "/blast_rhizobia.results-map.txt", sep=""), sep="\t", quote=F, row.names=F, col.names=T)




# import
df <- read.table(paste(dir, "/blast_public.results.txt", sep=""), header=T, sep="\t")

# mod
df$ID <- str_sub(df$sseqid, start=1, end=4)
idx <- match(df$ID, map$ID)
df <- data.frame(df, map[idx,])

# out
write.table(df, file=paste(dir, "/blast_public.results.txt-map.txt", sep=""), sep="\t", quote=F, row.names=F, col.names=T)






# import
df <- read.table(paste(dir, "/blast_atsphere.results.txt", sep=""), header=T, sep="\t")
map <- read.table(map_atsphere, sep="\t", header=T)

# mod
idx <- match(df$sseqid, map$ID)
df <- data.frame(df, map[idx,])

# out
write.table(df, file=paste(dir, "/blast_atsphere.results-map.txt", sep=""), sep="\t", quote=F, row.names=F, col.names=T)




