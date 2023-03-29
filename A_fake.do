
***************************************************************************
* CREATE AND EXPORT WLS DATA W/FAKE SCHCODE VARIABLE
***************************************************************************

if "`c(username)'"!="bt7304" {
	
	***load wls long [each row is a person]
	use "${data}\wls_public_long.dta", clear

	***generate random number and percentile
	generate random = round(rnormal(), .1)
	xtile percentile = random, nq(300)

	***only make schcode for wls grads (not sibs)
	egen schcode=group(percentile) if rtype=="g" []

	drop random percentile

	egen id = concat(idpub rtype), format(%8.0f)	
}

if "`c(username)'"=="bt7304" {
	
	***load wls long [each row is a person]
	use "${data_raw}/WLS_Survey_Phenotypic_Long-form_Data_13_06/wls_plg_13_06.dta", clear

	***merge on schcode variable
	merge 1:1 idpriv rtype using "${data_raw}/WLS_new/schcode_rlg.dta"
	
	***save out data
	save "${data}\wls_public_long_SCHCODE.dta", replace
	
	egen id = concat(idpriv rtype), format(%8.0f)	
}

***doublecheck id variable
isid id
	
***save out data
save "${data}\wls_public_long_SCHCODE.dta", replace