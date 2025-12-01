process NANOPLOT {
    label 'nanoplot'
    cpus 1
    memory '4 GB'
        
    container "quay.io/biocontainers/nanoplot:1.41.3--pyhdfd78af_0"

    input:
    path reads

    output:
    path "*.html"

    publishDir "results/nanoplot", mode: 'copy'

    script:

    """
    NanoPlot --fastq $reads -o .

    """
}
