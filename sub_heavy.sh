job_name=$1
job_script=$2
threads=$3
mem=$4
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
 -q long -J "$job_name" -W 23:58 \
 -n $threads -M $mem -eo ~/logs/mod_graph.%J.err.txt -oo ~/logs/mod_graph.%J.out.txt -P analysis-rd ./${job_script}
