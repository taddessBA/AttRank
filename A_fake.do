
***************************************************************************
* CREATE AND EXPORT WLS DATA W/FAKE SCHCODE VARIABLE
***************************************************************************

***load wls long [each row is a person]
use "${data}\wls_public_long.dta", clear

***generate random number and percentile
generate random = round(rnormal(), .1)
xtile percentile = random, nq(300)

***only make schcode for wls grads (not sibs)
egen schcode=group(percentile) if rtype=="g" []

drop random percentile

***save out data
save "${data}\wls_public_long_SCHCODE.dta", replace
