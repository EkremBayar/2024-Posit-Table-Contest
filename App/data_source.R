# Read Excel & Data Manipulation
df <- read_excel(
  "data/tmbio.xlsx", 
  col_types = c(
   "numeric","numeric", "text", "text", "text", "date", "numeric", "text", "text", "numeric",
   "text", "text", "text", "text", "text", "text", "text", "text", "text", "text",
   "numeric", "text", "date", "date", "text","text", "date", "text", "text", "numeric",
   "numeric", "numeric", "numeric", "numeric", "text", "text", "text", "text", "text",
   "text", "text", "text", "text", "numeric","numeric", "numeric")
  ) %>% 
  select(
    c("TMId", "player_name", "player_valuation",  "date_of_birth", "age",  "citizenship", "height",
      "foot",  "position_class", "main_position",  "league_id", "league", "league_country",
      "league_tier", "current_club_id", "current_club", "joined", "contract_expires",
      "contract_option", "on_loan_from_id", "on_loan_from", "contract_there_expires",
      "national_team_status", "national_team_id", "national_team", "national_caps", "national_goals",
      "player_agent", "twitter", "instagram",  "image_url", "url")
  ) %>% 
  filter(league_country %in% c("Spain", "England")) %>% 
  #head(500) %>% 
  mutate(
    height = height * 100,
    main_position = str_replace_all(abbreviate(str_replace_all(main_position, "-", " "),minlength = 2), "Gl", "GK"),
    photo = paste0('<img src="',image_url,'" height="40"></img>'),
    league = paste(league, "-", league_country),
    league_id = paste0('<img src="',"https://tmssl.akamaized.net/images/logo/header/", str_to_lower(league_id), ".png",'" height="40"></img>'),
    current_club_id = ifelse(!is.na(current_club_id), paste0('<img src="',"https://tmssl.akamaized.net/images/wappen/head/", str_to_lower(current_club_id), ".png", '" height="40"></img>'), ""),
    on_loan_from_id = ifelse(!is.na(on_loan_from_id), paste0('<img src="',"https://tmssl.akamaized.net/images/wappen/head/", str_to_lower(on_loan_from_id), ".png", '" height="40"></img>'), ""),
    age = ifelse(is.na(age) & !is.na(date_of_birth), as.integer(year(Sys.Date()) - year(date_of_birth)), age),
    date_of_birth = format(lubridate::ymd(date_of_birth), "%Y/%m/%d"),
    contract_expires = format(lubridate::ymd(contract_expires), "%Y/%m/%d"),
    contract_there_expires = format(lubridate::ymd(contract_there_expires), "%Y/%m/%d"),
    contract_option = str_to_sentence(contract_option),
    position_class = as.factor(position_class)
  ) %>%
  select(-image_url, -league_country) %>%
  arrange(desc(player_valuation)) %>%
  rename_all(., list(~str_to_title(gsub("[[:punct:]]", " ", .)))) %>%
  mutate(
    posclasscols = case_when(
      `Position Class` == "Attack" ~ "seagreen",
      `Position Class` == "Midfield" ~ "royalblue",
      `Position Class` == "Defender" ~ "orange",
      `Position Class` == "Goalkeeper" ~ "red",
      TRUE ~ "white"
    )
  ) %>% 
  select(
    c("Tmid","Photo", "Player Name", "Player Valuation", "Date Of Birth", "Age",
      "Citizenship", "Height", "Foot", "Position Class", "Main Position",
      "League Id", "League",  "Current Club Id",
      "Current Club", "Contract Expires", "Contract Option",
      "On Loan From Id", "On Loan From", "Contract There Expires", "Player Agent",
      "Twitter", "Instagram","posclasscols", "Url")
  ) %>% suppressWarnings() %>% invisible()
  


# Global Variables --------------------------------------------------------
celist <- sort(unique(lubridate::year(df$`Contract Expires`)))
mvlist <- sort(unique(df$`Player Valuation`))
yblist <- sort(unique(lubridate::year(df$`Date Of Birth`)))
poslist <- factor(sort(unique(df$`Main Position`)), labels = c("GK", "CB", "LB", "RB",  "DM",  "CM", "LM", "RM","AM",  "LW",  "RW", "SS", "CF"), ordered = TRUE)








