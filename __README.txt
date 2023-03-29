# Attractiveness Rank Effects README:

**********************************************************
****** "_MAIN"
**********************************************************

Main Stata script that sets file paths/globals and executes all following Stata scripts.

data in:

data out:
table out:
figure out:

**********************************************************
****** "A_fake"
**********************************************************

Generate a 'fake' schcode variable in the public WLS data for running test code off of the server (the data on the server contains the real restricted-use schcode variable).

data in: wls_public_SCHCODE.dta

data out: wls_public_long_SCHCODE.dta
table out:
figure out:

**********************************************************
****** "B_clean"
**********************************************************

Cleans raw WLS data saves out a .dta.

data in: wls_public_long_SCHCODE.dta

data out: wls_clean_${date}.dta
table out: 
figure out:

**********************************************************
****** "C_sumstat"
**********************************************************

Produces a summary statistics table.

data in: wls_clean_${date}.dta

data out:
table out: desc_${date}.dta
figure out:

**********************************************************
****** "D_analysis"
**********************************************************

Runs main attractiveness regressions.

data in: wls_clean_${date}.dta

data out:
table out:
figure out:

