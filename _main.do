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
*** SET DIRECTORY GLOBALS
***********************************************************************************

***set home folder
if "`c(username)'"=="trejo" {
	glob dir "C:\Users\trejo\Dropbox (Princeton)\seg_exp"
	graph set window fontface "Calibri Light" 
}

if "`c(username)'"=="" {}

}

***set files path globals
global data "${dir}/data"
global dofile "${dir}/dofiles"
global table "${dir}/tables"
global figure "${dir}/figures"

***returns YYYY_MM_DD as global $date
do "$dofile/stata_date.do"

***********************************************************************************
*** RUN DOFILES
***********************************************************************************

***import survey data
do "$dofile/A_data_import_v03.do"

***clean survey data


