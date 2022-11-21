library(mefa4)
library(e1071)
library(mgcv)
library(ggplot2)
library(plotly)
library(bananas)

#' Read the bananas data
x <- bananas[bananas$treatment == "Room",]

#' Ripeness  & the ripe indicator
print(table(x$ripeness, x$ripe), zero = ".")

#' Model the probability of ripe state with color proportions
#' (1) Logistic regression
m1 <- glm(ripe ~ yellow + brown + green, 
    data = x, 
    family = binomial(link = "logit"))

summary(m1)

#' Check classification accuracy
table(x$ripe, fitted(m1) >= 0.5)
sum(diag(table(x$ripe, fitted(m1) >= 0.5))) / nrow(x)

#' (2) Let's try a quadratic model with the same GLM
m2 <- glm(ripe ~ yellow + brown + green +
        I(yellow^2) + I(brown^2) + I(green^2), 
    data = x, 
    family = binomial(link = "logit"))
summary(m2)

table(x$ripe, fitted(m2) >= 0.5)
sum(diag(table(x$ripe, fitted(m2) >= 0.5))) / nrow(x)

## (3) Splines might be useful, use a GAM
m3 <- gam(ripe ~ s(green, yellow, brown),
    data = x, 
    family = binomial(link = "logit"))

table(x$ripe, fitted(m3) >= 0.5)
sum(diag(table(x$ripe, fitted(m3) >= 0.5))) / nrow(x)

#' Explore the Binomial models
boxplot(fitted(m3) ~ x$ripeness,
    col = c("#576a26", "#eece5a", "#966521", "#261d19"))

ggplot(
    data = data.frame(
        x, 
        fitted = fitted(m3)),
    mapping = aes(
        x = ripeness,
        y = fitted,
        fill = ripeness)) +
    geom_boxplot() +
    scale_fill_manual(
        values = c("#576a26", "#eece5a", "#966521", "#261d19")) +
    theme_minimal()

ggplot(
    data = data.frame(
        x, 
        ripeness = x$ripeness, 
        fitted = fitted(m3)),
    mapping = aes(
        x = yellow,
        y = green,
        size = fitted,
        fill = ripeness,
        color = ripeness)) +
    geom_point(alpha = 0.75) +
    scale_color_manual(
        values=c("#576a26", "#eece5a", "#966521", "#261d19")) +
    theme_minimal()


#' Prediction
predict(m3, data.frame(green=0, yellow=1, brown=0), type="response") |> round() |> unname()
predict(m3, data.frame(green=1, yellow=0, brown=0), type="response") |> round() |> unname()
predict(m3, data.frame(green=0, yellow=0, brown=1), type="response") |> round() |> unname()
predict(m3, data.frame(green=0.1, yellow=0.2, brown=0.7), type="response") |> round() |> unname()


#' Multinomial classification with Support Vector Machines
m4 <- svm(ripeness ~ green + yellow + brown, 
    data = x, 
    probability = TRUE)

table(x$ripeness, predict(m4))
sum(diag(table(x$ripeness, predict(m4)))) / nrow(x)

predict(m4, data.frame(green=0, yellow=1, brown=0), probability=TRUE)
predict(m4, data.frame(green=1, yellow=0, brown=0), probability=TRUE)
predict(m4, data.frame(green=0, yellow=0, brown=1), probability=TRUE)
predict(m4, data.frame(green=0.1, yellow=0.2, brown=0.7), probability=TRUE)

saveRDS(m4, "app/bananas-svm.rds")

## make a plot for this SVM classifier

u <- groupMeans(
    as.matrix(x[,c("green", "yellow", "brown")]), 
    MARGIN = 1, 
    by = x$ripeness)
rowSums(u)
u <- u / rowSums(u)
u

z <- data.frame(
    green = 0.1, 
    yellow = 0.2, 
    brown = 0.7)
pr <- predict(m4,
    newdata = z, 
    probability = TRUE)
#' Label
pr
#' Probabilities
attr(pr, "probabilities")

#' Plots
barplot(t(u), col = c("#576a26", "#eece5a", "#5c361f"))
abline(h = z$green, col = "white", lwd=4)
abline(h = z$green, col = "#576a26", lwd=2)
abline(h = z$yellow, col = "white", lwd=4)
abline(h = z$yellow, col = "#eece5a", lwd=2)
abline(h = z$brown, col = "white", lwd=4)
abline(h = z$brown, col = "#5c361f", lwd=2)

#' Probabilities
barplot(attr(pr, "probabilities")[1,],
    col = c(Under = "#576a26",
        Ripe = "#eece5a",
        Very = "#966521",
        Over = "#261d19"))

#' Ternary plot
fig <- plot_ly() |>
    trace_fun(x[x$ripeness == "Under",], "#576a26", "Under") |>
    trace_fun(x[x$ripeness == "Ripe",], "#eece5a", "Ripe") |>
    trace_fun(x[x$ripeness == "Very",], "#966521", "Very") |>
    trace_fun(x[x$ripeness == "Over",], "#261d19", "Over") |>
    trace_fun(x = data.frame(z, ripeness = pr),
        col = switch(as.character(pr),
            Under = "#576a26", 
            Ripe = "#eece5a",
            Very = "#966521", 
            Over = "#261d19"),
        name = "Prediction",
        highlight = TRUE) |>
    layout(
        margin = list(b = 40, l = 60, t = 40, r = 10),
        ternary = list(
            sum = 1,
            aaxis = axis_fun("Green"),
            baxis = axis_fun("Yellow"),
            caxis = axis_fun("Brown")))
fig

