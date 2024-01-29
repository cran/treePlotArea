# treePlotArea 2.0.0

* Fixed checking for flexed boundaries running through the origin.

# treePlotArea 1.5.0

* As requested by Gerald Kaendler, 'plot_tree_plot_area()' now plots all trees
  of a corner, if no tree number is given.
* To allow for using the field data, I have added missing dbh to the internal
  checks, albeit it being reported by `validate_data()`. Just in case I should
  forget to validate data first.

# treePlotArea 1.4.1

* fritools back on CRAN.

# treePlotArea 1.4.0

* Fixed `validate_data()` for boundaries (we accidentally deleted the flexing
  points).
* Now passing argument `counting_factor` from `get_corrections_factors()` down.
* It is now possible to disable checking the angle counts in
  `get_corrections_factors()` via argument `skip_check = TRUE`.
  This enables us to check for concentric circles otherwise marked as invalid an
  given correction factors of 0.

# treePlotArea 1.3.1

* Get rid of importing fritools.
* Fixed typo in docs.

# treePlotArea 1.3.0

* We now check that trees include the corner's center in their plot area and
  otherwise assign a correction factor of 0.
  Such trees occur when the diameters where not measured at  breast height and
  got corrected. Otherwise, `bwi2022de` would have complained about them being
  invalid sample trees.
* Streamlined internal status codes.

# treePlotArea 1.2.0

* Exported function `check_boundaries()`. It looks for invalid boundaries, one
  of which occurs in the federal database of the 2012 survey.
* `select_valid_angle_count_trees()` now removes trees with a diameter at breast
   height greater than zero and a distance of 0, for these tree should not be
   there. 
   Gerald/grenzkreis gives a warning, but assigns a correction factor >= 1. 
   Probably, these trees get filter out somewhere down the food chain.
   We assign a correction factor of 0 instead of only issue a warning.


# treePlotArea 1.1.0

* We are checking for boundaries that happen to run through a tract's corner.
  It's not even clear how we would define `stand` if such a boundary would be
  valid. 
  Despite that we by default keep and not delete these boundaries
  since they were dealt with by `grenzkreis`. So we do that, too.
  You may get rid of them using `get_boundary_polygons(..., clean_data = TRUE)`
  explicitly.
* `get_corrections_factors()` now adds status codes and info to the output.
* Added testing suite for internal function `get_corrections_factor`, which is
  the main work horse in the package (to which `get_corrections_factors()` is
  just a wrapper looping over the trees.
* Added verbosity to internal function `secant_intersection()` to not throw
  warnings all over the place.
* Added internal function `tree_and_boundary()` for manually double checking on
  trees and boundaries. It's not documented but you may use it to check on
  constellation where you have doubts.
* Added `validate_data()` to validate data to conform to the standards of the
  federal database.
* `get_corrections_factors()` now returns NA instead of stopping on _any_ error.

# treePlotArea 1.0.0

* Using internal `get_options()` the define column names in data frames.
* Refactored the options.
* Added `set_options()` and `get_defaults()`
* Added vignette.
* Added grenzkreis sources.
* Exported `plot_tree_plot_area()`.

# treePlotArea 0.5.0

* Got rid of stale functions.

# treePlotArea 0.4.0

* Many minor data, docs and testing stuff done. Package is now quite well
  tested, but documentation lacks. And we need to pass column names.

# treePlotAreas 0.3.0

* Fixed for including triangles.

# treePlotAreas 0.2.0

* Use pentagons instead of triangles for flexed boundaries.

# treePlotAreas 0.1.0
* Added a `NEWS.md` file to track changes to the package.



