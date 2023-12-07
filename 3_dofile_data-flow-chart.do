clear 
global root "C:/Users/d57917il/Documents/GitHub/thesis-chapter1"

*******************
* DATA FLOW CHART *
*******************

/*	Data flow charts specify which datasets are needed to create the analysis dataset and how they may be combined 
	by either appending or merging datasets.

	Every original dataset that is mentioned in a data flow chart should be listed in the data linkage table.

	For more info> https://dimewiki.worldbank.org/Data_Flow_Charts */
	
/* 	This do-file includes the following sections
	1. Data cleaning based on INEGI criteria. 
	2. Merge the datasets for each of the year/quarters considered for the study. 
	3. Append all the merged datasets to create a unique pool dataset 
	4. Create a unique identification variable based on INEGI criteria */

/* 	INEGI recommends to always uses the SDEM dataset as the reference dataset 
	and then merge it with the datasets that includes the questions that you are interested in. 
	But before doing that, it is necessary to execute a data cleaning process. 
	
	Therefore, I have to create a loop to perform the data cleaning and merge the datasets. */

// 	Create a folder where the merged datasets are going to be stored
	cd "${root}/2_data-storage"	
	capture mkdir merge_datasets
	
// 	Now, change the working directory to indicate Stata the file path of the raw datasets that I will merge. 	
	cd "${root}/2_data-storage/bases_enoe"	
	
// 	Creating the loop  	
	local year_quarter ///
	105 /// 1st quarter of 2005
	110 /// 1st quarter of 2010
	115 /// 1st quarter of 2015
	119 //	1st quarter of 2019

foreach year_q of local year_quarter {

use SDEMT`year_q' // Always use the SDEM dataset for each quarter as a reference. 

// DATA CLEANING BASED ON INEGI CRITERIA

	/* INEGI explains that it is necessary to execute a data cleaning process in the demographic dataset (SDEM) 
	in case you want to combine it with the employment datasets (COE1 and COE2)
	All the specifications are explained in page 13 of the following document: */

	/* First, INEGI recommends to drop all the kids below 12 years old from the sample because 
	those kids where not interviewed in the employment survey. Therefore, it is not necesary to keep them. 
	More specifically, all values between 00 and 11 as well as those equal to 99 should be dropped. 
	Remember that variable "eda" is equal to "age".*/
	
	drop if eda<=11
	drop if eda==99

	/* Second, INEGI recommends to drop all the individual that didn't complete the interview. 
	More specifically, the explain that I should eliminate those interviews where the variable "r_def" is 
	different from "00", since "r_def" is the definitive result of the interview and "00" indicates 
	that the interview was completed. */

	drop if r_def!=00 

	/* 	Third, INEGI recommends to drop all the interviews of people who were absent during the interview, 
	since there is no labor information or the questionnaire was not applied to the absentees.
	More specifically, they explain that I should eliminate those interviews where the variable "c_res" is equal to "2", 
	since "c_res" shows the residence condition and "2" is for definitive absentees.  */
	
	drop if c_res==2 

	
// MERGE PROCESS 

	* Now that the data cleaning process is complete, I will start the merging process. 
	* The first step is to merge the SDEM Database with the COE1 survey 
	merge 1:1 cd_a ent con v_sel n_hog h_mud n_ren using COE1T`year_q'
	rename _merge merge_COE1T`year_q'
	tab merge_COE1T`year_q' // Data quality check: All observations matched.

	* The second step is to merge the SDEM Database with the COE2 survey 
	merge 1:1 cd_a ent con v_sel n_hog h_mud n_ren using COE2T`year_q'
	rename _merge merge_COE2T`year_q'
	tab merge_COE2T`year_q' // Data quality check: All observations matched.
	
	* The third step is to save the merged datasets. 
	save "${root}/2_data-storage/merge_datasets/merge_enoe`year_q'.dta", replace
	
}


// Now that the datasets are merged, I will append them all to create a unique pool dataset.  

// 	Create a folder where the pool dataset is going to be stored
	cd 	"${root}/2_data-storage"	
	capture mkdir pool_dataset
	
/* 	The first time that I tried appending the datasets, Stata gave me this error message. 
	
	variable t_loc is double in master but str1 in using data 
	You could specify append's force option to ignore this numeric/string mismatch.
	The using variable would then be treated as if it contained numeric missing value.

	Therefore, before appending the datasets, I need to convert to string the variable t_loc 
	This issue is only in datasets merge_enoe115 & merge_enoe119. */	
	
	clear
	cd 	"${root}/2_data-storage/merge_datasets"	
	use merge_enoe115
	destring t_loc, replace
	tab t_loc // Data quality check: The variable now contains numeric variables from 1 to 4, rather than string values. 
	save "${root}/2_data-storage/merge_datasets/merge_enoe115.dta", replace
 
	clear
	cd 	"${root}/2_data-storage/merge_datasets"	
	use merge_enoe119
	destring t_loc, replace
	tab t_loc // Data quality check: The variable now contains numeric variables from 1 to 4, rather than string values. 
	save "${root}/2_data-storage/merge_datasets/merge_enoe119.dta", replace
	
		
// 	Now that this problem is solved, change the working directory to indicate Stata the file path of the merged datasets that will be pooled.
// 	Then, I will save the pool dataset
	
	clear
	cd 		"${root}/2_data-storage/merge_datasets"
	use 			merge_enoe105
	append	using 	merge_enoe110
	append	using	merge_enoe115
	append	using	merge_enoe119
	save 	"${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119.dta", replace

// 	Now that I have the pool dataset for each of the 4 year/quarters considered for this study...	
//	It is time to ask Stata to erase the merged_datasets as they are taking storage space and they are no longer needed.
	cd 		"${root}/2_data-storage/merge_datasets"
	erase 	merge_enoe105.dta	
	erase 	merge_enoe110.dta	
	erase 	merge_enoe115.dta	
	erase 	merge_enoe119.dta	
	cd 		"${root}/2_data-storage"
	rmdir 	merge_datasets

	
//	UNIQUE IDENTIFICATION VARIABLE BASED ON INEGI CRITERIA	
	
// 	unique id for each household
	egen house_id  = concat(cd_a ent con v_sel n_hog h_mud), 		punct(.)  
// 	unique_id for each respondent
	egen person_id = concat(cd_a ent con v_sel n_hog h_mud n_ren), 	punct(.) 

/* 	Data quality check: 
	person_id shouldn't have duplicates, so I will check if this is true. */
	duplicates report person_id
	
/* Duplicates in terms of person_id
--------------------------------------
   Copies | Observations       Surplus
----------+---------------------------
        1 |       546776             0
        2 |       711662        355831
-------------------------------------- */

/* 	The above result shows that there are several observations that are repeated. 
	The reason why this is happening is because I am not including 
	the variable "per" as an additional variable to uniquely identify individuals.
	The variable "per" indicates the period when the survey was done. 
	If I don't include it, there could be different people using the same ID in 
	different surveys. Let's say one person with the ID "1.9.501.1.1.0.1" in the survey 
	for 2005, and a different person with the same ID "1.9.501.1.1.0.1" in the 
	survey for 2019. Therefore, although INEGI doesn't include "per" as variable that 
	should be used to create the ID variable, for this study it is necessary to include it
	to uniquely identify individuals in the sample. */

egen person_id_per = concat(cd_a ent con v_sel n_hog h_mud n_ren per), 	punct(.)
duplicates report person_id_per

/* Duplicates in terms of person_id_per
--------------------------------------
   Copies | Observations       Surplus
----------+---------------------------
        1 |      1258438             0
-------------------------------------- */

/* 	Now that the problem is solved, 
	I should drop the person_id variable and only mantain person_id_per */
	drop person_id

save "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119.dta", replace
	
 