// JP Morgan yield-to-maturity from the EMBI index

import delimited "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\RepRigobon2003\Data\EMBI+ YTM.csv", case(upper) encoding(ISO-8859-2) 

rename ARGENTINAYLDTOMATURITY ARG_YTM
rename MEXICOYLDTOMATURITY MEX_YTM
rename BRAZILYLDTOMATURITY BRA_YTM

rename DATE DATE_STR
gen DATE = date(DATE_STR, "DMY", 2019)
format %td DATE
tsset DATE

gen DATE_Q = qofd(DATE)
label var "Quartery date"
format %tq DATE_Q

destring(BRA_YTM), replace force ignore("-")
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\SovereignRisk.dta"

collapse (mean) ARG_YTM (mean) BRA_YTM (mean) MEX_YTM, by(DATE_Q)
rename DATE_Q FECHA_Q
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\SovereignRisk-quarterly.dta"
