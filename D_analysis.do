
use "${clean}", clear

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




