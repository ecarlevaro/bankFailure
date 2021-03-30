/* ************************************ */
//		ENTIDADES
/* ************************************ */

// Cambio FCE
by IDent: gen cambioFCE = bMesCierre - L1.bMesCierre
// Corrección cambio FCE
replace bMesCierre = 6 if (IDent==60 & FECHAdata<ym(2007, 1))
replace bMesCierre = 12 if (IDent==60 & FECHAdata>=ym(2007, 1))
replace bMesCierre = 6 if (IDent==83 & FECHAdata<ym(2016, 1))
replace bMesCierre = 6 if (IDent==93 & FECHAdata<ym(2009, 1))
replace bMesCierre = 6 if (IDent==150 & FECHAdata<ym(2015, 1))
replace bMesCierre = 6 if (IDent==191 & FECHAdata<ym(2017, 1))
replace bMesCierre = 6 if (IDent==299 & FECHAdata<ym(2017, 1))
replace bMesCierre = 6 if (IDent==301 & FECHAdata<ym(2017, 1))
replace bMesCierre = 6 if (IDent==303 & FECHAdata<ym(2008, 1))
replace bMesCierre = 6 if (IDent==305 & FECHAdata<ym(2017, 1))
replace bMesCierre = 6 if (IDent==310 & FECHAdata<ym(2017, 1))
replace bMesCierre = 6 if (IDent==389 & FECHAdata<ym(2016, 1))
replace bMesCierre = 6 if (IDent==45056 & FECHAdata<ym(2016, 1))

/* ********************************************************** */
/*			INDICADORES									*/
/* ********************************************************** */

/* FUSION CON BASES DE INDICADORES */
//Mantiene las observaciones que coinciden y las que no del Master (y no incluye las que no coinciden del using)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\R1.dta", assert(master match) keep(master match) keepusing(R1) generate(_mergeR1)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\R4.dta", assert(master match) keep(master match) keepusing(R4) generate(_mergeR4)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\R2.dta", assert(master match) keep(master match) keepusing(R2) generate(_mergeR2)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\E4.dta", assert(master match) keep(master match) keepusing(E4) generate(_mergeE4)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\E3.dta", assert(master match) keep(master match) keepusing(E3) generate(_mergeE3)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\E7.dta", assert(master match) keep(master match) keepusing(E7) generate(_mergeE7)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\E17.dta", assert(master match) keep(master match) keepusing(E17) generate(_mergeE17)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\E15.dta", assert(master match) keep(master match) keepusing(E15) generate(_mergeE15)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\E1.dta", assert(master match) keep(master match) keepusing(E1) generate(_mergeE1)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\A10.dta", assert(master match) keep(master match) keepusing(A10) generate(_mergeA10)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\A2.dta", assert(master match) keep(master match) keepusing(A2) generate(_mergeA2)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\A3.dta", assert(master match) keep(master match) keepusing(A3) generate(_mergeA3)
merge 1:1 FECHAdata IDent using "D:\emi\Documents\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\A4.dta", assert(master match) keep(master match) keepusing(A4) generate(_mergeA4)

// INDICADORES MODERNO

// UPdate until 2020-02
// Allow incorporating observations which do not coincide with masters. The reason is that indicadores databases cointain data on failed banks since these DBs were constructed using each quarterly Report rather than the historical one
// CAR_IRR_3A6
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\CarteraIrregular-A9-A10.dta", keepusing(CAR_IRR_3A6) generate(_mergeCAR_IRR) update

// ROE
rename R_ROE R1
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Perfomance-Returns-R1.dta", keepusing(R1) nogenerate update 
rename R1 R_ROE
label var R_ROE "Perfomance return on equity"

// Loans rate
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Perfomance-LoansRate-R8-R6-T1-T2.dta", keepusing(P_LOANS_ARS_RATE) update nogenerate

// Deposits rate
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Perfomance-DepositsRate-R9-R7-T3.dta", keepusing(P_DEP_ARS_RATE) update nogenerate

// ROA
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Perfomance-ROA-R2-RG1.dta",  keepusing(P_ROA) update nogenerate

// Liquid assets to deposits and net call position
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Liquidity-LIQ-L1.dta",  keepusing(LA2DEPCALL) update nogenerate

// C8_E (capital ratio as computed by BCRA from indicadores)
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\C8_E-1995-2020.dta", keepusing(C8_E) generate(_mergeC8_E) update


/* ********************************************************** */
/*			BALANCE RESUMIDO									*/
/* ********************************************************** */

// A_IMP_NETEAR 
// Importes a netear por operaciones de pases
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\balanceResumido\impANetear.dta",  keepusing(A_IMP_NETEAR) update nogenerate

// impANetear from Blce resumido contains the groups (IDent>99 999)
drop if IDent > 99999
(4,230 obs deleted)
//There are still 8 obs which do not match

/* ************************************************************** */
/*
/* 						DATOS DE CASAS (SUCURSALES)
/*
/* ************************************************************** */
gen casasObsArt = 0
label var casasObsArt "1 si la observación es artificial (igual al trimestre anterior)"
by IDent: replace casNpcia = L1.casNpcia if casNpcia == . & FECHAdata<ym(2016, 6)

/* Relleno fechas sin datos (mensuales) */
by IDent: mipolate casNpcia FECHAdata if tin(1997m4, 2016m6), generate(casNpciaCom) nearest ties(before)
by IDent: mipolate casNsucu FECHAdata if tin(1997m4, 2016m6), generate(casNsucuCom) nearest ties(before)
by IDent: mipolate casNcajAut FECHAdata if tin(1997m4, 2016m6), generate(casNcajAutCom) nearest ties(before)
by IDent: mipolate casMedMktShrPcia FECHAdata if tin(2000m6, 2002m12), generate(casMedMktShrPciaCom) nearest ties(before)


/* ********************************************************** */
/*			BALANCE DE SALDOS									*/
/* ********************************************************** */

// Actualizaciones
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\balance de saldos\mainDB-1994_11-2020_02.dta", update

// Update with failing banks before 2020-02 (18, 60 , 303, 325, 44100).
merge 1:1 IDent FECHAdata using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\balance de saldos\mainDB-1994_11-2020_02.dta", update
// Drop observation for FINANSUR SA (303) which failed in Nov17 rather than Dec17.
drop in 15334 if _merge == 1

// ID 326 MERCOBANK is suspenden on the 5Jan2001
drop in 27573/27575 if IDent == 326
