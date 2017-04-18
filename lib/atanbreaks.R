atanbreaks <- function(x, n = 128, trg = 2) {
  if (is(x, "numeric")) {
    ymin <- -x
    ymax <- x
  } else if (is(x, "matrix")) {
    ymin <- min(x)
    ymax <- max(x)
  } else if (is(x, "ExpressionSet")) {
    ymin <- min(exprs(x))
    ymax <- max(exprs(x))
  } else {
    stop(paste("atanbreaks not implemented for class", class(x)))
  }

  scale_atan <- function(n, ymin, ymax, trg) {
    ymin2 <- ymin - 0.05*(ymax - ymin)
    ymax2 <- ymax + 0.05*(ymax - ymin)
    xmin <- atan(ymin2/trg*pi/2)
    xmax <- atan(ymax2/trg*pi/2)
    x_initial <- seq(xmin, xmax, length.out = n-1)
    dx <- min(x_initial[x_initial > 0])
    x <- c(x_initial - dx, max(x_initial) + dx)

    y <- trg/(pi/2)*tan(x)
    return(y)
  }
  scale_atan(n, ymin, ymax, trg)
}
