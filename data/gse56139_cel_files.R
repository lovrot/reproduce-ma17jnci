message("Retrieving CEL files from GEO")
destdir <- file.path("cache", "geo")
GEOquery::getGEOSuppFiles("GSE56139", makeDirectory = TRUE, baseDir = destdir)

message("Extracting CEL files")
untar(
  tarfile = file.path(destdir, "GSE56139", "GSE56139_RAW.tar"),
  exdir = file.path(destdir, "GSE56139"))
lapply(
  list.files(
    path = file.path(destdir, "GSE56139"),
    pattern = "*.CEL.gz",
    full.name = TRUE),
  gunzip, overwrite = TRUE)

gse56139_cel_files <- list.files(
  path = file.path(destdir, "GSE56139"),
  pattern = "*.CEL",
  full.name = TRUE)
