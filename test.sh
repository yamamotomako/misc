#! /usr/bin/bash

outdir=$1

mkdir -p ${outdir}

mkdir -p ${outdir}/other_snp
mkdir -p ${outdir}/other_snp/A
mkdir -p ${outdir}/other_snp/B
mkdir -p ${outdir}/other_snp/C

mkdir -p ${outdir}/beta_binomial
mkdir -p ${outdir}/beta_binomial/A
mkdir -p ${outdir}/beta_binomial/B
mkdir -p ${outdir}/beta_binomial/C


for file in ./mutation_addsnp/A/*; do
    echo $file
    awk -F'\t' '{print $1"\t"$2"\t"$3"\t"$51"\t"$52"\t"$59"\t"$97"\t"$98"\t"$99}' ${file} > ${outdir}/other_snp/A/`basename ${file}`
    python ./calc_alpha_beta.py ${outdir}/other_snp/A/`basename ${file}` ${outdir}/beta_binomial/A/`basename ${file}`
    #sed -e 's/\.${outdir}/other_snp\/A\///g' ${outdir}/beta_binomial/A/`basename ${file}` | sed -e 's/.addsnp//g' > ${outdir}/beta_binomial/A/`basename ${file}.beta`
    #rm -f ${outdir}/beta_binomial/A/`basename ${file}`
done


for file in ./mutation_addsnp/B/*; do
    echo $file
    awk -F'\t' '{print $1"\t"$2"\t"$3"\t"$51"\t"$52"\t"$55"\t"$86"\t"$87"\t"$88}' ${file} > ${outdir}/other_snp/B/`basename ${file}`
    python ./calc_alpha_beta.py ${outdir}/other_snp/B/`basename ${file}` ${outdir}/beta_binomial/B/`basename ${file}`
    #sed -e 's/\.${outdir}/other_snp\/B\///g' ${outdir}/beta_binomial/B/`basename ${file}` | sed -e 's/.addsnp//g' > ${outdir}/beta_binomial/B/`basename ${file}.beta`
    #rm -r ${outdir}/beta_binomial/B/`basename ${file}`
done


for file in ./mutation_addsnp/C/*; do
    echo $file
    awk -F'\t' '{print $1"\t"$2"\t"$3"\t"$51"\t"$52"\t"$55"\t"$86"\t"$87"\t"$88}' ${file} > ${outdir}/other_snp/C/`basename ${file}`
    python ./calc_alpha_beta.py ${outdir}/other_snp/C/`basename ${file}` ${outdir}/beta_binomial/C/`basename ${file}`
    #sed -e 's/\.${outdir}/other_snp\/A\///g' ${outdir}/beta_binomial/C/`basename ${file}` | sed -e 's/.addsnp//g' > ${outdir}/beta_binomial/C/`basename ${file}.beta`
    #rm -r ${outdir}/beta_binomial/C/`basename ${file}`
done




mkdir -p ${outdir}/A_noheader
mkdir -p ${outdir}/B_noheader

for file in ${outdir}/beta_binomial/A/*; do
    tail -n +2 ${file} > ${outdir}/A_noheader/`basename ${file}`
done

for file in ${outdir}/beta_binomial/B/*; do
    tail -n +2 ${file} > ${outdir}/B_noheader/`basename ${file}`
done


cat ./header.txt ${outdir}/A_noheader/* ${outdir}/B_noheader/* > ${outdir}/all.txt



