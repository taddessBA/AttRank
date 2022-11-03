clear

use /home/opr/data/dbgap/WLS/WLS_Survey_Phenotypic_Long-form_Data_13_06/wls_plg_13_06.dta

do clean_a.do

*** creating sample**
mark nomiss
markout nomiss id female birthdate bmi height cognitive educ afirstbirth num_marrige afirstmarrige num_childfirstm num_childlastm alcohol cig smoker_ever dep drinks pa self_health family_sat f_sat job_sat life_sat lone risk happy enjoy well_being ratmean
tab nomiss 

* Table of frequencies for reproductive behavior 
**V1
table () (female)
table () (female), nototals
table () (female), statistic(frequency) statistic(percent) statistic(mean afirstbirth num_marrige afirstmarrige num_childfirstm num_childlastm) statistic (sd afirstbirth num_marrige afirstmarrige num_childfirstm num_childlastm) nformat(%9.2f percent) sformat("%s%%" percent) nformat(%9.2f mean) nformat(%9.2f sd)
collect style cell, border(right, pattern(nil))
collect style cell, font(arial)
collect preview
collect export table.xlsx, replace

**v2
estimates clear
bysort nomiss: eststo: estpost sum afirstbirth num_marrige afirstmarrige num_childfirstm num_childlastm 
bysort nomiss: eststo: estpost sum afirstbirth num_marrige afirstmarrige num_childfirstm num_childlastm if female==1
bysort nomiss: eststo: estpost sum afirstbirth num_marrige afirstmarrige num_childfirstm num_childlastm if female==0
esttab  using "desc.csv", label nodepvar noobs nonumber plain replace cells("mean(fmt(2)) sd(fmt(2)) count(fmt(0))") collabels("Mean" "SD" "N") title("Table of Descriptives")


***v3
estimates clear
bysort nomiss: eststo: estpost sum afirstbirth num_marrige afirstmarrige num_childfirstm num_childlastm 
esttab  using "$table\desc_a_$date.csv", label nodepvar noobs nonumber plain replace cells("mean(fmt(2)) sd(fmt(2)) count(fmt(0))") collabels("Mean" "SD" "N") mtitle("Full Sample")

**v4
eststo est12: sum afirstbirth num_marrige afirstmarrige num_childfirstm num_childlastm 
mat mean = e(mean)'
mat sd = e(sd)'
mat N = e(count)'
putexcel set example_tables_2022_10_27, modify sheet("Only people with ratings") 
putexcel D3 = matrix(mean), nformat("#.##")
putexcel E3 = matrix(sd), nformat("#.##")
putexcel F3 = matrix(N), nformat("#")


**Health Behavior***
estimates clear
bysort nomiss: eststo: estpost sum alcohol cig smoker_ever drinks pa  self_health
esttab  using "$table\desc_b_$date.csv", label nodepvar noobs nonumber plain replace cells("mean(fmt(2)) sd(fmt(2)) count(fmt(0))") collabels("Mean" "SD" "N") mtitle("Full Sample")


**Mental well being**
estimates clear
bysort nomiss: eststo: estpost sum life_sat lone well_being dep 
esttab  using "$table\desc_c_$date.csv", label nodepvar noobs nonumber plain replace cells("mean(fmt(2)) sd(fmt(2)) count(fmt(0))") collabels("Mean" "SD" "N") mtitle("Full Sample")


















