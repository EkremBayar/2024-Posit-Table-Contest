# Enable Disable
observe({
  selected_rows <- getReactableState("players_table", name = "selected")
  
  if(length(selected_rows)>0){
    enable("download_button")
  }else{
    disable("download_button")
  }
})

# Download Button
observeEvent(input$download_button, {
  
  # Selected Rows
  selected_rows <- getReactableState("players_table", name = "selected")
  
  # Selected Data
  selected_players <- rv$player_df[selected_rows,] %>% pull(Tmid)
  
  # Excel Data
  excel_data <- df %>% 
    filter(Tmid %in% selected_players) %>% 
    select(c("Player Name", "Player Valuation", "Date Of Birth", "Age", "Citizenship", "Height", "Foot", "Position Class", "Main Position", "League","Current Club", "Contract Expires", "Contract Option",  "On Loan From", "Contract There Expires", "Player Agent", "Url")) %>% 
    rename(
      "Player" = "Player Name",
      "Market Value" = "Player Valuation",
      "Date of Birth" = "Date Of Birth",
      "Height (cm)" = "Height",
      "Position" = "Main Position",
      "Contract There" = "Contract There Expires", 
      "Agent" = "Player Agent"
    ) %>% 
    mutate(
      Player = paste0(
        "HYPERLINK(\"",
        Url,
        "\", \"",
        Player,
        "\")"
      )
  ) %>% 
    select(-Url)
  class(excel_data$Player) <- "formula"
  
  
  # Workbook Name
  rv$Watchlist <- "Watchlist_2024_Posit_Table_Contest.xlsx"
  # Create Workbook
  wb <- createWorkbook()
  sheetname <- "Watchlist"
  # Add Worksheet
  addWorksheet(wb, sheetName = sheetname)
  # Write Data
  writeData(wb, sheet = sheetname, x = excel_data, startRow = 1, startCol = 1)
  
  # Header Style
  addStyle(
    wb, sheet = sheetname, gridExpand = T, rows = 1 , cols = 1:(ncol(excel_data)),
    style = createStyle(
      # Background & Text Color
      fgFill = "#1F497D", fontColour = "white",
      # Bold & Font Size
      textDecoration = "bold", fontSize = 18,
      # Align Text Position
      halign = "center", valign = "center"
    )
  )
  
  # Values
  addStyle(
    wb, sheet = sheetname, gridExpand = T, rows = 2:(nrow(excel_data)+1), cols = 1:ncol(excel_data),
    style = createStyle(
      # Align Text Position
      halign = "center", valign = "center")
  )
  
  # Hyperlink
  addStyle(wb, sheet = sheetname, rows = 2:(nrow(excel_data)+1), cols = 1, style = createStyle(fontColour = "#0070C0",textDecoration = "underline"))
  
  # Market Value
  addStyle(wb, sheet = sheetname, rows = 2:(nrow(excel_data)+1), cols = 2, style = createStyle(numFmt = "€0,0.00"))
  
  # Conditional Formatting
  conditionalFormatting(wb, sheetname,
                        cols = 2, rows = 2:(nrow(excel_data)+1),
                        type = "databar",
                        style = c("green"),  gradient = T
  )
  
  # Set Col Widths
  setColWidths(wb, sheet = 1, cols = c(1:ncol(excel_data)), widths = "auto")
  
  # Freeze Pane
  freezePane(wb, sheet = sheetname, firstRow = T)
  
  # Save Workbook
  saveWorkbook(wb,  rv$Watchlist, overwrite = T)

  # Trigger Download Handler
  shinyjs::runjs(paste0("$('#","download_bttn", "')[0].click();"))
  
})

# Download Handler
output$download_bttn <- downloadHandler(
  filename = function() {
    rv$Watchlist
  },
  content = function(file) {
    file.copy(paste0(getwd(), "/",  rv$Watchlist), file)
  }
)