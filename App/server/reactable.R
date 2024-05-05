# Reactable
output$players_table <- renderReactable({
  
  reactable(
    # Data
    rv$player_df %>% mutate(`Player Name` = paste0("<a href='", Url,"' target='_blank'>", `Player Name`,"</a>")),
    # Options
    sortable = T,
    filterable = T,
    showPagination = T,
    pagination = T,
    defaultPageSize = 10,
    pageSizeOptions = c(10,15,25,50,100,250),
    showSortable = T,
    searchable = F,
    showPageSizeOptions = T,
    showSortIcon = T,
    showPageInfo = T,
    compact = T,
    bordered = T,
    selection = "multiple", onClick = "select",
    # Style
    style = "z-index: 0; width:100%; font-size:78%;  font-family: Repo, sans-serif;",
    # Theme
    theme = reactableTheme(
      highlightColor = "cornsilk",
      rowSelectedStyle = list(backgroundColor = "cornsilk", boxShadow = "inset 2px 0 0 0 #ffa62d"),
      filterInputStyle = list(color="black"),selectStyle = list(sticky="left")
    ),
    # Default Col Def
    defaultColDef = colDef(headerVAlign = "center",
                           align = "center",vAlign = "center",
                           minWidth = 100,
                           headerStyle = list(color = "white", backgroundColor="#1a3151")
    ),
    # Spesific Columns
    columns = list(
      "Tmid" = colDef(show = FALSE),
      "Url" = colDef(show = FALSE),
      "League Id" = colDef(align = "center", vAlign = "center", html = T, name = "", sortable = F, filterable = F),
      "Current Club Id" = colDef(align = "center", vAlign = "center", html = T, name = "",sortable = F, filterable = F),
      "On Loan From Id" = colDef(align = "center", vAlign = "center", html = T, name = "",sortable = F, filterable = F),
      "Date Of Birth" = colDef(name = "DoB"),
      "Contract There Expires" = colDef(name = "Contract There"),
      "Player Agent" = colDef(name = "Agent"),
      "Photo" = colDef(align = "center", vAlign = "center", html = T, minWidth = 40, style=list(backgroundColor = "#F3EEE7"), name = "", sortable = F, filterable = F, sticky = "left"),
      "Player Name" = colDef(name = "Player", html = TRUE, style = list(fontSize = 12, backgroundColor = "#F3EEE7"), sticky = "left", align = "center", vAlign = "center"),
      "Player Valuation" = colDef(
        name = "Market Value", sticky = "left",
        cell = data_bars(
          data = df,
          fill_color = 'seagreen',bar_height = "20px",
          background = 'orange',
          text_color = "white",
          border_style = 'solid',
          border_width = '1px',
          border_color = 'forestgreen',
          box_shadow = TRUE,
          text_position = 'inside-base',
          number_fmt =  scales::label_dollar(prefix = "€")
        )
      ),
      "Age" = colDef(
        cell = gauge_chart(
          data = df,
          fill_color = c('#1A9641','#A6D96A','#FFFFBF','#FDAE61','#D7191C'),
          number_fmt = scales::comma,
          bold_text = TRUE,
          text_size = 18,
          show_min_max = TRUE
        ),
        align = "center", vAlign = "center", width = 70
      ),
      "Height" = colDef(
        name = "Height (cm)",
        style = color_scales(df)
      ),
      
      "Twitter" = colDef(
        cell = function(url) {
          if(!is.na(url)){
            tags$a(href = url, target = "_blank", paste0("@", str_split_i(url, "/", -1)))
          }
        },
        width = 150
      ),
      "Instagram" = colDef(
        cell = function(url) {
          if(!is.na(url)){
            tags$a(href = url, target = "_blank", paste0("@", ifelse(str_sub(url, -1) == "/", str_split_i(url, "/", -2), str_split_i(url, "/", -1))))
          }
          
        },
        width = 150
      ),
      "Foot" = colDef(html = TRUE, width = 70,
                      cell = function(value) {
                        
                        img_src <- switch(
                          value,
                          "Right" = knitr::image_uri(file.path("www/rf.png")),
                          "Left" = knitr::image_uri(file.path("www/lf.png")),
                          "Both" = knitr::image_uri(file.path("www/bf.png")),
                          character()
                        )
                        if(length(img_src)>0){shiny::tagList(
                          tags$img(src = img_src, width = '25px', height = '25px')
                        )}else{""}
                      }
      ),
      "Position Class" = colDef(
        maxWidth = 100,
        align = "center",
        cell = pill_buttons(data = rv$player_df, color_ref = "posclasscols", opacity = 0.7, text_color = "white", bold_text = TRUE)
      ),
      "Main Position" = colDef(
        name = "Position",
        align = "center",
        cell = pill_buttons(data = rv$player_df, color_ref = "posclasscols", opacity = 0.9, text_color = "white", bold_text = TRUE)
      ),
      posclasscols = colDef(show = FALSE)
    )
  )
  
}) 


