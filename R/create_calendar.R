
#' Create a 4k weeks calendar!
#'
#' @param birthdate your birthdate
#' @param col_past rgb color for passed weeks
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
#'
create_calendar <- function(birthdate, col_past, col_future) {

  # debugging
  #birthdate <- as.Date("2000-01-01")
  #col_past <- "#00ff00"
  #col_future <- "#ff0000"

  # check for correct inputs
  if (!is.Date(birthdate)) {
    stop("birthdate must be a date")
  } else if (!grepl(pattern = "#{1}[[:alnum:]]{6}", col_past)) {
    stop("col_past must be a RGB color")
  } else if (!grepl(pattern = "#{1}[[:alnum:]]{6}", col_future)) {
    stop("col_past must be a RGB color")
  }

  # user input
  today <- today()
  # font <- "serif"

  # set colors
  mycol <- c(
    "1" = col_past,
    "0" = col_future
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

  caldf$year <- as.factor(caldf$year)
  caldf$week <- as.factor(caldf$week)

  caldf$id <- as.integer(rownames(caldf))

  currentweek <- as.integer(((today - birthdate)) / 7)

  caldf <- caldf %>%
    mutate(passed = ifelse(id < currentweek, "1", "0"))

  caldf$passed <- as.factor(caldf$passed)
  caldf$shapet <- as.factor(1)


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
      axis.title.x = element_text(family = "serif", hjust = 0),
      axis.title.y = element_text(family = "serif", hjust = 1),
      axis.text = element_text(family = "serif", )
    ) +
    scale_y_discrete(breaks = seq(5, 80, by = 5), limits = rev) +
    scale_x_discrete(breaks = seq(5, 80, by = 5), position = "top")

  return(calplot)
}
