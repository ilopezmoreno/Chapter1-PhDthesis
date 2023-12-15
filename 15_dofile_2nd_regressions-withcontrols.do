clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta"


global household_characteristics /// 
ib(1).ur 			/// Urban/rural identifier (Base category: 1. Living in urban areas)
ib(4).t_loc 		/// Locality population size (Base category: 4. Locality with less than 2,500 inhabitants)
ib(9).ent			//  Mexican state where the household is located - Fixed effect at the state level (Base category: 9. Mexico City) 
 
global individual_characteristics /// 
c.eda##c.eda 		/// Age and age squared
ib(5).e_con 		/// Marital status (Base category: 5. Being married)
ib(0).cs_p13_1 		/// Level of education (Base category: 0. No studies at all)
ib(4).soc_str 		//  Socio-economic stratum (Base category: 4. High socioeconomic stratum)









probit clase1 	/// 
c.sde_mun_agri##c.sde_mun_agri 	///
$household_characteristics 		///
$individual_characteristics 	///
ib(0).n_hij 	/// Number of sons or daughters (Base category: 0. No sons or daughters)
ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==1	///
[pweight=fac], 	///
vce(cluster count_entmun) 

probit clase1 	/// 
c.sde_mun_agri##c.sde_mun_agri 	///
$household_characteristics 		///
$individual_characteristics 	///
ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==0	///
[pweight=fac], 	///
vce(cluster count_entmun) 





probit clase1 	/// 
c.sde_mun_indu##c.sde_mun_indu 	///
$household_characteristics 		///
$individual_characteristics 	///
ib(0).n_hij 	/// Number of sons or daughters (Base category: 0. No sons or daughters)
ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==1	///
[pweight=fac], 	///
vce(cluster count_entmun) 

probit clase1 	/// 
c.sde_mun_indu##c.sde_mun_indu 	///
$household_characteristics 		///
$individual_characteristics 	///
ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==0	///
[pweight=fac], 	///
vce(cluster count_entmun) 






probit clase1 	/// 
c.sde_mun_serv##c.sde_mun_serv 	///
$household_characteristics 		///
$individual_characteristics 	///
ib(0).n_hij 	/// Number of sons or daughters (Base category: 0. No sons or daughters)
ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==1	///
[pweight=fac], 	///
vce(cluster count_entmun) 

probit clase1 	/// 
c.sde_mun_serv##c.sde_mun_serv 	///
$household_characteristics 		///
$individual_characteristics 	///
ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==0	///
[pweight=fac], 	///
vce(cluster count_entmun) 











