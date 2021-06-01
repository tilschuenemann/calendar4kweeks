test_that("inputs are correct", {
  expect_error(
    create_calendar("test", "#000000", "#000000"),
    "birthdate must be a date"
  )
  expect_error(
    create_calendar("2021-01-01", "test", "#000000"),
    "col_past must be a RGB color"
  )
  expect_error(
    create_calendar("2021-01-01", "#000000", "test"),
    "col_past must be a RGB color"
  )
})

# test_that("output is ggplot",{
#  expect_condition(create_calendar("2021-01-01","#000000", "#000000"),)
# })
