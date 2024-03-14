rule hifiasm:
    input:
        "results/{asmname}/01.reads/HiFi_reads_{asmname}.fa"
    output:
        "results/{asmname}/02.hifiasm/HiFiasm_{asmname}.bp.p_ctg.gfa"
    log:
        "results/logs/02.hifiasm/hifiasm/{asmname}.log"
    benchmark:
        "results/benchmarks/02.hifiasm/hifiasm/{asmname}.txt"
    threads:
        workflow.cores
    conda:
        "../envs/hifiasm.yaml"
    shell:
        "hifiasm -t {threads} -o $(echo {output} | rev | cut -d '.' -f 4- | rev) {input} 2> {log}"
