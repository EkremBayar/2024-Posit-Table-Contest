# Select / Deselect Rows
observeEvent(input$reactable_select_deselect_button, {
  
  selected_rows <- getReactableState("players_table", name = "selected")

  if(!is.null(selected_rows)){
    slct <- NA 
  }else{
    slct <- 1:nrow(rv$player_df)
  }
  
  updateReactable("players_table", selected = slct)
})
