server <- function(input, output, session) {

    output$ternary <- renderPlotly({
        base_plot() |>
        add_point(
            green = input$green,
            yellow = input$yellow,
            brown = input$brown)
    })

    pred <- reactive({
        message("G=", input$green, " / Y=", input$yellow, " / B=", input$brown)
        pred_fun(m,
            green = input$green,
            yellow = input$yellow,
            brown = input$brown)
    })

    output$bars <- renderPlotly({
        pred() |>
        plot_pred()
    })

    output$ripeness <- renderUI({
        state <- switch(as.character(pred()$ripeness),
            "Under" = "under ripe",
            "Ripe" = "ripe",
            "Very" = "very ripe",
            "Over" = "over ripe")
        tagList(
            p("The banana is ", strong(state))
        )
    })

}
