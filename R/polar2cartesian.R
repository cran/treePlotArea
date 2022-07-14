polar2cartesian <- function(phi, distance) {
    x <- cos(deg2rad(phi)) * distance
    y <- sin(deg2rad(phi)) * distance
    res <- cbind(x = x, y = y)
    return(res)
}
