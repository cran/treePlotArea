create_triangle <- function(xy1xy0xy2, verbose = FALSE, r) {
    if (isTRUE(verbose)) message("# is acute angle -> triangle will do")
    # first side
    straight_line <- points2equation(c(xy1xy0xy2["x1"], xy1xy0xy2["y1"]),
                                     c(xy1xy0xy2["x0"], xy1xy0xy2["y0"]))
    si <- secant_intersections(straight_line["a"], straight_line["b"], r)
    s10 <- si[1, TRUE] - c(xy1xy0xy2[["x0"]], xy1xy0xy2[["y0"]])
    s11 <- si[1, TRUE] - c(xy1xy0xy2[["x1"]], xy1xy0xy2[["y1"]])

    if (vector_length(s11) < vector_length(s10)) {
        i1 <- si[1, TRUE]
    } else {
        i1 <- si[2, TRUE]
    }

    # second side
    straight_line <- points2equation(c(xy1xy0xy2["x2"], xy1xy0xy2["y2"]),
                                     c(xy1xy0xy2["x0"], xy1xy0xy2["y0"]))
    si <- secant_intersections(straight_line["a"], straight_line["b"], r)
    s10 <- si[1, TRUE] - c(xy1xy0xy2[["x0"]], xy1xy0xy2[["y0"]])
    s11 <- si[1, TRUE] - c(xy1xy0xy2[["x2"]], xy1xy0xy2[["y2"]])
    if (vector_length(s11) < vector_length(s10)) {
        i2 <- si[1, TRUE]
    } else {
        i2 <- si[2, TRUE]
    }
    res <- rbind(
                 c(xy1xy0xy2[["x0"]], xy1xy0xy2[["y0"]]),
                 i1, i2,
                 c(xy1xy0xy2[["x0"]], xy1xy0xy2[["y0"]])
                 )
    return(res)
}
