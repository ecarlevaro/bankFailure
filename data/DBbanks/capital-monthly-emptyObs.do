/* These are observations discarded from the main database capital-allEntities-Monthly.dta */

open "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\capital-allEntities-Monthly-REBUILD VARS.dta"
egen MISS_ROW = rowtotal(saldo* C8Est), missing
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\capital-allEntities-Monthly-REBUILD VARS.dta", replace
keep if missing(MISS_ROW)
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\capital-monthly-emptyObs.dta"