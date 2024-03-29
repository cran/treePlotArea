% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/orthogonal.R
\name{orthogonal}
\alias{orthogonal}
\title{Get the Slope–intercept Form of an Orthogonal}
\usage{
orthogonal(b, xy)
}
\arguments{
\item{b}{The slope.}

\item{xy}{The point.}
}
\value{
A named vector with intercept ["a"] and slope ["b"], as in
\code{\link[graphics:abline]{graphics::abline}}.
If the slope was 0, there is no slope-intercept form as this is a vertical
line. Then the intercept is \code{\link{NA}} and the slope gives the value of
x.
}
\description{
If slope-point form of an equation is given, we might be interested in the
slope-intercept form of the orthogonal to the equation running through the
point.
}
\examples{
orthogonal(1, c(x = 0, y = 0))
orthogonal(0, c(x = 4, y = 0))
orthogonal(-1, c(x = -2, y = -2))
orthogonal(Inf, c(x = 0, y = 4))
}
\keyword{internal}
