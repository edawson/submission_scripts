job_name=$1
job_script=$2
threads=$3
mem=$4
if [ -z $job_name ]
then echo "usage: sub_min.sh <JOBNAME> <JOBFILE> *THREADS* *MEM*"
fi
if [ -z $threads ]
    then threads=4
fi
if [ -z $mem ]
    then mem=16000
fi
chmod 777 ${job_script}
bsub -R "rusage[mem=$mem]" -R "span[hosts=1]" \
 -R "select[mem>$mem]" -R "select[cpuf>=8.3] select[sse42] select[type==local]" \
 -m vr-4-1-[01-16] \
 -q small -J "$job_name" -W 1:59 \
 -n $threads -M $mem -eo ~/logs/small_job.%J.err.txt -oo ~/logs/small_job.%J.out.txt -P analysis-rd ./${job_script}
