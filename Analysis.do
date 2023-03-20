***analysis**

**generate analytical sample 

**raw (mean for every individual i)
egen mean_raw_score=rowmean(rawscore1 rawscore2  rawscore3
rawscore4 rawscore5 rawscore6 rawscore7  rawscore8 rawscore9
rawscore10  rawscore11  rawscore12)

**1,883 missing values generated 

list rtype mean_raw_score 

center mean_raw_score, inplace standardize

egen absolute_rank = rank(mean_raw_score), by(school)

**calculate the number of students in each school
sort school absolute_rank

egen n_s = count(absolute_rank), by(school) 

egen n_s=count(rtype=="g"), by(school)

**initialize percentile_rank_is variable
gen percentile_rank_is = . 

**calculate 
by school: gen rank_is = cond(absolute_rank == 1, 0, (absolute_rank - 1)/(n_s - 1)) 

**initialize percentile_rank_is variable
gen percentile_rank_is = . 

***Models***
************


**bivariante association (model 1) using age at frist marriage 
reg afirstmarrige rank_is

**Controlling for Raw Attractiveness (Model 2)**
**just fiting a quadratic for now 

gen mean_raw_score2=mean_raw_score*mean_raw_score

reg afirstmarrige rank_is mean_raw_score2

**Controlling for Individual Characteristics (Model 3)** adding sex and bmi

reg afirstmarrige rank_is mean_raw_score2 female bmi

**Adding School Fixed Effects (Model 4)

reg afirstmarrige rank_is mean_raw_score2 female bmi i.school




