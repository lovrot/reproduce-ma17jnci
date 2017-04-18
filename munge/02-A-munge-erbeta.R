## Extract and append phenotypic data
celnam <- sampleNames(erbeta)
celnam2 <- gsub("MCF7_S", "MCF7S", celnam, fixed = TRUE)

geo_accession <- unlist(lapply(strsplit(celnam, "_"), function(x) x[1]))
arraycd <- unlist(lapply(strsplit(celnam, "_"), function(x) x[2]))
condnam <- unlist(lapply(strsplit(celnam, "_"), function(x) x[3]))
cellcd <- unlist(lapply(strsplit(celnam2, "_"), function(x) x[4]))

armcd <- substr(gsub("DP", "P", condnam), 1, 1)
replicate <- substr(gsub("DP", "P", condnam), 2, 2)

lkup <- c("C" = "Control", "D" = "DPN", "P" = "DPN/PHTPP")

pData(erbeta) <- 
  tibble(
    geo_accession = geo_accession,
    arraycd = arraycd,
    cellcd = cellcd,
    armcd = factor(armcd, levels = names(lkup)),
    arm = factor(lkup[armcd], levels = lkup),
    replicate = replicate, 
    condnam = condnam, 
    celnam = celnam) %>%
  data.frame(row.names = sampleNames(erbeta))

stopifnot(validObject(erbeta))

sampleNames(erbeta) <- erbeta$arraycd

## Append annotation data

## "Probesets were mapped to Entrez Gene IDs using the 
## hta20sttranscriptcluster.db package (version 8.3.1) ..."

## The original analysis was performed using R version 3.2.3. 
## Here, we've instead used the hta20transcriptcluster.db annotation package
## (no "st" in the package name) as of R version 3.3 and higher.
## https://support.bioconductor.org/p/91448/

annotation(erbeta) <- "hta20transcriptcluster"

fData(erbeta) <- fData(erbeta) %>%
  mutate(
    probeid = featureNames(erbeta),
    entrezid = unlist(mget(
      featureNames(erbeta),
      hta20transcriptclusterENTREZID,
      ifnotfound = NA)),
    symbol = unlist(mget(
      featureNames(erbeta),
      hta20transcriptclusterSYMBOL,
      ifnotfound = NA))) %>%
  as.data.frame(row.names = featureNames(erbeta))

stopifnot(validObject(erbeta))
