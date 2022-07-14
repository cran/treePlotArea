#' Angle Count Sampling of the German National Inventory 2022
#'
#' This is an extract form a data set prepared by Gerald Kaendler.
#' He
#' \enumerate{
#'     \item added trees that are not part of the angle count sampling,
#'     \item converted the diameter at breast height from millimeter to
#'     centimeter and renamed it,
#'     \item converted horizontal distance from centimeter to meter and renamed
#'     it,
#'     \item computed correction factors using \command{grenzkreis}.
#' }
#' @format A data frame with 1121 observations on the following 9 variables.
#' Variables not needed with the package are marked with an asterisk.
#'   \describe{
#'     \item{\code{tnr}}{The tract id.}
#'     \item{\code{enr}}{The corner id. A tract may have up to 4 corners on
#'     wooden floor.}
#'     \item{\code{bnr}}{The tree id.}
#'     \item{\code{bhd2}}{The diameter at breast height, given in centimeter}.
#'     \item{\code{kf2}}{* The correction factor given by \command{grenzkreis}}.
#'     \item{\code{entf}}{The trees' distance from the center of the tract's
#'     corner, given in meter.}
#'     \item{\code{azi}}{The azimuth from North, measured in gon (or gradian).}
#'     \item{\code{pk}}{* An indicator giving the type of a tree in the German
#'     national forest inventory. 0 marks ingrowth, 1 marks ongrowth.}
#'     \item{\code{stp}}{* An indicator giving the type of sample the tree was
#'     in. 0 marks the angle count sample with counting factor 4.}
#'   }
#' @inherit bw2bwi2022de examples
#' @inherit select_valid_angle_count_trees examples
#' @usage data("trees", package = "treePlotArea")
#' @keywords datasets
"trees"


#' Boundaries of the German National Inventory 2022
#'
#' An extract from the the federal database. Refer to \emph{Aufnahmeanweisung
#' für die vierte Bundeswaldinventur (2021 - 2022)}.
#' @format  A data frame with 148 observations on the following 13 variables.
#' Variables not needed with the package are marked with an asterisk.
#'   \describe{
#'     \item{\code{tnr}}{The tract id.}
#'     \item{\code{enr}}{The corner id. A tract may have up to 4 corners on
#'     wooden floor.}
#'     \item{\code{vbl}}{* An indicator giving the country. 804 denotes
#'     Baden-Wuerttemberg.}
#'     \item{\code{rnr}}{* The boundary id.}
#'     \item{\code{rk}}{An indicator giving the validity of the boundary. Values
#'     of 9 or higher indicate that this boundary is not valid (any more).}
#'     \item{\code{rart}}{An indicator giving the type of the boundary (stand or
#'     forest boundary, for example).}
#'     \item{\code{rterrain}}{* An Indicator giving the type of terrain behind
#'     the border.}
#'     \item{\code{spa_gon}}{The azimuth in gon of the starting point of the
#'     boundary.}
#'     \item{\code{spa_m}}{The distance to the starting point of the boundary in
#'     centimeter}
#'     \item{\code{spk_gon}}{As above, for the boundary's flexing point.}
#'     \item{\code{spk_m}}{As above, for the boundary's flexing point.}
#'     \item{\code{spe_gon}}{As above, for the boundary's stopping point.}
#'     \item{\code{spe_m}}{As above, for the boundary's stopping point.}
#'   }
#' @references
#' \cite{
#' Aufnahmeanweisung für die vierte Bundeswaldinventur (2021 - 2022)
#' Johann Heinrich von Thünen-Institut. Bundesforschungseinheit für
#' Ländliche Räume, Wald und Fischerei, Thünen-Institut für
#' Waldökologie.
#' }
#' @usage data("boundaries", package = "treePlotArea")
#' @keywords datasets
#' @examples
#' boundaries <- get(data("boundaries", package = "treePlotArea"))
#' fritools::is_valid_primary_key(boundaries, c("tnr", "enr", "rnr"))
"boundaries"
