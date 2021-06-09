# Genome-Annotation
Summary of the pipeline used to generate a genome annotation

First move into the downloaded repository using cd.
Before running the first round of the annotation you need to edit the parameter_files/maker_opts_rnd1.log for use. Specifically you need to define the relative path to the genome file and the ortholog files.

Following this, you should run the maker_rnd1.sh script

```
sbatch --partition=largemem --cpus-per-task=4 --ntasks=40 --mem=1100g --time=5-00:00:00 maker_rnd1.sh
```
