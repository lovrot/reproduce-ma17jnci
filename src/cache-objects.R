unlink(list.files(path = "cache", pattern = "*.RData", full.names = TRUE))
ProjectTemplate::reload.project(list(data_loading = TRUE, munging = TRUE))

ProjectTemplate::cache("gse56139_cel_files")
ProjectTemplate::cache("erbeta")
