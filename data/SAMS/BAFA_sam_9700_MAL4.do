/* This is just a quick database that only uses banks that have complete observations during the period */
*/
use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\BAFA-main-1997-2001-quarterly.dta" 

keep if tin(1998q4,2000q4)
drop miss touse
bys IDENT: gen miss = !missing(ActivoN_S_MAL4, APRestamos_MAL4, C8Est_MAL4, CAR_IRR_3A6_IMP_MAL4, P_ROA_MAL4, P_LOANS_ARS_RATE_IS_IMP_MAL4, APRSpNF_RATE_W_MAL4, APR_USD_RATE_MAL4, APR_RATE_W_MAL4,  GDP_D_Q, ARG_YTM)
bys IDENT : egen touse = min(miss)

summarize IDENT if touse==1 & tin(1998q4, 1998q4)

drop if touse!=1

missings report ActivoN_S_MAL4  APRestamos_MAL4  C8Est_MAL4  CAR_IRR_3A6_IMP_MAL4  P_ROA_MAL4  P_LOANS_ARS_RATE_IS_IMP_MAL4  APRSpNF_RATE_W_MAL4  APR_USD_RATE_MAL4  APR_RATE_W_MAL4 GDP_D_Q ARG_YTM, percent 

drop if FIRST_DATE_Q>tq(1997q4)


save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\SAMS\BAFA_sam_9700_MAL4.dta", replace