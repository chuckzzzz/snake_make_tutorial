## Snakemake Notes ##

**General Snakemake tips**

- `snakemake -np {output_file}` will both do a dry run of the jobs intended and print out the respective commands. If there are wildcard characters, it will also expand on them. 
- Snakemake will only run if one of the input files i s newer than one of the output files or one of the input files will be updated by another job. 
- `snakemake --dag sorted_reads/{A,B}.bam.bai | dot -Tsvg > dag.svg` will create a visualization of the jobs to be run. Each node is a job and the arrows represent the dependencies. 
- shell commands in snakefile can be splitted onto different lines. However, each line **must be followed by a white space** and the resulting shell command is merely a concatenation of all lines. Failure to do so will generate erroneous shell commands. 
- To force everything to rerun, `--forceall`
- To specify the number of cores, use `--cores` {number_of_cores}. Using just the `--cores` flag will use all available cores. 
- `wildcards` is a place holder in function that helps retrieve information from the configuration file.  wildcard values will be interpreted on the go. For instance, `wildcards.sample` will be the value stored in `{sample}`.

