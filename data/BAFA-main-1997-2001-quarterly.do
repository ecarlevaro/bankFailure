/* ******************************************************* */
/*
BAFA-main 
(Bank Failure Main)
The valoe for grupoIDUni for the observations with missing vale for GROUP_ID_MAX have been manually recorded using information from "entidades_eventos.xlsx" from "BasesBCRA-IEF\entidades". There are may be some error here in differentiating between foreign entities and locals.
Based on DBbanks\failures-allEnts-1997-2004.dta

*/*/
/* ******************************************************* */

failures-quarterly

//exclude negative Assets
use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1997-2004.dta", clear

keep if tin(1997m9, 2001m12)

// Save variable labels into a local var (macro)
foreach varName of var B_NAME B_TYPE ActivoN_S APRestamos PdepARS C8Est CAR_IRR_2A6 CAR_IRR_3A6 P_ROA P_DEP_ARS_RATE P_DEPARS_IK_TNA P_DEPUSD_IK_TNA P_LOANS_ARS_RATE_SI P_LOANS_ARS_RATE_IS APRSpNF_RATE_W APR_USD_RATE APR_RATE_W {
	local l`varName' : variable label `varName'
       if `"`l`varName''"' == "" {
		local l`varName' "`varName'"
 	}
}

collapse (first) B_NAME B_TYPE (mean) ActivoN_S APRestamos PdepARS C8Est CAR_IRR_2A6 CAR_IRR_3A6 P_ROA P_DEP_ARS_RATE P_DEPARS_IK_TNA P_DEPUSD_IK_TNA P_LOANS_ARS_RATE_SI P_LOANS_ARS_RATE_IS APRSpNF_RATE_W APR_USD_RATE APR_RATE_W, by(IDENT FQ)

xtset IDENT FQ
xtsum IDENT
// N=2260, n=164, T-bar=13.7805
foreach varName of var B_NAME B_TYPE ActivoN APRestamos PdepARS C8Est CAR_IRR_2A6 CAR_IRR_3A6 P_ROA P_DEP_ARS_RATE P_DEPARS_IK_TNA P_DEPUSD_IK_TNA P_LOANS_ARS_RATE_SI P_LOANS_ARS_RATE_IS APRSpNF_RATE_W APR_USD_RATE APR_RATE_W {
	label var `varName' `"`l`varName''"'
}

drop if Activo <= 0
drop if ActivoN <= 0

// Mark entities that are not banks
//gen NOT_BANK = 1 if (PdepARS == 0 | APRestamos == 0)
//drop if NOT_BANK==1

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\BAFA-main-1997-2001-quarterly.dta", replace


// Bring exit date and type for each bank
// n=2,174
merge m:1 IDENT using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures\failure_time.dta", keep(master match) keepusing(FIRST_DATE_Q FAIL_DATE_Q FAIL_TYPE) nogenerate
// There are banks in the failure DB that don't exist in the balance sheet DB because either they were created after 2004 or they died before 1997q4.
// n=2,249 mactched. Proceed.

// Bring quarterly macro data
merge m:1 FQ using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\GDPchg.dta", keep(master match) keepusing(GDP_D_Q) nogenerate
merge m:1 FQ using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBmacro\SovereignRisk-quarterly.dta", keep(master match) keepusing(ARG_YTM BRA_YTM MEX_YTM) nogenerate

// N=2,249, n=164, t-bar=13,7134, K=27

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\BAFA-main-1997-2001-quarterly.dta", replace


// Observations of dead banks (FAIL_DATE_Q = . = ∞ is not failing bank) 
drop if FQ>FAIL_DATE_Q

/* ************************** */
SOLVE MISSING VALUES BY IMPUTATION

// Mean by panel
sort IDENT FQ
by 	IDENT: gen CAR_IRR_3A6_IN_LF = (L1.CAR_IRR_3A6 + F1.CAR_IRR_3A6)/2 if tin(1998q1,2000q4)

// Banco Prov de Cordoba 
replace CAR_IRR_3A6 = . if IDENT==20 & FQ==yq(2000,2)
replace CAR_IRR_3A6 = . if IDENT==20 & FQ==yq(2000,4)
// Nuevo Banco La Rioja
replace CAR_IRR_3A6 = . if IDENT==309 & FQ==yq(2000,3)

// Verfiy huge variations
by IDENT: gen CAR_IRR_3A6_PCH = ((D.CAR_IRR_3A6)/L.CAR_IRR_3A6)*100

//  FAIL_DATE_Q is missing for bank that do not fail. Missing value in Stata are represented by large positive values
gen CAR_IRR_3A6_IMP = CAR_IRR_3A6
replace CAR_IRR_3A6_IMP = CAR_IRR_3A6_IN_LF if missing(CAR_IRR_3A6) & tin(1998q1,2000q4) & FAIL_DATE_Q>FQ
label var CAR_IRR_3A6_IMP "Non-perfoming loans, some value imputed"

// Deposits rate
gen P_DEPARS_RATE_IS = P_DEP_ARS_RATE
replace P_DEPARS_RATE_IS = P_DEPARS_IK_TNA if missing(P_DEP_ARS_RATE)
replace P_DEPARS_RATE_IS = P_DEPARS_IK_TNA if P_DEP_ARS_RATE==0 & !missing(P_DEPARS_IK_TNA) & P_DEPARS_IK_TNA >0

// Loans rates
by 	IDENT: gen P_LOANS_ARS_RATE_IS_IN_LF = (L1.P_LOANS_ARS_RATE_IS + F1.P_LOANS_ARS_RATE_IS)/2 if tin(1998q1,2000q4)

replace P_LOANS_ARS_RATE_IS = . if IDENT==20 & FQ==yq(2000,2)
replace P_LOANS_ARS_RATE_IS = . if IDENT==42 & FQ==yq(2000,3) & P_LOANS_ARS_RATE_IS==0
replace P_LOANS_ARS_RATE_IS = . if IDENT==309 & FQ==yq(2000,3) & P_LOANS_ARS_RATE_IS==0
replace P_LOANS_ARS_RATE_IS = . if IDENT==312 & FQ==yq(2000,2) & P_LOANS_ARS_RATE_IS==0

gen P_LOANS_ARS_RATE_IS_IMP = P_LOANS_ARS_RATE_IS
replace P_LOANS_ARS_RATE_IS_IMP = P_LOANS_ARS_RATE_IS_IN_LF if missing(P_LOANS_ARS_RATE_IS) & tin(1998q1,2000q4) & FAIL_DATE_Q>FQ
label var P_LOANS_ARS_RATE_IS_IMP "Lending rate in ARS from IS, some values imputed BY LINEAR INTERPOLATION"

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\BAFA-main-1997-2001-quarterly.dta", replace

/* ************************************************* */
/*		GENERATE PAST MOVING AVERAGE OF BANK COVARIATES */ DO THIS IN THE RESPECT SAMPLE DO fiel
/* ************************************************* */
// Create past moving averages of bank covariates
//foreach `varName' of var ActivoN_S APRestamos C8Est CAR_IRR_3A6_IMP P_ROA P_LOANS_ARS_RATE_IS_IMP APRSpNF_RATE_W APR_USD_RATE APR_RATE_W  {
//	by IDENT: gen _MAL4 = (L1.`varName' + L2.`varName' + L3.`varName'  + L4.`varName')/4 
//	label varName `varName'_MAL4 "Moving average last 4 previous quarters"
//}






