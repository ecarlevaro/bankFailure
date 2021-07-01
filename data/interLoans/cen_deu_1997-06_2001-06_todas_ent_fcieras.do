/ *************************** */
/* From cen_deu_1997-06_2001-06 */

use "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\centralDeudores\cen_deu_1997-06_2001-06.dta" 
keep if ACTIVIDAD == 830 | ACTIVIDAD == 73

replace PRESTAMOS = DEUDA if missing(PRESTAMOS)
drop DEUDA

gen FEC_INF = mofd(date(FECHAcd,"YM")) if FECHA_CD <= ym(1997,12)
tostring FEC_INF_STR, replace
gen FEC_INF = ym(1900 + real(substr(FEC_INF_STR, 1, 2)), real(substr(FEC_INF_STR, 3, 2))) if FECHA_CD <= ym(1997,12)
replace FEC_INF = ym(real(substr(FEC_INF_STR, 1, 4)), real(substr(FEC_INF_STR, 5, 2))) if FECHA_CD > ym(1997,12)
format %tm FEC_INF
rename FEC_INF FECHA_DATA

drop FEC_INF_STR
save "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\centralDeudores\cen_deu_1997-06_2001-06_todas_ent_fcieras.dta", replace

//by CODIGO_ENT FEC_INF: table PRESTAMOS, contents(sum ) if FEC_INF = ym(1998,12)\

// CUITs and IDENT_DEUDORA

gen CUIT = IDEN_DEUDOR if TIPO == 11
label var CUIT "CUIT del deudor. Igual a IDEN_DEUDOR para los que tienen CUIT"

merge m:1 FECHA_DATA CUIT using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\entidades\mapeo_IDent_CUIT\CUITs_entidades_1997_2001.dta", assert(master match) keep(master match) keepusing(IDent) update
replace IDENT_DEUDORA = IDent 

order IDENT_ACREEDORA IDENT_DEUDORA, after(NOMBRE_ENT)

/* ********************** */
/* prepare for going QUARTERLY			*/
/* ********************** */
gen FECHA_Q = qofd(dofm(FECHAdata))
label var FECHA_Q "Quarterly date"
format FECHA_Q %tq
order FECHA_Q, after(FECHAdata)

