circle2polygon <- function(origin = c(x = 0, y = 0), r = 1, n = 400) {
    circle <- NULL
    for (i in seq(-r, r, length.out = n / 2)) {
        si <- secant_intersections(Inf, i, r)
        circle <- rbind(circle, c(si[1, TRUE], si[2, TRUE]))
    }
    circle <- rbind(circle[TRUE, c(1, 2)],
                    circle[order(circle[TRUE, 3], decreasing = TRUE), c(3, 4)])
    circle[TRUE, "x"] <-  circle[TRUE, "x"] + origin["x"]
    circle[TRUE, "y"] <-  circle[TRUE, "y"] + origin["y"]
    circle <- rbind(circle, circle[1, TRUE])
    return(circle)
}
