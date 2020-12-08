library(tidyverse)

#Reading CSV file
drug_groups_df <- read.csv("~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/drug_groups.csv")
drug_drug_interactions_df <- read.csv("~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/drug_drug_interactions.csv")
drug_mixtures_df <- read.csv("~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/drug_mixtures.csv")
drug_types_df <- read.csv("~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/drug.csv")

#Removing Unnecessary columns from CSV file
drug_types_df <- drug_types_df[, -c(4:15)]


#apply(demo_df, 2, function(x) any(is.na(x)))
#which(is.na(demo_df$drug_ingredients))
#demo_df <- na.omit(demo_df)
#demo_df[complete.cases(demo_df), ]
#demo_df %>% drop_na("drug_type")


# Final working from here (Matching Drug info from different CSV file)
demo_df <- drug_drug_interactions_df
demo_df$drug_group <- drug_groups_df$group[match(demo_df$drugbank.id, drug_groups_df$drugbank.id)] #Contains null (2668185 5)
demo_df$drug_type <- drug_types_df$type[match(demo_df$drugbank.id, drug_types_df$primary_key)] # A lots of missing values
demo_df$drug_ingredients <- drug_mixtures_df$ingredients[match(demo_df$drugbank.id, drug_mixtures_df$parent_key)] 
demo_df$parent_key_drug_group <- drug_groups_df$group[match(demo_df$parent_key, drug_groups_df$drugbank.id)]
demo_df$parent_key_drug_type <- drug_types_df$type[match(demo_df$parent_key, drug_types_df$primary_key)]
demo_df$parent_key_drug_ingredients <- drug_mixtures_df$ingredients[match(demo_df$parent_key, drug_mixtures_df$parent_key)]

#Removing rows which contains NULL value
demo_df <- na.omit(demo_df)

# Creating CSV from the dataframe
write.csv(demo_df, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/demo.csv", row.names = FALSE)

#Counting how many different types of drug 
length(unique(demo_df$drug_type))
length(unique(demo_df$parent_key_drug_type))


#Removing Biotech and others (only working with Small MOlequle)
demo_df<-demo_df[!(demo_df$drug_type=="biotech" | demo_df$drug_type=="NA" | demo_df$parent_key_drug_type=="biotech"),]
table(demo_df$drug_type)
# small molecule 
# 903928
table(demo_df$parent_key_drug_type)
# small molecule 
# 903928 

# Creating CSV only for Small molecule from the dataframe
write.csv(demo_df, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_small_molecule.csv", row.names = FALSE)


#Counting how many different groups of drug are there rows are there for different purpose
length(unique(demo_df$drug_group))
table(demo_df$drug_group)
# approved    experimental  investigational   nutraceutical   withdrawn
# 895235          5413           2246          110            924         

          
#Removing All groups rather than 'Approved' and others (only working with approved)
demo_df<-demo_df[!(demo_df$drug_group=="experimental" | demo_df$drug_group=="illicit" | demo_df$drug_group=="investigational" | demo_df$drug_group=="nutraceutical"| demo_df$drug_group=="vet_approved" | demo_df$drug_group=="withdrawn" | demo_df$drug_group=="NA" |
                   demo_df$parent_key_drug_group=="experimental" | demo_df$parent_key_drug_group=="illicit" | demo_df$parent_key_drug_group=="investigational" | demo_df$parent_key_drug_group=="nutraceutical"| demo_df$parent_key_drug_group=="vet_approved" | demo_df$parent_key_drug_group=="withdrawn" | demo_df$parent_key_drug_group=="NA"),]


# Now dataset Size (interaction) approved is 886678
#Creating CSV file from the dataframe 
write.csv(demo_df, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_small_molecule_approved.csv", row.names = FALSE)

#Extrating SMILES from dataset
demo_smiles <- read.csv("~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/drug_calculated_properties.csv")
smiles <- demo_smiles %>% filter(kind == "SMILES")

#Removing smiles those are not needed (Only need approved small molecules)
demo_small_mol_app <- read.csv("~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_small_molecule_approved.csv")
demo_small_mol_app$smiles <- smiles$value[match(demo_small_mol_app$drugbank.id, smiles$parent_key)]

#Creating CSV file of SMILES 
write.csv(demo_small_mol_app, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_small_molecule_approved_smiles.csv", row.names = FALSE)

#Checking N/A values
#indx <- apply(demo_small_mol_app, 2, function(x) any(is.na(x)))
#colnames[indx]
#demo_small_mol_app[complete.cases(demo_small_mol_appdf), ]
#demo_small_mol_app <- na.omit(demo_small_mol_app)
#which(is.na(demo_small_mol_app))
#which(is.na(demo_small_mol_app$drugbank.id))

#Reading SMILES csv file into a dtaframe
drug_id_smiles <- read.csv("~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_small_molecule_approved_smiles.csv")

#Extracting Only Unique drug including SMILES
only_unique_drug_id_smiles <- distinct(drug_id_smiles, drugbank.id, .keep_all = TRUE)

#Removing Unnecessary columns
only_unique_drug_id_smiles <- select (only_unique_drug_id_smiles,-c(name,description,parent_key, drug_group, drug_type, drug_ingredients, parent_key_drug_ingredients, parent_key_drug_ingredients, parent_key_drug_ingredients, parent_key_drug_group, parent_key_drug_type))

#Creating CSV file for Only Approved Small Molecules Unique drug
write.csv(only_unique_drug_id_smiles, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_unique_small_molecule_approved_smiles.csv", row.names = FALSE)


#Extracting SCV file based on the increased interaction
demo_small_mol_app %>% filter(str_detect(description,"increase")) -> df_increase_ddi_demo_small_mol_app
dim(df_increase_ddi_demo_small_mol_app)

#Creating CSV file for Only increased interaction Approved Small Molecules Unique drug
write.csv(df_increase_ddi_demo_small_mol_app, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_df_increase_ddi_demo_small_mol_app.csv", row.names = FALSE)


#Extracting SCV file based on the decrease interaction
demo_small_mol_app %>% filter(str_detect(description,"decrease")) -> df_decrease_ddi_demo_small_mol_app
dim(df_decrease_ddi_demo_small_mol_app)

#Creating CSV file for Only decrease interaction Approved Small Molecules Unique drug
write.csv(df_decrease_ddi_demo_small_mol_app, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_df_decrease_ddi_demo_small_mol_app.csv", row.names = FALSE)

#Total found 868951 (rest of the may be does not contain any increase or decrease word)

##Only metabolism related interaction
demo_small_mol_app <- read.csv("~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_small_molecule_approved_smiles.csv")

demo_small_mol_app %>% filter(str_detect(description,"metabolism")) -> df_metabolish
write.csv(df_metabolish, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_df_metabolism_ddi_demo_small_mol_app.csv", row.names = FALSE)


#Only metabolism related unique drug names, smiles, etc and removing columns
demo_metabolism_only_unique_drug_id_smiles <- distinct(demo_metabolism, drugbank.id, .keep_all = TRUE)
only_metabolism_drug_id_names_smiles <- select (demo_metabolism_only_unique_drug_id_smiles,-c(name, description,parent_key, drug_group, drug_type, drug_ingredients, parent_key_drug_ingredients, parent_key_drug_ingredients, parent_key_drug_ingredients, parent_key_drug_group, parent_key_drug_type))

write.csv(only_metabolism_drug_id_names_smiles, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_metabolism_fdi_unique_small_molecule_approved_smiles.csv", row.names = FALSE)


#Extracting metabolism (increase) related information
df_metabolish %>% filter(str_detect(description,"increase")) -> df_metabolish_increase
dim(df_metabolish_increase)
write.csv(df_metabolish_increase, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_df_metabolism_increase_ddi_demo_small_mol_app.csv", row.names = FALSE)


#Extracting metabolism (decrease) related information
df_metabolish %>% filter(str_detect(description,"decrease")) -> df_metabolish_decrease
dim(df_metabolish_decrease)
write.csv(df_metabolish_decrease, "~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi/demo_df_metabolism_decrease_ddi_demo_small_mol_app.csv", row.names = FALSE)

