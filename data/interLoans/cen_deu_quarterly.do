
use "C:\Users\emi\OneDrive\UWA PhD\bankFailure\data\interLoans\cen_deu_1997-06_2001-06_todas_ent_fcieras.dta" 
// keep only bank links 
drop if missing(IDENT_ACREEDORA) || missing(IDENT_DEUDORA)

summ IDENT_ACREEDORA
// n=10,381
codebook IDENT_ACREEDORA
// unique values = 135
codebook IDENT_DEUDORA
// unique values = 147
// k = 4

collapse PRESTAMOS, by(FECHA_Q IDENT_ACREEDORA IDENT_DEUDORA)

gen FQ = FECHA_Q
label var FQ "FECHA_Q"
// n=9697, k=4, IDENT_ACREEDORA unique values=135, IDENT_DEUDORA unique values=147

/* ********************************************** */
/*		BANK BALANCE SHEET DATA*/
/* ********************************************** */
// Import Assets and Loans to compute weights

// use IDent first for lender bank and then for borrower bank
gen IDENT = IDENT_ACREEDORA
sum IDENT_ACREEDORA
codebook IDENT_ACREEDORA
// unique values:  135 , n=9,697, k=5
merge m:1 IDENT FQ using "C:\Users\emi\OneDrive\UWA PhD\bankFailure\data\BAFA-main-1997-2004-quarterly.dta", assert(master match) keep(master match) keepusing(B_TYPE ActivoN APRestamos Pdep PdepARS PN)

rename 	B_TYPE A_GRUPO_ID_UNI
label var A_GRUPO_ID_UNI "Grupo uniforme entidad acreedora"	
			  
rename 	ActivoN A_ActivoN
label var A_ActivoN "Activo neto entidad acreedora"

rename 	APRestamos A_APRestamos	
label var A_APRestamos "Prestamos totales entidad acreedora"

rename 	Pdep A_Pdep	
label var A_Pdep "Depositos totalesentidad acreedora"

rename 	PdepARS A_PdepARS	
label var A_PdepARS "Depositos en ARS totales entidad acreedora"

rename 	PN A_PN	
label var A_PN "Patrimonio neto entidad acreedora"


replace IDENT = IDENT_DEUDORA
sum IDENT_DEUDORA
codebook IDENT_DEUDORA
// unique values:  147 , n=9,697, k=9
drop _merge
merge m:1 IDENT FECHA_Q using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures-1997-2001-quarterly.dta", assert(master match) keep(master match) keepusing(B_TYPE ActivoN APRestamos)
//  n=9,697, k=12

rename 	B_TYPE D_GRUPO_ID_UNI
label var D_GRUPO_ID_UNI "Grupo uniforme entidad deudora"				  
rename 	ActivoN D_ActivoN
label var D_ActivoN "Activo neto entidad deudora"
rename 	APRestamos D_APRestamos	
label var D_APRestamos "Prestamos totales entidad deudora"

/* WEIGHTS */
// From lender's side
gen W_A_A = PRESTAMOS / A_ActivoN
label var W_A_A "Proporción de prestamos a Activo del acreedor"
winsor2 W_A_A , cuts(1 99) suffix("")

gen W_A_PR = PRESTAMOS / A_APRestamos
label var W_A_PR "Proporción de prestamos a Préstamos"
winsor2 W_A_PR , cuts(1 99) suffix("")

// From debtor's side
gen W_D_A = PRESTAMOS / D_ActivoN
label var W_D_A "Proporción de prestamos a Activo del deudor"
winsor2 W_D_A , cuts(1 99) suffix("")

gen W_D_PR = PRESTAMOS / D_APRestamos
label var W_D_PR "Proporción de prestamos a Préstamos del deudor"
winsor2 W_D_PR , cuts(1 99) suffix("")

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\interLoans\cen_deu_1997-06_2001-quarterly.dta", replace

/* ****************************** */
gen FECHA_A = year(dofq(FECHA_Q))
label var FECHA_A "Año de la relación"
order FECHA_A, after(FECHA_Q)

gen FECHA_D = dofq(FECHA_Q)
format FECHA_D %td
label var FECHA_D "Date with DAY-MONTH-YEAR (days since 1960-01-01). Useful when exporting to R"


/* ****************************** */
// Extract network during 1998
	sum IDENT_ACREEDORA if FECHA_A == 1998
	// n=1866
	collapse (sum) W_A_A W_A_PR , by(FECHA_A IDENT_ACREEDORA IDENT_DEUDORA)
	sum IDENT_ACREEDORA if FECHA_A == 1998

	// Divide by four to get quarterly average
	replace W_A_A = W_A_A / 4
	replace W_A_PR= W_A_PR / 4

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\interLoans\cen_deu_annual.dta"
