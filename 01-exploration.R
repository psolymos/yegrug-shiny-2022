#' Load the bananas data
#' @remote psolymos/bananas
library(bananas)
x <- bananas[bananas$treatment == "Room",]
#' View the data
head(x)
str(x)
summary(x)
#' The data is about the color changes of ripening bananas:
#'
#' - fruit: banana fruit ID
#' - ripeness: under ripe, ripe, very ripe, over ripe
#' - ripe: indicator function for ripe state
#' - day: days since the start of the experiment
#' - green, yellow, brown: proportion of colors in the pictures

#' Plot the data: color proportions over time
#' 
#' A base R version
plot(x = jitter(x$day, 0.5), 
    y = x$green,
    col = "#576a26aa",
    xlab = "Days",
    ylab = "Proportion",
    ylim = c(0, 1),
    pch = 19)
points(x = jitter(x$day, 0.5), 
    y = x$yellow,
    col = "#eece5aaa",
    pch = 19)
points(x = jitter(x$day, 0.5), 
    y = x$brown,
    col = "#5c361faa",
    pch = 19)
lines(
    lowess(x = x$day, 
        y = x$green, 
        f = 0.3), 
    col = "#576a26", 
    lwd = 3)
lines(
    lowess(x = x$day, 
        y = x$yellow, 
        f = 0.3), 
    col = "#eece5a", 
    lwd = 3)
lines(
    lowess(x = x$day, 
        y = x$brown, 
        f = 0.3), 
    col = "#5c361f", 
    lwd = 3)

#' A ggplot2 version
library(ggplot2)
ggplot(
    data = data.frame(
        prop = c(x$green, x$yellow, x$brown),
        color = rep(c("green", "yellow", "brown"), each = nrow(x)),
        day = x$day),
    mapping = aes(
        x = jitter(day, 0.5),
        y = prop,
        group = color,
        color = color)) +
    geom_point(alpha = 0.75) +
    geom_smooth(
        method = 'loess', 
        formula = 'y ~ x') +
    scale_color_manual(
        values = c(
            green = "#576a26", 
            yellow = "#eece5a", 
            brown = "#5c361f")) +
    xlab("Days") +
    ylab("Proportion") +
    theme_minimal()

#' Check the ripeness variable
#' Using base plot
#' Let's focus on the ripe variable
op <- par(mfrow = c(3, 1))
boxplot(green ~ ripeness, x, col = "#576a26")
boxplot(yellow ~ ripeness, x, col = "#eece5a")
boxplot(brown ~ ripeness, x, col = "#5c361f")
par(op)

#' With ggplot2
ggplot(
    data = data.frame(
        prop = c(x$green, x$yellow, x$brown),
        color = factor(
            rep(c("green", "yellow", "brown"), each = nrow(x)),
            c("green", "yellow", "brown")),
        ripeness = x$ripeness),
    mapping = aes(
        x = ripeness,
        y = prop,
        group = ripeness,
        fill = color)) +
    geom_boxplot() +
    facet_wrap(vars(color)) +
    scale_fill_manual(
        values = c(
            green = "#576a26", 
            yellow = "#eece5a", 
            brown = "#5c361f")) +
    xlab("Ripeness") +
    ylab("Proportion") +
    theme_minimal()

#' Ternary plot using plotly
#' https://plotly.com/r/ternary-plots/
library(plotly)

#' Ternary plot axis layout
axis_fun <- function(title) {
    list(
        title = title,
        titlefont = list(
            size = 20),
        tickfont = list(
            size = 15),
        tickcolor = "rgba(0,0,0,0)",
        ticklen = 5)
}

#' This function is for adding one trace at a time
trace_fun <- function(p, x, col, name, highlight = FALSE) {
    p |> add_trace(
        data = x,
        type = "scatterternary",
        mode = "markers",
        a = ~green,
        b = ~yellow,
        c = ~brown,
        text = ~ripeness,
        name = name,
        marker = list(
            opacity = 0.75,
            color = col,
            size = if (highlight) 20 else 14,
            line = list(
                width = 2,
                color = if (highlight) "red" else col)))
}

#' Build the plot itself from the pieces
fig <- plot_ly() |>
    trace_fun(x[x$ripeness == "Under",], "#576a26", "Under") |>
    trace_fun(x[x$ripeness == "Ripe",], "#eece5a", "Ripe") |>
    trace_fun(x[x$ripeness == "Very",], "#966521", "Very") |>
    trace_fun(x[x$ripeness == "Over",], "#261d19", "Over") |>
    layout(
        margin = list(b = 40, l = 60, t = 40, r = 10),
        ternary = list(
            sum = 1,
            aaxis = axis_fun("Green"),
            baxis = axis_fun("Yellow"),
            caxis = axis_fun("Brown")))
fig

