///////////////////////////////////
 DATA 2000q4
 
esd_2000q4.dta
 
///////////////////////////////////

use "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\ESD\archivosConstruccion\esd_1998-07_2004-06_LONG_antesExtraccion.dta" 
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\ESD\others\ESD_BAFA_2000q4.dta", replace

// replazare "," por "."
drop if DATA_A_F2 == ""
gen DATA = subinstr(DATA_A_F2 , ",", ".", 1)
destring(DATA), replace
drop if IDent>99999
drop if missing(F2Fecha) & missing(DATA)
drop if missing(F2Fecha) & DATA == 0

// I only need data on last quarter of 2000
gen useful = 1 if F2Fecha == ym(2000,9)
replace useful = 1 if F2Fecha == ym(2000,10)
replace useful = 1 if F2Fecha == ym(2000,12)
keep if useful == 1
// Duplicates
duplicates tag F2Fecha IDent VAR_NAME DATA, generate(dup)
duplicates drop F2Fecha IDent VAR_NAME DATA, force

drop dup
duplicates tag F2Fecha IDent VAR_NAME, generate(dup)
// IDent 20 has 0s for 2001m3
drop if FECHAcd == ym(2001,3) & IDent==20
// Same for IDent 44059
drop if FECHAcd == ym(2001,3) & IDent==44059
drop if FECHAcd == ym(2001,12) & IDent==44059
drop if FECHAcd == ym(2001,6) & IDent==11
drop if FECHAcd == ym(2001,6) & IDent==271
drop if FECHAcd == ym(2001,6) & IDent==14
isid F2Fecha IDent VAR_NAME
drop dup

// Good to go!

// I do not keep FECHAcd because it varies for different banks
keep F2Fecha IDent VAR_NAME DATA
reshape wide DATA, i(F2Fecha IDent) j(VAR_NAME) string
rename DATA* *
rename F2Fecha FECHAdata
order FECHAdata IDent TFG TF_SIT_1 TF_SIT_2 TF_SIT_3 TF_SIT_4 TF_SIT_5 TF_SIT_6 TG TG_SIT_1 TG_SIT_2 TG_SIT_3 TG_SIT_4 TG_SIT_5 TG_SIT_6 TGO CCOM CCOM_RATIO_TF CCOM_SIT_1 CCOM_SIT_2 CCOM_SIT_3 CCOM_SIT_4 CCOM_SIT_5 CCOM_SIT_6 CCOMG CCOMG_SIT_1 CCOMG_SIT_2 CCOMG_SIT_3 CCOMG_SIT_4 CCOMG_SIT_5 CCOMG_SIT_6 CCOMGO CCONVIV CCONVIV_RATIO_TF CCONVIV_SIT_1 CCONVIV_SIT_2 CCONVIV_SIT_3 CCONVIV_SIT_4 CCONVIV_SIT_5 CCONVIV_SIT_6 CCONVIVG CCONVIVG_SIT_1 CCONVIVG_SIT_2 CCONVIVG_SIT_3 CCONVIVG_SIT_4 CCONVIVG_SIT_5 CCONVIVG_SIT_6 CCONVIVGO CCOM200 CCOM200_RATIO_TF CCOM200_SIT_1 CCOM200_SIT_2 CCOM200_SIT_3 CCOM200_SIT_4 CCOM200_SIT_5 CCOM200_SIT_6 CCOM200G CCOM200G_SIT_1 CCOM200G_SIT_2 CCOM200G_SIT_3 CCOM200G_SIT_4 CCOM200G_SIT_5 CCOM200G_SIT_6 CCOM200GO PREV
// More cleaning
list FECHAdata IDent if TFG==0
// This is a best solution than dropping observations because we preserve the var PREV which is not missing
mvdecode TFG-PREV if TFG==0, mv(0)
isid FECHAdata IDent

// should be 100 or close to for all. Many observations only have valuees for TF_SIT1
egen test = rowtotal(TF_SIT_1 TF_SIT_2 TF_SIT_3 TF_SIT_4 TF_SIT_5 TF_SIT_6)
sort test

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\ESD\others\ESD_BAFA_2000q4.dta", replace

// Now export to ESD_BAFA.dta