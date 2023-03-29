***********************************************************************************
*** SETUP
***********************************************************************************

clear all
set more off, perm
set maxvar 16000, perm
set matsize 5000
pause on
capture postutil close
set scheme burd
*graph set window fontface "Calibri Light" 
*set trace on
*capture log close

***********************************************************************************
*** DIRECTORY GLOBALS
***********************************************************************************

***set home folder
if "`c(username)'"=="trejo" {
	glob dir "C:\Users\trejo\Dropbox (Princeton)\attract_rank"
	
	***set files path globals
	global data "${dir}\data"
	global syntax "`c(pwd)'"
	global table "${dir}\tables"
	global figure "${dir}\figures"
}

if "`c(username)'"=="bezataddess" {
 glob dir "/Users/bezataddess/Desktop/attractive"
***set files path globals
	global data "${dir}/data"
	global syntax "`c(pwd)'"
	global table "${dir}/tables"
	global figure "${dir}/figures"
}

if "`c(username)'"=="bt7304" {
 glob dir "~/WLSProject"
***set files path globals
	global data_raw "/home/opr/data/dbgap/WLS/" // raw data
	global data "${dir}/data" // clean data
	global syntax "~/WLSProject/AttRank"
	global table "${dir}/tables"
	global figure "${dir}/figures"
}

***********************************************************************************
*** STATA DATE
***********************************************************************************

***returns YYYY_MM_DD as global $date
quietly {
	global date=c(current_date)

	***day
	if substr("$date",1,1)==" " {
		local val=substr("$date",2,1)
		global day=string(`val',"%02.0f")
	}
	else {
		global day=substr("$date",1,2)
	}

	***month
	if substr("$date",4,3)=="Jan" {
		global month="01"
	}
	if substr("$date",4,3)=="Feb" {
		global month="02"
	}
	if substr("$date",4,3)=="Mar" {
		global month="03"
	}
	if substr("$date",4,3)=="Apr" {
		global month="04"
	}
	if substr("$date",4,3)=="May" {
		global month="05"
	}
	if substr("$date",4,3)=="Jun" {
		global month="06"
	}
	if substr("$date",4,3)=="Jul" {
		global month="07"
	}
	if substr("$date",4,3)=="Aug" {
		global month="08"
	}
	if substr("$date",4,3)=="Sep" {
		global month="09"
	}
	if substr("$date",4,3)=="Oct" {
		global month="10"
	}
	if substr("$date",4,3)=="Nov" {
		global month="11"
	}
	if substr("$date",4,3)=="Dec" {
		global month="12"
	}

	***year
	global year=substr("$date",8,4)

	global date="$year"+"_"+"$month"+"_"+"$day"
}
dis "$date"

***********************************************************************************
*** DATA GLOBALS
***********************************************************************************

***clean analytic sample
global clean "${data}\wls_clean_2023_03_29.dta"

***********************************************************************************
*** RUN CODE
***********************************************************************************

***import survey data
do "${syntax}/A_fake.do"

***clean survey data
do "${syntax}/B_clean.do"

***summary statistics table
do "${syntax}/C_sumstat.do"

***analysis
do "${syntax}/D_analysis.do"



