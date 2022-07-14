if (requireNamespace("tinytest", quietly = TRUE)) {
  print(R.version)
  tinytest::test_package("treePlotArea")
}
