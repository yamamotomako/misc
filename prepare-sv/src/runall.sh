#! /bin/bash

write_usage(){
    echo ""
    echo "bash ./runall.sh 'path of sample and path list(after mutation call, result.filt.txt)' 'path of output directory'"
    echo ""
}


samplepath=$1
outdir=$2


if [ $# -ne 2 ]; then
    echo ""
    write_usage
    exit
fi

if [ ! -e ${samplepath} ]; then
    echo "samplepath file does not exist."
    write_usage
    exit
fi

mkdir -p ${outdir}
mkdir -p ${outdir}/filt_tn_1
mkdir -p ${outdir}/filt_n_1
mkdir -p ${outdir}/filt_n_2_ok
mkdir -p ${outdir}/filt_n_2_ng

rm -f ${outdir}/sample_TN_list.csv
rm -f ${outdir}/sample_N_list.csv


samplepathfile=`basename ${samplepath}`

cp ${samplepath} ${outdir}/${samplepathfile}


for line in `cat ${outdir}/${samplepathfile}`; do
    TEXT=${line}
    IFS=','
    set -- $TEXT
    if [ ${1: -1} = "T" ]; then
        echo $1,$2 >> ${outdir}/sample_TN_list.csv
    else
        echo $1,$2 >> ${outdir}/sample_N_list.csv
    fi
done

#get runall.sh directory
curdir=$(cd $(dirname $0); pwd)


#filter by exonic, misrate, indel
#with control
echo "filtering by exon misrate indel TN..."
python ${curdir}/filter_by_exonic_misrate_indel.py ${outdir}/sample_TN_list.csv ${outdir}/filt_tn_1 ${outdir}/filt_tn_1.txt "TN"

#without control
echo "filtering by exon misrate indel N..."
python ${curdir}/filter_by_exonic_misrate_indel.py ${outdir}/sample_N_list.csv ${outdir}/filt_n_1 ${outdir}/filt_n_1.txt "N"



#filter by depth, vaf
#without control
echo "filtering secondly by depth N..."
python ${curdir}/filter_by_depth_vaf.py ${outdir}/filt_n_1 ${outdir}/filt_n_2_ok ${outdir}/filt_n_2_ng "N"


#make categorized table
echo "categorizing into somatic germline others..."
python ${curdir}/categorize.py "somatic" ${outdir}/filt_tn_1 ${outdir}/somatic.txt
python ${curdir}/categorize.py "germline" ${outdir}/filt_n_2_ok ${outdir}/germline.txt
python ${curdir}/categorize.py "others" ${outdir}/filt_n_2_ng ${outdir}/others.txt

#remove header
tail -n +2 ${outdir}/germline.txt > ${outdir}/g_tmp
tail -n +2 ${outdir}/others.txt > ${outdir}/o_tmp

#merge all
cat ${outdir}/somatic.txt ${outdir}/g_tmp ${outdir}/o_tmp > ${outdir}/result_all.txt

rm -r ${outdir}/g_tmp ${outdir}/o_tmp


#make plot
Rscript --vanilla ${curdir}/make_plot.R ${outdir}
