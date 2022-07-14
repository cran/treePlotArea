create_tetragon <- function(xy1xy2, verbose = FALSE, r = 2 * get_r_max()) {
    if (isTRUE(verbose)) message("# is one line -> need tetragon")
    straight_line <- points2equation(c(xy1xy2["x1"], xy1xy2["y1"]),
                                     c(xy1xy2["x2"], xy1xy2["y2"]))
    si <- secant_intersections(straight_line["a"], straight_line["b"], r)
    length_of_chord <- vector_length(c(si[1, "x"] - si[2, "x"],
                                       si[1, "y"] - si[2, "y"]))
    o <- orthogonal(straight_line["b"], c(x = si[1, "x"], y = si[1, "y"]))
    b <- o["b"]
    dx <- sqrt(length_of_chord^2 / (b^2 + 1))
    dy <- b * dx
    xyplus <- si[1, TRUE] + c(dx, dy)
    xyminus <- si[1, TRUE] + c(-dx, -dy)
    corners_away_from_origin <- NULL
    if (vector_length(xyplus) > vector_length(xyminus)) {
        corners_away_from_origin <- matrix(c(si[2, TRUE] + c(dx, dy), xyplus),
                                           byrow = TRUE, ncol = 2,
                                           dimnames = list(c("3", "4"),
                                                           c("x", "y")))
    } else {
        corners_away_from_origin <- matrix(c(si[2, TRUE] - c(dx, dy), xyminus),
                                           byrow = TRUE, ncol = 2,
                                           dimnames = list(c("3", "4"),
                                                           c("x", "y")))
    }
    tetragon <- rbind(si, corners_away_from_origin, si[1, TRUE])
    res <- tetragon
    return(res)
}
