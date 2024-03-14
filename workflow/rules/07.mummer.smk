def get_assembly(wildcards):
    if wildcards.seqtype == "Contigs":
        return ["results/{asmname}/05.contigs_renamed/Contigs_HiFiasm_{asmname}.{parameters}.fa"]
    elif wildcards.seqtype == "Scaffolds":
        return ["results/{asmname}/06.ntjoin/Scaffolds_HiFiasm_{asmname}.{parameters}.fa"]
    else:
        raise ValueError("invalid sequence type")

rule mummer:
    input:
        reference = lambda wildcards: config["ref_genome"][wildcards.reference],
        assembly = get_assembly,
    output:
        "results/{asmname}/07.mummer/{reference}/{seqtype}_HiFiasm_{asmname}.{parameters}.MUMmer.delta"
    log:
        "results/logs/07.mummer/{seqtype}/{reference}/{asmname}.{parameters}.log"
    benchmark:
        "results/benchmarks/07.mummer/{seqtype}/{reference}/{asmname}.{parameters}.txt"
    threads:
        24
    conda:
        "../envs/mummer.yaml"
    shell:
        "nucmer -t {threads} -l 1000 -g 1000 --prefix=$(echo {output} | rev | cut -d '.' -f 2- | rev) {input.reference} {input.assembly} &> {log}"

rule dotplot:
    input:
        "results/{asmname}/07.mummer/{reference}/{seqtype}_HiFiasm_{asmname}.{parameters}.MUMmer.delta"
    output:
        "results/{asmname}/07.mummer/{reference}/{seqtype}_HiFiasm_{asmname}.{parameters}.MUMmer.plot.gp"
    log:
        "results/logs/07.dotplot/{seqtype}/{reference}/{asmname}.{parameters}.log"
    benchmark:
        "results/benchmarks/07.dotplot/{seqtype}/{reference}/{asmname}.{parameters}.txt"
    conda:
        "../envs/mummer.yaml"
    shell:
        """
        (
        cd $(dirname {output})
        mummerplot --filter --png --large --prefix={wildcards.seqtype}_HiFiasm_{wildcards.asmname}.{wildcards.parameters}.MUMmer.plot --title {wildcards.asmname}_{wildcards.seqtype} ../../../../{input}
        ) &> {log} 
        """
