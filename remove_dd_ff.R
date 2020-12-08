library(dplyr)

all_data <- read.csv("~/Downloads/path-category-based-similarity.csv")

df_remove_dd <- all_data %>% 
  filter(!grepl('DB', query) | !grepl('DB', target))

df_remove_ff <- df_remove_dd %>% 
  filter(grepl('DB', query) | grepl('DB', target))

write.csv(df_remove_ff,"~/Downloads/only_food_drug_int.csv", row.names = TRUE)





