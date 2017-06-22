#! /bin/bash

mutation_dir=$1
result_dir=$2



f_snp=${result_dir}/filt_snp
f_snp_sort=${result_dir}/filt_snp_sort
f_bgzip=${result_dir}/filt_bgzip


mkdir -p ${result_dir}
mkdir -p ${f_snp}
mkdir -p ${f_snp_sort}
mkdir -p ${f_bgzip}


#choose snp from tumor mutatio  result
python ./get_snp.py $1 ${f_snp}


#make index of snp database
for file in `ls ${f_snp}`; do
    head -n 1 ${f_snp}/${file} > ${f_snp}/${file}.header
    tail -n +2 ${f_snp}/${file} > ${f_snp}/${file}.content

    sort -V -k 1,1 -k 2,2n ${f_snp}/${file}.content > ${f_snp_sort}/${file}.bed

    rm -f ${f_snp}/${file}.header ${f_snp}/${file}.content

    bgzip -c ${f_snp_sort}/${file}.bed > ${f_bgzip}/${file}.gz

    tabix -p bed ${f_bgzip}/${file}.gz

done


#define result directory of categorize(ABC)
#本当はここで分類するスクリプトを入れなければならない
categ_dir="./mutation_ABC"




#A: tumor_normal, BC:normal
#for cdir in ${categdir}; do
#    python ./get_cohoto_count.py ${categdir}/${cdir} ${result_dir}/cohoto_count_${cdir}.txt
#    python ./add_cohoto_count.py ${categdir}/${cdir} ${result_dir}/cohoto_count_${cdir}.txt ${result_dir}/${categdir}_addcohoto/${cdir}
#done
python ./get_cohoto.py



python ./add_cohoto_count.py ${categ_dir}/A ${result_dir}/${categ_dir}.ccount/A
python ./add_cohoto_count.py ${categ_dir}/B ${result_dir}/${categ_dir}.ccount/B
python ./add_cohoto_count.py ${categ_dir}/C ${result_dir}/${categ_dir}.ccount/C




#add snp around at the end of mutation result
#for cdir in ${categdir}; do
#    python ./add_1MbpSNP.py ${categdir}/${cdir} ${result_dir}/${categdir}_addsnp/${cdir}
#done
python ./add_1MbpSNP.py ${result_dir}/${categ_dir}.ccount/A ${result_dir}/${categ_dir}.addsnp/A
python ./add_1MbpSNP.py ${result_dir}/${categ_dir}.ccount/B ${result_dir}/${categ_dir}.addsnp/B
python ./add_1MbpSNP.py ${result_dir}/${categ_dir}.ccount/C ${result_dir}/${categ_dir}.addsnp/C




#choose featured column from mutation result
python ./choose_feature_column.py 


