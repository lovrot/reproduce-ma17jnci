ProjectTemplate::reload.project()

message("Performing differential expression analysis")

## "Probesets were mapped to Entrez Gene IDs using the 
## hta20sttranscriptcluster.db package (version 8.3.1) and expression data was 
## collapsed to gene level using using the featureFilter function in the 
## genefilter package (version 1.52.0), i.e. a non-specific filter keeping only 
## the probesets with highest interquartile range in the case of multiple 
## mappings to the same Entrez Gene ID."

eset <- genefilter::featureFilter(erbeta)

## "A total of 7 samples were analysed: 3 biological replicates of MCF7-S cells 
## treated with DPN and 4 biological replicates of MCF7-S cells without 
## treatment."

eset <- eset[, eset$cellcd == "MCF7S" & eset$armcd %in% c("C", "D")]
eset$armcd <- eset$armcd[drop = TRUE]

## "Transcriptomal changes in the comparison DPN versus control in MCF7S cells 
## were assessed with moderated t-tests using the limma package (version 3.26.5). 
## Multiple testing was controlled by estimating the false discovery rate (FDR) 
## according to Benjamini and Hochberg."

design <- model.matrix(~ armcd, data = pData(eset))
fit <- lmFit(eset, design)
fit <- contrasts.fit(fit, coefficients = "armcdD")
fit <- eBayes(fit)
tab <- topTable(fit, number = nrow(eset), adjust.method = "BH")

nrow(filter(tab, P.Value < 0.0005))
max(filter(tab, P.Value < 0.0005)$adj.P.Val)  # FDR
tab %>%
  dplyr::select(symbol, entrezid, logFC, AveExpr, t, P.Value, adj.P.Val) %>%
  head()

message("Performing gene set enrichment analysis (GSEA)")

## "Gene-set enrichment analyses (GSEA) of the canonical pathways gene set 
## collection (c2.cp.v5.1.entrez) in the Molecular Signatures Database 
## (Broad Institute, version 5.1) was performed using the GSEA Software 
## (Broad Institute, version 2.2.2) with genes pre-ranked according to the 
## moderated t-test statistics."

rnk <- topTable(fit, number = nrow(eset))[, c("entrezid", "t")]
rnk_file <- file.path("reports", "gsea", "BSC_mod_ttest_DvC.rnk")
write.table(rnk,
  file = rnk_file,
  quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)

gsea_jar <- file.path("resources", "gsea2-2.2.2.jar")
gmt_file <- file.path("resources", "c2.cp.v5.1.entrez.gmt")
rnd_seed <- 2100
output_name <- "BSC_mod_ttest_DvC_c2_cp"
output_dir <- file.path("reports", "gsea")

cmd <- paste("java -Xmx2g -cp", gsea_jar, "xtools.gsea.GseaPreranked",
  "-gmx", gmt_file,
  "-rnk", rnk_file,
  "-rnd_seed", rnd_seed,
  "-rpt_label", output_name,
  "-out", output_dir,
  "-collapse false")
system(cmd, ignore.stdout = TRUE)
