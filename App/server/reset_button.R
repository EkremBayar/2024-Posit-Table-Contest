# Reset Button
observeEvent(input$reset_button, {
  
  # Clear selected rows
  updateReactable("players_table", selected = NA)
  
  # Reset RV Data
  rv$player_df <- df
  
})