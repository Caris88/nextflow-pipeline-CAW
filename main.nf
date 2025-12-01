#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.reads   = "*_251.fastq.gz"
params.outdir  = "results"
params.min_len = 500
params.min_q   = 7
params.target_bases = 1000000000   // for filtlong (optional): keep best 1 Gbp

include { NANOPLOT as NANOPLOT_RAW }  from './nanoplot.nf'
include { NANOPLOT as NANOPLOT_FILTERED } from './nanoplot.nf'
include { NANOPLOT as NANOPLOT_HIGH } from './nanoplot.nf'
include { NANOFILT }  from './nanofilt.nf'
include { FILTLONG }  from './filtlong.nf'
include { MULTIQC }   from './multiqc.nf'

workflow {

    // Step 0 - Input reads
    Channel
        .fromPath(params.reads)
        .ifEmpty { error "No FASTQ files found with pattern: ${params.reads}" }
        .set { ch_reads }

    // Step 1 — QC raw reads (Nanoplot)
    raw_qc = NANOPLOT_RAW(ch_reads)

    ch_reads.view()

    // Step 2 — Basic filtering (Nanofilt)
    filtered_reads = NANOFILT(ch_reads)

    filtered_reads.view()

    // Step 3 - QC filtered reads
    filtered_qc = NANOPLOT_FILTERED(filtered_reads)

    // Step 4 — High-quality selection (Filtlong) (optional)
    highqual_reads = FILTLONG(filtered_reads)

    // Step 5 - QC high-quality reads
    highqual_qc = NANOPLOT_HIGH(highqual_reads)

    // Step 6 — Collect all Nanoplot outputs HTML files for MultiQC 
    // Only include files/folders that exist
    Channel
	.fromPath("results/nanoplot/**/*.{html}") 
	.ifEmpty { error "No Nanoplot summary files found for MultiQC" }
	.set { multiqc_input }

    // Step 7 - MultiQC summary
    MULTIQC(multiqc_input)
}
