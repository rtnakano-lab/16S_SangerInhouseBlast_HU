#/bin/bash

project=$1
# project="2024-03-13_20240313okumura"

dir="/Users/rtnakano/NextCloud2/data_hokudai/sequence-results"
output="${dir}/${project}/query.fasta"


rm -rf ${output}

awk '/TRUE/ {print $2"\n"$3}' ${dir}/${project}/mapping.txt | while read file
do
	filepath="${dir}/${project}/${file}*.seq"
	if [ -f $filepath ]
	then
		echo ">"$file >> ${output}
		cat $filepath >> ${output}
	fi
done


