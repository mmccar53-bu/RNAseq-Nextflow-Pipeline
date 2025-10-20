#!/usr/bin/env nextflow

process STAR_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path index
    tuple val(name), path(reads)

    output:
    path("${name}.Aligned.sortedByCoord.out.bam"), emit: bam
    path "${name}.Log.final.out", emit: log

    shell:
    """
    STAR --runThreadN $task.cpus --genomeDir $index --readFilesIn ${reads[0]} ${reads[1]} --readFilesCommand zcat --outFileNamePrefix ${name}. --outSAMtype BAM SortedByCoordinate 2> ${name}.Log.final.out
    """

    stub:
    """
    touch ${name}.Aligned.out.bam
    touch ${name}.Log.final.out
    """

}