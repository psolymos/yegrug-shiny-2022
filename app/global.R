library(shiny)
library(plotly)
library(e1071)
library(bananas)

x <- bananas[bananas$treatment == "Room",]
m <- readRDS("bananas-svm.rds")

source("functions.R")
