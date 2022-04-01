/*
data from 1997q4 (or before if available,)
failures from 1998q1.
banks alive by 1997q4*/

use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\BAFA-main-1997-2001-quarterly.dta" 

// Create past moving averages of bank covariates
//foreach varName of var ActivoN_S APRestamos C8Est CAR_IRR_3A6_IMP P_ROA P_LOANS_ARS_RATE_IS_IMP APRSpNF_RATE_W APR_USD_RATE APR_RATE_W  {
//	by IDENT: gen `varName'_MA4L4 = (L4.`varName' + L5.`varName' + L6.`varName'  + L7.`varName')/4 if FQ>=tq(1998q4)
//	// Use 1997q4 for now
//	by IDENT: replace `varName'_MA4L4 = L3.`varName'  if FQ==tq(1998q3)
//	by IDENT: replace `varName'_MA4L4 = L2.`varName'  if FQ==tq(1998q2)
//	by IDENT: replace `varName'_MA4L4 = L1.`varName' if FQ==tq(1998q1)
//	
//	label var `varName'_MAL4 "Moving average last 4 previous quarters"
//}

foreach varName of var ActivoN_S APRestamos C8Est CAR_IRR_3A6_IMP P_ROA P_LOANS_ARS_RATE_IS_IMP APRSpNF_RATE_W APR_USD_RATE APR_RATE_W  {
	by IDENT: gen `varName'_L4 = L4.`varName'
	
	label var `varName'_L4 "Moving average last 4 previous quarters"
}

keep if tin(1998q4,2000q4)
drop miss touse
bys IDENT: gen miss = !missing(ActivoN_S_L4, APRestamos_L4, C8Est_L4, CAR_IRR_3A6_IMP_L4, P_ROA_L4, P_LOANS_ARS_RATE_IS_IMP_L4, APRSpNF_RATE_W_L4, APR_USD_RATE_L4, APR_RATE_W_L4,  GDP_D_Q, ARG_YTM)
bys IDENT : egen touse = min(miss)

summarize IDENT if touse==1 & tin(1998q4, 1998q4)

drop if touse!=1

missings report ActivoN_S_L4  APRestamos_L4  C8Est_L4  CAR_IRR_3A6_IMP_L4  P_ROA_L4  P_LOANS_ARS_RATE_IS_IMP_L4  APRSpNF_RATE_W_L4  APR_USD_RATE_L4  APR_RATE_W_L4 GDP_D_Q ARG_YTM, percent 

drop if FIRST_DATE_Q>tq(1997q4)


save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\SAMS\9700_L4.dta", replace


