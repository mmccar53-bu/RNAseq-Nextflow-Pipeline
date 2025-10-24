#!/usr/bin/env nextflow

process CONCAT {
    label 'process_medium'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path exon_files

    output:
    path "counts_matrix.csv", emit: counts_matrix

    script:
    """
    concat.py \
        --input_dir . \
        --output_file counts_matrix.csv
    """
}