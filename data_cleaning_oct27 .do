***clean survey data

clear all
set more off, perm
set matsize 5000
pause on
capture postutil close
set scheme burd

**idpub + rytpe or familypub+personid uniquely identify (school id will be add)


**personal id

gen id =familypriv + "-" personid

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
recode bmi_92 (.=.)
gen bmi_03=z_ix011rec
recode bmi_03 (.=.)
gen bmi_11=z_jx011rec
recode bmi_11 (.=.)

** need to combine school id 
egen bmi= rowmax(bim_92 bmi_03 bmi ), by (id female birthdate)


**height in mm

gen height =0.0254*z_ix010rec
recode height (.=.)

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

egen educ= rowmax(educ_75 educ_92 educ_03 educ_11), by (id female birthdate)
recode educ(.=.)
recode educ (0/11=1) (12=2) (13/15=3) (16=4) (17/21=5) 
label define educ_recode_label 1 "Less than high school" 2 "High school" 3 "Some college" 4 "College, BA" 5 "Master's or more"
label value educ educ_recode_label


**fertility and sexual development** 

** age at first birth 

gen afirstbirth=z_agrkd1
recode afirstbirth (.=.)

**number of marriges 

gen num_marrige =z_marno
recode num_marrige (.=.)

**age at frist marrige

gen afirstmarrige=z_agrfm
recode afirstmarrige (.=.)

**number of children during frist marrige

gen num_childfirstm =z_fmnoch
recode num_childfirstm (.=.)

** number of children during the last marrige

gen num_childlastm = z_lmnoch


** health and health behaviors **

**alcohol misuse 

gen alc1=z_ru025regen 
recode alc1 (.=.)
gen alc2=z_hu025re
recode alc2 (.=.)
gen alcohol=.
replace alcohol = 0 if alc1 & alc2==2
replace alcohol = 1 if alc1 & alc2==1
label define alcohol_recode_label 0 "No" 1 "Yes" 
label value alcohol alcohol_recode_label

**cigarettes per day 

gen cig1=mx015rer
recode cig1 (.=.)
recode cig1 (6=0)
gen cig2=z_ix015rer
recode cig2 (.=.)
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
recode dep_92 (.=.)
gen dep_03=z_iu001rec
recode dep_03 (.=.)
gen dep_11=z_ju001rec
recode dep_11 (.=.)

** need to combine by school id 

egen dep= rowmax(dep_92 dep_03 dep_11), by (id female birthdate)
recode dep(.=.)


** drinks per week 
gen drinks_92=z_ru027re
recode drinks_92 (.=.)
gen drinks_03=z_gu027re
recode drinks_03 (.=.)
gen drinks_11=z_hu027re
recode drinks_11 (.=.)

gen days_92=z_ru026re
recode days_92 (.=.)
gen days_03=z_gu026re
recode days_03 (.=.)
gen days_11=z_hu026re
recode days_11 (.=.)

gen dpw_92= days_92*drinks_92
recode dpw_92 (.=.)
gen dpw_03= days_03*drinks_03
recode dpw_03 (.=.)
gen dpw_11= days_11*drinks_11
recode dpw_11 (.=.)

** need to combine school id 

egen drinks= rowmax(dpw_92 dpw_03 dpw_11 ), by (id female birthdate)
recode drinks (.=.)

**physical acitivity 

gen light_92=.
replace light_92=1 if z_mx005rer==15
replace light_92=2 if z_mx005rer==6
replace light_92=3 if z_mx005rer==2
replace light_92=4 if z_mx005rer==0.5

gen heavy_92=.
replace heavy_92=1 if z_mx006rer==15
replace heavy_92=2 if z_mx006rer==6
replace heavy_92=3 if z_mx006rer==2
replace heavy_92=4 if z_mx006rer==0.5

gen light1_03=z_iz165rer
recode light1_03 (.=.)
gen light2_03=z_iz168rer
recode light2_03 (.=.)

gen heavy1_03=z_iz171rer
recode heavy1_03 (.=.)
gen heavy2_03=z_iz174rer
recode heavy2_03 (.=.)


gen light1_11=z_jz165rer
recode light1_11 (.=.)
gen light2_11=z_jz168rer
recode light2_11 (.=.)

gen heavy1_11=z_jz171rer
recode heavy1_11 (.=.)
gen heavy2_11=z_jz174rer
recode heavy2_11 (.=.)

gen pa_92= (2*light_92) + (8*heavy_92)
gen pa_03= (2*(light1_03 + light2_03))+(8*(heavy1_03 + heavy2_03))
gen pa_11= (2*(light1_11 + light2_11))+(8*(heavy1_11 + heavy2_11))


** need to combine by school id 
egen pa= rowmax(pa_92 pa_03 pa_92 ), by (id female birthdate)
recode pa (.=.)


**self rated health 

gen self_h92=z_mx001rer
gen self_h03=z_ix001rer
gen self_h11=z_jx001rer

** need to combine by school id 

egen self_health= rowmax(self_h92 self_h92 self_h92 ), by (id female birthdate)
recode self_health (.=.)

** life satisfaction: family, finance, work

gen family_sat=z_gb040re
recode family_sat (.=.)

gen f_sat03=z_gp226re
recode f_sat03 (.=.)
gen f_sat11=z_gp226re
recode f_sat11 (.=.)

egen f_sat= rowmax (f_sat03 f_sat11), by (id female birthdate)
recode f_sat (.=.)

gen job_sat92=z_rg044jjc
recode job_sat92 (.=.)
gen job_sat03=z_gg044jjc
recode job_sat03 (.=.)
gen job_sat11=z_gg044jjc
recode job_sat11(.=.)

egen job_sat= rowmax (job_sat92 job_sat03 job_sat11), by (id female birthdate)
recode job_sat (.=.)

** need to combine school id 
egen life_sat= rowmax(family_sat  f_sat job_sat ), by (id female birthdate)

**loneliness 

gen lone_92=z_mu008rer
recode lone_92 (.=.)
gen lone_03=z_iu008rer
recode lone_03 (.=.)
gen lone_11=z_ju008rer
recode lone_11 (.=.)

** need to combine school id 
egen lone=rowmax(lone_92 lone_03 lone_11), by (id female birthdate)

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
egen happy=rowmax(happy_03 happy_92 happy_11 ), by (id female birthdate)

gen enjoy_92=z_mu009rer
recode enjoy_92 (.=.)
gen enjoy_03=z_iu009rer
recode enjoy_03 (.=.)
gen enjoy_11=z_ju009rer
recode enjoy_11 (.=.)
egen enjoy =rowmax(enjoy_92 enjoy_03 enjoy_11 ), by (id female birthdate)


egen well_being= rowmax (happy enjoy), by (id female birthdate)

** number of months between first marriage and birth of the first child

gen firstm_c =durmeb
recode firstm_c (.=.)

** how often contact with (first and second) high school friend 

gen contact =hmx47rer
recode contact (.=.)
 
**married or lived with someone who was a problem drinker 

gen lived_driker =gu038re 
recode lived_driker (.=.)

******attractive*** 

tab meanrat
gen ratmean=meanrat
recode ratmean (.=.)


  
