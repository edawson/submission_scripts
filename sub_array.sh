job_name=$1
job_script=$2
tasks=$3
threads=$4
mem=$5

default_proj="analysis-rd"
default_queue="long"
default_time="23:58"

usage () {
    echo "sub_array.sh <job_name> </full/path/to/job_script> <numTasks> <threads> <MemoryInMB>"
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
if [ ! -d ~/logs ]
    then mkdir ~/logs
fi

## The first line lists default requirements for the node on which the job is to run.
## The memory requirements and span are useful, but the rest is just specific to programs with strict instruction set requirements.
## Modify at will

chmod 777 ${job_script}
bsub  -R "rusage[mem=$mem]" -R "span[hosts=1]" -R "select[mem>$mem]" -R "select[cpuf>=8.3] select[sse42] select[type==local]" -m vr-4-1-[01-16] \
 -q ${default_queue} -J "$job_name[1-${tasks}]" -W ${default_time} \
 -n $threads -M $mem -eo ~/logs/%J.%I.err.txt -oo ~/logs/%J.%I.out.txt -P ${default_proj} ${job_script}
