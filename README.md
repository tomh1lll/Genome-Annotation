# Genome-Annotation
Summary of the pipeline used to generate a genome annotation

First move into the downloaded repository using cd.
Before running the first round of the annotation you need to edit the parameter_files/maker_opts_rnd1.log for use. Specifically you need to define the absolute path to the genome file and the ortholog files, in the following rows of parameter_files/maker_opts_rnd1.log:

```
genome= #genome sequence (fasta file or fasta embeded in GFF3 file)

altest=/PATHTOHERE/parameter_files/caenorhabditis_elegans.PRJNA13758.WBPS15.mRNA_transcripts.fa,/PATHTOHERE/parameter_files/strongyloides_ratti.PRJEB125.WBPS15.mRNA_transcripts.fa #EST/cDNA sequence file in fasta format from an alternate organism

protein=/PATHTOHERE/parameter_files/caenorhabditis_elegans.PRJNA13758.WBPS15.protein.fa,/PATHTOHERE/parameter_files/strongyloides_ratti.PRJEB125.WBPS15.protein.fa  #protein sequence file in fasta format (i.e. from mutiple organisms)

snaphmm=/PATHTOHERE/snap/round0/my-genome.hmm #SNAP HMM file

augustus_species=caenorhabditis
```

Following this, you should run the maker_rnd1.sh script

```
sbatch --partition=largemem --cpus-per-task=4 --ntasks=40 --mem=1100g --time=5-00:00:00 maker_rnd1.sh
```

After maker round 1 is completed, should generate a gff from the maker output and then generate a snap file from the first round annotation.

```
module load maker snap
cd round1.maker.output
gff3_merge -d round1_master_datastore_index.log

mkdir -p ../snap/round1
cd ../snap/round1
maker2zff -x 0.5 -l 50 -c 0 -e 0 -o 0 -d ../../round1.maker.output/round1_master_datastore_index.log
fathom ../../round1.maker.output/genome.round1.all.gff genome.dna -gene-stats > gene-stats.log
fathom ../../round1.maker.output/genome.round1.all.gff genome.dna -validate > validate.log

fathom ../../round1.maker.output/genome.round1.all.gff genome.dna -categorize 1000 > categorize.log
fathom uni.ann uni.dna -export 1000 -plus > uni-plus.log

mkdir params
cd params
forge ../export.ann ../export.dna > ../forge.log
cd ..
hmm-assembler.pl genome params > round1.hmm
cd ../..
```

You can now edit the maker opts files and run the second and third round of the annotation. Following the second round of maker, you should again run snap to generate a new hmm for round 3. Here is an example of what is changed for round 2 of the annotation in maker_opts_rnd2.org. For round 2 and 3, you do not need to use augustus, but need to update the SNAP HMM.

```
maker_gff=/PATHTOHERE/round1.maker.output/genome.round1.all.gff #MAKER derived GFF3 file

snaphmm=/PATHTOHERE/snap/round1/round1.hmm #SNAP HMM file

augustus_species=
```

Following this, run the second and third round of annotation

```
sbatch --partition=largemem --cpus-per-task=4 --ntasks=40 --mem=1100g --time=5-00:00:00 maker_rnd2.sh
```

Generating a new SNAP HMM for round 3.

```
module load maker snap
cd round2.maker.output
gff3_merge -d round2_master_datastore_index.log
mkdir -p ../snap/round2
cd ../snap/round2
maker2zff -x 0.5 -l 50 -c 0 -e 0 -o 0 -d ../../round2.maker.output/round2_master_datastore_index.log
fathom ../../round2.maker.output/genome.round2.all.gff genome.dna -gene-stats > gene-stats.log
fathom ../../round2.maker.output/genome.round2.all.gff genome.dna -validate > validate.log

fathom ../../round2.maker.output/genome.round2.all.gff genome.dna -categorize 1000 > categorize.log
fathom uni.ann uni.dna -export 1000 -plus > uni-plus.log

mkdir params
cd params
forge ../export.ann ../export.dna > ../forge.log
cd ..
hmm-assembler.pl genome params > round2.hmm
cd ../..
```

```
sbatch --partition=largemem --cpus-per-task=4 --ntasks=40 --mem=1100g --time=5-00:00:00 maker_rnd3.sh
```
