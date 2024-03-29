% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_boundary_polygons.R
\name{get_boundary_polygons}
\alias{get_boundary_polygons}
\title{Convert Boundaries to Polygons}
\usage{
get_boundary_polygons(boundaries, stop_on_error = TRUE, clean_data = FALSE)
}
\arguments{
\item{boundaries}{A \code{\link{data.frame}} containing boundaries.
It has to have columns named by the contents of
either\cr
\code{\link{get_defaults}()[["boundaries"]]} or \cr
\code{getOption("treePlotArea")[["boundaries"]]}.\cr
Could be
\code{get(data("boundaries", package = "treePlotArea"))} or the
output of
\code{\link{get_boundary_polygons}}.}

\item{stop_on_error}{Throw an error if invalid boundaries are encountered?
(There was tract 6878, corner 1, boundary 1 in the federal
database for the 2012 survey, runs through the plot.
There is no stand defined that way!).}

\item{clean_data}{Omit invalid boundaries in any further calculations?}
}
\value{
A list with all boundary polygons for each corner for each tract.
}
\description{
Used by \code{\link{get_correction_factors}} to convert a boundary table
to polygons. You may want to see the polygons, that is why we exported this
function.
}
\examples{
boundaries <- get(data("boundaries", package = "treePlotArea"))
boundary_polygons <- get_boundary_polygons(boundaries)
}
\seealso{
Other boundary functions: 
\code{\link{check_boundaries}()}
}
\concept{boundary functions}
