clear 

*global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

use "$root/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta" 
drop _merge


cd "$root/2_data-storage"
capture mkdir robustness_check


cd "$root"



// 	Create the variable "agri_share" to identify people working in agriculture.
		generate agri_share=.
		replace  agri_share=1 if rama_est1==1 // Primary sector (Agriculture)
		replace  agri_share=0 if inlist(rama_est1, 2, 3, 4) 
		
// 	Create the variable "non_agri_share" to identify people that are not working in agriculture.
		generate non_agri_share=.
		replace  non_agri_share=0 if rama_est1==1 // Primary sector (Agriculture)
		replace  non_agri_share=1 if inlist(rama_est1, 2, 3, 4) 
		
// 	Create the variable "non_agri_formal" to exclude people with informal jobs in industry and services. (Roncolato 2016)
		generate non_agri_formal=.
		replace  non_agri_formal=0 if rama_est1==1 // Primary sector (Agriculture)
		replace  non_agri_formal=1 if rama_est1==2 & emp_ppal==2
		replace  non_agri_formal=1 if rama_est1==3 & emp_ppal==2
		replace  non_agri_formal=1 if rama_est1==4 & emp_ppal==2
		
		

		
		
//  Ask stata to calculate the percentage of AGRICULTURAL jobs at the municipal level.
			preserve
			collapse (mean) agri_share [fweight=fac], by(ent_mun_per) 
			generate agri_share_mun = (agri_share * 100) 
			drop agri_share
			save "${root}/2_data-storage/robustness_check/agri_share_mun.dta", replace
			restore
			
// 	Ask stata to calculate the percentage of NON-AGRICULTURAL jobs at the municipal level.
			preserve
			collapse (mean) non_agri_share [fweight=fac], by(ent_mun_per) 
			generate non_agri_share_mun = (non_agri_share * 100) 
			drop non_agri_share
			save "${root}/2_data-storage/robustness_check/non_agri_share_mun.dta", replace
			restore	
			
			
// 	Ask stata to calculate the percentage of FORMAL NON-AGRICULTURAL jobs at the municipal level.
			preserve
			collapse (mean) non_agri_formal [fweight=fac], by(ent_mun_per) 
			generate non_agri_formal_mun = (non_agri_formal * 100) 
			drop non_agri_formal
			save "${root}/2_data-storage/robustness_check/non_agri_formal_mun.dta", replace
			restore				
			
			
			
			
			
			
			
cd "${root}/2_data-storage/robustness_check"
						
// 	Ask stata to merge the datasets using "ent_mun_per" as the key variable
			merge m:1 ent_mun_per using     agri_share_mun,  generate(merge_agrishare) 
			merge m:1 ent_mun_per using non_agri_share_mun,  generate(merge_non_agrishare)
			merge m:1 ent_mun_per using non_agri_formal_mun, generate(merge_non_agri_formal_mun)
			summarize merge_agrishare merge_non_agrishare merge_non_agri_formal_mun
			drop merge_agrishare merge_non_agrishare merge_non_agri_formal_mun
			
			summarize agri_share_mun non_agri_share_mun // Average share of agricultural jobs at the municipal level
			summarize agri_share_mun non_agri_share_mun if ur==0 // Average share of agricultural jobs at the municipal level in rural areas
			summarize agri_share_mun non_agri_share_mun if t_loc==4 // Average share of agricultural jobs at the municipal level in small localities of Chiapas
			summarize agri_share_mun non_agri_share_mun if t_loc==4 & ent==7 // Average share of agricultural jobs at the municipal level in small localities of Chiapas

			summarize non_agri_formal_mun
			
// Data quality check.			
// Ask stata to generate a variable to confirm that the sum of agri_share_mun + non_agri_share_mun is always equal to 100
			generate total_share = agri_share_mun + non_agri_share_mun
			fre 	 total_share // Data quality check: All cases are equal to 100
			drop 	 total_share 
			

			
			
			
			
			
			
			

			
			
			
			
// Regression analysis based on the empirical strategy of Roncolato (2016)

cd "${root}/4_outputs/"	
capture mkdir robustness_check 		
cd "${root}/4_outputs/robustness_check"
						

fre p2e	
fre p2g2					


drop if  p2e==2  // Drop students from the sample
drop if  p2e==5  // Drop people with disabilities from the sample			
drop if p2g2==7  // Drop people that are not working because they are recovering from a disease or an accident.			
drop if  eda>=66 // Drop people that are above 65 years old.
fre eda 		 // Data quality check: Now the sample is restricted to individual between 15 and 65 years old. 


// Regression with control variables.	
probit clase1 								/// Dummy variable to capture if the individual is economically active
c.non_agri_share_mun##c.non_agri_share_mun	/// Share of non-agricultural jobs at the municipal level (squared)
c.eda##c.eda 								/// Age and age squared
ib(5).e_con 								/// Marital status (Base category: 5. Being married)
ib(0).cs_p13_1 								/// Level of education (Base category: 0. No studies at all) 	
c.hh_eda 									/// Age of the household head
ib(1).ur 									/// Urban/rural identifier (Base category: 1. Living in urban areas)
ib(4).t_loc 								/// Locality population size (Base category: 4. Locality with less than 2,500 inhabitants)
ib(0).hh_cs_p13_1 							/// Level of education of the household head. (Base category: 0. No studies at all)
ib(0).hh_female 							/// Sex of the household head. Base category: 0 - Male 
ib(4).soc_str 								/// Socio-economic stratum (Base category: 4. High socioeconomic stratum)
ib(4).hh_members							/// Total of household members
ib(0).hh_kids								///  Presence of kids in the household. 			
c.migration_mun								/// % of residents in the municipality who migrated for their current job.
c.w_educ_mun_pr								/// % of women in the municipality with primary school or less
c.w_educ_mun_s								/// % of women in the municipality with secondary school 
c.w_educ_mun_h 								/// % of women in the municipality with high school 
c.w_econ_mun_singl 							/// % of women in the municipality that are single
c.w_econ_mun_marri 							/// % of women in the municipality that are married 
c.w_econ_mun_freeu 							/// % of women in the municipality that are in a free-union relationship
c.ss_mun_low 								/// % of people in the municipality from a low socioeconomic stratum
c.ss_mun_mlow								/// % of people in the municipality from a medium-low socioeconomic stratum
c.w_mun_nkids 								/// Average children per woman aged 20-35 in the municipality.
c.w_mun_eda 								/// Average age of women in the municipality			
if female==1								/// Regression restricted to women
[pweight=fac], 								/// Weight variable
vce(cluster count_entmun) 					//  Clustered standard errors 
outreg2 using 	nonagrishare_05101519.xls, label dec(5) ctitle("Women")
estimates save 	nonagrishare_05101519.ster, replace



margins, at(non_agri_share_mun=(0(2)100)) atmeans post 
outreg2 using  margins_nonagrishare_05101519.xls, label dec(4)
estimates save margins_nonagrishare_05101519.ster, replace 




marginsplot, 																														///
title("Predicted probability that mexican women are economically active depending" 													///
	  "on the % of non-agricultural jobs in the municipality where they live") title(, size(small)) 								///
ytitle("Predicted probability") ytitle(, size(vsmall)) 																				///
xtitle("Percentage of non-agricultural jobs as a share of total employment") xtitle(, size(vsmall)) 								///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) 																					///
ylabel(0(0.1)1) 																													///
xlabel(0(20)100) 																													///
plotopts(msize(vsmall)) 																											///
legend(size(vsmall)) 																												///
graphregion(color(white)) 
graph save "Graph"  "${root}/4_outputs/robustness_check/marginsplot_robustness_check_sde_05101519_women.gph", replace
graph export 		"${root}\4_outputs\robustness_check\marginsplot_robustness_check_sde_05101519_women.png", replace			
			
			
			
