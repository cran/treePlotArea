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



