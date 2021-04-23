failures-quarterly

//exclude negative Assets
use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\failures-allEnts-1997-2004.dta", clear

drop if Activo <= 0
drop if ActivoN <= 0
drop if C8Est_w <= 0

keep if tin(1997m9, 2001m12)

collapse ActivoN C8Est_w CAR_IRR_3A6 P_ROA P_DEP_ARS_RATE P_LOANS_ARS_RATE_W APRSpNF_RATE_W APR_USD_RATE APR_RATE_W, by(IDent FECHA_Q)

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