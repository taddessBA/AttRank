
use "${clean}", clear

gen mean_raw_score2=mean_raw_score*mean_raw_score

** Globals for controls
global controls "female birhdate bmi height chhoodSES maeduc paeduc mawork mawork paocc faminc57 milwaukee"
global outcomes "educ afirstbirth num_marrige afirstmarrige num_childfirstm num_childlastm alcohol cig smoker dep drinks pa self_health life_sat lone risk happy well_being"

** Running loops for each outcome
foreach outcome in $outcomes {
  reg `outcome' rank_is $controls, vce(robust)

  // Store regression results
  eststo table_`outcome'_1: estpost, vce(robust)

  reg `outcome' rank_is mean_raw_score2, vce(robust)

  // Store regression results
  eststo table_`outcome'_2: estpost, vce(robust)

  reg `outcome' rank_is mean_raw_score2 $controls, vce(robust)

  // Store regression results
  eststo table_`outcome'_3: estpost, se robust

  areg `outcome' rank_is mean_raw_score2 $controls, vce(robust)

  // Store regression results
  eststo table_`outcome'_4: estpost, vce(robust)
}

** Export regression results to separate tables
foreach outcome in $outcomes {
  esttab table_`outcome'_*, vce(robust) ///
    cells("b se") ///
    nonotes label replace ///
    title("Regression Results for `outcome'") ///
    replace
}
	
	



