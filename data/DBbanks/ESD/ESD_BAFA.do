/ ********************************************
Creates ESD_BAFA.dta

TFG
TF_SIT_1
TF_SIT_2
TF_SIT_3
TF_SIT_4
TF_SIT_5
TF_SIT_6
CCOM_RATIO_TF
CCONVIV_RATIO_TF
CCOM200_RATIO_TF
PREV
TG
TGO

*/

use "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\ESD\ESD_98m9_2001.dta"
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\ESD\ESD_BAFA.dta", replace

/* *********************************** */
// GENERATE NEW VARIABLES
/* *********************************** */
gen CAR_IRR_3A6 = 100-(TF_SIT_1+TF_SIT_2)
gen CAR_IRR_2A6 = 100-TF_SIT_1


duplicates drop FECHAdata IDent TFG TF_SIT_1 CAR_IRR_3A6, force
duplicates tag FECHAdata IDent, generate(dup)

drop dup
duplicates tag FECHAdata IDent, generate(dup)
drop if FECHAdata==ym(2001, 1) & IDent==44088 & FECHAcd==ym(2001,3)
drop if FECHAdata==ym(2001, 1) & IDent==44092 & FECHAcd==ym(2001,3)
drop dup

isid FECHAdata IDent

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\ESD\ESD_BAFA.dta", replace


/ ************************** *//
Missing values analysis

misstable summarize TFG CAR_IRR_* CCOM_RATIO_TF CCONVIV_RATIO_TF CCOM200_RATIO_TF TG TGO

