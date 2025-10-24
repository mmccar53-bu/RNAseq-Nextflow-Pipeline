#!/usr/bin/env nextflow

include {FASTQC} from './modules/fastqc'
include {INDEX} from './modules/star_index'
include {PARSE_GTF} from './modules/parse_gtf'
include {STAR_ALIGN} from './modules/star_align'
include {MULTIQC} from './modules/multiqc'
include {VERSE} from './modules/verse'
include {CONCAT} from './modules/concat'

workflow {
   
    Channel.fromFilePairs(params.reads).transpose().set{ fastqc_ch }
    Channel.fromFilePairs(params.reads).set { align_ch }
    
    PARSE_GTF(params.gtf)
    FASTQC(fastqc_ch)
    INDEX(params.genome, params.gtf)
    STAR_ALIGN(INDEX.out.index, align_ch)
    multiqc_ch = FASTQC.out.zip.map { sample, files -> files }.flatten().mix(STAR_ALIGN.out.log.map{sample,log -> log}).collect()
    MULTIQC(multiqc_ch)
    VERSE(STAR_ALIGN.out.bam, Channel.value(params.gtf))
    CONCAT(VERSE.out.exon_counts.collect())

}
