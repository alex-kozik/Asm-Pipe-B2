rule sort_sequences:
    input:
        "results/{asmname}/03.contigs_all/Contigs_HiFiasm_{asmname}.bp.p_ctg.fasta"
    output:
        "results/{asmname}/04.contigs_filtered/Contigs_HiFiasm_{asmname}.Sorted.fa",
    log:
        "results/logs/04.contigs_filtered/sort_sequences/{asmname}.log"
    benchmark:
        "results/benchmarks/04.contigs_filtered/sort_sequences/{asmname}.txt"
    conda:
        "../envs/bioawk.yaml"
    shell:
        """
        (
        bioawk -c fastx '{{ print ">"$name, length($seq), $seq }}' {input} | sort -k2nr > {output}
        perl -p -i -e 's/\\t/  L:/' {output}
        perl -p -i -e 's/\\t/ \\n/' {output}
        ) &> {log}
        """

rule filter_sequences:
    input:
        "results/{asmname}/04.contigs_filtered/Contigs_HiFiasm_{asmname}.Sorted.fa",
    output:
        "results/{asmname}/04.contigs_filtered/Contigs_HiFiasm_{asmname}.{minlen}.fa",
    log:
        "results/logs/04.contigs_filtered/filter_sequences/{asmname}.{minlen}.log"
    benchmark:
        "results/benchmarks/04.contigs_filtered/filter_sequences/{asmname}.{minlen}.txt"
    conda:
        "../envs/bioawk.yaml"
    shell:
        "bioawk -c fastx '{{ if(length($seq) >= {wildcards.minlen}) {{print \">\"$name; print $seq }} }}' {input} > {output} 2> {log}"
