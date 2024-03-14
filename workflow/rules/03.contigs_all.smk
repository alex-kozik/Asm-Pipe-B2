rule gfa2fasta:
    input:
        #"results/{asmname}/02.hifiasm/HiFiasm_{asmname}.bp.p_ctg.gfa"  #TODO: uncomment this line to use hifiasm
        lambda wildcards: config["gfa_hifiasm"][wildcards.name]         #TODO: remove this line to use hifiasm
    output:
        #"results/{asmname}/03.contigs_all/Contigs_HiFiasm_{asmname}.bp.p_ctg.fasta"               #TODO: uncomment this line to use hifiasm
        "results/{name}/03.contigs_all/Contigs_HiFiasm_{name}.bp.p_ctg.fasta"  #TODO: remove this line to use hifiasm
    log:
        #"results/logs/03.contigs_all/gfa2fasta/{asmname}.log"        #TODO: uncomment this line to use hifiasm
        "results/logs/03.contigs_all/gfa2fasta/{name}.log"  #TODO: remove this line to use hifiasm
    benchmark:
        #"results/benchmarks/03.contigs_all/gfa2fasta/{asmname}.txt"        #TODO: uncomment this line to use hifiasm
        "results/benchmarks/03.contigs_all/gfa2fasta/{name}.txt"  #TODO: remove this line to use hifiasm
    shell:
        "awk '/^S/{{print \">\"$2; print $3;}}' {input} > {output} 2> {log}"
