***********************************************************************************
*** SETUP
***********************************************************************************

clear all
set more off, perm
set matsize 5000
pause on
capture postutil close
set scheme burd
*set trace on
*capture log close

***********************************************************************************
*** DIRECTORY GLOBALS
***********************************************************************************

***set home folder
if "`c(username)'"=="trejo" {
	glob dir "C:\Users\trejo\Dropbox (Princeton)\attract_rank"
	graph set window fontface "Calibri Light" 
	
	***set files path globals
	global data "${dir}\data"
	global syntax "`c(pwd)'"
	global table "${dir}\tables"
	global figure "${dir}\figures"
}

if "`c(username)'"=="" {

***set files path globals
	global data "${dir}/data"
	global syntax "`c(pwd)'"
	global table "${dir}/tables"
	global figure "${dir}/figures"
}

***returns YYYY_MM_DD as global $date
do "${syntax}/stata_date.do"

***********************************************************************************
*** DATA GLOBALS
***********************************************************************************

***raw wls data
global raw "${data}\wls_public_long_SCHCODE.dta"

***clean analytic sample
global clean "${data}\"

***********************************************************************************
*** RUN CODE
***********************************************************************************

***import survey data
do "${syntax}/A_fake.do"

***clean survey data


