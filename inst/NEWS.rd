\name{NEWS}
\title{NEWS}

\section{Changes in version 1.5.0}{
\itemize{
\item As requested by Gerald Kaendler, 'plot_tree_plot_area()' now plots all trees
of a corner, if no tree number is given.
\item To allow for using the field data, I have added missing dbh to the internal
checks, albeit it being reported by \code{validate_data()}. Just in case I should
forget to validate data first.
}
}

\section{Changes in version 1.4.1}{
\itemize{
\item fritools back on CRAN.
}
}

\section{Changes in version 1.4.0}{
\itemize{
\item Fixed \code{validate_data()} for boundaries (we accidentally deleted the flexing
points).
\item Now passing argument \code{counting_factor} from \code{get_corrections_factors()} down.
\item It is now possible to disable checking the angle counts in
\code{get_corrections_factors()} via argument \code{skip_check = TRUE}.
This enables us to check for concentric circles otherwise marked as invalid an
given correction factors of 0.
}
}

\section{Changes in version 1.3.1}{
\itemize{
\item Get rid of importing fritools.
\item Fixed typo in docs.
}
}

\section{Changes in version 1.3.0}{
\itemize{
\item We now check that trees include the corner's center in their plot area and
otherwise assign a correction factor of 0.
Such trees occur when the diameters where not measured at  breast height and
got corrected. Otherwise, \code{bwi2022de} would have complained about them being
invalid sample trees.
\item Streamlined internal status codes.
}
}

\section{Changes in version 1.2.0}{
\itemize{
\item Exported function \code{check_boundaries()}. It looks for invalid boundaries, one
of which occurs in the federal database of the 2012 survey.
\item \code{select_valid_angle_count_trees()} now removes trees with a diameter at breast
height greater than zero and a distance of 0, for these tree should not be
there.
Gerald/grenzkreis gives a warning, but assigns a correction factor >= 1.
Probably, these trees get filter out somewhere down the food chain.
We assign a correction factor of 0 instead of only issue a warning.
}
}

\section{Changes in version 1.1.0}{
\itemize{
\item We are checking for boundaries that happen to run through a tract's corner.
It's not even clear how we would define \code{stand} if such a boundary would be
valid.
Despite that we by default keep and not delete these boundaries
since they were dealt with by \code{grenzkreis}. So we do that, too.
You may get rid of them using \code{get_boundary_polygons(..., clean_data = TRUE)}
explicitly.
\item \code{get_corrections_factors()} now adds status codes and info to the output.
\item Added testing suite for internal function \code{get_corrections_factor}, which is
the main work horse in the package (to which \code{get_corrections_factors()} is
just a wrapper looping over the trees.
\item Added verbosity to internal function \code{secant_intersection()} to not throw
warnings all over the place.
\item Added internal function \code{tree_and_boundary()} for manually double checking on
trees and boundaries. It's not documented but you may use it to check on
constellation where you have doubts.
\item Added \code{validate_data()} to validate data to conform to the standards of the
federal database.
\item \code{get_corrections_factors()} now returns NA instead of stopping on \emph{any} error.
}
}

\section{Changes in version 1.0.0}{
\itemize{
\item Using internal \code{get_options()} the define column names in data frames.
\item Refactored the options.
\item Added \code{set_options()} and \code{get_defaults()}
\item Added vignette.
\item Added grenzkreis sources.
\item Exported \code{plot_tree_plot_area()}.
}
}

\section{Changes in version 0.5.0}{
\itemize{
\item Got rid of stale functions.
}
}

\section{Changes in version 0.4.0}{
\itemize{
\item Many minor data, docs and testing stuff done. Package is now quite well
tested, but documentation lacks. And we need to pass column names.
}
}

\section{Changes in version 0.3.0}{
\itemize{
\item Fixed for including triangles.
}
}

\section{Changes in version 0.2.0}{
\itemize{
\item Use pentagons instead of triangles for flexed boundaries.
}
}

\section{Changes in version 0.1.0}{
\itemize{
\item Added a \code{NEWS.md} file to track changes to the package.
}
}

