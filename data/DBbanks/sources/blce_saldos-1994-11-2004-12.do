// Create balance de saldos only with observations relevants to the BAFA project

use "C:\Users\emi.ABLE-22868\OneDrive\InvUNL\BasesBCRA-IEF\balance de saldos\blce_saldos-1994_11-2020_02.dta"
drop if FECHAdata > ym(2004,12)
drop if FECHAdata < ym(1996,12)
drop marcaFinalOK 

// The order of vars is critical for computation of balance sheet vars
order saldo*, after(FECHAcd) sequential

save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\DBbanks\sources\blce_saldos-1994-11-2004-12.dta"
