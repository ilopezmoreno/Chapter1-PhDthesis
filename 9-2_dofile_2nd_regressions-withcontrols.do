clear 
*global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta"


cd "${root}/4_outputs/regression_results"
capture mkdir 2_probit_sde_controls

cd "${root}/4_outputs/regression_results/2_probit_sde_controls"
capture mkdir regressions


global individual_characteristics /// 
c.eda##c.eda 		/// Age and age squared
ib(5).e_con 		/// Marital status (Base category: 5. Being married)
ib(0).cs_p13_1 		/// Level of education (Base category: 0. No studies at all)


global household_characteristics /// 
c.hh_eda 			/// Age of the household head
ib(1).ur 			/// Urban/rural identifier (Base category: 1. Living in urban areas)
ib(4).t_loc 		/// Locality population size (Base category: 4. Locality with less than 2,500 inhabitants)
ib(0).hh_cs_p13_1 	/// Level of education of the household head. (Base category: 0. No studies at all)
ib(0).hh_female 	/// Sex of the household head. Base category: 0 - Male 
ib(4).soc_str 		/// Socio-economic stratum (Base category: 4. High socioeconomic stratum)
ib(4).hh_members	/// Total of household members
ib(0).hh_kids		//  Presence of kids in the household. 


// PROBIT REGRESSIONS  
cd "${root}/4_outputs/regression_results/2_probit_sde_controls/regressions"


// Creating the loops 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	

foreach sde_mun of local sde 	{

probit clase1 					/// 
c.`sde_mun'				  		///
$individual_characteristics 	///
$household_characteristics 		///
ib(0).n_hij 	/// Number of sons or daughters (Base category: 0. No sons or daughters)
ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
ib(9).ent		/// Mexican state where the household is located - Fixed effect at the state level (Base category: 9. Mexico City)
if female==1	///
[pweight=fac], 	///
vce (robust)	// 
outreg2 using probit_sde_controls_05101519.xls, label dec(4) ctitle("Women")	
	
probit clase1 					/// 
c.`sde_mun'						///
$individual_characteristics 	///
$household_characteristics 		///
ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
ib(9).ent		/// Mexican state where the household is located - Fixed effect at the state level (Base category: 9. Mexico City)
if female==0	///
[pweight=fac], 	///
vce (robust)  	//
outreg2 using probit_sde_controls_05101519.xls, label dec(4) ctitle("Men")
									
									}

	
/*
iterate(4)
*/	