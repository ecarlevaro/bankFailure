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

// Select 20 banks, 50% failing and not failing 50%
// Select the first  10 failing banks from this list
list IDENT if FQ==yq(1997,4) & FAIL_DATE_Q  <= yq(2001,4), noobs clean
// 10 not-failing 
list IDENT if FQ==yq(1997,4) & FAIL_DATE_Q  > yq(2004,4), noobs clean

egen KEEPIT = anymatch(IDENT), values(307 308 318 320 323 44032 44087 45085 64124 65201 321 322 44068 44077 44088 45056 45065 45118 64085 65203)

keep if KEEPIT==1
xtsum IDENT
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\SAMS\9700_s20.dta", replace