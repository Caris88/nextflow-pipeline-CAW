process NANOFILT {

    tag "${reads.baseName}"

    label 'nanofilt'

    publishDir "results/nanofilt", mode: 'copy'

    container "docker.io/prccar005/nanofilt:v1"

    input:
    path reads

    output:
    path "${reads.baseName}.nanofilt.fastq.gz"

    script:
    """
    gunzip -c ${reads} | NanoFilt --quality 10 | gzip > ${reads.baseName}.nanofilt.fastq.gz
    """
}
