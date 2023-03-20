***clean survey data

clear all

**idpub + rytpe or familypub+personid uniquely identify (school id will be add)

set maxvar 16000, perm

use "/home/opr/data/dbgap/WLS/WLS_Survey_Phenotypic_Long-form_Data_13_06/wls_plg_13_06.dta",clear

** merge with the school id dataset 

merge 1:1 idpriv rtype using "/home/opr/data/dbgap/WLS/WLS_new/schcode_rlg.dta"

**personal id

gen famid = "familypriv"

gen person = personid

egen id = concat(famid person), format(%8.0f)

**droping sibilings 

drop if rtype== "s"

*** sex

gen female = z_sexrsp
recode female (1=0) (2=1)
label define female_label 0 "Male" 1 "Female"
label values female female_label

**birthdate
gen birthdate = z_brdxdy


**anthopometric**

**bmi for graduate 
gen bmi_92=z_mx011rec
recode bmi_92 (.=.)(-4=.) (-3.5=.) (-3=.) (-2.5=.) (-2.3333333=.) (-2=.)

gen bmi_03=z_ix011rec
recode bmi_03 (.=.)(-4=.) (-3.5=.) (-3=.) (-2.5=.) (-2.3333333=.) (-2=.)
gen bmi_11=z_jx011rec
recode bmi_11 (.=.)(-4=.) (-3.5=.) (-3=.) (-2.5=.) (-2.3333333=.) (-2=.)

** need to combine school id 

egen bmi= rowmean(bmi_92 bmi_03 bmi_11 )
recode bmi (.=.)(-4=.)

**height in mm

gen height =0.0254*z_ix010rec
recode height (.=.) ( -.0508=.) ( -.1016=.)

**cognition and education**

**cognitive performance (1957-1964 graduates)

gen cognitive= gwiiq_bm
recode cognitive (.=.)

**education

gen educ_75=z_edeqyr
recode educ_75 (.=.)
gen educ_92=z_rb003red
recode educ_92 (.=.)
gen educ_03=z_gb103red
recode educ_03 (.=.)
gen educ_11=z_hb103red
recode educ_11 (.=.)

egen educ= rowmax(educ_75 educ_92 educ_03 educ_11)
recode educ(.=.)
recode educ (-3=.)
recode educ (0/11=1) (12=2) (13/15=3) (16=4) (17/21=5) 
label define educ_recode_label 1 "Less than high school" 2 "High school" 3 "Some college" 4 "College, BA" 5 "Master's or more"
label value educ educ_recode_label


**fertility and sexual development** 

** age at first birth 

gen afirstbirth=z_agrkd1
recode afirstbirth (.=.)(-3=.) (-2=.)
label variable afirstbirth "Age at first birth (months)"

**number of marriges 

gen num_marrige =z_marno
recode num_marrige (.=.)(-3=.)
label variable num_marrige "Number of marriages"

**age at frist marrige

gen afirstmarrige=z_agrfm
recode afirstmarrige (.=.)(-3=.) (-2=.)
label variable afirstmarrige "Age at first marriage (months)"

**number of children during first marriage

gen num_childfirstm =z_fmnoch
recode num_childfirstm (.=.)(-3=.) (-2=.)
label variable num_childfirstm "Number of children during first marriage"

** number of children during the last marriage

gen num_childlastm = z_lmnoch
recode num_childlastm (-3=.) (-2=.)
label variable num_childlastm "Number of children during last marriage"

** health and health behaviors **

**alcohol misuse 

gen alc1=z_ru025re  
recode alc1 (.=.)(-3=.) (-2=.)

gen alc2=z_hu025re
recode alc2 (.=.)(-3=.) (-2=.)

gen alcohol=.
replace alcohol = 0 if alc1 & alc2==2
replace alcohol = 1 if alc1 & alc2==1
label define alcohol_recode_label 0 "No" 1 "Yes" 
label value alcohol alcohol_recode_label

**cigarettes per day 

gen cig1=mx015rer
recode cig1 (.=.)(6=0)(-3=.) (-2=.)
gen cig2=z_ix015rer
recode cig2 (.=.)(-3=.) (-2=.)

recode cig2 (.25/0.75=0) (1/1.75=1) (2/2.75=2)(3/3.5=3)(4/5=4)
label define cig2_recode_label 0 "Less a pack" 1 " Less than 2 packs" 2 "Less than 3 packs" 3 "Less than 4 pack" 4 "For or more packs"
label value cig2 cig2_recode_label

gen cig=.
replace cig = 0 if cig1==0 & cig2==0
replace cig = 1 if cig1==1 & cig2==1
replace cig = 2 if cig1==2 & cig2==2
replace cig = 3 if cig1==3 & cig2==3
replace cig = 4 if cig1==4 & cig2==4
label define cig_recode_label 0 "Less a pack" 1 " Less than 2 packs" 2 "Less than 3 packs" 3 "Less than 4 pack" 4 "For or more packs"
label value cig cig_recode_label

**ever smoker 

gen smoker_ever=.
replace smoker_ever=0 if z_mx012rer==2 & z_ix012rer==2 & z_jx012rer==2
replace smoker_ever=1 if z_mx012rer==1 & z_ix012rer==1 & z_jx012rer==1
label define smoker_ever_recode_label 0 "No" 1 " Yes" 
label value smoker smoker_ever_recode_label 


**depressive symptoms

** summary score on CESD

gen dep_92=z_mu001rec
recode dep_92 (.=.) (-3=.)
gen dep_03=z_iu001rec
recode dep_03 (.=.) (-2=.)
gen dep_11=z_ju001rec
recode dep_11 (.=.) (-2=.) (-27=.)

egen dep= rowmean(dep_92 dep_03 dep_11)

** drinks per week 
gen drinks_92=z_ru027re
recode drinks_92 (.=.) (-3=.)(-2=.)(-1=0)

gen drinks_03=z_gu027re
recode drinks_03 (.=.) (-25=1) (-24=1)(-5=.)(-4=.)(-3=.)(-2=.)(-1=0)
gen drinks_11=z_hu027re
recode drinks_11 (.=.) (-5=.)(-30=.)(-2=.)(-1=0)

gen days_92=z_ru026re
recode days_92 (.=.)(-3=.)(-2=.) (-1=.)

gen days_03=z_gu026re
recode days_03 (.=.)(-3=.)(-2=.) (-1=.) (-5=.)

gen days_11=z_hu026re
recode days_11 (.=.)(-5=.)(-30=.)(-2=.)(-1=0)

gen dpw_92= days_92*drinks_92
recode dpw_92 (.=.)
gen dpw_03= days_03*drinks_03
recode dpw_03 (.=.)
gen dpw_11= days_11*drinks_11
recode dpw_11 (.=.)

egen drinks= rowmean(dpw_92 dpw_03 dpw_11 )
recode drinks (.=.)

**physical acitivity 

gen light_92= z_mx005rer
tab light_92, m
recode light_92 (-3=.) (1=15) (2=6) (3=2) (4=0.5)
tab light_92

gen heavy_92= z_mx006rer
tab heavy_92, m
recode heavy_92 (-3=.) (1=15) (2=6) (3=2) (4=0.5)
tab heavy_92
tab heavy_92,m

gen light1_03=z_iz165rer
recode light1_03 (.=.) (-3=.) (-1=.)

gen light2_03=z_iz168rer
recode light2_03 (.=.) (-3=.) (-1=.)

gen heavy1_03=z_iz171rer
recode heavy1_03 (.=.) (-3=.) (-1=.)

gen heavy2_03=z_iz174rer
recode heavy2_03 (.=.)(-3=.) (-1=.)

gen light1_11=z_jz165rer
recode light1_11 (.=.) (-3=.) (-1=.)

gen light2_11=z_jz168rer
recode light2_11 (.=.) (-3=.) (-1=.)

gen heavy1_11=z_jz171rer
recode heavy1_11 (.=.) (-3=.) (-1=.)

gen heavy2_11=z_jz174rer
recode heavy2_11 (.=.) (-3=.) (-1=.)


gen pa_92= (light_92) + (heavy_92)
gen pa_03= (light1_03 + light2_03)+(heavy1_03 + heavy2_03)
gen pa_11= (light1_11 + light2_11)+(heavy1_11 + heavy2_11)
egen pa= rowmean(pa_92 pa_03 pa_92 )
recode pa (.=.)
tab pa,m 


**self rated health 

gen self_h92=z_mx001rer
gen self_h03=z_ix001rer
gen self_h11=z_jx001rer

egen self_health= rowmax(self_h92 self_h92 self_h92 )
recode self_health (.=.)

** life satisfaction: family, finance, work

gen family_sat=z_gb040re
recode family_sat (.=.) (-5=.)(-4=.)(-1=0) (-3=.)

gen f_sat03=z_gp226re
recode f_sat03 (.=.)(-5=.)(-3=.)(-1=0)

gen f_sat11=z_gp226re
recode f_sat11 (.=.)(-5=.)(-3=.)(-1=0)

egen f_sat= rowmax (f_sat03 f_sat11)
recode f_sat (.=.)

gen job_sat92=z_rg044jjc
recode job_sat92 (.=.)(-3=.)(-2=.)(-1=0)

gen job_sat03=z_gg044jjc
recode job_sat03 (.=.)(-5=.)(-3=.)(-1=0) (-4=.)(-2=.)

gen job_sat11=z_gg044jjc
recode job_sat11(.=.)(-5=.)(-3=.)(-1=0) (-4=.)(-2=.)

egen job_sat= rowmax (job_sat92 job_sat03 job_sat11)
recode job_sat (.=.)

egen life_sat= rowmax(family_sat  f_sat job_sat)


**loneliness 

gen lone_92=z_mu008rer
recode lone_92 (.=.)
gen lone_03=z_iu008rer
recode lone_03 (.=.)
gen lone_11=z_ju008rer
recode lone_11 (.=.)

egen lone=rowmax(lone_92 lone_03 lone_11)
recode lone (-3=.)(-29=.)(-27=.)

**risk tolerance 

gen risk=.
replace risk=1 if z_jstk02re ==1| z_jstk03re ==1| z_jstk04re==1| z_jstk05re==1| z_jstk06re==1| z_jstk07re==1| z_jstk08re==1| z_jstk09re==1| z_jstk10re==1| z_jstk11re ==1| z_jstk12re==1 | z_jstk13re==1| z_jstk14re==1| z_jstk15re==1| z_jstk16re==1 | z_jstk17re==1| z_jstk18re==1 | z_jstk19re==1| z_jstk20re==1| z_jstk21re==1| z_jstk22re==1

replace risk=0 if z_jstk02re ==2| z_jstk03re ==2| z_jstk04re==2| z_jstk05re==2| z_jstk06re==2| z_jstk07re==2| z_jstk08re==2| z_jstk09re==2| z_jstk10re==2| z_jstk11re==2| z_jstk12re==2 | z_jstk13re==2| z_jstk14re==2| z_jstk15re==2| z_jstk16re==2 | z_jstk17re==2| z_jstk18re==2| z_jstk19re==2| z_jstk20re==2| z_jstk21re==2| z_jstk22re==2


**subjective well-being

gen happy_92=z_mu006rer
recode happy_92 (.=.)
gen happy_03=z_iu006rer
recode happy_03 (.=.)
gen happy_11=z_ju006rer
recode happy_11 (.=.)
egen happy=rowmax(happy_03 happy_92 happy_11 )
recode happy (-3=.) (-29=.)(-27=.)

gen enjoy_92=z_mu009rer
recode enjoy_92 (.=.)
gen enjoy_03=z_iu009rer
recode enjoy_03 (.=.)
gen enjoy_11=z_ju009rer
recode enjoy_11 (.=.)
egen enjoy =rowmax(enjoy_92 enjoy_03 enjoy_11 )
recode enjoy (-3=.)(-29=.)(-27=.)

egen well_being= rowmax (happy enjoy)

******attractive*** 
tab meanrat
gen ratmean=meanrat
recode ratmean (.=.)

**raw (mean for every individual i)
egen mean_raw_score=rowmean(rawscore1 rawscore2  rawscore3 rawscore4 rawscore5 rawscore6 rawscore7  rawscore8 rawscore9 rawscore10 rawscore11 rawscore12)
 
list rtype mean_raw_score 
 
***school code 
tab schcode
gen school=schcode
recode school (.=.)  
