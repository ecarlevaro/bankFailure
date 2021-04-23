import excel "C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\data\failures\entities_start_end_dates.xlsx", sheet("entsDates") firstrow case(upper)

format %td *_DATE*
drop ORDER_N

// Vars 12, n=185

// Only work with failures during 1997-2004
drop if EXIT_DATE > date("31dec2004", "YMD")
// 0 observations deleted
// END_DATE is always less or equal to the exit date
drop if END_DATE > date("31dec2004", "YMD")
// 0 observations deleted
// n=185
// Any exit must be of at least 1 type, then this sum should be >= 1 for all failing banks
egen ET_CONTROL = rowtotal(ET_MERGE ET_ADQUIRED ET_MA  ET_PARTIAL_SALE ET_TRANSFORMATION ET_VOLUNTARY ET_OTHER)
list IDENT FIRST_DATE END_DATE EXIT_DATE ET_CONTROL if !missing(EXIT_DATE) & (ET_CONTROL<1 | missing(ET_CONTROL)) 
drop ET_CONTROL

recode ET_MERGE ET_ADQUIRED ET_MA  ET_PARTIAL_SALE ET_TRANSFORMATION ET_VOLUNTARY ET_OTHER (. = 0)
gen EXIT_TYPE = 1*ET_MA + 2*ET_PARTIAL_SALE + 3*ET_TRANSFORMATION + 4*ET_VOLUNTARY + 5*ET_OTHER
