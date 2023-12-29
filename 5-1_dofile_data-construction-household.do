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

// Verify that each household has only one head 

by house_id_per, sort: egen hh_count = total(par_c==101)
fre hh_count // Data quality check: 99.67% of the cases have only one household head. 






// Create variables that capture age, sex and educational level of the household head

foreach x in eda female cs_p13_1 clase1 {
	
	by house_id_per, sort: egen hh_`x' = max(cond(par_c==101, `x', .))
	
}

order hh_count par_c eda hh_eda female hh_female cs_p13_1 hh_cs_p13_1 clase1 hh_clase1, last


save "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-cleaned.dta", replace