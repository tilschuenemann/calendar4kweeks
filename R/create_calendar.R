
#' Create a 4k weeks calendar!
#'
#' @param birthdate your birthdate, format: yyyy-mm-dd
#' @param passed_color rgb color for passed weeks
#' @param col_future rgb color for future weeks
#'
#' @return 4k weeks calendar as ggplot object
#' @export
#'
#' @importFrom lubridate is.Date
#' @importFrom lubridate today
#' @importFrom dplyr mutate
#' @importFrom ggplot2 ggplot
#' @importFrom dplyr "%>%"
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 theme_light
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 scale_color_manual
#' @importFrom ggplot2 scale_shape_manual
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 element_blank
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 scale_y_discrete
#' @importFrom ggplot2 scale_x_discrete
#' @importFrom ggplot2 aes
#' @importFrom graphics title
#' @importFrom lubridate ymd
#'
create_calendar <- function(birthdate, passed_color = "#000000", future_color = "#000000") {

  # debugging
  # birthdate <- as.Date("2000-01-01")
  # passed_color <- "#00ff00"
  # future_color <- "#ff0000"
  #birthdate <- "test"

  result = tryCatch({
    ymd(birthdate)
  }, warning = function(w) {
    stop("birthdate must be a date")
  }, error = function(e) {
    stop("birthdate must be a date")
  })

  birthdate <- ymd(birthdate)

  # check for correct inputs
  if (!is.Date(birthdate)) {
    stop("birthdate must be a date")
  } else if (!grepl(pattern = "#{1}[0-9a-f]{6}", passed_color)) {
    stop("col_past must be a RGB color")
  } else if (!grepl(pattern = "#{1}[0-9a-f]{6}", future_color)) {
    stop("col_past must be a RGB color")
  }

  # set colors
  mycol <- c(
    "1" = passed_color,
    "0" = future_color
  )

  # result df
  caldf <- NULL

  j <- 80L

  for (i in 1:j) {
    entry <- data.frame(
      year = i,
      week = seq(1L:52L)
    )

    caldf <- rbind(caldf, entry)
  }

  # shapes can only can be displayed if scales are discrete (week, year)
  caldf <- caldf %>%
    mutate(
      year = as.factor(caldf$year),
      week = as.factor(caldf$week),
      id = as.integer(rownames(caldf)),
      passed = as.factor(ifelse(id < as.integer(((today() - birthdate)) / 7), "1", "0"))
    )

  font_size <- 12

  calplot <- ggplot(caldf, aes(week, year, color = passed, shape = passed)) +
    geom_point() +
    theme_light() +
    labs(x = "weeks", y = "years", title = "my life in 4000 weeks") +
    scale_color_manual(values = mycol) +
    scale_shape_manual(values = c(0, 15)) +
    theme(
      panel.grid.major = element_blank(),
      legend.position = "none",
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      axis.ticks = element_blank(),
      plot.title = element_text(family = "serif", size = 20),
      axis.title.x = element_text(family = "serif", hjust = 0, size = font_size),
      axis.title.y = element_text(family = "serif", vjust = 1, angle = 0, size = font_size),
      axis.text = element_text(family = "serif", )
    ) +
    scale_y_discrete(breaks = seq(5, 80, by = 5), limits = rev) +
    scale_x_discrete(breaks = seq(5, 80, by = 5), position = "top")

  return(calplot)
}
