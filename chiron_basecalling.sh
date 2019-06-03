#!/usr/bin/env bash

# Copyright 2019 Ryan Wick (rrwick@gmail.com)
# https://github.com/rrwick/Basecalling-comparison

# This program is free software: you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version. This program is distributed in the hope that it
# will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You
# should have received a copy of the GNU General Public License along with this program. If not,
# see <http://www.gnu.org/licenses/>.

# This script will execute each version of Chiron on the reads. Chiron takes a long time to run,
# so I ran it on smaller batches of files so I could start/stop the basecalling as needed.


# Edit the following paths before running, as appropriate for your environment:
fast5_dir=/scratch/general/lustre/u1142888/basecalling/Klebsiella_pneumoniae_NUH29_fast5   # should contain numbered subdirectories (000 to 151), each containing fast5 files
output_prefix=/scratch/general/lustre/u1142888/basecalling/Klebsiella_pneumoniae_NUH29_fast5/basecalling_output  # Chiron output fastqs will go in this directory
chiron_dirs=/uufs/chpc.utah.edu/common/home/u1142888/Chiron-0.4                # should contain a subdirectory for each version of Chiron, e.g. Chiron-v0.4.2


export PYTHONPATH=/uufs/chpc.utah.edu/common/home/u1142888/Chiron-0.4/chiron:$PYTHONPATH

# Versions 0.4, 0.4.1 and 0.4.2 all seem to produce the same reads, so I'm only running v0.4.2.
v=0.4
out_dir="$output_prefix"/chiron_v"$v"
out_file=chiron_v"$v".fastq
time_file=chiron_v"$v".time
rm -rf $out_dir
rm -f $time_file
/usr/bin/time -v -o $time_file python chiron/entry.py call -i "$fast5_dir"/ -o $out_dir || break
cat "$out_dir"/result/*.fastq | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > $out_file

cat chiron_v"$v"_*.fastq | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > chiron_v"$v".fastq
cat chiron_v"$v"_*.time > chiron_v"$v".time
