/* ************************************** */
/* This database takes observations from capital-allEntities-Monthly.dta from 1997 to 2004
The do files are: 
	-CapTotalMen-VarsDef.do 
	-This file.
In this database, the variables that are sums of 'saldo' vars, treted missing values as zero. 
*/
 // this file
drop if IDENT>99999
drop if missing(ActivoN)

gen FECHA_Q = qofd(dofm(FECHAdata))
label var FECHA_Q "Quarterly date"
format FECHA_Q %tq
order FECHA_Q, after(FECHAdata)
// Mes cierre: update
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\entidades\entidades.dta", assert(master match match_update) keep(master match match_update) keepusing(MESCIE grupoIDUni) update
drop bMesCierre
rename MESCIE bMesCierre
order bMesCierre, after(FECHAcd)

gen APRestamos = APRestamosARS+APRestamosUSD
label var APRestamos "Total prestamos"
format APRestamos %14.0gc

gen APRSpNF_RATE = ((APRARSSpNFCap + APRUSDSpNFCap)/ (APRestamosARS+APRestamosUSD))*100
order APRSpNF_RATE, after(RISK_EXC_PREV)
label var APRSpNF_RATE "Ratio de préstamos al Sector Público No Financiero al total de Préstamos"
// There are 5 big values greater than 100
winsor2 APRSpNF_RATE, cuts(1 99) suffix(_W)
order APRSpNF_RATE_W, after(APRSpNF_RATE)
label var APRSpNF_RATE_W "Rate of total loans to public sector (%)"

gen APR_USD_RATE = (APRestamosUSD / (APRestamosARS + APRestamosUSD))*100
label var APR_USD_RATE "Loans in USD to total loans"
order APR_USD_RATE, after(APRSpNF_RATE)

gen APR_RATE = ((APRestamosARS + APRestamosUSD)/ActivoN)*100
label var APR_RATE "Loans to ActivoN"
order APR_RATE, before(CAR_IRR_3A6)
// There are 4 weird values (lower than 0 or greater than 1)
winsor2 APR_RATE , cuts(1 99) suffix(_W)
order APR_RATE, after(APR_RATE)
label variable APR_RATE_W "Loans to ActivoN winsorized at 1-99"

winsor2 P_LOANS_ARS_RATE , cuts(1 99) suffix(_W)
order P_LOANS_ARS_RATE_W, after(P_LOANS_ARS_RATE)
label variable P_LOANS_ARS_RATE_W "Loans interest rate (%) winsorized at 1-99"
