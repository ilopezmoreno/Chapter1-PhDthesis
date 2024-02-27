clear
*global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"
use	"${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-cleaned-hh.dta" 


/* 

Data CONSTRUCTION transforms clean data into analysis data. 

You shouldn't generate variables or construct indicators during 
the CLEANING PROCESS or the ANALYSIS process.
In cleaning you can correct typos, make missing value decisions, etc. but not 
constructing indicators or generate new variables.   

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
*** Constructing indicators at the municipal level ***
******************************************************

// First, create a folder to store all the calculations. 
cd "${root}/2_data-storage"
capture mkdir municipal_data

/* 	Generate a variable that uniquely identifies each municipality in the sample 
	The variable "per" captures the year/quarter when the survey was done. 
	It is important to use it as a way to differentiate municipalities across years. */ 
egen ent_mun_per = concat(mun ent per), punct(.) // 
sort ent_mun_per
tab per if mun==.
tab ent if mun==.
	
// 	Create a variable that shows the number of people 
// 	that were interviewed in each municipality. 
	egen surveys_entmun = total(eda>=14), by(ent_mun_per)
	summarize surveys_entmun // Mean: 2,458 respondents. Maximum: 7,714. Minimum: 2. 
		//	Now ask stata to store the 		
			preserve
			collapse (count) surveys_entmun, by(ent_mun_per) 
			save "${root}/2_data-storage/municipal_data/surveys_entmun.dta", replace
			restore

			

			
			
			
			
			
			
			
			
			
			
			
			
/* 	Now it is time to create the variables that will show the 
	SECTORAL DISTRIBUTION OF EMPLOYMENT at the municipal level */
	
// 	Create the variable "agri_sector" to identify people working in agriculture.
		generate agri_sector=.
		replace  agri_sector=1 if rama_est1==1 // Primary sector (Agriculture)
		replace  agri_sector=0 if inlist(rama_est1, 2, 3, 4) 
//  Create the variable "agri_sector" to identify people working in industrial jobs.
		generate ind_sector=.
		replace  ind_sector=1 if rama_est1==2 // Secondary sector (Industry)
		replace  ind_sector=0 if inlist(rama_est1, 1, 3, 4)
//  Create the variable "serv_sector" to identify people working in service jobs.
		generate serv_sector=.
		replace  serv_sector=1 if rama_est1==3 // Tertiary sector (Services) 
		replace  serv_sector=0 if inlist(rama_est1, 1, 2, 4)
//  Create the variable "unsp_sector" to identify people working in unspecified activities.
		generate unsp_sector=.
		replace  unsp_sector=1 if rama_est1==4 // Unspecified activities
		replace  unsp_sector=0 if inlist(rama_est1, 1, 2, 3)
			
//  Ask stata to calculate the percentage of AGRICULTURAL jobs at the municipal level.
			preserve
			collapse (mean) agri_sector [fweight=fac], by(ent_mun_per) 
			rename agri_sector agrishare_mun
			save "${root}/2_data-storage/municipal_data/sde_mun_agri.dta", replace
			restore
// 	Ask stata to calculate the percentage of INDUSTRIAL jobs at the municipal level.
			preserve
			collapse (mean) ind_sector [fweight=fac], by(ent_mun_per) 
			rename ind_sector indushare_mun
			save "${root}/2_data-storage/municipal_data/sde_mun_indu.dta", replace
			restore				
// 	Ask stata to calculate the percentage of SERVICE jobs at the municipal level.
			preserve
			collapse (mean) serv_sector [fweight=fac], by(ent_mun_per) 
			rename serv_sector servishare_mun
			save "${root}/2_data-storage/municipal_data/sde_mun_serv.dta", replace
			restore	
// 	Ask stata to calculate the percentage of UNSPECIFIEC activities at the municipal level.
			preserve
			collapse (mean) unsp_sector [fweight=fac], by(ent_mun_per) 
			rename unsp_sector unspeshare_mun
			save "${root}/2_data-storage/municipal_data/sde_mun_unsp.dta", replace
			restore	
			
			
// 	Now it is time to create the CONTROL VARIABLES at the municipal level. 			
			
/*  BUILDING CONTROL VARIABLE: Share of women with different education levels at the municipal level. 
 	Use the variable cs_p13_1 "educational level" to calculate the 
	Share of WOMEN with different level of education at the municipal level */
	fre cs_p13_1
	drop if cs_p13_1==.d // If i don't drop this missing values, the variables are not equal to 100. 

				generate w_educ_prim_orless=. 									// Women with primary school or less 
					replace w_educ_prim_orless=0 if cs_p13_1>=3 & female==1					
					replace w_educ_prim_orless=1 if cs_p13_1==2 & female==1
					replace w_educ_prim_orless=1 if cs_p13_1==1 & female==1
					replace w_educ_prim_orless=1 if cs_p13_1==0 & female==1
				generate w_educ_secon=. 										// Women with secondary school 
					replace w_educ_secon=0 if cs_p13_1>=0 & female==1		
					replace w_educ_secon=1 if cs_p13_1==3 & female==1 			// 3 = Secondary
				generate w_educ_high=.											// Share of women with high school 
					replace w_educ_high=0 if cs_p13_1>=0 & female==1		
					replace w_educ_high=1 if cs_p13_1==4 & female==1 			// 4 = High school
				generate w_educ_tech=.											// Share of women with techical career 
					replace w_educ_tech=0 if cs_p13_1>=0 & female==1
					replace w_educ_tech=1 if cs_p13_1==5 & female==1 			// 5 = Teacher traning college
					replace w_educ_tech=1 if cs_p13_1==6 & female==1 			// 6 =	Techical career	
				generate w_educ_grad=.											// Share of women with graduate degree
					replace w_educ_grad=0 if cs_p13_1>=0 & female==1
					replace w_educ_grad=1 if cs_p13_1==7 & female==1 			// 7 =	Bachelor's degree		
				generate w_educ_postg=.											// Share of women with post-graduate degree
					replace w_educ_postg=0 if cs_p13_1>=0 & female==1
					replace w_educ_postg=1 if cs_p13_1==8 & female==1 			// 8 = Masters's degree
					replace w_educ_postg=1 if cs_p13_1==9 & female==1 			// 9 = Ph.D. degree	
					 							
		//	Now ask stata to calculate the % of women with different level of education at the municipal level. 	
				preserve
					collapse (mean) w_educ_prim_orless [fweight=fac], by(ent_mun_per) 
					rename w_educ_prim_orless w_educ_mun_prim
					save "${root}/2_data-storage/municipal_data/w_educ_mun_prim.dta", replace
				restore
				
				preserve
					collapse (mean) w_educ_secon [fweight=fac], by(ent_mun_per) 
					rename w_educ_secon w_educ_mun_secon
					save "${root}/2_data-storage/municipal_data/w_educ_mun_secon.dta", replace
				restore
				
				preserve
					collapse (mean) w_educ_high [fweight=fac], by(ent_mun_per) 
					rename w_educ_high w_educ_mun_high
					save "${root}/2_data-storage/municipal_data/w_educ_mun_high.dta", replace
				restore
				
				preserve
					collapse (mean) w_educ_tech [fweight=fac], by(ent_mun_per) 
					rename w_educ_tech w_educ_mun_tech
					save "${root}/2_data-storage/municipal_data/w_educ_mun_tech.dta", replace
				restore
				
				preserve
					collapse (mean) w_educ_grad [fweight=fac], by(ent_mun_per) 
					rename w_educ_grad w_educ_mun_grad
					save "${root}/2_data-storage/municipal_data/w_educ_mun_grad.dta", replace
				restore
				
				preserve
					collapse (mean) w_educ_postg [fweight=fac], by(ent_mun_per) 
					rename w_educ_postg w_educ_mun_postg
					save "${root}/2_data-storage/municipal_data/w_educ_mun_postg.dta", replace
				restore


/*  BUILDING CONTROL VARIABLE: Share of women with different MARITAL STATUS at the municipal level.		
 	Using the variable e_con "marital status", create dummy variables to identify  
	different marital status of women */ 
		fre e_con
		drop if e_con==.d // If i don't drop this missing values, the variables are not equal to 100.
				generate 	w_freeunion=.
					replace w_freeunion=1 	if e_con==1 & female==1
					replace w_freeunion=0 	if e_con!=1 & female==1 
				generate 	w_separated=.
					replace w_separated=1 	if e_con==2 & female==1
					replace w_separated=0 	if e_con!=2 & female==1
				generate 	w_divorced=.
					replace w_divorced=1 	if e_con==3 & female==1
					replace w_divorced=0 	if e_con!=3 & female==1
				generate 	w_widowed=.
					replace w_widowed=1 	if e_con==4 & female==1
					replace w_widowed=0 	if e_con!=4 & female==1
				generate 	w_married=.
					replace w_married=1 	if e_con==5 & female==1
					replace w_married=0 	if e_con!=5 & female==1
				generate 	w_single=.
					replace w_single=1 		if e_con==6 & female==1
					replace w_single=0 		if e_con!=6 & female==1	

		
		//	Now ask stata to calculate the % of women with different level of education at the municipal level.
				
				preserve
				collapse (mean) w_freeunion [fweight=fac], by(ent_mun_per) 
				rename w_freeunion w_econ_mun_freeu
				save "${root}/2_data-storage/municipal_data/w_econ_mun_freeu.dta", replace
				restore
				
				preserve
				collapse (mean) w_separated [fweight=fac], by(ent_mun_per) 
				rename w_separated w_econ_mun_separ
				save "${root}/2_data-storage/municipal_data/w_econ_mun_separ.dta", replace
				restore
				
				preserve
				collapse (mean) w_divorced [fweight=fac], by(ent_mun_per)
				rename w_divorced w_econ_mun_divor 
				save "${root}/2_data-storage/municipal_data/w_econ_mun_divor.dta", replace
				restore
				
				preserve
				collapse (mean) w_widowed [fweight=fac], by(ent_mun_per) 
				rename w_widowed w_econ_mun_widow
				save "${root}/2_data-storage/municipal_data/w_econ_mun_widow.dta", replace
				restore
				
				preserve
				collapse (mean) w_married [fweight=fac], by(ent_mun_per) 
				rename w_married w_econ_mun_marri
				save "${root}/2_data-storage/municipal_data/w_econ_mun_marri.dta", replace
				restore
				
				preserve
				collapse (mean) w_single [fweight=fac], by(ent_mun_per)
				rename w_single w_econ_mun_singl 
				save "${root}/2_data-storage/municipal_data/w_econ_mun_singl.dta", replace
				restore
		

/*  BUILDING CONTROL VARIABLE: Share of women with different socio-economic stratum at the municipal level.		
 	Using the variable soc_str "socioeconomic stratum", create dummy variables to identify  
	women with different socio-economic stratum at the municipal level. */		
				generate w_stratum_low=.
					replace w_stratum_low=1 if soc_str==1 & female==1
					replace w_stratum_low=0 if soc_str!=1 & female==1					
				generate w_stratum_mlow=.
					replace w_stratum_mlow=1 if soc_str==2 & female==1
					replace w_stratum_mlow=0 if soc_str!=2 & female==1					
				generate w_stratum_mhigh=.
					replace w_stratum_mhigh=1 if soc_str==3 & female==1
					replace w_stratum_mhigh=0 if soc_str!=3 & female==1					
				generate w_stratum_high=.
					replace w_stratum_high=1 if soc_str==4 & female==1
					replace w_stratum_high=0 if soc_str!=4 & female==1
		//	Now ask stata to calculate the % of women with different level of education at the municipal level.
				preserve
				collapse (mean) w_stratum_low [fweight=fac], by(ent_mun_per) 
				rename w_stratum_low w_str_low
				save "${root}/2_data-storage/municipal_data/w_stratum_low_municipal.dta", replace
				restore
				
				preserve
				collapse (mean) w_stratum_mlow [fweight=fac], by(ent_mun_per) 
				rename w_stratum_mlow w_str_mlow
				save "${root}/2_data-storage/municipal_data/w_stratum_mlow_municipal.dta", replace
				restore
				
				preserve
				collapse (mean) w_stratum_mhigh [fweight=fac], by(ent_mun_per) 
				rename w_stratum_mhigh w_str_mhigh
				save "${root}/2_data-storage/municipal_data/w_stratum_mhigh_municipal.dta", replace
				restore
				
				preserve
				collapse (mean) w_stratum_high [fweight=fac], by(ent_mun_per) 
				rename w_stratum_high w_str_high
				save "${root}/2_data-storage/municipal_data/w_stratum_high_municipal.dta", replace
				restore				


/*  BUILDING CONTROL VARIABLE: Share of PEOPLE with different socio-economic stratum at the municipal level.		
 	Using the variable soc_str "socioeconomic stratum", create dummy variables to identify  
	people with different socio-economic stratum at the municipal level. */					
				generate stratum_low=.
					replace stratum_low=1 	if soc_str==1
					replace stratum_low=0 	if soc_str!=1					
				generate stratum_mlow=.
					replace stratum_mlow=1 	if soc_str==2
					replace stratum_mlow=0 	if soc_str!=2					
				generate stratum_mhigh=.
					replace stratum_mhigh=1 if soc_str==3
					replace stratum_mhigh=0 if soc_str!=3					
				generate stratum_high=.
					replace stratum_high=1 	if soc_str==4
					replace stratum_high=0 	if soc_str!=4	
		//	Now ask stata to calculate the % of women with different level of education at the municipal level.				
				preserve
				collapse (mean) stratum_low [fweight=fac], by(ent_mun_per) 
				rename stratum_low str_low
				save "${root}/2_data-storage/municipal_data/stratum_low_municipal.dta", replace
				restore
				
				preserve
				collapse (mean) stratum_mlow [fweight=fac], by(ent_mun_per) 
				rename stratum_mlow str_mlow
				save "${root}/2_data-storage/municipal_data/stratum_mlow_municipal.dta", replace
				restore
				
				preserve
				collapse (mean) stratum_mhigh [fweight=fac], by(ent_mun_per) 
				rename stratum_mhigh str_mhigh
				save "${root}/2_data-storage/municipal_data/stratum_mhigh_municipal.dta", replace
				restore
				
				preserve
				collapse (mean) stratum_high [fweight=fac], by(ent_mun_per) 
				rename stratum_high str_high
				save "${root}/2_data-storage/municipal_data/stratum_high_municipal.dta", replace
				restore				
				
				
	/* 	Use variable "p3o" to calculate the percentage of people that migrated 
		from their hometown to keep or obtain their current job. */
			preserve
			collapse (mean) p3o [fweight=fac], by(ent_mun_per) 
			rename p3o migra_mun
			save "${root}/2_data-storage/municipal_data/migra_mun.dta", replace
			restore

	/* 	Use variable "eda" to calculate the  
		average age of women at the municipal level */			
			preserve
			collapse (mean) eda if female==1 [fweight=fac], by(ent_mun_per) 
			rename eda w_mun_eda
			save "${root}/2_data-storage/municipal_data/w_mun_eda.dta", replace
			restore
			
	/* 	Use variable "n_hij" to calculate the average number of sons or 
		daughters at the municipal level for women between 20 and 35 years old.
		This will be used as a proxy of the fertility rate at the municipal level. */
			preserve
			collapse (mean) n_hij if female==1 & eda>19 & eda<36 [fweight=fac], by(ent_mun_per) 
			rename n_hij w_mun_nkids
			save "${root}/2_data-storage/municipal_data/w_mun_nkids.dta", replace
			restore			
	
	
			clear
			