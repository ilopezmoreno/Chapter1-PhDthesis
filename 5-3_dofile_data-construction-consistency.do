clear
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

/* 

In this do-file I will:

	•   Test that municipal ID is uniquely and fully identifying after construct.
	•  	Set up expectations for an indicator. For example, 
		all variables at the municipal level should be equal to 100. 
		

	•  	Create new variables instead of overwriting the original information.
	•  	Constructed variables should have intuitive and functional names.
	•  	Harmonizing variable measures and scales.
	•  	Order the data set so that related variables are close to each other.
	•  	Document in the code how research questions has influenced variable construction.
	•  	Clearly note each decision made in the script, the reasons behind them, and 
		any alternatives considered. Be considerate to your future self or teammembers.
	•  	Set up expectations for an indicator. For example, never negative, within arange, 
		always smaller than some other variable, etc. Build in tests for those expectations.
	•   List all observations with missing values in constructed variables. Make sure 
		you can explain why they are missing.
	•	Test as much as you can. Use the command "assert" in Stata

*/ 

use	"${root}/2_data-storage/municipal_data/migra_mun.dta" 

//	Test that municipal ID is uniquely and fully identifying after construct.
	duplicates report ent_mun_per
//	Data consistency check: municipal ID has no duplicated values. 


/* 	Now I will create a loop to merge all the indicators that capture 		
	different municipal characteristics */ 

cd 	"${root}/2_data-storage/municipal_data"
	
// 	Creating the loop 
	local municipality_dataset 	///
	sde_mun_agri				///
	sde_mun_indu				///
	sde_mun_serv				///
	sde_mun_unsp				///
	stratum_low_municipal		///	
	stratum_mlow_municipal		///
	stratum_mhigh_municipal		///
	stratum_high_municipal		///
	surveys_entmun 				///
	w_econ_mun_divor			///
	w_econ_mun_freeu            ///
	w_econ_mun_marri            ///
	w_econ_mun_separ            ///
	w_econ_mun_singl            ///
	w_econ_mun_widow            ///
	w_educ_mun_grad             ///
	w_educ_mun_high				///
	w_educ_mun_postg            ///
	w_educ_mun_prim             ///
	w_educ_mun_secon            ///
	w_educ_mun_tech             ///
	w_mun_eda                   ///
	w_mun_nkids                 ///
	w_stratum_high_municipal    ///
	w_stratum_low_municipal		///
	w_stratum_mhigh_municipal	///
	w_stratum_mlow_municipal	//
	

foreach municipal_dataset of local municipality_dataset {
	
	merge 1:1 ent_mun_per using `municipal_dataset'	
	rename _merge merge_`municipal_dataset'
	tab merge_`municipal_dataset'
	drop merge_`municipal_dataset'
}

/* 	

Note: merge_w_mun_nkids is the only one that didn't merge all 

   Matching result from |
                  merge |      Freq.     Percent        Cum.
------------------------+-----------------------------------
        Master only (1) |          5        0.12        0.12
            Matched (3) |      4,059       99.88      100.00
------------------------+-----------------------------------
                  Total |      4,064      100.00

*/

/* 		Moreover, there are a few municipalities reporting that there are no women (20 to 35 years old) with kids. 
		I will check what's the number of respondents that each municipality had */
		tab surveys_entmun w_mun_nkids if w_mun_nkids==0
/* 		he number of respondents in those municipalities is maximum 56. 
		It is likely that considering the low number of respondents, 
		there were no women in the municipality between 20 and 35 years and with kids.	*/



summarize surveys_entmun
order ent_mun_per surveys_entmun, first

/*
ent_mun_per		surveys_entmun
	..10.3			52
	..14.3			110
	..19.3			93
	..19.4			84
	..20.3			1082
	..20.4			825
	..21.4			157
	..24.4			66
	..26.3			90
	..26.4			85
	..28.3			46
	..28.4			34
	..29.3			181
	..29.4			217
	..31.3			701
	..31.4			336
	..5.3			32
	..5.4			39
	..8.3			36
	..8.4			79
*/

/* 	Note to myself: 
	There are some cases where the ENOE survey is not indicating a value in the municipality variable. 
	Instead, the municipality variable has a missing value "."
	
	This problem is only happening in period 3 and 4. Meaning 2015 & 2019
	This is something from the dataset itself. I will have to ocontact INEGI to check what's the problem. 
	
*/

	
		
// CONSISTENCY CHECKS 

	gen total_sde_mun = agrishare_mun + indushare_mun + servishare_mun + unspeshare_mun
	tab total_sde_mun // CONSISTENCY check. Result: All variables are equal to .99 or 1
	drop total_sde_mun 

	gen total_stratum = str_low + str_mlow + str_mhigh + str_high
	tab total_stratum // CONSISTENCY check. Result: All variables are equal to .99 or 1
	drop total_stratum 	

	gen total_w_stratum = w_str_low + w_str_mlow + w_str_mhigh + w_str_high
	tab total_w_stratum // CONSISTENCY check. Result: All variables are equal to .99 or 1
	drop total_w_stratum 		
	
	gen total_educ =  w_educ_mun_prim + w_educ_mun_secon + w_educ_mun_high + /// 
					  w_educ_mun_tech + w_educ_mun_grad  + w_educ_mun_postg 
	tab total_educ // CONSISTENCY check. Result: All variables are equal to .99 or 1
	drop total_educ 	
	
	gen total_econ = w_econ_mun_divor + w_econ_mun_freeu + w_econ_mun_marri + ///
					 w_econ_mun_separ + w_econ_mun_singl + w_econ_mun_widow 
	tab total_econ // CONSISTENCY check. Result: All variables are equal to .99 or 1
	drop total_econ 	
	
	

// CONVERT VARIABLES VALUES FROM (O-1) TO (0%-100%)

		// 	Creating the loop 
			local municipal_variables 	///
			agrishare_mun indushare_mun servishare_mun unspeshare_mun /// 
			str_low str_mlow str_mhigh str_high /// 
			w_econ_mun_divor w_econ_mun_freeu w_econ_mun_marri w_econ_mun_separ w_econ_mun_singl w_econ_mun_widow ///
			w_educ_mun_grad w_educ_mun_high w_educ_mun_postg w_educ_mun_prim w_educ_mun_secon w_educ_mun_tech /// 
			w_str_high w_str_low w_str_mhigh w_str_mlow /// 
			migra_mun 	
	
			foreach variable of local municipal_variables {
				
				sort ent_mun_per
				bysort ent_mun_per: egen min=min(`variable')
				bysort ent_mun_per: egen max=max(`variable')
				gen dif = min - max
				tab dif // Data quality check: All values are equal to zero. Variable values are correct.
				drop min max dif
								
				generate one_`variable' = (100 * `variable')      
				drop `variable'	
			}	
	
// RENAME VARIABLES 	
	
			rename one_agrishare_mun 			sde_mun_agri
			rename one_indushare_mun 			sde_mun_indu
			rename one_servishare_mun 			sde_mun_serv
			rename one_unspeshare_mun 			sde_mun_unsp	
				
			rename one_str_low 					ss_mun_low
            rename one_str_mlow 				ss_mun_mlow
            rename one_str_mhigh 				ss_mun_mhigh
            rename one_str_high 				ss_mun_high

			rename one_w_str_low 				w_mun_low
            rename one_w_str_mlow 				w_mun_mlow
            rename one_w_str_mhigh 				w_mun_mhig
            rename one_w_str_high 				w_mun_high	
			
			rename one_w_econ_mun_divor 		w_econ_mun_divor
		    rename one_w_econ_mun_freeu 		w_econ_mun_freeu
		    rename one_w_econ_mun_marri 		w_econ_mun_marri
		    rename one_w_econ_mun_separ 		w_econ_mun_separ
			rename one_w_econ_mun_singl 		w_econ_mun_singl
		    rename one_w_econ_mun_widow			w_econ_mun_widow
		
		    rename one_w_educ_mun_prim			w_educ_mun_prim		
		    rename one_w_educ_mun_secon 		w_educ_mun_secon		
		    rename one_w_educ_mun_high 			w_educ_mun_high
			rename one_w_educ_mun_tech 			w_educ_mun_tech		
			rename one_w_educ_mun_grad	 		w_educ_mun_grad		
		    rename one_w_educ_mun_postg 		w_educ_mun_postg		
		
			rename one_migra_mun				migration_mun 

			
		
// FINAL CONSISTENCY CHECKS 

	gen total_sde_mun 	= 	sde_mun_agri + sde_mun_indu + sde_mun_serv + sde_mun_unsp
	gen total_stratum 	= 	ss_mun_low 	+ ss_mun_mlow + ss_mun_mhigh + ss_mun_high
	gen total_w_stratum = 	w_mun_low + w_mun_mlow + w_mun_mhig + w_mun_high
	gen total_econ 		= 	w_econ_mun_divor + w_econ_mun_freeu + w_econ_mun_marri + ///
							w_econ_mun_separ + w_econ_mun_singl + w_econ_mun_widow	
	gen total_educ 		=  	w_educ_mun_prim + w_educ_mun_secon + w_educ_mun_high + /// 
							w_educ_mun_tech + w_educ_mun_grad  + w_educ_mun_postg 
							
	summarize total_sde_mun total_stratum total_w_stratum total_econ total_educ
	// All variables are equal to 100. 
		

// RE-LABEL VARIABLES 

		label variable sde_mun_agri 	"% of agricultural jobs at the municipal level"
        label variable sde_mun_indu 	"% of industrial jobs at the municipal level"
        label variable sde_mun_serv		"% of service jobs at the municipal level"
        label variable sde_mun_unsp		"% of unspecified jobs at the municipal level"

        label variable ss_mun_low 		"% of people from low socio-economic stratum at the municipal level"		
        label variable ss_mun_mlow		"% of people from medium-low socio-economic stratum at the municipal level"
        label variable ss_mun_mhigh		"% of people from medium-high socio-economic stratum at the municipal level"
        label variable ss_mun_high		"% of people from high socio-economic stratum at the municipal level"		

        label variable w_mun_low		"% of women from low socio-economic stratum at the municipal level"		
        label variable w_mun_mlow		"% of women from medium-low socio-economic stratum at the municipal level"
        label variable w_mun_mhig		"% of women from medium-high socio-economic stratum at the municipal level"
        label variable w_mun_high		"% of women from high socio-economic stratum at the municipal level"		

        label variable w_econ_mun_divor	"% of divorced women at the municipal level"		
        label variable w_econ_mun_freeu	"% of free-union women at the municipal level"
        label variable w_econ_mun_marri	"% of married women at the municipal level"
        label variable w_econ_mun_separ	"% of separated women at the municipal level"
        label variable w_econ_mun_singl	"% of single women at the municipal level"
        label variable w_econ_mun_widow	"% of widowed women at the municipal level"
      
        label variable w_educ_mun_prim	"% of women with primary school or less at the municipal level"			
        label variable w_educ_mun_secon	"% of women with secondary school at the municipal level"
        label variable w_educ_mun_high	"% of women with high school school at the municipal level"
        label variable w_educ_mun_tech	"% of women with technical career at the municipal level"	
        label variable w_educ_mun_grad	"% of women with graduate degree at the municipal level"	
        label variable w_educ_mun_postg	"% of women with post-graduate degree at the municipal level"

		label variable ent_mun_per		"Municipality identifier in a specific year/quarter"
		label variable surveys_entmun	"Total surveys carried out in the municipality in a specific year/quarter"
		label variable w_mun_eda		"Average age of women at the municipal level"	
        label variable w_mun_nkids		"Average number of kids from women between 20-35 years old at the municipal level"
		
		
save "${root}/2_data-storage/municipal_data/1_tidy_municipal_dataset.dta", replace		