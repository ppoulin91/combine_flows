#!/usr/bin/env bash
usage() { echo "$(basename $0) [-t tractoflow/results] [-s DWI_SH/output] [-o output]" 1>&2; exit 1; }

while getopts "t:s:o:" args; do
    case "${args}" in
        t) t=${OPTARG};;
        s) s=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

echo "$t $s $o"

if [ -z "${t}" ] || [ -z "${s}" ] || [ -z "${o}" ]; then
    usage
fi

t=$(realpath $t)
s=$(realpath $s)
output=$(realpath $o)

echo "Tractoflow folder: ${t}"
echo "DWI_SH folder: ${s}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"

for i in $t/*[!{FRF}];
do
   subid=$(basename $i)
   echo $i
   mkdir -p $output/$subid

   ln -s ${t}/${subid}/Resample_B0/*.nii.gz ${output}/${subid}/
   ln -s ${t}/${subid}/Resample_T1/*t1_resampled.nii.gz ${output}/${subid}/${subid}__t1.nii.gz
   ln -s ${t}/${subid}/DTI_Metrics/*.nii.gz ${output}/${subid}/
   ln -s ${t}/${subid}/FODF_Metrics/*.nii.gz ${output}/${subid}/


done

rm -rf ${output}/Readme*
rm -rf ${output}/Read_BIDS


for i in $s/*;
do
   subid=$(basename $i)
   echo $i
   ln -s ${s}/${subid}/Compute_SH/*.nii* ${output}/${subid}/
done
