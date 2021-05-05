# ======== Hamlet Evaluation System ==============
# ------ HAMLA Data Wrangler (for GIS) -----------
# ------ author: John T McCormick

library(tidyverse)
library(lubridate)

# A. Create extract function

hamla_extract <- function(append_data, year_str){
    # 1. Load Input Data -----------------------------
    hamla_path <- str_c(getwd(), "/data/NARA/HAMLA/")
    hamla_df <- read_tsv(str_c(hamla_path, "HAMLA_", year_str, "_FS.txt"))
    
    # 2. Cleaning -----------------------------------
    # remove district observations
    hamla_tidy_df <- hamla_df %>% filter(RECTP==1)
    # assign consistent ID
    hamla_tidy_df <- hamla_tidy_df %>%
      mutate(id = str_c(CHAM, PHAM, DHAM, VHAM, HHAM),
             id_country = CHAM,
             id_province = str_c(CHAM, PHAM), 
             id_district = str_c(CHAM, PHAM, DHAM),
             id_village = str_c(CHAM, PHAM, DHAM, VHAM),
             .keep = "unused") %>%
      select(id, id_country, id_province, id_district, id_village, everything())
    # clean up date stamp
    hamla_tidy_df <- hamla_tidy_df %>%
      mutate(DATE = str_c("19",str_sub(DATE, 1L, 2L), "-",str_sub(DATE, 3L, 4L), "-01"),
             date = as_date(DATE)) %>%
      select(-DATE)
    # remove extraneous features
    hamla_tidy_df <- hamla_tidy_df %>% select(-(MLAC:ECDV), -XPROB) %>% 
      select(-(`+PCN`:VSZ), -VALID, -RECTP, -NUMB, -(PROB1:PROB3), -(PROB5:PROB8), -VCMR, -TEAMS) 
    # handle election data
    hamla_tidy_df <- hamla_tidy_df %>%
      mutate(elect_num_officials = str_sub(ELECT, 1L, 2L),
             elect_reliability = str_sub(ELECT, 3L), .keep="unused")
    # treat NA values
    hamla_tidy_df <- hamla_tidy_df %>% 
      mutate(across(POPUL:CONFX, ~ if_else(.x==0, NA_real_, .x, missing=NA_real_)))
    # formatting
    hamla_tidy_df <- hamla_tidy_df %>% 
      mutate(population = POPUL,
             score_security = SECUR,
             score_development = DEVEL,
             score_overall = CLASX,
             score_confidence = CONFX,
             hamlet = NAME, 
             village = XNAME,
             loc = POINT,
             control_prior = CNTL6,
             control_plantype = HTYPE,
             control_current = CNTL7,
             develop_status = RDSTA,
             class = CLAS,
             pop_reliability = POPRE,
             security_status = SCSTA, 
             .keep = "unused") %>%
      select(id, date, hamlet,  loc, class, village, id_village, everything())
    
    # 3. Geocoding-----------------------------------------
    # standardize format
    hamla_tidy_df <- hamla_tidy_df %>% 
      mutate(loc = paste(substr(loc,1L,2L), paste0(substr(loc,3L,5L),'0', substr(loc,6L,8L), '0')))
    # remove invalid locations
    hamla_tidy_df <- hamla_tidy_df %>% 
      mutate(loc = ifelse(test = str_detect(loc, "^[:alpha:]{2} [:digit:]{8}$"),
                          yes = loc, no = NA_character_)) %>%
      filter(!is.na(loc))
    # return GZD
    hamla_tidy_df <- hamla_tidy_df %>% 
      mutate(loc = case_when(
        # when vertical square identifier is in one GZD
        str_detect(substr(loc,1L,1L), "[VW]") ~ paste("48P", loc),
        str_detect(substr(loc,1L,1L), "C") ~ paste("49P", loc),
        # when vertical square identifier is split
        str_detect(substr(loc,1L,1L), "[YZXAB]") ~ case_when(
          # when  100km square is above split (Q)
          str_detect(substr(loc,1L,2L), "[YZX][DE]") ~ paste("48Q", loc),
          str_detect(substr(loc,1L,2L), "[AB]U") ~ paste("49Q", loc),
          # when 100km square is below split (P)
          str_detect(substr(loc,1L,2L), "[YZX][^C]") ~ paste("48P", loc),
          str_detect(substr(loc,1L,2L), "[AB][^T]") ~ paste("49P", loc),
          # when 100km square is split between two GZD (split by northing)
          as.numeric(substr(loc,8L,10L)) >= 707 ~ case_when( # above divider (Q row)
            # select by first grid-square code
            str_detect(substr(loc,1L,1L), "[YZX]") ~ paste("48Q", loc),
            str_detect(substr(loc,1L,1L), "[AB]") ~ paste("49Q", loc),
          ),
          as.numeric(substr(loc,8L,10L)) < 707 ~ case_when( # below divider (P row)
            # select by first grid-square code
            str_detect(substr(loc,1L,1L), "[YZX]") ~ paste("48P", loc),
            str_detect(substr(loc,1L,1L), "[AB]") ~ paste("49P", loc),
          ),
        ),
      ))
    
    # 4. Export Data -------------------------------------------
    export_path <- str_c(getwd(), "/data/tidy/GIS_HAMLA.csv")
    write_csv(hamla_tidy_df, export_path, append = append_data)
}

# B. Extract each data source
hamla_extract(append_data = FALSE, year_str = "1967")
