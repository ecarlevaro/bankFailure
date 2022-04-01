/* ********************************* 
ESD_quarterly_BAFA.dta
*/

use "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\ESD\ESD_BAFA.dta" 
gen FECHA_Q = qofd(dofm(FECHAdata))
label var FECHA_Q "Quarterly date"
format FECHA_Q %tq
order FECHA_Q, after(FECHAdata)

collapse TFG CAR_IRR_* CCOM_RATIO_TF CCONVIV_RATIO_TF CCOM200_RATIO_TF TG TGO, by(IDent FECHA_Q)

rename IDent IDENT
rename FECHA_Q FECHADATA

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\ESD\ESD_BAFA_quarterly.dta", replace 