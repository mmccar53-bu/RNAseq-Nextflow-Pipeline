#!/usr/bin/env nextflow

process VERSE {
    label 'process_high'
    container 'ghcr.io/bf528/verse:latest'  
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(bam)
    path gtf

    output:
    path "${sample_id}.exon.txt", emit: exon_counts

    shell:
    """
    verse -bam $bam -S -o ${sample_id}.exon.txt -a $gtf
    """

    stub:
    """
    touch ${sample_id}.exon.txt
    """
}