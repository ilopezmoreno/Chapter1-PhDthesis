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
	w_econ_mun_divor			///
	w_econ_mun_freeu            ///
	w_econ_mun_marri            ///
	w_econ_mun_na               ///
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


// CONSISTENCY CHECKS 

	
	// 	SECTORAL DISTRIBUTION OF EMPLOYMENT
	
				summarize agrishare_mun indushare_mun servishare_mun unspeshare_mun
				// 	Minimum value: 0. Maximum value: 1
				
				// 	I need to transform the variables from 0-1 to 0-100
				gen one_agri = (100 * agrishare_mun)
				gen one_ind = (100 * indushare_mun)
				gen one_serv = (100 * servishare_mun)
				gen one_unsp = (100 * unspeshare_mun)
				drop agrishare_mun indushare_mun servishare_mun unspeshare_mun
					rename one_agri sde_mun_agri
					rename one_ind sde_mun_indu
					rename one_serv sde_mun_serv
					rename one_unsp sde_mun_unsp
				
				/* 	Now I need to do the consistency check.
				 	With the following code, I want to check if the sum between 
					the four variables created are equal to 100. */
					gen total_sde_mun = sde_mun_agri + sde_mun_indu + sde_mun_serv + sde_mun_unsp
					tab total_sde_mun // Data quality check.
					// Result: All variables are equal to 100 or 99.9999999
					drop total_sde_mun 
				
				/* 	With the following code, I also want to check if each municipality has only 
					one value for the sectoral distribution of employment in each sector. 
					To do so, I will create two variables. 
					The first one captures the minimum value for each municipality in each sector, 
					while the second one captures the maximum value. 
					If the difference between the maximum value and the minimum value is equal to 0, 
					it means that the variables were created correctly. */
			
					sort ent_mun_per
					bysort ent_mun_per: egen min_agri=min(sde_mun_agri)
					bysort ent_mun_per: egen max_agri=max(sde_mun_agri)
					gen dif_agri = min_agri - max_agri
					tab dif_agri 
					// Data quality check: All values are equal to zero. Variable values are correct.
					drop min_agri max_agri dif_agri
					
					sort ent_mun
					bysort ent_mun: egen min_ind=min(sde_mun_indu)
					bysort ent_mun: egen max_ind=max(sde_mun_indu)
					gen dif_ind = min_ind - max_ind
					tab dif_ind 
					// Data quality check: All values are equal to zero. Variable values are correct.
					drop min_ind max_ind dif_ind
					
					
					sort ent_mun
					bysort ent_mun: egen min_serv=min(sde_mun_serv)
					bysort ent_mun: egen max_serv=max(sde_mun_serv)
					gen dif_serv = min_serv - max_serv
					tab dif_serv 
					// Data quality check: All values are equal to zero. Variable values are correct.
					drop min_serv max_serv dif_serv		

	
		// 	SHARE OF WOMEN WITH DIFFERENT MARITAL STATUS AT THE MUNICIPAL LEVEL 
				
		
		
		