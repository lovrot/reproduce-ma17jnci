message("Prerocessing CEL files using the Robust Multichip Average (RMA) methodology")

## "Probe intensities were extracted from CEL files and background corrected, 
## normalized and summarized to probeset expression using the pd.hta.2.0 package 
## (version 3.12.1) and the rma function in the oligo package (version 1.34.2)
## with the default settings."

erbeta <- oligo::rma(read.celfiles(gse56139_cel_files))

stopifnot(validObject(erbeta))
