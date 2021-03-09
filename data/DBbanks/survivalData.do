// Generates a database with panels and time for failure data
// Apparently this is not the standard approach.

drop _all
local banksN 3
//721 - 420
local periodsT 301

// `periodsT' * `banksN'
set obs 903

egen FECHAdata = seq(), from(420) to(721) 
egen IDbank = seq(), from(1) to(`banksN') block(`banksN')

sort IDbank FECHAdata

gen FAIL = 0






