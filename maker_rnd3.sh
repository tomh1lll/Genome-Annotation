#!/bin/sh

##sbatch --partition=largemem --cpus-per-task=4 --ntasks=40 --mem=1100g --time=5-00:00:00 maker_rnd3.sh

module load maker

mpiexec -np 40 maker -RM_off -base round3 parameter_files/maker_opts_rnd3.log parameter_files/maker_bopts.log parameter_files/maker_exe.log
