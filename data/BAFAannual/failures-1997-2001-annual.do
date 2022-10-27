/* ******************************************************* */
/*
The valoe for grupoIDUni for the observations with missing vale for GROUP_ID_MAX have been manually recorded using information from "entidades_eventos.xlsx" from "BasesBCRA-IEF\entidades". There are may be some error here in differentiating between foreign entities and locals.
*/
/* ******************************************************* */

failures-quarterly

//exclude negative Assets
use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\failures-allEnts-1997-2004.dta", clear

drop if Activo <= 0
drop if ActivoN <= 0
drop if C8Est_w <= 0

keep if tin(1997m9, 2001m12)

collapse ActivoN C8Est_w CAR_IRR_3A6 P_ROA P_DEP_ARS_RATE P_LOANS_ARS_RATE_W APRSpNF_RATE_W APR_USD_RATE APR_RATE_W, by(IDent FECHAdataAnio)

rename IDent IDENT
rename FECHAdataAnio FECHA_A
xtset IDENT FECHA_A

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures-1997-2001-annual.dta"

// Bring exit date and type for each bank
// N=656, n=162, t-bar=4.04
merge m:1 IDENT using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures\failure_time.dta", keep(master match) keepusing(FIRST_DATE EXIT_DATE EXIT_TYPE)
// There are banks in the failure DB that don't exist in the balance sheet DB because either they were created after 2004 or they died before 1997q4.
drop _merge
// N=656, n=162, t-bar=4.04

// Exit date: use a high date value for censored banks (entities that did not fail)
replace EXIT_DATE = date("31Dec2099", "DMY", 2099) if missing(EXIT_DATE) & EXIT_TYPE==0

/* *************************** */
/*	IMPORT DATA ON ENTITIES TYPE
/* *************************** */
gen FECHAdata = mofd( mdy(1,1,FECHA_A))
format FECHAdata %tm
label var FECHAdata "Monthly date of the first month of the year. To bring data from other DBs"
order FECHAdata, after(FECHA_A)

gen FECHA_D = dofm(FECHAdata)
label var FECHA_D "FECHAdata as a full date that R can understand"
format %td FECHA_D

xtsum IDENT
// N=655, n=162, t-bar=4304, k=15
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures-1997-2001-quarterly.dta", assert(master match) keep(master match) keepusing(GRUPO_ID_UNI NOMRED)
// N=655, n=162, t-bar=4304, k=18

// Solve GRUPO_ID_UNI missing data
sort IDENT
by IDENT: egen GRUPO_ID_MAX = max(GRUPO_ID_UNI)
replace GRUPO_ID_UNI = GRUPO_ID_MAX if missing(GRUPO_ID_UNI)

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures-1997-2001-annual.dta", replace
order NOMRED, after(FECHAdata)

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures-1997-2001-annual.dta", replace