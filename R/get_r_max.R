#' Get a Theoretical Maximum Distance for a Tree
#'
#' Maximum distance is of interest as boundaries that are more than double that
#' distance away are of no interest.
#' This only a convenience wrapper to \code{\link{get_boundary_radius}}.
#' @return A theoretical maximum distance in centimeter. Based on the assumption
#' that trees have a maximum diameter at breast height of 200 cm.
#' @inheritParams get_boundary_radius
#' @export
#' @keywords internal
#' @examples
#' get_r_max(counting_factor = 4)
get_r_max <- function(counting_factor, area = 1e04) {
    # Unit needs to be centimeter as this is the way the horizontal distance is
    # recorded.
    # A tree with a diameter at breast height of 2000 millimeter.
    # We don't expect any more.
    res <- get_boundary_radius(dbh = 2000, unit = "cm",
                               counting_factor = counting_factor, area = area)
    return(res)
}
