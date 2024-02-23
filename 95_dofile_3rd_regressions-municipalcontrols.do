clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"




use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta"

cd "${root}/4_outputs/regression_results"
capture mkdir 3_probit_sde_municipalcontrols


cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols"
capture mkdir regressions


global individual_characteristics /// 
c.eda##c.eda 		/// Age and age squared
ib(5).e_con 		/// Marital status (Base category: 5. Being married)
ib(0).cs_p13_1 		/// Level of education (Base category: 0. No studies at all)

global household_characteristics /// 
ib(4).soc_str 		/// Socio-economic stratum (Base category: 4. High socioeconomic stratum)
ib(4).hh_members	/// Total of household members
ib(0).hh_kids		//  Presence of kids in the household. 
c.hh_eda 			/// Age of the household head
ib(0).hh_cs_p13_1 	/// Level of education of the household head. (Base category: 0. No studies at all)
ib(0).hh_female 	/// Sex of the household head. Base category: 0 - Male 

global municipal_characteristics /// 
ib(1).ur 			/// Urban/rural identifier (Base category: 1. Living in urban areas)
ib(4).t_loc 		/// Locality population size (Base category: 4. Locality with less than 2,500 inhabitants)
c.migration_mun		/// % of residents in the municipality who migrated for their current job.
c.w_educ_mun_pr		/// % of women in the municipality with primary school or less
c.w_educ_mun_s		/// % of women in the municipality with secondary school 
c.w_educ_mun_h 		/// % of women in the municipality with high school 
c.w_econ_mun_singl 	/// % of women in the municipality that are single
c.w_econ_mun_marri 	/// % of women in the municipality that are married 
c.w_econ_mun_freeu 	/// % of women in the municipality that are in a free-union relationship
c.ss_mun_low 		/// % of people in the municipality from a low socioeconomic stratum
c.ss_mun_mlow		/// % of people in the municipality from a medium-low socioeconomic stratum
c.w_mun_nkids 		/// Average children per woman aged 20-35 in the municipality.
c.w_mun_eda 		//  Average age of women in the municipality



// PROBIT REGRESSIONS  
cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/regressions"

	// Creating the loop 
	local sde 		///
	sde_mun_agri 	///
	sde_mun_indu	/// 
	sde_mun_serv 	//
	
	
	foreach sde_mun of local sde {

	// REGRESSIONS FOR WOMEN
	// WITH MUNICIPAL CONTROLS AND WITHOUT INTERACTION (SDE##SDE)
	probit clase1 				/// 
	$individual_characteristics ///
	$household_characteristics 	///
	$municipal_characteristics 	///
	ib(0).n_hij 				/// Number of sons or daughters (Base category: 0. No sons or daughters)
	ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
	ib(9).ent					///  Mexican state where the household is located - Fixed effect at the state level (Base category: 9. Mexico City) 
	c.`sde_mun'	 				/// SECTORAL DISTRIBUTION OF EMPLOYMENT
	if female==1				///
	[pweight=fac], 				/// 
	vce(cluster count_entmun) 	// Clustered standard errors 
	outreg2 using 	probit_sde_05101519.xls, label dec(5) ctitle("Women")
	estimates save 	probit_sde_05101519_women_`sde_mun'.ster, replace	
		
	
	// REGRESSIONS FOR WOMEN
	// WITH MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
	probit clase1 				/// 
	$individual_characteristics ///
	$household_characteristics 	///
	$municipal_characteristics 	///
	ib(0).n_hij 				/// Number of sons or daughters (Base category: 0. No sons or daughters)
	ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
	ib(9).ent					///  Mexican state where the household is located - Fixed effect at the state level (Base category: 9. Mexico City) 
	c.`sde_mun'##c.`sde_mun'	/// SECTORAL DISTRIBUTION OF EMPLOYMENT
	if female==1				///
	[pweight=fac], 				/// 
	vce(cluster count_entmun) 	// Clustered standard errors 
	outreg2 using 	probit_sde_05101519.xls, label dec(5) ctitle("Women")
	estimates save 	probit_sde_05101519_womeninteraction_`sde_mun'.ster, replace	
	
	// REGRESSIONS FOR MEN 
	// WITHOUT MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
	probit clase1 				/// 
	$individual_characteristics ///
	$household_characteristics 	///
	ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
	ib(9).ent					///  Mexican state where the household is located - Fixed effect at the state level (Base category: 9. Mexico City) 
	c.`sde_mun'##c.`sde_mun'	/// SECTORAL DISTRIBUTION OF EMPLOYMENT 
	if female==0				///
	[pweight=fac],				/// 
	vce(cluster count_entmun) 	// Clustered standard errors 
	outreg2 using 	probit_sde_05101519.xls, label dec(5) ctitle("Men")
	estimates save 	probit_sde_05101519_meninteraction_`sde_mun'.ster, replace			
	
	}

 

 
/* 
 
 	// REGRESSIONS FOR MEN 
	// WITHOUT MUNICIPAL CONTROLS AND WITHOUT INTERACTION (SDE##SDE)
	probit clase1 	/// 
	$individual_characteristics 	///
	$household_characteristics 		///
	c.`sde_mun'	 	/// SECTORAL DISTRIBUTION OF EMPLOYMENT 
	ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
	if female==0	///
	[pweight=fac], 	/// 
	vce(cluster count_entmun) // Clustered standard errors 
	outreg2 using 	probit_sde_05101519.xls, label dec(4)
	estimates save 	probit_sde_05101519_men_`sde_mun'.ster, replace		

	// REGRESSION ALL TOGETHER.
	probit clase1 	/// 
	$individual_characteristics 	///
	$household_characteristics 		///
	c.`sde_mun'##i.female	 	/// SECTORAL DISTRIBUTION OF EMPLOYMENT interaction with sex
	ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
	[pweight=fac], 	/// 
	vce(cluster count_entmun) // Clustered standard errors 
	outreg2 using 	probit_sde_05101519.xls, label dec(4)
	estimates save 	probit_sde_05101519_together_`sde_mun'.ster, replace		
 
*/ 