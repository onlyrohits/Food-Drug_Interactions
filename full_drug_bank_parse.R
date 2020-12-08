library(dbparser)
library(dplyr)
library(ggplot2)
library(XML)

read_drugbank_xml_db("~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/full_database.xml") 

database_connection <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

drug_interactions(save_csv = TRUE, override_csv = FALSE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv")

drug_mixtures(save_csv = TRUE, override_csv = TRUE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv")

drug_pharmacology(save_csv = TRUE, override_csv = TRUE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv")

drug_categories(save_csv = TRUE, override_csv = TRUE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv")

drug_groups(save_csv = TRUE, override_csv = TRUE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv")

drug_general_information(save_csv = TRUE, override_csv = TRUE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv")

drug_sequences(save_csv = TRUE, override_csv = TRUE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv/test_ddi")

drug_salts(save_csv = TRUE, override_csv = TRUE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv")

drug_reactions(save_csv = TRUE, override_csv = TRUE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv")

drug_calc_prop(save_csv = TRUE, override_csv = TRUE, csv_path="~/projects/def-jlevman/x2020fpt/biomedical/drug_bank/drug_bank_csv")
