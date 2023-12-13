clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

*******************
* DATA FLOW CHART *
*******************

/*	Data flow charts specify which datasets are needed to create the main 
	analysis dataset and how they may be combined by either appending 
	or merging datasets.

	Every original dataset that is mentioned in a data flow chart should be 
	listed in the data linkage table.

	For more info -> https://dimewiki.worldbank.org/Data_Flow_Charts */
	
/* 	This do-file includes the following sections
	1. Data cleaning based on INEGI criteria. 
	2. Merge the datasets for each of the year/quarters considered for the study. 
	3. Append all the merged datasets to create a unique pool dataset 
	4. Create a unique identification variable based on INEGI criteria 
	5. Compress the pool dataset. */

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

	/* Second, INEGI recommends to drop all the individual that didn't 
	complete the interview. More specifically, the explain that I should 
	eliminate those interviews where the variable "r_def" is different from 
	"00", since "r_def" is the definitive result of the interview and 
	"00" indicates that the interview was completed. */

	drop if r_def!=00 

	/* 	Third, INEGI recommends to drop all the interviews of people who 
	were absent during the interview, since there is no labor information 
	or the questionnaire was not applied to the absentees. 	More specifically, 
	they explain that I should eliminate those interviews where the variable 
	"c_res" is equal to "2", since "c_res" shows the residence condition and 
	"2" is for definitive absentees.  */
	
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
	tab t_loc /* Data quality check: The variable now contains numeric 
	variables from 1 to 4, rather than string values. */
	save "${root}/2_data-storage/merge_datasets/merge_enoe115.dta", replace
 
	clear
	cd 	"${root}/2_data-storage/merge_datasets"	
	use merge_enoe119
	destring t_loc, replace
	tab t_loc /* Data quality check: The variable now contains numeric 
	variables from 1 to 4, rather than string values. */
	save "${root}/2_data-storage/merge_datasets/merge_enoe119.dta", replace
	
		
/* 	Now that this problem is solved, change the working directory 
	to indicate Stata the file path of the merged datasets that will be pooled.
 	Then, I will save the pool dataset */
	
	clear
	cd 		"${root}/2_data-storage/merge_datasets"
	use 			merge_enoe105
	append	using 	merge_enoe110
	append	using	merge_enoe115
	append	using	merge_enoe119
	save 	"${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119.dta", replace

/*	Now that I have the pool dataset for each of the 4 year/quarters considered for this study...	
	It is time to ask Stata to erase the merged_datasets as they are taking storage space and 
	they are no longer needed. */
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

/* 	No I will document all the variables that will be dropped from the dataset, 
	as it currently have almost 400 variables, and most of them are not needed. */
	drop 			///
	r_def 			///
	loc				///
	est_d			///
	ageb			///
	cd_a    		///
	con     		///
	upm     		///
	d_sem			///
	n_pro_viv   	///
	v_sel       	///
	n_hog       	///
	h_mud       	///
	n_ent       	///
	n_ren       	///
	nac_dia     	///
	nac_mes			///
	nac_anio    	///
	l_nac_c     	///
	cs_p12      	///
	cs_p13_2    	///
	cs_p14_c    	///
	cs_p15      	///
	cs_p16      	///
	cs_p17			///
	cs_ad_mot   	///
	cs_p20_des  	///
	cs_ad_des   	///
	cs_nr_mot   	///
	cs_p22_des  	///
	cs_nr_ori   	///
	zona        	///
	salario			///
	seg_soc     	///
	c_ocu11c    	///
	ing7c       	///
	dur9c       	///
	emple7c     	///
	medica5c    	///
	buscar5c    	///
	dur_est			///
	ambito1     	///
	ambito2     	///
	tue1        	///
	tue2        	///
	tue3        	///
	busqueda    	///
	d_ant_lab   	///
	d_cexp_est 		///
	dur_des     	///
	sub_o       	///
	s_clasifi   	///
	remune2c    	///
	pre_asa     	///
	tip_con     	///
	dispo       	///
	nodispo			///
	c_inac5c    	///
	eda5c       	///
	eda7c       	///
	eda12c      	///
	eda19c      	///
	domestico   	///
	anios_esc   	///
	hrsocup			///
	ing_x_hrs   	///
	tpg_p8a     	///
	tcco        	///
	cp_anoc     	///
	imssissste  	///
	ma48me1sm   	///
	p14apoyos   	///
	t_tra			///
	tue_ppal    	///
	trans_ppal  	///
	mh_fil2     	///
	mh_col      	///
	sec_ins     	///
	n_inf       	///
	p1          	///
	p1a1        	///
	p1a2        	///
	p1a3        	///
	p1b         	///
	p1c         	///
	p1d         	///
	p1e         	///
	p2_1        	///
	p2_2        	///
	p2_3        	///
	p2_4        	///
	p2_9        	///
	p2a_dia     	///
	p2a_sem     	///
	p2a_mes     	///
	p2a_anio    	///
	p2b_dia     	///
	p2b_sem     	///
	p2b_mes     	///
	p2b_anio    	///
	p2b         	///
	p2c         	///
	p2d1        	///
	p2d2        	///
	p2d3        	///
	p2d4        	///
	p2d5        	///
	p2d6        	///
	p2d7        	///
	p2d8        	///
	p2d9        	///
	p2d10       	///
	p2d11       	///
	p2d99       	///
	p2e         	///
	p2f         	///
	p2g1        	///
	p2g2        	///
	p2h1        	///
	p2h2        	///
	p2h3        	///
	p2h4        	///
	p2h9        	///
	p3          	///
	p3a         	///
	p3b         	///
	p3c1        	///
	p3c2        	///
	p3c3        	///
	p3c4        	///
	p3c9        	///
	p3d         	///
	p3e         	///
	p3f1        	///
	p3f2        	///
	p3g1_1      	///
	p3g1_2      	///
	p3g2_1      	///
	p3g2_2      	///
	p3g3_1      	///
	p3g3_2      	///
	p3g4_1      	///
	p3g4_2      	///
	p3g9        	///
	p3g_tot			///
	p3h         	///
	p3i         	///
	p3j         	///
	p3k1        	///
	p3k2        	///
	p3l1        	///
	p3l2        	///
	p3l3        	///
	p3l4        	///
	p3l5        	///
	p3l9        	///
	p3m1        	///
	p3m2        	///
	p3m3        	///
	p3m4        	///
	p3m5        	///
	p3m6        	///
	p3m7        	///
	p3m8        	///
	p3m9        	///
	p3n         	///
	p3o         	///
	p3p1        	///
	p3p2        	///
	p3q         	///
	p3r_anio    	///
	p3r_mes     	///
	p3r         	///
	p3s         	///
	p3t_anio    	///
	p3t_mes     	///
	p4          	///
	p4_1        	///
	p4_2        	///
	p4_3        	///
	p4b         	///
	p4c         	///
	p4d1        	///
	p4d2        	///
	p4d3        	///
	p4e         	///
	p4f         	///
	p4g         	///
	p4h         	///
	p4i         	///
	p4i_1       	///
	p5          	///
	p5a         	///
	p5b         	///
	p5c_hlu     	///
	p5c_mlu     	///
	p5c_hma     	///
	p5c_mma     	///
	p5c_hmi     	///
	p5c_mmi     	///
	p5c_hju     	///
	p5c_mju     	///
	p5c_hvi     	///
	p5c_mvi     	///
	p5c_hsa     	///
	p5c_msa     	///
	p5c_hdo     	///
	p5c_mdo     	///
	p5c_thrs    	///
	p5c_tdia    	///
	p5d         	///
	p5e1        	///
	p5e_hlu     	///
	p5e_mlu     	///
	p5e_hma     	///
	p5e_mma     	///
	p5e_hmi			///
	p5e_mmi     	///
	p5e_hju     	///
	p5e_mju     	///
	p5e_hvi     	///
	p5e_mvi     	///
	p5e_hsa     	///
	p5e_msa     	///
	p5e_hdo     	///
	p5e_mdo     	///
	p5e_thrs    	///
	p5e_tdia    	///
	p5f				///
	p5g1        	///
	p5g2        	///
	p5g3        	///
	p5g4        	///
	p5g5        	///
	p5g6        	///
	p5g7        	///
	p5g8        	///
	p5g9        	///
	p5g10       	///
	p5g11       	///
	p5g12			///		
	p5g13			///
	p5g14			///
	p5g15			///
	p5g99			///
	p5h				///
	merge_COE1T105  ///
	p6_1			///
	p6_2            ///
	p6_3            ///
	p6_4            ///
	p6_5            ///
	p6_6            ///
	p6_7            ///
	p6_8            ///
	p6_9            ///
	p6_10           ///
	p6_99			///
	p6a1            ///
	p6a2            ///
	p6a3            ///
	p6a4            ///
	p6a9            ///
	p6b1            ///
	p6b2            ///
	p6c             ///
	p6d             ///
	p7              ///
	p7a             ///
	p7b             ///
	p7c				///
	p7d             ///
	p7e             ///
	p7f             ///
	p7f_dias        ///
	p7f_horas       ///
	p7g1            ///
	p7g2            ///
	p7g3            ///
	p7g9            ///
	p7gcan          ///
	p8_1            ///
	p8_2            ///
	p8_3			///
	p8_4            ///
	p8_9            ///
	p8a             ///
	p8b             ///
	p9              ///
	p9a             ///
	p9b             ///
	p9c             ///
	p9d             ///
	p9e             ///
	p9f_anio        ///
	p9f_mes         ///
	p9f				///
	p9g             ///
	p9h             ///
	p9h_1           ///
	p9i             ///
	p9j             ///
	p9k             ///
	p9l1            ///
	p9l2            ///
	p9l3            ///
	p9l4            ///
	p9l5            ///
	p9l9            ///
	p9m1			///
	p9m2            ///
	p9m3            ///
	p9m9            ///
	p9mcan          ///
	p9n1            ///
	p9n2            ///
	p9n3            ///
	p9n4            ///
	p9n5            ///
	p9n6            ///
	p9n9            ///
	p10_1           ///
	p10_2			///			
	p10_3           ///
	p10_4           ///
	p10_9           ///
	p10a1           ///
	p10a2           ///
	p10a3           ///
	p10a4           ///
	p10a9           ///
	p10b            ///
	p11_1           ///
	p11_h1          ///
	p11_m1          ///
	p11_2           ///
	p11_h2          ///
	p11_m2          ///
	p11_3           ///
	p11_h3			///
	p11_m3          ///
	p11_4           ///
	p11_h4          ///
	p11_m4          ///
	p11_5           ///
	p11_h5          ///
	p11_m5          ///
	p11_6           ///
	p11_h6          ///
	p11_m6          ///
	p11_7           ///
	p11_h7          ///
	p11_m7          ///
	p11_8           ///
	p11_h8          ///
	p11_m8          //


// 	Finally, compress the dataset so it takes less memory from your computer. 

/* 	COMPRESS
	Use the command "compress" to reduce the size of the dataset. 
	It will also take less memory from your computer. */
	compress 
	/*  This is what the compress command does.	
		doubles   to   longs, ints, or bytes
        floats    to   ints or bytes
        longs     to   ints or bytes
        ints      to   bytes
        str#s     to   shorter str#s
        strLs     to   str#s  				*/
	
	
save "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119.dta", replace
