# Buttons
div(
  class="button-container", align="right",
  
  disabled(downloadButton("download_bttn", "", style="color:rgb(26, 49, 81);background-color:rgb(26, 49, 81)")),

  # Reactable Select or Clear Button
  bsTooltip("reactable_select_deselect_button", "Select/Deselect rows on reactable!", placement = "bottom", trigger = "hover", options = NULL),
  actionBttn(
    inputId = "reactable_select_deselect_button",
    label = NULL,
    style = "simple", 
    color = "primary",
    icon = icon("square-check"),
    size = "lg"
  ),
  
  # Reset Button
  bsTooltip("reset_button", "Reset Filter", placement = "bottom", trigger = "hover", options = NULL),
  actionBttn(
    inputId = "reset_button",
    label = NULL,
    style = "simple", 
    color = "primary",
    icon = icon("rotate"),
    size = "lg"
  ),
  
  # Filter button
  bsTooltip("filter_button", "Filters", placement = "bottom", trigger = "hover", options = NULL),
  actionBttn(
    inputId = "filter_button",
    label = NULL,
    style = "simple", 
    color = "primary",
    icon = icon("caret-down"),size = "lg",
    width = 1000
  ),

  # Download Button
  bsTooltip("download_button", "Download", placement = "bottom", trigger = "hover", options = NULL),
  disabled(actionBttn(
    inputId = "download_button",
    label = NULL,
    style = "simple", 
    color = "primary",
    icon = icon("download"),
    size = "lg"
  ))
    
)