test_that("inputs are correct", {
  expect_error(
    create_calendar("test"),
    "birthdate must be a date"
  )
})

test_that("output is ggplot", {
  expect_type(
    create_calendar(as.Date("2021-01-01")),
    "list"
  )
})
