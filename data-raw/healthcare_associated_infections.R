## code to prepare `healthcare_associated_infections` dataset goes here

library(tidyverse)

healthcare_associated_infections <- read.csv("data-raw/healthcare_associated_infections.csv", stringsAsFactors = FALSE)


# coerce types
healthcare_associated_infections <- healthcare_associated_infections %>%
  mutate(
    Infection_Type = as.character(Infection_Type),
    Number_of_HAIs = as.numeric(Number_of_HAIs),
    Number_of_attributable_deaths = as.numeric(Number_of_attributable_deaths)
  )


usethis::use_data(healthcare_associated_infections, overwrite = TRUE)
