import excel "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\GDP_variation_seasonally_adjusted.xlsx", sheet("chgNoSeasonality") firstrow

drop ANO CUAT

egen DATE_Q_STR = concat(YEAR_STR QUARTER_STR), punct("-")
gen DATE_Q = quarterly(DATE_Q_STR, "YQ", 2019)
format %tq DATE_Q
drop DATE_Q_STR
order DATE_Q 

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\GDPchg.dta"