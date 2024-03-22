rule ntjoin:
    input:
        reference = lambda wildcards: config["ref_genome"][wildcards.ref_gen],
        contigs   = "results/{asmname}/05.contigs_renamed/Contigs_HiFiasm_{asmname}.{minlen}.Renamed.fa",
    output: 
        all = "results/{asmname}/06.ntjoin/Scaffolds_HiFiasm_{asmname}.vs.{ref_gen}.{minlen}.k{k}.w{w}.n1.all.scaffolds.fa",
        assigned = "results/{asmname}/06.ntjoin/Scaffolds_HiFiasm_{asmname}.vs.{ref_gen}.{minlen}.k{k}.w{w}.n1.assigned.scaffolds.fa",
        unassigned = "results/{asmname}/06.ntjoin/Scaffolds_HiFiasm_{asmname}.vs.{ref_gen}.{minlen}.k{k}.w{w}.n1.unassigned.scaffolds.fa"
    log:
        "results/logs/06.ntjoin/{asmname}.vs.{ref_gen}.{minlen}.k{k}.w{w}.log"
    benchmark:
        "results/benchmarks/06.ntjoin/{asmname}.vs.{ref_gen}.{minlen}.k{k}.w{w}.txt"
    threads:
        5
    conda:
        "../envs/ntjoin.yaml"
    shell:
        """
        (
        ln -s $(realpath {input.contigs}) $(dirname {output.all})/Scaffolds_HiFiasm_{wildcards.asmname}.vs.{wildcards.ref_gen}.{wildcards.minlen}
        cd $(dirname {output.all})
        ntJoin assemble target=Scaffolds_HiFiasm_{wildcards.asmname}.vs.{wildcards.ref_gen}.{wildcards.minlen} references='{input.reference}' target_weight='1' reference_weights='2' G=10000 agp=True no_cut=True overlap=False n=2 k={wildcards.k} w={wildcards.w} mkt=True prefix=$(basename {output.all} | rev | cut -d '.' -f 2- | rev) t={threads}
        ) &> {log}
        """
