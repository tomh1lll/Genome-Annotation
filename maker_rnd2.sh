#!/bin/sh

##sbatch --partition=largemem --cpus-per-task=4 --ntasks=40 --mem=1100g --time=5-00:00:00 maker_rnd2.sh

module load maker

mpiexec -np 40 maker -RM_off -base round2 parameter_files/maker_opts_rnd2.log parameter_files/maker_bopts.log parameter_files/maker_exe.log
