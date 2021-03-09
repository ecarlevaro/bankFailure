ORDEN VARIABLES 

// display list of variables and return the list in r(varlist)
ds 
// store the list in local macro order
local varOrder `r(varlist)' 
order `varOrder'


/* **************************** */
/* 	MISSING OR ZERO?				*/
/* **************************** */
// An observation could be missing due to the bank did not report (or we don't have access to) that data or because the balance for that account was zero.  
// Banks do not report the balance for accounts that are zero. We set to 0 these 'missing' values.
if missing for all saldo* vars then it is missing
if one or more saldo* vars are not missing, then put 0 for all 'missing' saldo* vars

egen missing = rowtotal(saldo*), missing
label var missing "The sum of all saldo* variables. If missing observation, this variable is missing"
// Now we know which are missing and which not, we assign 0 to the 'missing' observations of saldo* variables 
mvencode saldo* if !missing(missing), mv(0)
replace saldo* = 0 
// Each time we use egen now, we must add ,missing

/* **********************************************************	*/
/*																*/
/*					ACTIVO									*/
/*
/*	*********************************************************	*/
drop Activo
egen Activo = rowtotal(saldo111001-saldo235009) ,missing
gen ActivoR = Activo*(100.689987182617/IPC)
label var ActivoR "Activo en pesos de Septiembre 2009"
// PRÉSTAMOS
// ARS
drop APRestamosARS
egen APRestamosARS = rowtotal(saldo131108-saldo132301), missing
label var APRestamosARS "APRéstamos en pesos"
order APRestamosARS, after(ALIQs1_1ratio)

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
// Prest.USD
drop APRestamosARS
egen APRestamosARS = rowtotal(saldo131108-saldo132301), missing
label var APRestamosARS "APRéstamos en pesos"
order APRestamosARS, after(ALIQs1_1ratio)
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
// OtCredXIntFciera
drop APRotCredXIntFcieraARS
egen APRotCredXIntFcieraARS = rowtotal(saldo141101-saldo142429), missing
label var APRotCredXIntFcieraARS "Otros créditos por itnermediación fciera en pesos"
order APRotCredXIntFcieraARS, after(APRUSDCap)

drop APRotCredXIntFcieraUSD
egen APRotCredXIntFcieraUSD = rowtotal(saldo145101-saldo146305), missing
label var APRotCredXIntFcieraUSD "Otros créditos por itnermediación fciera en dolares"
order APRotCredXIntFcieraUSD, after(APRotCredXIntFcieraARS)

// ArrendFcieros
drop APRarrFcierosARS
egen APRarrFcierosARS = rowtotal(saldo151003-saldo151312), missing
label var APRarrFcierosARS "Arrendamientos fcieros pesos"
order APRarrFcierosARS, after(APRotCredXIntFcieraUSD)

drop APRarrFcierosUSD
egen APRarrFcierosUSD = rowtotal(saldo155003-saldo155312), missing
label var APRarrFcierosUSD "Arrendamientos fcieros dólares"
order APRarrFcierosUSD, after(APRarrFcierosARS)

egen APRarrFcierosCapARS = rowtotal(saldo151003-saldo151312), missing
label var APRarrFcierosCapARS "Arrendamientos fcieros CAPITAL pesos"
egen APRarrFcierosCapUSD = rowtotal(saldo155003-saldo155312), missing
label var APRarrFcierosCapUSD "Arrendamientos fcieros CAPITAL dólares"

drop APRamplio
gen APRamplio = APRestamosARS+APRestamosUSD+APRotCredXIntFcieraARS+APRotCredXIntFcieraUSD+APRarrFcierosARS+APRarrFcierosUSD
label var APRamplio "APRéstamos amplio (APRéstamos+OtCredXIntFciera+Arrendamientos)"
order APRamplio, after(APRarrFcierosCapUSD)

gen APRamplioARS = APRestamosARS + APRotCredXIntFcieraARS + APRarrFcierosARS
label var APRamplioARS "APRéstamos amplio ARS (APRéstamos+OtCredXIntFciera+Arrendamientos)"
gen APRamplioUSD = APRestamosUSD + APRotCredXIntFcieraUSD + APRarrFcierosUSD
label var APRamplioUSD "APRéstamos amplio USD (APRéstamos+OtCredXIntFciera+Arrendamientos)"

//gen APRamplio1CapARS = APRARSCap + APR

// LIQUIDEZ
egen ALIQs1_1 = rowtotal(saldo121002 saldo121003 saldo121015 saldo121017 saldo121018 saldo121019 saldo121021 saldo121022 saldo121023 saldo121024 saldo121025 saldo121026 saldo121027 saldo121028 saldo121029 saldo121031 saldo121034 saldo121035 saldo121037 saldo121039 saldo125002 saldo125003 saldo125008 saldo125018 saldo125019 saldo125020 saldo125021 saldo125022 saldo125023 saldo125031 saldo125035 saldo125036 saldo125037 saldo125038 saldo126003 saldo126010), missing
gen ALIQs1_1ratio = (ALIQs1_1/Activo)*100

egen ALIQs1_1u =  = rowtotal(saldo121002 saldo121003 saldo121015 saldo121017 saldo121018 saldo121019 saldo121021 saldo121022 saldo121023 saldo121024 saldo121025 saldo121026 saldo121027 saldo121028 saldo121029 saldo121031 saldo121034 saldo121035 saldo121037 saldo121039 saldo125002 saldo125003 saldo125008 saldo125018 saldo125019 saldo125020 saldo125021 saldo125022 saldo125023 saldo125031 saldo125035 saldo125036 saldo125037 saldo125038 saldo126003 saldo126010), missing

// PREVISIONES POR INCOBRABILIDAD
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

/* **********************************************************	*/
/*																*/
/*					PASIVO									*/
/*
/*	*********************************************************	*/
egen Pasivo = rowtotal(saldo311106-saldo366229), missing
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

egen PdepVista = rowtotal(saldo311113 saldo311118 saldo311121 saldo311123 saldo311124 saldo311142 saldo311171 saldo311172 saldo311413 saldo311423 saldo311424 saldo311718 saldo311721 saldo311722 saldo311723 saldo311724 saldo311725 saldo311726 saldo311771 saldo311772 saldo311773 saldo312118 saldo312121 saldo312123 saldo312124 saldo312172 saldo312173 saldo315107 saldo315113 saldo315118 saldo315123 saldo315124 saldo315404 saldo315407 saldo315413 saldo315423 saldo315424 saldo315707 saldo315718 saldo315723 saldo315724 saldo315725 saldo316104 saldo316107 saldo316118 saldo316123 saldo316124), missing
label var PdepVista "Dep. Vista"
gen PdepVistaDEP = (PdepVista/Pdep)*100
label var PdepVistaDEP "Dep. Vista sobre DEPÓSITOS (%)"

/* **********************************************************	*/
/*																*/
/*					PATRIMONIO NETO 									*/
/*
/*	*********************************************************	*/

egen PNcapSocial = rowtotal(saldo410003-saldo410012), missing
label var PNcapSocial "PN Capital social"
egen PNapoNoCap = rowtotal(saldo420003-saldo420009), missing
label var PNapoNoCap "PN Aportes no capitalizados"
egen PNajPatr = rowtotal(saldo430015-saldo430026), missing
label var PNajPatr "PN-Ajustres al patrimonio"
egen PNresrvUtil = rowtotal(saldo440003-saldo440013), missing
label var PNreservUtil "PN-Reserva de utilidades"
egen PNresultNoAsig = rowtotal(saldo450003-saldo450006 RnetoDspImpMon), missing
label var PNresultNoAsig "PN-Resultados no asignados (incluye resultado en curso)"
egen PNdifValNoReali = rowtotal(saldo470003-saldo470005), missing
label var PNdifValNoReali "PN-Diferencia valuación no realizada"

gen PNtotal = PNcapSocial+PNapoNoCap+PNajPatr+PNreservUtil+PNresultNoAsig+PNdifValNoReali
label var PNtotal "Patrimonio Neto CON resultado en curso"
order PNtotal, after(PN)
format PN* %14.0gc
foreach varNom of varlist PNcapSocial-PNtotal {
	replace `varNom' = `varNom'*(-1)
}

/* **********************************************************	*/
/*																*/
/*					RESULTADOS 									*/
/*
/*	*********************************************************	*/
//
// RESULTADOS ACUMULADOS
//
egen RnetoDspImpMon = rowtotal(saldo511002-saldo640003), missing // Éste coincide con "Resultados Acumuados" IEF PDF
label var RnetoDspImpMon "Resultados ACUMULADOS desde FCE"
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
format RingFcieros-RresultMon %14.0gc
foreach varNom of varlist RnetoDspImpMon-RresultMon {
	replace `varNom' = `varNom'*(-1)
}


//
// RESULTADOS MENSUALES cuentas contables
//
// Para cada variable de resultado calculo el dato mensual en función si la fecha de cierre es dic o jun. La primer observación para cada banco es valor perdido (no se puede calcular)
foreach varname of varlist saldo511002-saldo640003 {
	drop `varname'M
	by IDent: gen `varname'M = (`varname' - L1.`varname') if (FECHAdataMes != 1 & bMesCierre == 12)
	format `varname'M %14.0gc
	local etiqueta: variable label `varname'
	label variable `varname'M "`etiqueta' (mensual)"
	by IDent: replace `varname'M = `varname' if (FECHAdataMes == 1 & bMesCierre == 12)
	// Cierre en Mes 6
	by IDent: replace `varname'M = (`varname' - L1.`varname') if (FECHAdataMes != 7 & bMesCierre == 6)
	by IDent: replace `varname'M = `varname' if (FECHAdataMes == 7 & bMesCierre == 6)
}
// Comprobación
foreach varname of varlist saldo511002-saldo640003 {
	display `varname'
	by IDent: gen CTRL`varname' = `varname' - (`varname'M+ L1.`varname'M+ L2.`varname'M+ L3.`varname'M+ L4.`varname'M+ L5.`varname'M+ L6.`varname'M+ L7.`varname'M+ L8.`varname'M+ L9.`varname'M+ L10.`varname'M+ L11.`varname'M) if (FECHAdataMes == 12 & bMesCierre == 12)
	by IDent: replace CTRL`varname' = `varname' - (`varname'M+ L1.`varname'M+ L2.`varname'M+ L3.`varname'M+ L4.`varname'M+ L5.`varname'M+ L6.`varname'M+ L7.`varname'M+ L8.`varname'M+ L9.`varname'M+ L10.`varname'M+ L11.`varname'M) if (FECHAdataMes == 6 & bMesCierre == 6)
}
//
// RESULTADOS MENSUALES COMPONENTES
//
egen RnetoDspImpMonM = rowtotal(saldo511002M-saldo640003M), missing 
label var RnetoDspImpMonM "Result. Neto Dsp. ImpGcias y Result.Monetario MENSUAL"
egen RingFcierosM = rowtotal(saldo511002M-saldo515087M), missing
label var RingFcierosM "Result. Ing. Fcieros MENSUAL"
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
label var RresultMon "Resultado Monetario MENSUAL"
format RingFcierosM-RresultMonM %14.0gc
foreach varNom of varlist RnetoDspImpMonM-RresultMonM {
replace `varNom' = `varNom'*(-1)
}

order saldo511002M-saldo640003M, after(saldo640003)
order RnetoDspImpMonM-RresultMonM, after(cambioFCE)

// TASA DE INTERÉS IMPLÍCITA
egen double RintGanaARS0 = rowtotal(saldo511003M saldo511004M saldo511013M saldo511014M saldo511015M saldo511016M saldo511018M saldo511047M saldo511048M saldo511049M saldo511050M saldo511051M saldo511052M saldo511053M saldo511054M saldo511055M saldo511060M saldo511061M saldo511064M saldo511071M saldo511073M saldo511076M saldo511077M), missing
replace RintGanaARS0 = RintGanaARS0 * (-1)
label var RintGanaARS0 "Intereses ganados mensuales X Prest.yArrend. ARS (sin OtCredXIntFciera)"
egen double RintGanaUSD0 = rowtotal(saldo515003M saldo515004M saldo515006M saldo515007M saldo515009M saldo515015M saldo515016M saldo515018M saldo515027M saldo515047M saldo515048M saldo515049M saldo515050M saldo515051M saldo515052M saldo515053M saldo515054M saldo515055M saldo515060M saldo515064M saldo515070M saldo515077M), missing
label var RintGanaUSD0 "Intereses ganados mensuales por Prest.yArrend. USD (sin OtCredXIntFciera)"

// Intereses ganados sobre (Préstamos+ArrendFcieros + (-Total previsiones- (-Previsiones por OtCredXIntFciera)))
by IDent: gen RtasaIntPRARS = RintGanaARS0 /  ( ( (L1.APRamplioARS-APRotCredXIntFcieraARS+Prev) + APRamplioARS-APRotCredXIntFcieraARS+Prev)/2 ) *100
label var RtasaIntPRARS "Tasa de interés implícita X Prest.yArrend ARS %"
by IDent: gen RtasaIntPRARSReal = ( (RtasaIntPRARS - IPCxMom)/(100 + IPCxMom) )*100
label var RtasaIntPRARSReal "Tasa de interés implícita X Prest.yArrend ARS REAL %"
gen RtasaIntPRUSD = (RintGanaUSD0 / (APRestamosUSD+APRarrFcierosUSD+(AprevActPRUSD-AprevActOtCredXIntFcieraUSD)))*100
label var RtasaIntPRUSD "Tasa de interés implícita X Prest.yArrend USD"

// Bankruptcies

gen sinRatioM =  (saldo580031M/ALIQs1_1)*100


/* **********************************************************	*/
/*																*/
/*					INDICADORES 									*/
/*
/*	*********************************************************	*/
gen C8Est = (PNtotal/Activo)*100
winsor2 C8Est , cuts(1 99)
// MARKET SHARE

sort FECHAdata IDent
by FECHAdata: egen totalDep = total(Pdep)
format %12.0gc totalDep
order totalDep, after(RresultMonM)
by FECHAdata: egen totalDepPriv = total(PdepSPrivNF)
format %12.0gc totalDepPriv
order totalDepPriv, after(totalDep)
by FECHAdata: egen totalAct = total(Activo)
format %12.0gc totalAct
order totalAct, before(totalDep)
gen mktShareDep = (Pdep/totalDep)*100
gen mktShareDepPriv = (PdepSPrivNF/totalDepPriv)*100
gen mktShareAct = (Activo/totalAct)*100
// EFICIENCIA
by IDent: gen IDn = _n
tssmooth ma volNgcioCapProm12 = APRARSCap+APRUSDCap+(-1)*(PdepARSCap+PdepUSDCap), window(11 1 0)


gen volNgcioCapProm12 = (((L11.APRARSCap+L10.APRARSCap+L9.APRARSCap+L8.APRARSCap+L7.APRARSCap+L6.APRARSCap+L5.APRARSCap+L4.APRARSCap+L3.APRARSCap+L2.APRARSCap+L1.APRARSCap+APRARSCap) + (L11.APRUSDCap+L10.APRUSDCap+L9.APRUSDCap+L8.APRUSDCap+L7.APRUSDCap+L6.APRUSDCap+L5.APRUSDCap+L4.APRUSDCap+L3.APRUSDCap+L2.APRUSDCap+L1.APRUSDCap+APRUSDCap) + (-1)*((L11.PdepARSCap+L10.PdepARSCap+L9.PdepARSCap+L8.PdepARSCap+L7.PdepARSCap+L6.PdepARSCap+L5.PdepARSCap+L4.PdepARSCap+L3.PdepARSCap+L2.PdepARSCap+L1.PdepARSCap+PdepARSCap)+ (L11.PdepUSDCap+L10.PdepUSDCap+L9.PdepUSDCap+L8.PdepUSDCap+L7.PdepUSDCap+L6.PdepUSDCap+L5.PdepUSDCap+L4.PdepUSDCap+L3.PdepUSDCap+L2.PdepUSDCap+L1.PdepUSDCap+PdepUSDCap))  ) / 12) if IDn >= 12 
label var volNgcioCapProm12 "Promedio ult. 12meses PRESTAMOS+DEPOSITOS (capitales)" 

gen E402est = (L11.RgasAdmnM+L10.RgasAdmnM+ L9.RgasAdmnM + L8.RgasAdmnM +L7.RgasAdmnM +L6.RgasAdmnM +L5.RgasAdmnM +L4.RgasAdmnM +L3.RgasAdmnM +L2.RgasAdmnM +L1.RgasAdmnM +RgasAdmnM) / ((L11.Activo+L10.Activo+ L9.Activo + L8.Activo +L7.Activo +L6.Activo +L5.Activo +L4.Activo +L3.Activo +L2.Activo +L1.Activo +Activo)/12)


/* **********************************************************	*/
/*																*/
/*					PERIODIZACIÓN 									*/
/*
/*	*********************************************************	*/

gen tt24 = 0
replace tt24 =1 if tin(1998m9,2000m9)
replace tt24 =2 if tin(2000m10,2003m5)
replace tt24 =3 if tin(2003m4,2005m4)
replace tt24 =4 if tin(2005m5,2006m5)
replace tt24 =5 if tin(2006m6,2008m4)
replace tt24 =6 if tin(2008m5,2008m12)
replace tt24 =7 if tin(2009m1,2011m1)
replace tt24 =8 if tin(2011m2,2012m2)
replace tt24 =9 if tin(2012m3,2014m3)
replace tt24 =10 if tin(2015m4,2015m11)

gen crisisTodas = 0
replace crisisTodas = 1 if tt24 == 2 | tt24 == 4 | tt24 == 6 | tt24 == 8 | tt24 == 10
gen crisis = 0
replace crisis = 1 if tt24==1 | tt24==7

/* ****************/
/* COLLAPSE        */
collapse (firstnm) crisisTodas bNombre grupoIDUni (mean) casNpcia-mktShareAct, by(IDent tt24)
tsset IDent tt24

gen camMktShareDep = ((F1.mktShareDep - mktShareDep)/mktShareDep)*100 if crisisTodas == 0

gen camMktShareAct = ((F1.mktShareAct - mktShareAct)/mktShareAct)*100
label var camMktShareAct "Cambio % mktShare por Activo"

/* Alternative definition for market share */
// We aggregate ACTIVO and compute market share rather than averageing marketShares 
gen camMktShareAct2 = ((Activo/totalAct) - (L1.Activo/L1.totalAct))*100
label var camMktShareAct2 "Cambio en market share nominal bien computado (promedio zero)"

gen camMktShareActR2 = ((ActivoR/totalActR) - (F1.ActivoR/F1.totalActR))*100
label var camMktShareActR2 "Cambio en market share real "bien computado" (promedio zero)"

egen P_BCRA = rowtotal(saldo321108 saldo321112 saldo321113 saldo321115 saldo321180 saldo321183 saldo321191 saldo321192 saldo321194 saldo321213 saldo321214 saldo321222 saldo321251 saldo321252 saldo321401 saldo321402 saldo321403 saldo321405 saldo321406 saldo321411 saldo321437 saldo321438 saldo321439 saldo321440 saldo321441 saldo321442 saldo321443 saldo321444 saldo325105 saldo325106 saldo325120 saldo325124 saldo325202 saldo331121 saldo340006), missing
label var P_BCRA "Pasivos con el BCRA"


/* *****************/
/*  ANALYSIS       */
/* ****************/

reg camMktShareAct C8Est_w   mktShareAct casNpciaCom casNsucuCom casNcajAutCom ALIQs1_1ratio ALIQs1_1ratio RtasaIntPRARS PdepVistaDEP   i.tt24 i.grupoIDUni if tt24==1, cluster(IDent)


reg camMktShareAct  i.crisis#c.capRatioPc capChgPs   mktShrAss  prov casasAss08  ALIQs1_1ratioWPc  prevRatioPPc IRLoansARSWRealMA6 depRatioAssPc depRatioWPc  i.t i.bGroup, cluster(ID_entidad )
gen tYb = 0
replace tYb = 1 if tin(2002m1, 2003m5)

foreach varNombre of varlist APRestamosARS APRotCredXIntFcieraUSD 	APRestamosUSD 	APRarrFcierosARS APRotCredXIntFcieraARS APRarrFcierosUSD R4 	R1 	R2 	E3 E4 	E1 	A3 E7 E17 A2 {
	winsor2 `varNombre', suffix(W) cuts( 1 99)
	order `varNombre'W, after(`varNombre')
} 

<!--- TODO: DISPERSION GEOGRAFICA --->
gen dispGeogIndx = medMktShrPcia * nPcia

