#!/bin/bash
#SBATCH -p defq
#SBATCH -n 3
#SBATCH --time=36:00:00
#SBATCH -o masterout.txt
#SBATCH -e mastererr.txt
#SBATCH --mincpus=3
#SBATCH --mem=8000

mkdir ../assemblies

mkdir $1
cd $1
cp ../*$2* .
gunzip *$2*
cat '1_'*$2'.unmapped.1.fastq' '2_'*$2'.unmapped.1.fastq' > $1'_1.fastq'
cat '1_'*$2'.unmapped.2.fastq' '2_'*$2'.unmapped.2.fastq' > $1'_2.fastq'


module add c3ddb/python/2.7.11 
python2.7 ~/.local/lib/python2.7/site-packages/cutadapt -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -A CTGTCTCTTATACACATCTGACGCTGCCGACGA -o $1'_1.cut.fastq' -p $1'_2.cut.fastq' $1'_1.fastq' $1'_2.fastq' -m 50


module add c3ddb/SPAdes/3.13.0

spades.py -1 $1'_1.cut.fastq' -2 $1'_2.cut.fastq' --careful -o $1
cp $1'/scaffolds.fasta' '../../assemblies/'$1'.fasta'

