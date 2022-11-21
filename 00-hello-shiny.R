#' This is Hello Shiny

library(shiny)

ui <- fluidPage(
    mainPanel(
        sliderInput("obs",
            "Number of observations",
            min = 1,
            max = 5000,
            value = 100),
        plotOutput("distPlot")
    )
)

#' print(ui) will show the rendered output from `shiny::fluidPage()`

# <div class="container-fluid">
#   <div class="col-sm-8" role="main">
#     <div class="form-group shiny-input-container">
#       <label class="control-label" id="obs-label" for="obs">Number of observations</label>
#       <input class="js-range-slider" id="obs" data-skin="shiny" data-min="1" data-max="5000" data-from="100" data-step="1" data-grid="true" data-grid-num="9.998" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#     </div>
#     <div id="distPlot" class="shiny-plot-output" style="width:100%;height:400px;"></div>
#   </div>
# </div>

server <- function(input, output) {
    output$distPlot <- renderPlot({
        message("input$obs is ", input$obs)
        dist <- rnorm(input$obs)
        hist(dist,
            col="purple",
            xlab="Random values")
    })
}

shinyApp(ui = ui, server = server)

#' `shiny::shinyApp()`` function returns the app object which is run either
#' - by implicitly calling the `print()` method on it when running in the R console
#' - you can also pass the app object to the `shiny::runApp()` function

app <- shinyApp(ui = ui, server = server)
print(app) # see `shiny:::print.shiny.appobj`
runApp(app)

#' Check page source:

# <!DOCTYPE html>
# <html>
# <head>
#   <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
#   <script type="application/shiny-singletons"></script>
#   <script type="application/html-dependencies">jquery[3.6.0];shiny-css[1.7.1];shiny-javascript[1.7.1];ionrangeslider-javascript[2.3.1];strftime[0.9.2];ionrangeslider-css[2.3.1];bootstrap[3.4.1]</script>
# <script src="shared/jquery.min.js"></script>
# <link href="shared/shiny.min.css" rel="stylesheet" />
# <script src="shared/shiny.min.js"></script>
# <script src="shared/ionrangeslider/js/ion.rangeSlider.min.js"></script>
# <script src="shared/strftime/strftime-min.js"></script>
# <link href="shared/ionrangeslider/css/ion.rangeSlider.css" rel="stylesheet" />
# <meta name="viewport" content="width=device-width, initial-scale=1" />
# <link href="shared/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
# <link href="shared/bootstrap/accessibility/css/bootstrap-accessibility.min.css" rel="stylesheet" />
# <script src="shared/bootstrap/js/bootstrap.min.js"></script>
# <script src="shared/bootstrap/accessibility/js/bootstrap-accessibility.min.js"></script>
# </head>
# <body>
#   <div class="container-fluid">
#     <div class="col-sm-8" role="main">
#       <div class="form-group shiny-input-container">
#         <label class="control-label" id="obs-label" for="obs">Number of observations</label>
#         <input class="js-range-slider" id="obs" data-skin="shiny" data-min="1" data-max="5000" data-from="100" data-step="1" data-grid="true" data-grid-num="9.998" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#       </div>
#       <div id="distPlot" class="shiny-plot-output" style="width:100%;height:400px;"></div>
#     </div>
#   </div>
# </body>
# </html>

run_app <- function() {
  runApp(
    shinyApp(
      ui = fluidPage(
        mainPanel(
          sliderInput("obs",
            "Number of observations",
            min = 1,
            max = 5000,
            value = 100),
          plotOutput("distPlot")
        )
      ),
      server = function(input, output) {
        output$distPlot <- renderPlot({
          message("input$obs is ", input$obs)
          dist <- rnorm(input$obs)
          hist(dist,
            col="purple",
            xlab="Random values")
        })
      }
    )
  )
}

run_app()
