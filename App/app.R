# 1. Packages -------------------------------------------------------------
source("library.R")

# 2. Data Source ----------------------------------------------------------
source("data_source.R")

# 2. User Interface -------------------------------------------------------
ui <- fluidPage(
  
  # App Title
  title = "TM Contract Detector",
  
  # Theme
  theme = shinytheme("superhero"),
  
  # Shiny JS
  useShinyjs(),
  
  # CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css")
  ),
  
  # UI
  source(file.path("ui", "navbar.R"),  local = TRUE, encoding = "UTF-8" )$value,
  source(file.path("ui", "navbar_buttons.R"),  local = TRUE, encoding = "UTF-8" )$value,
  shinycssloaders::withSpinner(reactableOutput("players_table")),
  source(file.path("ui", "footer.R"),  local = TRUE, encoding = "UTF-8" )$value

)

# 3. Server ---------------------------------------------------------------
server <- function(input, output, session) {
  
  # Reactive Values
  rv <- reactiveValues(player_df = df, Watchlist = NULL)
  # Server Scripts
  source(file.path("server", "reactable_select_deselect_button.R"),  local = TRUE, encoding = "UTF-8")$value
  source(file.path("server", "reset_button.R"),  local = TRUE, encoding = "UTF-8")$value
  source(file.path("server", "filter_button.R"),  local = TRUE, encoding = "UTF-8")$value
  source(file.path("server", "download_button.R"),  local = TRUE, encoding = "UTF-8")$value
  source(file.path("server", "reactable.R"),  local = TRUE, encoding = "UTF-8")$value
  
}

# 4. Run the application --------------------------------------------------
shinyApp(ui = ui, server = server)

