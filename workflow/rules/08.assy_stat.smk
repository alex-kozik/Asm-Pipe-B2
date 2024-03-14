def get_assembly(wildcards):
    if wildcards.seqtype == "Contigs":
        return ["results/{asmname}/05.contigs_renamed/Contigs_HiFiasm_{asmname}.{parameters}.fa"]
    elif wildcards.seqtype == "Scaffolds":
        return ["results/{asmname}/06.ntjoin/Scaffolds_HiFiasm_{asmname}.{parameters}.fa"]
    else:
        raise ValueError("invalid sequence type")

rule assy_stat:
    input:
        get_assembly
    output:
        "results/{asmname}/08.assy_stat/{seqtype}_HiFiasm_{asmname}.{parameters}.assy_stat"
    log:
        "results/logs/08.assy_stat/{seqtype}/{asmname}.{parameters}.log"
    benchmark:
        "results/benchmarks/08.assy_stat/{seqtype}/{asmname}.{parameters}.txt"
    conda:
        "../envs/assembly-stats.yaml"
    shell:
        "assembly-stats {input} > {output} 2> {log}"
