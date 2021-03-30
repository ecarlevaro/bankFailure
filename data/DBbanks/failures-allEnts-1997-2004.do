drop if IDent>99999

// Mes cierre: update
merge 1:1 FECHAdata IDent using "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\entidades\entidades.dta", assert(master match match_update) keep(master match match_update) keepusing(MESCIE grupoIDUni) update
