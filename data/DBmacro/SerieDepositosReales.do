/* ********************************************* */
/* 							*/
/*			                */
/*			 					*/
/* ********************************************* */

tsset DATE

// Deflacto variables nominales usando IPCx
foreach var of varlist DEP_SPRIV_FX  DEP_SPRIV_FX_PF DEP_SPRIV DEP_SPRIV_ARS DEP_SPRIV_ARS_PF {
	gen `var'_R = `var' / (IPCX_INDEX/100)
	format `var'_R %10.0fc
	label variable `var'_R " `var' ajustada por inflacion"
}

gen DEP_SPRIV_PF_R = DEP_SPRIV_FX_PF_R + DEP_SPRIV_ARS_PF_R
label variable DEP_SPRIV_PF_R "Depositos en plazo fijo totales"
format DEP_SPRIV_PF_R %12.0fc
 
// Tasa variacion mensual plazo fijo
gen DEP_SPRIV_PF_R_DP = ((DEP_SPRIV_PF_R/L.DEP_SPRIV_PF_R) - 1) * 100
label var DEP_SPRIV_PF_R_DP "Variacion porcentual deposito plazo fijo sector Priv"
format DEP_SPRIV_PF_R_DP %4.2fc

// Tasa variacion interanual plazo fijo
gen DEP_SPRIV_PF_R_DPA = ((DEP_SPRIV_PF_R/L12.DEP_SPRIV_PF_R) - 1) * 100
label var DEP_SPRIV_PF_R_DPA "Variacion porcentual INTERANUAL deposito plazo fijo sector Priv"
format DEP_SPRIV_PF_R_DPA %4.2fc

gen DEP_SPRIV_PF_R_DPM3A = (L1.DEP_SPRIV_PF_R_DP + DEP_SPRIV_PF_R_DP + F1.DEP_SPRIV_PF_R_DP)/3
label var DEP_SPRIV_PF_R_DPM3A "DEP_SPRIV_PF_R_DP Promedio movil 1lag+current+ 1forward"
format DEP_SPRIV_PF_R_DP %4.2fc

// Tasa variacion interanual total dep sector priv
gen DEP_SPRIV_R_DPA = ((DEP_SPRIV_R/L12.DEP_SPRIV_R) - 1) * 100
label var DEP_SPRIV_R_DPA "Variacion porcentual INTERANUAL total depositos sector Priv"
format DEP_SPRIV_R_DPA %4.2fc

/* GRAPHS */
 twoway (tsline DEP_SPRIV_PF_R_DPA , recast(bar)) if DATE>ym(1992,4)
  twoway (tsline DEP_SPRIV_PF_R_DPA , recast(bar)) if DATE>ym(1992,4)
  
  twoway (tsline DEP_SPRIV_R_DPA, recast(bar) lcolor(yellow))
  