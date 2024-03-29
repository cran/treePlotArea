% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/secant_intersections.R
\name{secant_intersections}
\alias{secant_intersections}
\title{Calculate Intersections of Circle by a Straight Line}
\usage{
secant_intersections(a, b, r, verbose = FALSE)
}
\arguments{
\item{a}{The secant's intercept.}

\item{b}{The secant's slope.}

\item{r}{The circle's radius}

\item{verbose}{Be verbose?}
}
\value{
A matrix of x und y values. For a tangent, both rows are identical,
for a straight line missing the circle, a matrix of \code{\link{NA}}.
}
\description{
The circle is centered a (0, 0) and has radius r, the line is given in
slope-intercept from.
}
\examples{
secant_intersections(a = 0, b = 1, r = 2)
# A tangent
secant_intersections(a = 2, b = 0, r = 2, verbose = TRUE)
# Missing the circle
secant_intersections(a = 3, b = 0, r = 2)
# Creating a circle boundary approximation
plot(0, 0, col = "red", pch = "+",
     xlim = c(-2, 2),
     ylim = c(-2, 2))
for (i in seq(-1, 1, by = 0.01)) {
         points(secant_intersections(Inf, i, 1), pch = "+")
}
}
\keyword{internal}
