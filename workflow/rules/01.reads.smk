rule link_reads_fasta:
    input:
        lambda wildcards: config["reads"][wildcards.name]
    output:
        "results/{name}/01.reads/HiFi_reads_{name}.fa"
    log:
        "results/logs/01.reads/link_reads_fasta/{name}.log"
    benchmark:
        "results/benchmarks/01.reads/link_reads_fasta/{name}.txt"
    shell:
        "ln -s $(realpath {input}) {output} 2> {log}"
