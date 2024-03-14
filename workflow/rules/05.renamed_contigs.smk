rule add_prefix:
    input:
        "results/{asmname}/04.contigs_filtered/Contigs_HiFiasm_{asmname}.{minlen}.fa",
    output:
        "results/{asmname}/05.contigs_renamed/Contigs_HiFiasm_{asmname}.{minlen}.Renamed.fa",
    log:
        "results/logs/05.contigs_renamed/add_prefix/{asmname}.{minlen}.log"
    benchmark:
        "results/benchmarks/05.contigs_renamed/add_prefix/{asmname}.{minlen}.txt"
    params:
        prefix = lambda wildcards: f"{wildcards.asmname}_C"
    conda:
        "../envs/bioawk.yaml"
    shell:
        """
        (
        bioawk -c fastx '{{ print ">{params.prefix}" $name; print $seq }}' {input} > {output}
        perl -p -i -e 's/ptg00//' {output}
        ) &> {log}
        """
