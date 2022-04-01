library(tidyverse)
library(haven)
library(xlsx)
library(lubridate)

setwd('C:/Users/emi/OneDrive/InvUNL/capitalEffects/data/interLoans')
DbCenDeu <- read_dta('cen_deu_1997-06_2001-06_todas_ent_fcieras.dta') %>%
      mutate(., FECHA_CD = lubridate::ymd("1960-01-01")+months(FECHA_CD),
         FECHA_DATA = lubridate::ymd("1960-01-01")+months(FECHA_DATA))

QC <- DbCenDeu %>%
      filter(., IDEN == 	30709205982) %>%
      select(FECHA_DATA, FECHA_CD, NOMCLI)
QC


