# configurations
configfile: "config.yaml"

# helper functions
def get_bwa_map_input_fastqs(wildcards):
    return config["samples"][wildcards.sample]


# Snakemake rules
rule all:
    input:
        "plots/quals.svg"
rule bwa_map:
    input:
        "data/genome.fa",
        get_bwa_map_input_fastqs
    output:
        "mapped_reads/{sample}.bam"
    threads: 1
    shell:
        "bwa mem -t {threads} {input} | samtools view -Sb -> {output}"

rule samtools_sort:
    input:
        "mapped_reads/{sample}.bam"
    output:
        "sorted_reads/{sample}.bam"
    shell:
        "samtools sort -T sorted_reads/{wildcards.sample} "
        "-O bam {input} > {output}"
rule samtools_index:
    input:
        "sorted_reads/{sample}.bam"
    output:
        "sorted_reads/{sample}.bam.bai"
    shell:
        "samtools index {input}"
rule bcftools_call:
    input:
        fa="data/genome.fa",
        bam=expand("sorted_reads/{sample}.bam",sample=config["samples"]),
        bai=expand("sorted_reads/{sample}.bam.bai",sample=config["samples"])
    output:
        "calls/all.vcf"
    params:
        mr=float(config["mutation_rate"])
    shell:
        "samtools mpileup -g -f {input.fa} {input.bam} | "
        "bcftools call -p {params.mr} -mv -> {output}"

rule plot_quals:
    input:
        "calls/all.vcf"
    output:
        "plots/quals.svg"
    script:
        "scripts/plot-quals.py"
