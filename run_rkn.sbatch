#!/bin/bash

####
#a) Define slurm job parameters
####

#SBATCH --job-name=rkn_exp

#resources:

#SBATCH --cpus-per-task=4
# the job can use and see 4 CPUs (from max 24).

#SBATCH --partition=day
# the slurm partition the job is queued to.

#SBATCH --mem-per-cpu=20G
# the job will need 12GB of memory equally distributed on 4 cpus.  (251GB are available in total on one node)

#SBATCH --gres=gpu:1
#the job can use and see 1 GPUs (4 GPUs are available in total on one node)

#SBATCH --time=2:00:00
# the maximum time the scripts needs to run
# "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds"



#SBATCH --error=job.%J.err
# write the error output to job.*jobID*.err

#SBATCH --output=job.%J.out
# write the standard output to job.*jobID*.out

#SBATCH --mail-type=ALL
#write a mail if a job begins, ends, fails, gets requeued or stages out

#SBATCH --mail-user=uenal@informatik.uni-tuebingen.de
# your mail address

####
#b) copy all needed data to the jobs scratch folder
####

cp -R /home/uenal/rkn/data/SCOP167-fold /scratch/$SLURM_JOB_ID/

####
#c) Execute your tensorflow code in a specific singularity container
#d) Write your checkpoints to your home directory, so that you still have them if your job fails
#cnn_minst.py <model save path> <mnist data path>
####

singularity exec rkn.simg python3 ~/rkn/experiments/train_scop.py --dataset /scratch/$SLURM_JOB_ID/SCOP167-fold/ --pooling max --embedding blosum62 --kmer-size 14 --sigma 0.4 --tfid 1 --hidden-size 2048 --batch-size 64

echo DONE!

