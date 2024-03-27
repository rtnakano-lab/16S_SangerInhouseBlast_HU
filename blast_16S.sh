#! /bin/bash

# Shell script for 16S sanger seq results.
# BLASTs against rhizobia isolated at MPIPZ, rhizobia obtained from public stocks, and AtSphere root isolates.
# MultiFASTA file containing all sequencing results is required
#
# originally by
# Ryohei Thomas Nakano, 04.02.2017
# last modified: 14.11.2023 (optimized for Hokudai 7-06 local Mac Mini environment)
# nakano@mpipz.mpg.de; rtnakano@sci.hokudai.ac.jp

# usage
# ./blast_16S.sh [full path of data directory]
# (Example: ./blast_16S.sh /biodata/dep_psl/grp_psl/ThomasN/seq_results/11106756571-1
# 
# sequence data should be stored in the ${ID}.fasta file, where ${ID} is the name of your directory (the last part of your full path)


# paths
# path to the blast database
BLASTDB="/Users/rtnakano/NextCloud2/data_hokudai/blastdb"
BALSTPATH="/usr/local/ncbi/blast/bin"
# path to the directory you store all relevant scripts
script_dir="/Users/rtnakano/NextCloud2/data_hokudai/scripts/16S_SangerInhouseBlast_HU"
# path to Rscript
R_PATH="/usr/local/bin"

dat_dir="/Users/rtnakano/NextCloud2/data_hokudai/sequence-results"

project=$1
# project="2024-03-13_20240313okumura"


# setup
query="${dat_dir}/${project}/query.fasta"
out_dir=${dat_dir}/${project}/results

rm -r -f ${query}
rm -r -f ${out_dir}
mkdir -p ${out_dir}



# prepare query
awk '/TRUE/ {print $2"\n"$3}' ${dat_dir}/${project}/mapping.txt | while read file
do
	filepath="${dat_dir}/${project}/${file}*.seq"
	if [ -f $filepath ]
	then
		echo ">"$file >> ${query}
		cat $filepath >> ${query}
	fi
done


# BLAST against public rhizobia
${BALSTPATH}/blastn -db ${BLASTDB}/rhizobia_2_16S_public.fasta -query ${query} -outfmt 6 -evalue 1e-100 -perc_identity 93 -out ${out_dir}/blast_public.results.temp.txt
cat ${script_dir}/outfmt_6.header.txt ${out_dir}/blast_public.results.temp.txt > ${out_dir}/blast_public.results.txt
rm ${out_dir}/blast_public.results.temp.txt

# BLAST agianst AtSphere Root isolate
${BALSTPATH}/blastn -db ${BLASTDB}/AtSPHERE_WGS_full.fasta -query ${query} -outfmt 6 -evalue 1e-100 -perc_identity 93 -out ${out_dir}/blast_atsphere.results.temp.txt
cat ${script_dir}/outfmt_6.header.txt ${out_dir}/blast_atsphere.results.temp.txt > ${out_dir}/blast_atsphere.results.txt
rm ${out_dir}/blast_atsphere.results.temp.txt

# BLAST agianst MPIPZ-rhizobia
${BALSTPATH}/blastn -db ${BLASTDB}/rhizobia_2_16S.fasta -query ${query} -outfmt 6 -evalue 1e-100 -perc_identity 93 -out ${out_dir}/blast_rhizobia.results.temp.txt
cat ${script_dir}/outfmt_6.header.txt ${out_dir}/blast_rhizobia.results.temp.txt > ${out_dir}/blast_rhizobia.results.txt
rm ${out_dir}/blast_rhizobia.results.temp.txt

# Implementing meta information about isolates
${R_PATH}/Rscript ${script_dir}/blast_result_merge.R ${out_dir} ${script_dir}

# Done
