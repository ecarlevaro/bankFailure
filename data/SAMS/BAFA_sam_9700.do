/* This is just a quick database that only uses banks that have complete observations during the period */
use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\BAFA-main-1997-2001-quarterly.dta" 

keep if tin(1997q4,2000q4)
drop miss touse
bys IDENT: gen miss = !missing(ActivoN, APRestamos, C8Est, CAR_IRR_3A6_IMP, P_ROA, P_LOANS_ARS_RATE_IS_IMP, APRSpNF_RATE_W, APR_USD_RATE, APR_RATE_W,  GDP_D_Q, ARG_YTM)
bys IDENT : egen touse = min(miss)

summarize IDENT if touse==1 & tin(1997q4, 1997q4)

drop if touse!=1

missings report ActivoN  APRestamos  C8Est  CAR_IRR_3A6_IMP  P_ROA  P_LOANS_ARS_RATE_IS_IMP  APRSpNF_RATE_W  APR_USD_RATE  APR_RATE_W GDP_D_Q ARG_YTM, percent 

drop if FIRST_DATE_Q>tq(1997q4)

tssmooth
// also for macro vars?

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\SAMS\BAFA_sam_9700.dta", replace