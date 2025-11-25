create_pentagon <- function(xy1xy0xy2, verbose = FALSE, r) {
    triangle <- create_triangle(xy1xy0xy2, verbose = verbose, r = r)
    xy1xy2 <- c(triangle[2, TRUE], triangle[3, TRUE])
    names(xy1xy2) <- c("x1", "y1", "x2", "y2")
    tetragon <- create_tetragon(xy1xy2, verbose = FALSE, r = r)
    # insert nook in between rows 1 and 2 of tetragon:
    res <- do.call("rbind", list(tetragon[1, TRUE],
                                 triangle[1, TRUE],
                                 tetragon[2:5, TRUE])
    )
    return(res)
}
