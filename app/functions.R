#' @param m A model by `e1071::svm()`.
#' @param green,yellow,brown Numeric, relative color proportions.
pred_fun <- function(m, green, yellow, brown) {
    green <- as.numeric(green)
    yellow <- as.numeric(yellow)
    brown <- as.numeric(brown)
    total <- green + yellow + brown
    green <- green / total
    yellow <- yellow / total
    brown <- brown / total
    z <- data.frame(
        green = green, 
        yellow = yellow, 
        brown = brown)
    pr <- predict(m,
        newdata = z, 
        probability = TRUE)
    data.frame(
        green = green,
        yellow = yellow,
        brown = brown,
        ripeness = factor(as.character(pr), levels(pr)),
        as.data.frame(attr(pr, "probabilities")))
}

# ternary plots function with and without prediction
#' @param title Title
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

#' @param p A Plotly object from `plotly::plot_ly()`.
#' @param x Data frame, containing ripeness state (Under/Ripe/Very/Over)
#'   and green/yellow/brown proportions.
#' @param col Character, color hex code.
#' @param name Character, the name for the legend.
#' @param highlight Logical, highlight points with a red stroke.
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
            size = 14,
            line = list(
                width = 2,
                color = if (highlight) "red" else col)))
}

base_plot <- function() {
    plot_ly() |>
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
}

#' @param p A Plotly object from `plotly::plot_ly()`.
#' @param pr A prediction object returned by `pred_fun()`.
add_pred <- function(p, pr) {
    if (nrow(pr) > 1)
        stop("pr must have only 1 row.")
    p |> 
    trace_fun(x = pr,
        col = switch(as.character(pr$ripeness),
            Under = "#576a26", 
            Ripe = "#eece5a",
            Very = "#966521", 
            Over = "#261d19"),
        name = "Prediction",
        highlight = TRUE)
}

#' @param p A Plotly object from `plotly::plot_ly()`.
#' @param green,yellow,brown Numeric, relative color proportions.
add_point <- function(p, green, yellow, brown) {
    p |> 
    trace_fun(x = data.frame(
            green = green,
            yellow = yellow,
            brown = brown,
            ripeness = "Ripe"),
        col = "red",
        name = "New point",
        highlight = TRUE)
}

#' @param pr A prediction object returned by `pred_fun()`.
plot_pred <- function(pr) {
    if (nrow(pr) > 1)
        stop("pr must have only 1 row.")
    d <- data.frame(
        ripeness = factor(c("Under", "Ripe", "Very", "Over"), c("Under", "Ripe", "Very", "Over")),
        probability = round(c(pr$Under, pr$Ripe, pr$Very, pr$Over), 4),
        color = c("#576a26", "#eece5a", "#966521", "#261d19"))
    plot_ly(data = d,
        x = ~ripeness, y = ~probability, type = 'bar',
        marker = list(color = d$color))
}
