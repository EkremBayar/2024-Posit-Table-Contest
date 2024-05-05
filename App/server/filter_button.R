# Show Modal Dialog - Filter
observeEvent(input$filter_button, {
  
  showModal(
    modalDialog(id = "filter_form",
                title = tagList(
                  "Filters", 
                  div(
                    style="float:right;",
                    materialSwitch(
                      inputId = "mdin_missing",
                      label = "Inlcude Missing Values",
                      value = FALSE, 
                      status = "danger",inline = TRUE
                    )
                  )
                  
                ),
                fluidRow(
                  
                  column(
                    width = 6,
                    sliderTextInput(
                      inputId = "mdin_cey",
                      label = "Contract Expires Year:",
                      choices = celist,
                      selected = c(celist[1], celist[length(celist)]) 
                    ),
                    
                    sliderTextInput(
                      pre = "€",
                      inputId = "mdin_mv",
                      label = "Market Value:",
                      choices = mvlist,
                      selected = c(mvlist[1], mvlist[length(mvlist)]) 
                    ),
                    
                    sliderTextInput(
                      inputId = "mdin_yb",
                      label = "Year of Birth:",
                      choices = yblist,
                      selected = c(yblist[1], yblist[length(yblist)]) 
                    )
                  ),
                  
                  column(
                    width = 6,
                    
                    pickerInput(
                      inputId = "mdin_league",
                      label = "League:", 
                      choices = sort(unique(df$League)),
                      selected = sort(unique(df$League)),
                      multiple = TRUE,
                      options = pickerOptions(container = "body", actionsBox = TRUE),
                      width = "100%"
                    ),
                    
                    pickerInput(
                      inputId = "mdin_position",
                      label = "Position", 
                      choices = poslist,
                      selected = poslist,
                      multiple = TRUE,
                      options = pickerOptions(container = "body", actionsBox = TRUE),
                      width = "100%"
                    ),
                    
                    pickerInput(
                      inputId = "mdin_foot",
                      label = "Foot", 
                      choices = sort(unique(df$Foot)),
                      selected = sort(unique(df$Foot)),
                      multiple = TRUE,
                      options = pickerOptions(container = "body", actionsBox = TRUE),
                      width = "100%"
                    )
                  )

                ),
                footer = tagList(
                  actionButton("submit_filter_button", "Submit"), modalButton("Cancel")
                )
    )
  )
  
})


# Filter Data
observeEvent(input$submit_filter_button, {
  
  # Clear selected rows
  updateReactable("players_table", selected = NA)
  
  # Filter
  cond <- celist[1] == as.integer(input$mdin_cey)[1] & celist[length(celist)] == as.integer(input$mdin_cey)[2] & mvlist[1] == as.integer(input$mdin_mv)[1] & mvlist[length(mvlist)] == as.integer(input$mdin_mv)[2] & yblist[1] == as.integer(input$mdin_yb)[1] & yblist[length(yblist)] == as.integer(input$mdin_yb)[2] & dplyr::setequal(sort(unique(df$League)), input$mdin_league) & dplyr::setequal(poslist, input$mdin_position) & dplyr::setequal(sort(unique(df$Foot)), input$mdin_foot)
  if(cond == TRUE){
    rv$player_df <- df 
  }else{
    rv$player_df <- df %>% 
      filter(
        (as.integer(lubridate::year(`Contract Expires`)) >= as.integer(input$mdin_cey)[1]) %>% replace_na(input$mdin_missing),
        (as.integer(lubridate::year(`Contract Expires`)) <= as.integer(input$mdin_cey)[2]) %>% replace_na(input$mdin_missing), 
        (as.integer(`Player Valuation`) >= as.integer(input$mdin_mv)[1]) %>% replace_na(input$mdin_missing), 
        (as.integer(`Player Valuation`) <= as.integer(input$mdin_mv)[2]) %>% replace_na(input$mdin_missing),
        (as.integer(lubridate::year(`Date Of Birth`)) >= as.integer(input$mdin_yb)[1]) %>% replace_na(input$mdin_missing), 
        (as.integer(lubridate::year(`Date Of Birth`)) <= as.integer(input$mdin_yb)[2]) %>% replace_na(input$mdin_missing), 
        (League %in% input$mdin_league) %>% replace_na(input$mdin_missing),
        (`Main Position` %in% input$mdin_position) %>% replace_na(input$mdin_missing),
        (Foot %in% input$mdin_foot) %>% replace_na(input$mdin_missing)
      ) %>% 
      arrange(desc(`Player Valuation`))
  }
  

  # Close Modal
  removeModal()
  
}) 














