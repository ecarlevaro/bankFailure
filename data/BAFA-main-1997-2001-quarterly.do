/* ******************************************************* */
/*
BAFA-main 
(Bank Failure Main)
The valoe for grupoIDUni for the observations with missing vale for GROUP_ID_MAX have been manually recorded using information from "entidades_eventos.xlsx" from "BasesBCRA-IEF\entidades". There are may be some error here in differentiating between foreign entities and locals.
Based on DBbanks\failures-allEnts-1997-2004.dta

*/
/* ******************************************************* */

failures-quarterly

//exclude negative Assets
use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\failures-allEnts-1997-2004.dta", clear

drop if Activo <= 0
drop if ActivoN <= 0
drop if missing(Activo)
drop if C8Est_w <= 0

keep if tin(1997m9, 2001m12)

collapse ActivoN APRestamos C8Est_w CAR_IRR_3A6 P_ROA P_DEP_ARS_RATE P_LOANS_ARS_RATE_W APRSpNF_RATE_W APR_USD_RATE APR_RATE_W, by(IDent FECHA_Q)

rename IDent IDENT
xtset IDENT FECHA_Q

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures-1997-2001-quarterly.dta"

// Bring quarterly macro data

merge m:1 FECHA_Q using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\GDPchg.dta", keep(master match) keepusing(GDP_D_Q)
merge m:1 FECHA_Q using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\SovereignRisk-quarterly.dta", keep(master match) keepusing(ARG_YTM BRA_YTM MEX_YTM)

// Bring exit date and type for each bank
// n=2,174
merge m:1 IDENT using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures\failure_time.dta", keep(master match) keepusing(FIRST_DATE EXIT_DATE EXIT_TYPE)
// There are banks in the failure DB that don't exist in the balance sheet DB because either they were created after 2004 or they died before 1997q4.
drop _merge
// n=2,174 mactched. Proceed.

// Exit date: use a high date value for censored banks (entities that did not fail)
replace EXIT_DATE = date("31Dec2099", "DMY", 2099) if missing(EXIT_DATE) & EXIT_TYPE==0

gen EXIT_Q = qofd(EXIT_DATE)
format %tq EXIT_Q
order EXIT_Q, after(EXIT_DATE)

/* *************************** */
/*	IMPORT DATA ON ENTITIES TYPE
/* *************************** */
gen FECHA_M = mofd( dofq(FECHA_Q))
format FECHA_M %tm
label var FECHA_M "Monthly date of the first month of quarter. To bring data from other DBs"
order FECHA_M, after(FECHA_Q)

gen FECHA_D = dofm(FECHA_M)
format FECHA_D %td
label var FECHA_D "Date with DAY-MONTH-YEAR (days since 1960-01-01). Useful when exporting to R"

// N=2,714, n=162, t-bar=13,41, k=19
merge 1:1 FECHA_M IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\entidades\entidades.dta", assert(master match) keep(master match) keepusing(grupoIDUni)
// N=2,714, n=162, t-bar=13,41, k=21

//////////////////
// solve missing values for grupoIDUni
sort IDENT
by IDENT: egen GRUPO_ID_MAX = max(grupoIDUni)
replace grupoIDUni = GRUPO_ID_MAX if missing(grupoIDUni)
rename grupoIDUni GRUPO_ID_UNI

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures-1997-2001-quarterly.dta", replace

// NOMBRE
xtsum IDENT
// N=2174, n=162, t-bar=13.41, k=21
merge 1:1 FECHA_M IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\entidades\entidades.dta", assert(master match) keep(master match) keepusing(NOMRED)
// N=2174, n=162, t-bar=13.41, k=23
order NOMRED, after(FECHA_M)

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures-1997-2001-quarterly.dta", replace