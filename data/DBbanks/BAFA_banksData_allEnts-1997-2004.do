/* ************************************** */
/* This database takes observations from capital-allEntities-Monthly.dta from 1997 to 2004
The do files are: 
	-CapTotalMen-VarsDef.do 
	-This file.
In this database, the variables that are sums of 'saldo' vars, treted missing values as zero. 
Frequency is monthly (as original data are)

*/
// a COPY OF capital-allEntities-Monthly.dta
// this file */

use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\sources\blce_saldos-1994-11-2004-12.dta" 
// The order of vars is critical for computation of balance sheet vars
order saldo*, after(FECHAcd) sequential
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1997-2004.dta"

// Import missing register from the update balance de saldos
xtsum IDENT
// vars=4896, and N=12084, n=199, T-bar=60.7236

// I import all data and then get rid of unnecesary observations
// CAR_IRR_3A6
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\CarteraIrregular-A9-A10.dta", keepusing(CAR_IRR_3A6) update nogenerate

// ROE
//rename R_ROE R1
//merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Perfomance-Returns-R1.dta", keepusing(R1) nogenerate update 
//rename R1 R_ROE
//label var R_ROE "Perfomance return on equity"

// Loans rate
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Perfomance-LoansRate-R8-R6-T1-T2.dta", keepusing(P_LOANS_ARS_RATE) update nogenerate

// Deposits rate
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Perfomance-DepositsRate-R9-R7-T3.dta", keepusing(P_DEP_ARS_RATE) update nogenerate

// ROA
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Perfomance-ROA-R2-RG1.dta",  keepusing(P_ROA) update nogenerate

// Liquid assets to deposits and net call position
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\Liquidity-LIQ-L1.dta",  keepusing(LA2DEPCALL) update nogenerate

// C8_E (capital ratio as computed by BCRA from indicadores)
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\indicadores\variablesIndividuales\C8_E-1995-2020.dta", keepusing(C8_E) update nogenerate

// A_IMP_NETEAR from Balance Resumido
// Importes a netear por operaciones de pases
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\balanceResumido\impANetear.dta",  keepusing(A_IMP_NETEAR) update nogenerate

// Non-performing loans
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\ESD\ESD_BAFA.dta", keep(master match match_update) keepusing(CAR_IRR_3A6 CAR_IRR_2A6) update nogenerate

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

/**********************************************/
/*			ENTIDADES							*/
/**********************************************/
// ENTIDADES: nombre, mes cierre, grupo
merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\entidades\entidades.dta", keep(master match match_update) keepusing(NOMENT MESCIE grupoIDUni) update

rename MESCIE B_MESCIE
order B_MESCIE, after(FECHAcd)
// Fill forward in time 
sort IDENT FECHAdata
by IDENT: carryforward B_MESCIE, replace
// Fill bakward in time 
gen NEG_FD = -FECHAdata
bysort IDENT (NEG_FD): carryforward B_MESCIE, replace back
drop NEG_FD
sort IDENT FECHAdata

// Grupo homog'eneo de entidad 
// Fill backward that first known type of the bank
gen B_TYPE = grupoIDUni
gen NEG_FD = -FECHAdata
bysort IDE (NEG_FD): carryforward B_TYPE, replace back
drop NEG_FD

/**********************************************/
rename NOMENT B_NAME
gen FD = FECHAdata
label var FD "Copy of FECHAdata for faster typing"
format FD %tm
gen IDE = IDENT
label var IDE "Copy of IDENT for faster typing"

gen FECHAdataMes = month(dofm(FECHAdata))
label var FECHAdataMes "Mes"

gen FQ = qofd(dofm(FECHAdata))
label var FQ "Quarterly date"
format FQ %tq
order FQ, after(FECHAdata)

xtsum IDENT
// vars=4281, and N=31808, n=215, T-bar=147.944
sort IDENT FECHAdata

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

/* ******************************************** */
/* DATA ON ENTITIES */
/* ******************************************** */
// Reimport MESCIE (bMesCierre). It's used to compute monthly results. 
gen IDE = IDENT
label var IDE "A copy of IDENT. Saves typing"
gen FD = FECHAdata
label var FD "A copy of FECHAdata. Saves typing"
format %tm FD

gen FECHAdataMes = month(dofm(FECHAdata)

merge 1:1 IDE FD using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\entidades\MESCIE\entidades_97-06_98-07.dta", keep(master match match_update) keepusing(MESCIE) update
sort IDENT FECHAdata

// Mes cierre (used for computing monthly results variables)
// Fill forward in time
by IDENT: carryforward MESCIE, replace
replace bMesCierre = MESCIE if missing(bMesCierre)
// Fill bakward in time 
gen NEG_FD = -FECHAdata
bysort IDENT (NEG_FD): carryforward bMesCierre, replace back
drop NEG_FD
sort IDENT FECHAdata

// En el balance de saldos a missing en realidad es un saldo de 0.
// If IsMissObs is missing, then the whole observations is missing
egen IsMisObs = rowtotal(saldo*), missing
label var IsMisObs "The sum of all saldo* variables. If missing observation, this variable is missing"
// Now we know which are missing and which not, we assign 0 to the observations that are not true missing but 0s
mvencode saldo* if !missing(IsMisObs), mv(0) override
 
// Each time we use egen now, we must add ,missing (NOT TRUE AFTER MVENCODE BUT IT'S OK)

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace


/* ****************************************** */
/*      COMPUTATION BALANCE SHEET VARS*/
/* ****************************************** */


/* **********************************************************	*/
/*																*/
/*					ACTIVO									*/
/**/
/*	*********************************************************	*/

codebook Activo
// range:-261153, 1.705e+08, missing: 19,724/31,808. mean=2.4e+06, median=255733
drop Activo ActivoN APRestamosARS APRestamosARS APRARSSpNFCap APRARSSFcieroCap APRARSSPrivNFCap APRARSExtCap APRARSCap APRARSSPrivNFAj APRARSAjSobreCap APR_SNoF_ARS
egen Activo = rowtotal(saldo111001-saldo235009), missing 
//  It creates the (row) sum of the variables in varlist, treating missing as 0.  If missing is specified and all values in varlist are missing for an observation, newvar is set to missing.
label var Activo "Activo en miles de pesos nominal"
codebook Activo 

gen ActivoN = Activo - A_IMP_NETEAR
label var ActivoN "Activo neteado de A_IMP_NETEAR"
replace ActivoN = Activo if missing(A_IMP_NETEAR)

gen ActivoN_S = ActivoN/1000000
label var ActivoN_S "Activo in millions (the algorithm fails otherwise)"

//gen ActivoRN = Activo*(100.689987182617/IPC)
//label var ActivoR "Activo en pesos de Septiembre 2009"
//order Activo ActivoN ActivoR, after(IPC)
// PRÉSTAMOS
// ARS
egen APRestamosARS = rowtotal(saldo131108-saldo132301), missing
label var APRestamosARS "APRéstamos en pesos"
egen APRARSSpNFCap = rowtotal(saldo1311*), missing
label var APRARSSpNFCap "APRéstamos ARS SectorPublico NoFciero CAPITALES"
egen APRARSSFcieroCap = rowtotal(saldo1314*), missing
label var APRARSSFcieroCap "APRéstamos ARS SectFciero CAPITALES"
egen APRARSSPrivNFCap = rowtotal(saldo1317*), missing
label var APRARSSPrivNFCap "APRéstamos ARS SectPrivNF CAPITALES"
egen APRARSExtCap = rowtotal(saldo1321*), missing
label var APRARSExtCap "APRéstamos ARS ResidExt CAPITALES"
gen APRARSCap = APRARSSpNFCap+APRARSSFcieroCap+APRARSSPrivNFCap+APRARSExtCap
label var APRARSCap "Préstams en ARS Capitales"

egen APRARSSPrivNFAj = rowtotal(saldo131851-saldo131892), missing
label var APRARSSPrivNFAj "APRéstamos ARS SectPrivNF Ajustes"
gen APRARSAjSobreCap = APRARSSPrivNFAj/APRARSSPrivNFCap
label var APRARSAjSobreCap "ratio de Ajustes sobre Capital SPrivNF"

// Usada para calcular la tasa activa implicita
gen APR_SNoF_ARS = APRARSSpNFCap + APRARSSPrivNFCap + APRARSExtCap
label var APR_SNoF_ARS "Préstamos capitales en ARS al sector no financiero"

// Prest.USD
drop APRestamosUSD-APRestamos

egen APRestamosUSD = rowtotal(saldo135* saldo136*), missing
label var APRestamosUSD "APRéstamos en mda extranjera"
order APRestamosUSD, after(APRARSAjSobreCap)

egen APRUSDSpNFCap = rowtotal(saldo1351*), missing
label var APRUSDSpNFCap "APRéstamos USD SectorPublico NoFciero CAPITALES"
egen APRUSDSFcieroCap = rowtotal(saldo1354*), missing
label var APRUSDSFcieroCap "APRéstamos USD SectFciero CAPITALES"
egen APRUSDSPrivNFCap = rowtotal(saldo1357*), missing
label var APRUSDSPrivNFCap "APRéstamos USD SectPrivNF CAPITALES"
egen APRUSDExtCap = rowtotal(saldo1361*), missing
label var APRUSDExtCap "APRéstamos USD ResidExt CAPITALES"
gen APRUSDCap = APRUSDSpNFCap+APRUSDSFcieroCap+APRUSDSPrivNFCap+APRUSDExtCap
label var APRUSDCap "Préstams en USD Capitales"

gen APRestamos = APRestamosARS + APRestamosUSD
label var APRestamos "Prestamos"

// OtCredXIntFciera
drop APRotCredXIntFcieraARS APRotCredXIntFcieraUSD
egen APRotCredXIntFcieraARS = rowtotal(saldo141101-saldo142429), missing
label var APRotCredXIntFcieraARS "Otros créditos por itnermediación fciera en pesos"
order APRotCredXIntFcieraARS, after(APRUSDCap)

egen APRotCredXIntFcieraUSD = rowtotal(saldo145101-saldo146305), missing
label var APRotCredXIntFcieraUSD "Otros créditos por itnermediación fciera en dolares"
order APRotCredXIntFcieraUSD, after(APRotCredXIntFcieraARS)

// ArrendFcieros
drop APRarrFcierosARS APRarrFcierosUSD APRarrFcierosCapARS APRamplio APRamplioARS APRamplioUSD
egen APRarrFcierosARS = rowtotal(saldo151003-saldo151312), missing
label var APRarrFcierosARS "Arrendamientos fcieros pesos"
order APRarrFcierosARS, after(APRotCredXIntFcieraUSD)

egen APRarrFcierosUSD = rowtotal(saldo155003-saldo155312), missing
label var APRarrFcierosUSD "Arrendamientos fcieros dólares"
order APRarrFcierosUSD, after(APRarrFcierosARS)

egen APRarrFcierosCapARS = rowtotal(saldo151003-saldo151312), missing
label var APRarrFcierosCapARS "Arrendamientos fcieros CAPITAL pesos"
egen APRarrFcierosCapUSD = rowtotal(saldo155003-saldo155312), missing
label var APRarrFcierosCapUSD "Arrendamientos fcieros CAPITAL dólares"

gen APRamplio = APRestamosARS+APRestamosUSD+APRotCredXIntFcieraARS+APRotCredXIntFcieraUSD+APRarrFcierosARS+APRarrFcierosUSD
label var APRamplio "APRéstamos amplio (APRéstamos+OtCredXIntFciera+Arrendamientos)"
order APRamplio, after(APRarrFcierosCapUSD)

gen APRamplioARS = APRestamosARS + APRotCredXIntFcieraARS + APRarrFcierosARS
label var APRamplioARS "APRéstamos amplio ARS (APRéstamos+OtCredXIntFciera+Arrendamientos)"
gen APRamplioUSD = APRestamosUSD + APRotCredXIntFcieraUSD + APRarrFcierosUSD
label var APRamplioUSD "APRéstamos amplio USD (APRéstamos+OtCredXIntFciera+Arrendamientos)"

format APR* %14.0gc
//gen APRamplio1CapARS = APRARSCap + APR

// LIQUIDEZ
drop ALIQs1_1 ALIQs1_1u ALIQs1_1ratio
egen ALIQs1_1 = rowtotal(saldo121002 saldo121003 saldo121015 saldo121017 saldo121018 saldo121019 saldo121021 saldo121022 saldo121023 saldo121024 saldo121025 saldo121026 saldo121027 saldo121028 saldo121029 saldo121031 saldo121034 saldo121035 saldo121037 saldo121039 saldo125002 saldo125003 saldo125008 saldo125018 saldo125019 saldo125020 saldo125021 saldo125022 saldo125023 saldo125031 saldo125035 saldo125036 saldo125037 saldo125038 saldo126003 saldo126010), missing
gen ALIQs1_1ratio = (ALIQs1_1/ActivoN)*100

egen ALIQs1_1u = rowtotal(saldo121002 saldo121003 saldo121015 saldo121017 saldo121018 saldo121019 saldo121021 saldo121022 saldo121023 saldo121024 saldo121025 saldo121026 saldo121027 saldo121028 saldo121029 saldo121031 saldo121034 saldo121035 saldo121037 saldo121039 saldo125002 saldo125003 saldo125008 saldo125018 saldo125019 saldo125020 saldo125021 saldo125022 saldo125023 saldo125031 saldo125035 saldo125036 saldo125037 saldo125038 saldo126003 saldo126010), missing

// PREVISIONES POR INCOBRABILIDAD
drop AprevActAmp0 AprevActAmp1 AprevActPRARS AprevActPRUSD AprevActOtCredXIntFcieraARS AprevActOtCredXIntFcieraUSD AprevActPRratio
egen double AprevActAmp0 = rowtotal(saldo131304 saldo131601 saldo131604 saldo131605 saldo131901 saldo131904 saldo131905 saldo131906 saldo132301 saldo135304 saldo135601 saldo135604 saldo135605 saldo135901 saldo135904 saldo135905 saldo135906 saldo136301 saldo136304 saldo141301 saldo141303 saldo141304 saldo141305 saldo141306 saldo142301 saldo145301 saldo145303 saldo145304 saldo145305 saldo145306 saldo146301 saldo146305 saldo151212 saldo151312 saldo155212 saldo155312 saldo161091 saldo161092 saldo161093 saldo161094 saldo161095 saldo161096 saldo161097 saldo161102 saldo165091 saldo165092), missing
label var AprevActAmp0 "Previsiones Activo Amplia (casi todos los rubros)"

egen double AprevActAmp1 = rowtotal(saldo121012 saldo121112 saldo121123 saldo121124 saldo121125 saldo121126 saldo121127 saldo121131 saldo121132 saldo125012 saldo125112 saldo125124 saldo125126 saldo125127 saldo125128 saldo125132 saldo126012 saldo126113 saldo131304 saldo131601 saldo131604 saldo131605 saldo131901 saldo131904 saldo131905 saldo131906 saldo132301 saldo135304 saldo135601 saldo135604 saldo135605 saldo135901 saldo135904 saldo135905 saldo135906 saldo136301 saldo136304 saldo141301 saldo141303 saldo141304 saldo141305 saldo141306 saldo142301 saldo145301 saldo145303 saldo145304 saldo145305 saldo145306 saldo146301 saldo146305 saldo151212 saldo151312 saldo155212 saldo155312 saldo161091 saldo161092 saldo161093 saldo161094 saldo161095 saldo161096 saldo161097 saldo161102 saldo165091 saldo165092 saldo171301 saldo171302 saldo171303 saldo172301 saldo175301 saldo175302 saldo176301 saldo176302), missing
label var AprevActAmp1 "Previsiones Activo Amplia (todos los rubros)"

egen AprevActPRARS = rowtotal(saldo131304 saldo131601 saldo131604 saldo131605 saldo131901 saldo131904 saldo131905 saldo131906 saldo132301 saldo141301 saldo141303 saldo141304 saldo141305 saldo141306 saldo142301 saldo151312), missing
label var AprevActPRARS "Previsiones por PréstamosAmplio ARS (Prest+OtCredXIntFciera+ArrendFcieros)"

egen AprevActPRUSD = rowtotal(saldo135304 saldo135601 saldo135604 saldo135605 saldo135901 saldo135904 saldo135905 saldo135906 saldo136301 saldo136304 saldo145301 saldo145303 saldo145304 saldo145305 saldo145306 saldo146301 saldo146305 saldo155312), missing
label var AprevActPRUSD "Previsiones por PréstamosAmplio USD (Prest+OtCredXIntFciera+ArrendFcieros)"

egen AprevActOtCredXIntFcieraARS = rowtotal(saldo141301 saldo141303 saldo141304 saldo141305 saldo141306 saldo142301), missing
label var AprevActOtCredXIntFcieraARS "Previsiones por incobrabilidad OtCredXIntFciera en ARS"

egen AprevActOtCredXIntFcieraUSD = rowtotal(saldo145301 saldo145303 saldo145304 saldo145305 saldo145306 saldo146301 saldo146305), missing 
label var AprevActOtCredXIntFcieraUSD "Previsiones por incobrabilidad OtCredXIntFciera en USD"

gen AprevActPRratio = ((-1)*(AprevActPRARS+AprevActPRUSD)/APRamplio)*100
label var AprevActPRratio "Previsiones sobre Préstamos Amplio (%)"

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

/* **********************************************************	*/
/*																*/
/*					PASIVO									*/
/*															*/
/*	*********************************************************	*/
drop Pasivo PdepARS PdepUSD Pdep PdepSPrivNFARS PdepSPrivNFUSD PdepSPrivNF
egen Pasivo = rowtotal(saldo311106-saldo369001), missing
egen PdepARS = rowtotal(saldo311106-saldo312268), missing
label var PdepARS "Pdepósitos en pesos"

egen PdepUSD = rowtotal(saldo315106-saldo316212), missing
label var PdepUSD "Pdepósitos en USD"

gen Pdep = PdepARS+PdepUSD
label var Pdep "Total Pdepósitos (ARS y USD)"

egen PdepSPrivNFARS = rowtotal(saldo311706-saldo312268), missing
label var PdepSPrivNFARS "Pdepósitos en pesos sector Priv. No Fciero"

egen PdepSPrivNFUSD = rowtotal(saldo315706-saldo316212), missing
label var PdepSPrivNFUSD "Pdepósitos en mda. ext. sector priv. no fciero"

gen PdepSPrivNF = PdepSPrivNFARS+PdepSPrivNFUSD
label var PdepSPrivNF "Pdepósitos sector privado no fciero (ARS y USD)"
// DepCap ARS
drop PdepSPubNFARSCap PdepSFcieroARSCap PdepSPrivNFARSCap PdepExtARSCap PdepARSCap
egen PdepSPubNFARSCap = rowtotal(saldo3111*), missing
label var PdepSPubNFARSCap "Depósitos SectorPub ARS CAPITALES"

egen PdepSFcieroARSCap = rowtotal(saldo3114*), missing
label var PdepSFcieroARSCap "Depósitos SectorFciero ARS CAPITALES"

egen PdepSPrivNFARSCap = rowtotal(saldo3117*), missing
label var PdepSPrivNFARSCap "Depósitos SectorPrivNF ARS CAPITALES"

egen PdepExtARSCap = rowtotal(saldo3121*), missing
label var PdepExtARSCap "Depósitos ResidExt ARS CAPITALES"

gen PdepARSCap = PdepSPubNFARSCap+PdepSFcieroARSCap+PdepSPrivNFARSCap+PdepExtARSCap
label var PdepARSCap "Depósitos en ARS Capitales"
// DepCap USD
drop PdepSPubNFUSDCap PdepSFcieroUSDCap PdepSPrivNFUSDCap PdepExtUSDCap PdepUSDCap
egen PdepSPubNFUSDCap = rowtotal(saldo3151*), missing
label var PdepSPubNFUSDCap "Depósitos SecPubNoFciero USD CAPITALES"

egen PdepSFcieroUSDCap = rowtotal(saldo3154*), missing
label var PdepSFcieroUSDCap "Depósitos SecPubFciero USD CAPITALES"

egen PdepSPrivNFUSDCap = rowtotal(saldo3157*), missing
label var PdepSPrivNFUSDCap "Depósitos SecPrivNoFciero USD CAPITALES"

egen PdepExtUSDCap = rowtotal(saldo316*), missing
label var PdepExtUSDCap "Depósitos ResidExt USD CAPITALES"

gen PdepUSDCap = PdepSPubNFUSDCap+PdepSFcieroUSDCap+PdepSPrivNFUSDCap+PdepExtUSDCap
label var PdepUSDCap "Depósitos en USD Capitales"

drop PdepVista PdepVistaDEP
egen PdepVista = rowtotal(saldo311113 saldo311118 saldo311121 saldo311123 saldo311124 saldo311142 saldo311171 saldo311172 saldo311413 saldo311423 saldo311424 saldo311718 saldo311721 saldo311722 saldo311723 saldo311724 saldo311725 saldo311726 saldo311771 saldo311772 saldo311773 saldo312118 saldo312121 saldo312123 saldo312124 saldo312172 saldo312173 saldo315107 saldo315113 saldo315118 saldo315123 saldo315124 saldo315404 saldo315407 saldo315413 saldo315423 saldo315424 saldo315707 saldo315718 saldo315723 saldo315724 saldo315725 saldo316104 saldo316107 saldo316118 saldo316123 saldo316124), missing
label var PdepVista "Dep. Vista"
gen PdepVistaDEP = (PdepVista/Pdep)*100
label var PdepVistaDEP "Dep. Vista sobre DEPÓSITOS (%)"

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

/* *********************************************	*/
//	PATRIMONIO NETO
/* *********************************************	*/

drop PN PNcapSocial PNapoNoCap PNajPatr PNreservUtil PNresultNoAsig PNdifValNoReali PNtotal

egen PN = rowtotal(saldo4*), missing
format PN* %14.0gc

egen PNcapSocial = rowtotal(saldo410003-saldo410012), missing
label var PNcapSocial "PN Capital social"
egen PNapoNoCap = rowtotal(saldo420003-saldo420009), missing
label var PNapoNoCap "PN Aportes no capitalizados"
egen PNajPatr = rowtotal(saldo430015-saldo430026), missing
label var PNajPatr "PN-Ajustres al patrimonio"
egen PNreservUtil = rowtotal(saldo440003-saldo440013), missing
label var PNreservUtil "PN-Reserva de utilidades"
egen PNdifValNoReali = rowtotal(saldo470003-saldo470005), missing
label var PNdifValNoReali "PN-Diferencia valuación no realizada"

/* *********************************************	*/
// RESULTADOS ejercicio en curso
/* *********************************************	*/

drop RnetoDspImpMon RingFcieros RegrFcieros RcargoIncob RingServ RegrServ  RgasAdmn RutilDiversas RperdDiversas RresultExt RiGcias RresultMon
// Éste coincide con "Resultados Acumuados" IEF PDF
egen RnetoDspImpMon = rowtotal(saldo511002-saldo640003), missing 
egen RingFcieros = rowtotal(saldo511002-saldo515087), missing
egen RegrFcieros = rowtotal(saldo521001-saldo525089), missing
egen RcargoIncob = rowtotal(saldo531003-saldo535003), missing
egen RingServ = rowtotal(saldo541003-saldo545018), missing
egen RegrServ = rowtotal(saldo551003-saldo555018), missing
egen RgasAdmn = rowtotal(saldo560003-saldo560058), missing
egen RutilDiversas = rowtotal(saldo570003-saldo570045), missing
egen RperdDiversas = rowtotal(saldo580003-saldo580045), missing
egen RresultExt = rowtotal(saldo590001-saldo590015), missing
gen RiGcias = saldo610003
egen RresultMon = rowtotal(saldo620003-saldo640003), missing
label var RresultMon "Resultado monetario acumulado desde FCE"
format RingFcieros-RresultMon %14.0gc

egen PNresultNoAsig = rowtotal(saldo450003-saldo450006 RnetoDspImpMon), missing
label var PNresultNoAsig "PN-Resultados no asignados (incluye resultado en curso)"
gen PNtotal = PNcapSocial+PNapoNoCap+PNajPatr+PNreservUtil+PNresultNoAsig+PNdifValNoReali
label var PNtotal "Patrimonio Neto CON resultado en curso"
order PN PNcapSocial PNapoNoCap PNajPatr PNreservUtil PNresultNoAsig PNdifValNoReali PNtotal PNtotal, after(PdepVistaDEP)

order RnetoDspImpMon-RresultMon, after(PNtotal)

// Cambio el signo a positivo por ganancia y negativo una perdida
foreach varNom of varlist PN-RresultMon {
	replace `varNom' = `varNom'*(-1)
}

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

/* *********************************************	*/
// RESULTADOS MENSUALES cuentas contables
/* *********************************************	*/
// Para cada variable de resultado calculo el dato mensual en función si la fecha de cierre es dic o jun. La primer observación para cada banco es valor perdido (no se puede calcular)
sort IDENT FECHAdata
foreach varname of varlist saldo511002-saldo640003 {
	//drop `varname'M
	by IDENT: gen `varname'M = (`varname' - L1.`varname') if (FECHAdataMes != 1 & B_MESCIE == 12)
	format `varname'M %14.0gc
	local etiqueta: variable label `varname'
	label variable `varname'M "`etiqueta' (mensual)"
	by IDENT: replace `varname'M = `varname' if (FECHAdataMes == 1 & B_MESCIE == 12)
	// Cierre en Mes 6
	by IDENT: replace `varname'M = (`varname' - L1.`varname') if (FECHAdataMes != 7 & B_MESCIE == 6)
	by IDENT: replace `varname'M = `varname' if (FECHAdataMes == 7 & B_MESCIE == 6)
}
// Comprobación
foreach varname of varlist saldo511002-saldo640003 {
	display `varname'
	by IDENT: gen CTRL`varname' = `varname' - (`varname'M+ L1.`varname'M+ L2.`varname'M+ L3.`varname'M+ L4.`varname'M+ L5.`varname'M+ L6.`varname'M+ L7.`varname'M+ L8.`varname'M+ L9.`varname'M+ L10.`varname'M+ L11.`varname'M) if (FECHAdataMes == 12 & B_MESCIE == 12)
	by IDENT: replace CTRL`varname' = `varname' - (`varname'M+ L1.`varname'M+ L2.`varname'M+ L3.`varname'M+ L4.`varname'M+ L5.`varname'M+ L6.`varname'M+ L7.`varname'M+ L8.`varname'M+ L9.`varname'M+ L10.`varname'M+ L11.`varname'M) if (FECHAdataMes == 6 & B_MESCIE == 6)
}

summarize CTRLsaldo511002-CTRLsaldo640003
drop CTRL*

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

//
// RESULTADOS MENSUALES COMPONENTES
//

drop RnetoDspImpMonM RingFcierosM RegrFcierosM RcargoIncobM RingServM RegrServM  RgasAdmnM RutilDiversasM RperdDiversasM RresultExtM RiGciasM RresultMonM

egen RnetoDspImpMonM = rowtotal(saldo511002M-saldo640003M), missing 
label var RnetoDspImpMon "Resultados ACUMULADOS desde FCE"
egen RingFcierosM = rowtotal(saldo511002M-saldo515087M), missing
egen RegrFcierosM = rowtotal(saldo521001M-saldo525089M), missing
label var RegrFcierosM "Result. Egresos Fcieros MENSUAL"
egen RcargoIncobM = rowtotal(saldo531003M-saldo535003M), missing
label var RcargoIncobM "Cargo X incobrabilidad MENSUAL"
egen RingServM = rowtotal(saldo541003M-saldo545018M), missing
label var RingServM "Ingresos X servicios MENSUAL"
egen RegrServM = rowtotal(saldo551003M-saldo555018M), missing
label var RegrServM "Egresos X servicios MENSUAL"
egen RgasAdmnM = rowtotal(saldo560003M-saldo560058M), missing
label var RgasAdmnM "Gastos de administración MENSUAL"
egen RutilDiversasM = rowtotal(saldo570003M-saldo570045M), missing
label var RutilDiversasM "Utilidades diversas MENSUAL"
egen RperdDiversasM = rowtotal(saldo580003M-saldo580045M), missing
label var RperdDiversasM "Pérdidas diversas MENSUAL"
egen RresultExtM = rowtotal(saldo590001M-saldo590015M), missing
label var RresultExtM "Resultado filiales exterior MENSUAL"
gen RiGciasM = saldo610003M
label var RiGciasM "Impuesto a las Gcias MENSUAL"
egen RresultMonM = rowtotal(saldo620003M-saldo640003M), missing
label var RresultMonM "Resultado Monetario MENSUAL"

format RnetoDspImpMonM-RresultMonM %14.0gc
foreach varNom of varlist RnetoDspImpMonM-RresultMonM {
replace `varNom' = `varNom'*(-1)
}

order saldo511002M-saldo640003M, after(saldo640003)
order RnetoDspImpMonM-RresultMonM, after(PNtotal)

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

/* ********************************* 		*/
/*		 TASAS DE INTERÉS IMPLÍCITAS 		*/
/* ********************************* 		*/

//////////////////////////////////
// PR'ESTAMOS
//////////////////////////////////
drop RintGanaARS0 RintGanaUSD0 R_INGFCIERO_AJ_ARS RtasaIntPR_ARS_TNA
// Emula el indicador del BCRA que solo considera prestamos al sector NO financiero. No incluye ajustes ni amortizaciones, resultados, ni prestamos al sector finaciero. 
egen double RintGanaARS0 = rowtotal(saldo511003M  saldo511008M saldo511013M saldo511015M  saldo511018M saldo511047M saldo511048M saldo511049M saldo511050M saldo511051M saldo511052M saldo511053M saldo511054M saldo511055M saldo511060M saldo511061M saldo511064M), missing
replace RintGanaARS0 = RintGanaARS0 * (-1)
label var RintGanaARS0 "Intereses ganados mensuales X Prest.yArrend. ARS (sin OtCredXIntFciera)"

egen double R_INGFCIERO_AJ_ARS = rowtotal(saldo511016M saldo511018M saldo511020M saldo511071M saldo511072M saldo511073M saldo511074M saldo511075M saldo511076M saldo511077M saldo511085M saldo511088M saldo511089M), missing
replace R_INGFCIERO_AJ_ARS = R_INGFCIERO_AJ_ARS * (-1)
label var R_INGFCIERO_AJ_ARS "Ingresos financieros mensuales por ajustes en prestamos al sector NO fciero"
// No incluye ingresos fcieros por resultados ni intereses

egen double RintGanaUSD0 = rowtotal(saldo515003M saldo515006M saldo515015M  saldo515018M  saldo515047M saldo515048M saldo515049M saldo515050M saldo515051M saldo515052M saldo515053M saldo515054M  saldo515060M saldo515064M saldo515070M saldo515107M ), missing
replace RintGanaUSD0 = RintGanaUSD0 * (-1)
label var RintGanaUSD0 "Intereses ganados mensuales por Prest.yArrend. USD (sin OtCredXIntFciera)"

// Intereses ganados sobre Préstamos (no incluye Arrendamientos Financieros)
// la idea es imitar el indicador del BCRA, ver BCRA_2001_12_Aclaraciones.rtf 
sort IDENT FECHAdata
by IDENT: gen RtasaIntPR_ARS_TNA = ((RintGanaARS0 /  ((L1.APR_SNoF_ARS+APR_SNoF_ARS)/2)) *100)*12
label var RtasaIntPR_ARS_TNA "Tasa de interés implícita anualizada (desde la mensual) X Prest ARS %"

// I think its better to use the TNA one since it is the the Central Bank used. 
//gen RtasaIntPR_ARS_L = ln( 1+(RtasaIntPR_ARS/100))
//label var RtasaIntPR_ARS_L "Ln de la tasa bruta mensual. Para calcular la TEA como suma de tasas mensuales"

//by IDENT: gen RtasaIntPR_ARS_TEA = ( exp( L1.RtasaIntPR_ARS_L + L2.RtasaIntPR_ARS_L + L3.RtasaIntPR_ARS_L + L4.RtasaIntPR_ARS_L + L5.RtasaIntPR_ARS_L + L6.RtasaIntPR_ARS_L + L7.RtasaIntPR_ARS_L + L8.RtasaIntPR_ARS_L + L9.RtasaIntPR_ARS_L + L10.RtasaIntPR_ARS_L + L11.RtasaIntPR_ARS_L + L12.RtasaIntPR_ARS_L) - 1)*100
//label var RtasaIntPR_ARS_TEA "TEA implícita por préstamos en ARS ultimos 12 meses"
order  RtasaIntPR_ARS_TNA  , after(RintGanaUSD0)
///////////////////////////
// PRESTAMOS EN USD
drop APR_CREDITOS_USD RtasaIntPR_USD_TNA RtasaIntPR_USD_L RtasaIntPR_USD_TEA

gen APR_CREDITOS_USD = APRestamosUSD + APRarrFcierosUSD
label var APR_CREDITOS_USD "Capital préstamos en USD"
format %12.0gc APR_CREDITOS_USD

by IDENT: gen RtasaIntPR_USD_TNA = (RintGanaUSD0 / ((L1.APR_CREDITOS_USD + APR_CREDITOS_USD)/2) )*100*12
label var RtasaIntPR_USD_TNA "Tasa de interés mensual implícita X Prest.yArrend USD %"

// TEA
/*
gen RtasaIntPR_USD_L = ln( 1+(RtasaIntPR_USD/100))
label var RtasaIntPR_USD_L "Ln de la tasa bruta mensual. Para calcular la TEA como suma de tasas mensuales"

by IDENT: gen RtasaIntPR_USD_TEA = ( exp( L1.RtasaIntPR_USD_L + L2.RtasaIntPR_USD_L + L3.RtasaIntPR_USD_L + L4.RtasaIntPR_USD_L + L5.RtasaIntPR_USD_L + L6.RtasaIntPR_USD_L + L7.RtasaIntPR_USD_L + L8.RtasaIntPR_USD_L + L9.RtasaIntPR_USD_L + L10.RtasaIntPR_USD_L + L11.RtasaIntPR_USD_L + L12.RtasaIntPR_USD_L) - 1)*100
label var RtasaIntPR_USD_TEA "TEA implícita por préstamos en USD ultimos 12 meses"
*/
//order APR_CREDITOS_USD  RtasaIntPR_USD_TNA  , after(RtasaIntPR_ARS_TEA)
/*
by IDENT: gen RtasaIntPR_ARSReal = ( (RtasaIntPR_ARS - IPCxMom)/(100 + IPCxMom) )*100
label var RtasaIntPR_ARSReal "Tasa de interés implícita X Prest.yArrend ARS REAL %"
*/

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

//////////////////////////////////
// DEP'OSITOS
//////////////////////////////////

//////////////////////////////////////////////////////
// INTERESES POR DEPÓSITOS
// No incluye dep'ositos de Oblgiaciones por intermediaci'on financiera, obligaciones subordinadas ni ajustes al capital.
drop RintPagDep_ARS RintPagDep_USD RintPagDep_AJ_ARS

egen double RintPagDep_ARS = rowtotal(saldo521003M 	saldo521005M 	saldo521010M 	saldo521013M 	saldo521062M 	saldo521063M 	saldo521064M 	saldo521065M 	saldo521082M)
label var RintPagDep_ARS "Intereses pagados por todos depósitos en ARS"

egen double RintPagDep_USD = rowtotal(saldo525002M 	saldo525003M 	saldo525015M 	saldo525062M 	saldo525063M 	saldo525064M 	saldo525065M )
label var RintPagDep_USD "Intereses pagados por todos depósitos en USD"
 
// Con ajustes al capital
gen double RintPagDep_AJ_ARS = RintPagDep_ARS + saldo521006M + saldo521016M + saldo521071M + saldo521075M + saldo521080M + saldo521081M + saldo521083M + saldo521092M + saldo521093M
label var RintPagDep_AJ_ARS "Intereses pagados por todos depósitos en ARS incluyendo ajustes de capital"

format %12.0gc Rint*
format %12.0gc Pdep*

//////////////////////////////////////////////////////
// TASA DE INTERES POR DEPÓSITOS

drop P_DEPARS_I_TNA P_DEPUSD_I_TNA P_DEPARS_IK_TNA P_DEPUSD_IK_TNA
// Las variables que solo contienen capitales en el denominador son mas cercanas al valor en el Informe 2001-07.
by IDENT: gen P_DEPARS_I_TNA = ((RintPagDep_ARS / ( ((-1)*(L1.PdepARS + PdepARS))/2) )*100)*12
label var P_DEPARS_I_TNA "Tasa implícita por depósitos en pesos anualizada (%)"

by IDENT: gen P_DEPUSD_I_TNA = ((RintPagDep_USD / ( ((-1)*(L1.PdepUSD + PdepUSD))/2) )*100)*12
label var P_DEPUSD_I_TNA "Tasa implícita por depósitos en USD anualizada (%)"
// Solo capitales
by IDENT: gen P_DEPARS_IK_TNA = ((RintPagDep_ARS / ( ((-1)*(L1.PdepARSCap + PdepARSCap))/2) )*100)*12
label var P_DEPARS_IK_TNA "Tasa implícita por depósitos en pesos anualizada (%) solo capitales"

by IDENT: gen P_DEPUSD_IK_TNA = ((RintPagDep_USD / ( ((-1)*(L1.PdepUSDCap + PdepUSDCap))/2) )*100)*12
label var P_DEPUSD_IK_TNA "Tasa implícita por depósitos en USD anualizada (%) solo capitales"

//bysort FECHAdata: mdesc P_DEPARS_IK_TNA P_DEPUSD_IK_TNA
tabulate FECHAdata if missing(RtasaIntPR_ARS_TNA) & !missing(P_LOANS_ARS_RATE)

table FD, contents(mean P_DEPARS_IK_TNA min P_DEPARS_IK_TNA max P_DEPARS_IK_TNA freq )
// Bankruptcies

gen sinRatioM =  (saldo580031M/ALIQs1_1)*100

/* ****************************************** */
/*      COMPUTATION BALANCE SHEET VARS*/
/* ****************************************** */

/* **********************************************************	*/
/*					INDICADORES computables from balance sheet data			*/
/*	*********************************************************	*/
// Capital ratio
drop C8Est C8Est_w
gen C8Est = (PNtotal/ActivoN)*100
// I don't think winsorization is needed since then we take quarterly averages
//winsor2 C8Est , cuts(1 99)
//label variable C8Est_w "PNTotal/Activo * 100 winsorized at 99%"
order C8Est, after(C8_E)

// ROA Return on assets (%), trailing 12 months
sort IDENT FECHAdata
by IDENT: gen P_ROA_EST = ( (L11.RnetoDspImpMonM + L10.RnetoDspImpMonM + L9.RnetoDspImpMonM + L8.RnetoDspImpMonM + L7.RnetoDspImpMonM + L6.RnetoDspImpMonM + L5.RnetoDspImpMonM + L4.RnetoDspImpMonM + L3.RnetoDspImpMonM + L2.RnetoDspImpMonM + L1.RnetoDspImpMonM + RnetoDspImpMonM) / ((1/12)*((L1.ActivoN + L2.ActivoN + L3.ActivoN + L4.ActivoN + L5.ActivoN + L6.ActivoN + L7.ActivoN + L8.ActivoN + L9.ActivoN + L10.ActivoN + L11.ActivoN + L12.ActivoN))) )*100
label var P_ROA_EST "Return on assets last 12-months (nominal(=effective) annual rate %)"
order P_ROA_EST, after(P_ROA)

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

/* OTHER VARS */
gen APRSpNF_RATE = ((APRARSSpNFCap + APRUSDSpNFCap)/ (APRestamosARS+APRestamosUSD))*100
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
label variable APR_RATE_W "Loans to Activo winsorized at 1-99"


/* *********************************************** */
/* 				 LOANS_RATE 						 */
/* *********************************************** */

/* *********** P_LOANS_ARS_RATE (from indicadores) */
winsor2 P_LOANS_ARS_RATE , cuts(1 99) suffix(_W)
order P_LOANS_ARS_RATE_W, after(P_LOANS_ARS_RATE)
label variable P_LOANS_ARS_RATE_W "Loans interest rate (%) winsorized at 1-99"

gen P_LOANS_ARS_RATE_SI = RtasaIntPR_ARS_TNA
label variable P_LOANS_ARS_RATE_SI "Nominal annual rate for loans % mainly for Statements of Results"
// Replace missing values from Indicatores vars 
replace P_LOANS_ARS_RATE_SI = P_LOANS_ARS_RATE if missing(RtasaIntPR_ARS_TNA) & !missing(P_LOANS_ARS_RATE) 

tabulate FECHAdata if missing(RtasaIntPR_ARS_TNA) & !missing(P_LOANS_ARS_RATE)
mean P_LOANS_ARS_RATE_SI, over(FECHAdata)

// For some banks, say, SAN MIGUEL DE TUCUMAN (IDE 327) the reported indicator looks better than the data from Staement of Results.
// The following var prefers this variable excep for 2000m12 to 2001m12
gen P_LOANS_ARS_RATE_IS = P_LOANS_ARS_RATE
label variable P_LOANS_ARS_RATE_IS "Nominal annual rate for loans % mainly from indicator"
// Replace missing values from Indicatores vars only outisde 2000m12-2001m12
replace P_LOANS_ARS_RATE_IS = RtasaIntPR_ARS_TNA if missing(P_LOANS_ARS_RATE) & !missing(RtasaIntPR_ARS_TNA) 

mean P_LOANS_ARS_RATE_IS, over(FECHAdata)
tabulate FECHAdata tabulate FECHAdata if missing(RtasaIntPR_ARS_TNA) & !missing(P_LOANS_ARS_RATE)

xtsum FD IDE
//  N=31808, n=215, T-bar=147.944. mean IDE=897834

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace

/* *********************************************** */
/* **************** NON-PERFORMING LOANS (ESD, CAR_IRR_*) ********************
/* *********************************************** */

merge 1:1 FECHAdata IDENT using "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\ESD\ESD_BAFA.dta", keep(master match match_update) keepusing(CAR_IRR_3A6 CAR_IRR_2A6) update

/* *********************************************** */
/* **************** RETURN ON ASSETS ********************
/* *********************************************** */

// Compute ROA in the last 6-month to avoid missing values at the beginning of the sample 
// Return on assets (%), trailing 6 months

by IDENT: gen P_ROA_EST6 = ( (L5.RnetoDspImpMonM + L4.RnetoDspImpMonM + L3.RnetoDspImpMonM + L2.RnetoDspImpMonM + L1.RnetoDspImpMonM + RnetoDspImpMonM) / ((1/6)*((L1.ActivoN + L2.ActivoN + L3.ActivoN + L4.ActivoN + L5.ActivoN + L6.ActivoN))) )*100*2
label var P_ROA_EST6 "Return on assets last 6-months ( TNA %)"
order P_ROA_EST6, after(P_ROA_EST_PC)

// Replace missing values of P_ROA (from indicadores) with an estimate from balance sheet data if missing.
gen P_ROA_E1 = P_ROA
replace P_ROA_E1 = P_ROA_EST if missing(P_ROA_E1)
// If still missing, we use the last 6-month data instead of the original 12-month
replace P_ROA_E1 = P_ROA_EST6 if missing(P_ROA_E1)

/* *********************************************** */
/* 					ROA								*/
/* *********************************************** */

// Compute ROA in the last 6-month to avoid missing values at the beginning of the sample 
// Return on assets (%), trailing 6 months

sort IDENT FECHAdata
by IDENT: gen P_ROA_EST6 = ( (L5.RnetoDspImpMonM + L4.RnetoDspImpMonM + L3.RnetoDspImpMonM + L2.RnetoDspImpMonM + L1.RnetoDspImpMonM + RnetoDspImpMonM) / ((1/6)*((L1.ActivoN + L2.ActivoN + L3.ActivoN + L4.ActivoN + L5.ActivoN + L6.ActivoN))) )*100*2
label var P_ROA_EST6 "Return on assets last 6-months ( TNA %)"
order P_ROA_EST6, after(P_ROA_EST)

// Replace missing values of P_ROA (from indicadores) with an estimate from balance sheet data if missing.
gen P_ROA_E1 = P_ROA
replace P_ROA_E1 = P_ROA_EST if missing(P_ROA_E1)
// If still missing, we use the last 6-month data instead of the original 12-month
replace P_ROA_E1 = P_ROA_EST6 if missing(P_ROA_E1)

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1994-2020.dta", replace


/* ****************************************** */
/*              FILTERING 					*/
/* ****************************************** */

drop if IDENT > 99999
//(4,230 obs deleted)
//There are still 8 obs which do not match
drop if FECHAdata<ym(1996,12)
drop if FECHAdata > ym(2004,12)

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1997-2004.dta", replace

// ActivoN is equal to Activo when A_IMP_NETEAR is missing. Also, some entities only report data quarterly so there are missing values for some months, ex; IDENT 65201
drop if missing(ActivoN)

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\BAFA_banksData_monthly_1997-2004.dta", replace
