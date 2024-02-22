clear
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

use	"${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-cleaned.dta" 


/* 

Data CONSTRUCTION transforms clean data into analysis data. 

You shouldn't generate variables or construct indicators during 
the CLEANING PROCESS or the ANALYSIS process.
During the cleaning process you can correct typos, make missing value decisions, etc. 
but you cannot construct indicators or generate new variables.   

Data cleaning makes raw/original data easy to use. 
Data construction transforms clean data into data ready for analysis. 

Unit of observation -> Unit of analysis 
Observed measurements -> Analysis indicators.

	•  	Create new variables instead of overwriting the original information.
	•  	Constructed variables should have intuitive and functional names.
	•  	Harmonizing variable measures and scales.
	•  	Order the data set so that related variables are close to each other.
	•  	Document in the code how research questions has influenced variable construction.
	•  	Clearly note each decision made in the script, the reasons behind them, and 
		any alternatives considered. Be considerate to your future self or teammembers.
	•  	Set up expectations for an indicator. For example, never negative, within arange, 
		always smaller than some other variable, etc. Build in tests for thoseexpectations.
	•   List all observations with missing values in constructed variables. Make sure 
		you can explain why they are missing.
	•   Test that ID is uniquely and fully identifying after construct.
	•	Test as much as you can. Use the command "assert" in Stata

*/ 


******************************************************
*** Constructing indicators at the household level ***
******************************************************

// Verify that each household has only one household head 

by house_id_per, sort: egen hh_count = total(par_c==101)

fre hh_count 
/* 	Data quality check: 99.67% of the cases have only one household head. 
	For some reason, the rest is equal to 0. */

tab sex if hh_count==0
/* 	The majority of the cases are women. 
	There is a chance that women doesn't consider themselves as the head of the household, and 
	the person they consider the head of the household is currently not living in the household. */


// Create variables to capture age, sex and educational level of the household head

foreach x in eda female cs_p13_1 clase1 {
	
	by house_id_per, sort: egen hh_`x' = max(cond(par_c==101, `x', .))
	
}

order hh_count par_c eda hh_eda female hh_female cs_p13_1 hh_cs_p13_1 clase1 hh_clase1, last


// Give a label to the new variables generated at the household level. 

label variable hh_eda 		"Age of the household head"
label variable hh_female 	"Identifier of female headed household"
label variable hh_cs_p13_1 	"Educational level of the household head"
label variable hh_clase1 	"Labour status of the household head"
label variable hh_kids 		"Number of kids in the household"
label variable hh_members 	"Number of household members"


// Changes to the variable hh_kids "Number of kids in the household"			
tab hh_kids
recode hh_kids (5=4) (6=4) (7=4) (8=4) (9=4)
label define hh_kids 	///
0 "No kids"				///
1 "One kid" 			///
2 "Two kids"			///
3 "Three kids"	 		///
4 "Four or more kids", replace
label value hh_kids hh_kids
fre hh_kids


// Changes to the variable hh_members "Number of household members"			
tab hh_members
recode hh_members (12=11) (13=11) (14=11) (15=11) (16=11) (17=11) (18=11) (19=11) (20=11) (21=11) (22=11) (23=11) (24=11) (25=11) (26=11) (27=11)
label define hh_members 11 "More than 10 household members", replace
label value hh_members hh_members
fre hh_members


// Check if socio-economic stratum is a variable at the individual or household level. 

sort house_id_per
bysort house_id_per: egen min_soc_str=min(soc_str)
bysort house_id_per: egen max_soc_str=max(soc_str)
gen dif = min_soc_str - max_soc_str
tab dif 
/* Data quality check: All values are equal to zero. 
This indicates that there are no value variations within households. 
Therefore, socio-economic stratum is a variable at the household level. */
drop dif min_soc_str max_soc_str

drop hh_count


save "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-cleaned-hh.dta", replace