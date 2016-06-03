job_name=$1
job_script=$2
tasks=$3
threads=$4
mem=$5

usage () {
    echo "sub_array.sh <job_name> <job_script> <numTaks> <threads> <memory>"
    exit
}

if [ -z $1 ]
    then usage
fi

if [ -z $threads ]
    then threads=32
fi
if [ -z $mem ]
    then mem=64000
fi
chmod 777 ${job_script}
bsub -R "rusage[mem=$mem]" -R "span[hosts=1]" \
 -R "select[mem>$mem]" -R "select[cpuf>=8.3] select[sse42] select[type==local]" \
 -m vr-4-1-[01-16] \
 -q long -J "$job_name[1-${tasks}]" -W 23:58 \
 -n $threads -M $mem -eo ~/logs/%J.%I.err.txt -oo ~/logs/%J.%I.out.txt -P analysis-rd ${job_script}
