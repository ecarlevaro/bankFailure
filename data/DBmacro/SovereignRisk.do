// JP Morgan yield-to-maturity from the EMBI index

import delimited "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\RepRigobon2003\Data\EMBI+ YTM.csv", case(upper) encoding(ISO-8859-2) 

rename ARGENTINAYLDTOMATURITY ARG_YTM
rename MEXICOYLDTOMATURITY MEX_YTM
rename BRAZILYLDTOMATURITY BRA_YTM

rename DATE DATE_STR
gen DATE = date(DATE_STR, "DMY", 2019)
format %td DATE
tsset DATE

gen FQ = qofd(DATE)
label var "Quartery date"
format %tq FQ

destring(BRA_YTM), replace force ignore("-")
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\SovereignRisk.dta"

/* quarterly */

collapse (mean) ARG_YTM (mean) BRA_YTM (mean) MEX_YTM, by(DATE_Q)
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\SovereignRisk-quarterly.dta"

order FQ ARG_ BRA_ MEX_

/* ************************************************* */
/*		GENERATE DATES FOR R */
/* ************************************************* */ 

// R doesnt like Stata quarter date, so I generate date (YEAR-MONTH-DAY) dates
gen F_D = dofq(FQ)
format %tdCCYY-NN-DD F_D
label var F_D "date (YEAR-MONTH-DAY) for R"
