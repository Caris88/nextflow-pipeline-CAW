process MULTIQC {
    label 'multiqc'
    publishDir "results/multiqc", mode: 'copy'

    container "quay.io/biocontainers/multiqc:1.22--pyhdfd78af_0"


    input:
    path qc_files // can accept multiple JSON/HTML files

    output:
    path "multiqc_report.html"
    path "multiqc_data" // directory

    script:

    """
    multiqc . -o . 

    """
}
