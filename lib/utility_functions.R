trimstr <- function(x) gsub("^\\s+|\\s+$", "", x)

dis_cor <- function(x, method = "spearman") as.dist(1 - cor(t(x), method = method))

hclust_avl <- function(x) hclust(x, method = "average")

cat2 <- function(x) {
  factor(x > median(x),
    levels = c(FALSE, TRUE),
    labels = c("Low", "High"))
}

cat3 <- function(x) {
  factor(cut(x, c(-Inf, quantile(x, c(1/3, 2/3)), Inf)),
    c("Low", "Medium", "High"))
}

cat4 <- function(x) {
  factor(cut(x, c(-Inf, quantile(x, c(0.25, 0.5, 0.75)), Inf)),
    labels = c("Q1", "Q2", "Q3", "Q4"))
}
