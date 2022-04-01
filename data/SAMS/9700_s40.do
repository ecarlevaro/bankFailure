/* This is just a quick database that only uses banks that have complete observations during the period */
use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\BAFA-main-1997-2001-quarterly.dta" 

keep if tin(1997q4,2000q4)
drop miss touse
bys IDENT: gen miss = !missing(ActivoN, APRestamos, C8Est, CAR_IRR_3A6_IMP, P_ROA, P_LOANS_ARS_RATE_IS_IMP, APRSpNF_RATE_W, APR_USD_RATE, APR_RATE_W)
bys IDENT : egen touse = min(miss)

summarize IDENT if touse==1 & tin(1997q4, 1997q4)

drop if touse!=1

missings report ActivoN  APRestamos  C8Est  CAR_IRR_3A6_IMP  P_ROA  P_LOANS_ARS_RATE_IS_IMP  APRSpNF_RATE_W  APR_USD_RATE  APR_RATE_W , percent 

drop if FIRST_DATE_Q>tq(1997q4)

// Select 20 banks, 50% failing and not failing
// Select the first  20 failing banks from this list
list IDENT if FQ==yq(1997,4) & FAIL_DATE_Q  <= yq(2001,4), noobs
// 20 not-failing 
list IDENT if FQ==yq(1997,4) & FAIL_DATE_Q  > yq(2004,4), noobs clean

egen KEEPIT = anymatch(IDENT), values(1 6 39 50 54 62 81 133 141 149 162 167 178 229 231 249 260 267 273 275 5 7 10 11 15 16 17 18 27 29 34 42 44 45 46 60 72 79 93 137)

keep if KEEPIT==1
xtsum IDENT

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\SAMS\9700_s40.dta", replace