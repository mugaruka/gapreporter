# clearing the r workspace
rm(list = ls(all = TRUE))

# setting the working directory
setwd("E:/personal-files/blog/mugaruka/sandbox")

# loading the required packages
library(foreign) # for reading Stata files into the R environment
library(dplyr) # for the tidyverse pipe operator and multiple functions called to manipulate the data
library(tidyr) # for the spread() and gather() functions used to transform the data from wide to long

#  wrangling the data into the form required for analysis
source("FUNCTION.PrepForSiblingsDHS.r")
df <- PrepForSiblingsDHS(ind.recode="CDIR61FL.DTA", SurveyRefDate="12/31/2013")

#  performing the mortality estimation according to a set of options
source("FUNCTION.SiblingSurvival.r")
out <- SiblingSurvival(PreppedSibData = df,
                       include.Respondent = FALSE,
                       impute.Sex = FALSE,
                       PregRelCode = c(2,3,6),
                       recall.back = 7,
                       recall.end = 0,
                       stderror = FALSE,
                       age.standardize = TRUE,
                       pr.recode = "CDPR61FL.DTA")

out <- out %>%
  tidyr::pivot_wider(names_from = sex, values_from = Estimate) %>%
  dplyr::mutate(Age = ifelse(Age == 15 & AgeInt == 35, 1535, Age)) %>%
  dplyr::mutate(Age = recode(Age,
                             `15` = "15-19",
                             `20` = "20-24",
                             `25` = "25-29",
                             `30` = "30-34",
                             `35` = "35-39",
                             `40` = "40-44",
                             `45` = "45-49",
                             `1535` = "15-49")) %>%
  dplyr::rename(`Age Group` = Age, `Male` = `1`, `Female` = `2`)

# the mortality rate 
mx <- out %>% dplyr::filter(Indicator == "mx") %>%
  dplyr::select(-c(AgeInt, Indicator)) %>%
  dplyr::mutate(Male = round(Male * 1000),  Female = round(Female * 1000))

# the probability of dying 
qx <- out %>% dplyr::filter(Indicator == "qx") %>%
  dplyr::select(-c(AgeInt, Indicator))
