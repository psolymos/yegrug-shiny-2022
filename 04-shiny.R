#' Run the app:
shiny::runApp("app")
#' Now go and check the files in the ./app folder

#' Deploy

## https://psolymos.shinyapps.io/BananaAI/

# rsconnect::setAccountInfo(name = "psolymos",
#   token = "xxxxxx",
#   secret = "xxxxxx")

rsconnect::deployApp("app", 
  appName = "BananaAI",
  account = "psolymos",
  forceUpdate = TRUE)
