clear 
*global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"


// 	Ask stata to open the dataset with ENOE household surveys
use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-cleaned-hh.dta"

// 	Change the working directory to the path where the municipal data is located.
cd "${root}/2_data-storage/municipal_data"

// 	Create the key variable that will merge both datasets.
egen ent_mun_per = concat(mun ent per), punct(.)

// 	Ask stata to merge the datasets using "ent_mun_per" as the key variable
merge m:1 ent_mun_per using 1_tidy_municipal_dataset
/* 	Note: ent_mun_per can be multiple times in the household data, 
	but only one time in the municipal data */

// Generate a variable to know how many municipalities are covered in this survey. 			
egen ent_mun = concat(mun ent), punct(.)  
egen count_entmun = group(ent_mun)
summarize count_entmun 
// Result: This surveys covered 1526 municipalities in Mexico 

egen count_entmunper = group(ent_mun_per)
summarize count_entmunper

fre  total_sde_mun total_stratum total_w_stratum total_econ total_educ
drop total_sde_mun total_stratum total_w_stratum total_econ total_educ

label variable migration_mun "% of people that migrated from their hometown to keep or maintain their current job"
label variable ent_mun "Municipality identifier"
label variable ent_mun_per "Municipality identifier in a specific year/quarter"
	
compress	
	
save "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta", replace