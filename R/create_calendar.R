
#' Create a 4k weeks calendar!
#'
#' @param birthdate your birthdate, format: yyyy-mm-dd
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
create_calendar <- function(birthdate) {

  # debugging
  # birthdate <- as.Date("2000-01-01")
  # birthdate <- "test"

  result <- tryCatch(
    {
      ymd(birthdate)
    },
    warning = function(w) {
      stop("birthdate must be a date")
    },
    error = function(e) {
      stop("birthdate must be a date")
    }
  )

  birthdate <- ymd(birthdate)

  # check for correct inputs
  if (!is.Date(birthdate)) {
    stop("birthdate must be a date")
  }

  # set colors
  mycol <- c(
    "1" = "#000000",
    "0" = "#000000"
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

  font_size <- 10

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
      plot.title = element_text(family = "serif", size = font_size * 2, face = "italic"),
      axis.title.x = element_text(family = "serif", hjust = 0, size = font_size, face = "italic"),
      axis.title.y = element_text(family = "serif", vjust = 1, angle = 0, size = font_size, face = "italic"),
      axis.text = element_text(family = "serif", size = font_size, face = "italic", colour = "black")
    ) +
    scale_y_discrete(breaks = seq(5, 80, by = 5), limits = rev) +
    scale_x_discrete(breaks = seq(5, 80, by = 5), position = "top")

  return(calplot)
}
