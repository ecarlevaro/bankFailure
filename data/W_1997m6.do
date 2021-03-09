drop if IDent > 99999
// Resolve CUITs into IDent
merge m:1 FECHA_DATA IDEN_DEUDOR using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\entidades\mapeo_IDent_CUIT\CUITs_entidades_1997m6.dta", assert(master match) keep(master match) keepusing(ID_ENT_DEUDOR) update
// Keep only the loans that are within financial entities regulated by the BCRA
drop if _merge == 1
// Verify the unmatched ones (_merge==1)

// Verify M&A

gen IDent = IDENT_ACCREDOR
label var IDent "IDent bank acreedor"
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\capitalEffects\data\DBbanks\capital-allEntities-Monthly.dta", assert(master match) keep(master match) keepusing(Activo APRamplio)

rename Activo A_ACTIVO
label var A_ACTIVO "Activo nominal de acreedor"

rename APRamplio A_APRamplio
label var A_APRamplio "Préstamos + OtPrestamoXAIntFciera del acreedor"

/* WEIGHTS */

// Lender
gen W_A_A = PRESTAMOS / A_ACTIVO
label var W_A_A "Proporción de prestamos a Activo del acreedor"
gen W_A_PRA = PRESTAMOS / A_APRamplio
label var W_A_PRA "Proporción de prestamos a Total de préstamos (amplio, con OtPrestXIntFciera del acreedor"
