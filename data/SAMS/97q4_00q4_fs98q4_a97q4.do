data from 1997q4 (or before if available,)
failures from 1998q1.
banks alive by 1997q4
// Create past moving averages of bank covariates
foreach `varName' of var ActivoN_S APRestamos C8Est CAR_IRR_3A6_IMP P_ROA P_LOANS_ARS_RATE_IS_IMP APRSpNF_RATE_W APR_USD_RATE APR_RATE_W  {
	by IDENT: gen _MAL4 = (L4.`varName' + L5.`varName' + L6.`varName'  + L7.`varName')/4 
	label varName `varName'_MAL4 "Moving average last 4 previous quarters"
}