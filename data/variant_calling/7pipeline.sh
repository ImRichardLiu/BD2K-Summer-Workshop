genome=ref_genome/ecoli_rel606.fasta
bwa index $genome
samtools faidx $genome
for shhh in trimmed_fastq/*.fastq
do
    base=$(basename $shhh .fastq)
    fq=trimmed_fastq/$base\.fastq
    sai=results/sai/$base\_aligned.sai
    sam=results/sam/$base\_aligned.sam
    bam=results/bam/$base\_aligned.bam
    sorted_bam=results/bam/$base\_aligned_sorted.bam
    raw_bcf=results/bcf/$base\_raw.bcf
    variants=results/bcf/$base\_variants.bcf
    final_variants=results/vcf/$base\_final_variants.vcf
    bwa aln $genome $fq > $sai
    bwa samse $genome $sai $fq > $sam
    samtools view -S -b $sam > $bam
    samtools sort -f $bam $sorted_bam
    samtools index $sorted_bam
    samtools mpileup -g -f $genome $sorted_bam > $raw_bcf
    bcftools view -bvcg $raw_bcf > $variants
    bcftools view $variants | /usr/share/samtools/vcfutils.pl varFilter - > $final_variants
done