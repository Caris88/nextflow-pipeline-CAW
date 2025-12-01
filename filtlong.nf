process FILTLONG {
    label 'filtlong'
    publishDir "${params.outdir}/filtlong", mode: 'copy'

    input:
    path reads

    output:
    path "${reads.baseName}.filtlong.fastq.gz"

    script:
    """
    filtlong \
      --min_length 500 \
      --min_mean_q 7 \
      --target_bases 1000000000 \
      ${reads} \
    | gzip -c > ${reads.baseName}.filtlong.fastq.gz
    """
}
