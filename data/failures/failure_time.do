

import excel "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures\entities_start_end_dates.xlsx", sheet("entsDates") firstrow case(upper)

format %td *_DATE*
format %td ET_*
drop ORDER_N

// Vars 12, n=185

// Create FAIL_DATE
// The min of 
egen FAIL_DATE = rowmin(ET_MERGE ET_ADQUIRED ET_MA ET_PARTIAL_SALE ET_TRANSFORMATION ET_VOLUNTARY ET_CBA ET_OTHER)
label var FAIL_DATE "Date of the first event that I consider failure"
format FAIL_DATE %td
// n=86

// Only work with failures during 1997-2004
drop if FAIL_DATE > date("31dec2004", "YMD")
// 0 observations deleted
// END_DATE is always less or equal to the exit date
drop if END_DATE > date("31dec2004", "YMD")
// 0 observations deleted
// n=185
// Any exit must be of at least 1 type, then this sum should be >= 1 for all failing banks
egen ET_CONTROL = rowtotal(ET_MERGE ET_ADQUIRED ET_MA ET_PARTIAL_SALE ET_TRANSFORMATION ET_VOLUNTARY ET_CBA ET_OTHER)
list IDENT FIRST_DATE END_DATE FAIL_DATE ET_CONTROL if ET_CONTROL==0 & END_DATE<td(1dec2002) & missing(FAIL_DATE)
// The bank id 42 the Chanse Manhattan was merged in the US by another bank. A foreignd merge. It's not a failure

gen FAIL_TYPE = 1 if FAIL_DATE == ET_MA
replace FAIL_TYPE = 2 if FAIL_DATE == ET_PARTIAL_SALE
replace FAIL_TYPE = 3 if FAIL_DATE == ET_TRANSFORMATION
replace FAIL_TYPE = 4 if FAIL_DATE == ET_VOLUNTARY
replace FAIL_TYPE = 5 if FAIL_DATE == ET_CBA
replace FAIL_TYPE = 6 if !missing(FAIL_DATE) & FAIL_DATE == ET_OTHER 
label var FAIL_TYPE "Type of failure for FAIL_DATE"

order FAIL_DATE FAIL_TYPE, after(END_DATE)

// We only care about quarterly data in the analysis
gen double FIRST_DATE_Q = qofd(FIRST_DATE)
label var FIRST_DATE_Q "First observation for this bank (quarterly)"
gen double FAIL_DATE_Q = qofd(FAIL_DATE)
label var FAIL_DATE_Q "Failure date (quarterly)"
format FIRST_DATE_Q FAIL_DATE_Q %tq
order FAIL_DATE_Q, after(FAIL_DATE)
save "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures\failure_time.dta", replace