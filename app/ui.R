

ui <- fluidPage(
    title = "Banana AI",
    fluidRow(
        column(width = 12,
            h1("Banana AI")
        )
    ),
    fluidRow(
        column(width = 2,
            h2("Settings"),
            p("Enter color values."),
            numericInput("green",
                label = "Green",
                value = 0.33,
                min = 0,
                max = 1,
                step = 0.01
            ),
            numericInput("yellow",
                label = "Yellow",
                value = 0.33,
                min = 0,
                max = 1,
                step = 0.01
            ),
            numericInput("brown",
                label = "Brown",
                value = 0.33,
                min = 0,
                max = 1,
                step = 0.01
            )
        ),
        column(width = 6,
            plotlyOutput("ternary",
                width = "100%",
                height = "400px"
            )
        ),
        column(width = 4,
            h2("Prediction"),
            uiOutput("ripeness"),
            plotlyOutput("bars",
                width = "100%",
                height = "200px"
            )
        )
    )
)
