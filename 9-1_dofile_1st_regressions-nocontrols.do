clear 
*global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta"


cd "${root}/4_outputs/regression_results"
capture mkdir 1_probit_sde_nocontrols

cd "${root}/4_outputs/regression_results/1_probit_sde_nocontrols"
capture mkdir regressions


// PROBIT REGRESSIONS  
cd "${root}/4_outputs/regression_results/1_probit_sde_nocontrols/regressions"

	// Creating the loops 
	local sde ///
	sde_mun_agri sde_mun_indu sde_mun_serv 	

	local sexs ///
	1 0
	
	
	foreach sde_mun of local sde {
		foreach sex of local sexs {
		
			probit clase1 				/// 
			c.`sde_mun' 				///
			ib(9).ent 					/// State fixed effects to control unobserved heterogeneity. Base category: 9 "Mexico City" 
			ib(1).per 					/// Year fixed effects to control for unobserved heterogeneity across years/quarters. Base category: 1st quarter of 2016
			if female==`sex'			/// 
			[pweight=fac], 				///
			vce (robust)			 	//
			outreg2 using probit_sde_nocontrols_05101519.xls, label dec(4) ctitle("`sde_mun' `sex'")
												}
												}

								
												
												
/*												
									
									
			probit clase1 				/// 
			c.`sde_mun' 				///
			if female==1 				///
			ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
			[pweight=fac], 				///
			vce(cluster count_entmun) 									
			outreg2 using probit_sde_nocontrols_05101519.xls, label dec(5)

			probit clase1 				/// 
			c.`sde_mun' 				///
			if female==0 & per==4		///
			[pweight=fac], 				///
			vce(cluster count_entmun) 
			outreg2 using probit_sde_nocontrols_05101519.xls, label dec(5)
			
			probit clase1 				/// 
			c.`sde_mun' 				///
			if female==0 				///
			ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
			[pweight=fac], 				///
			vce(cluster count_entmun) 									
			outreg2 using probit_sde_nocontrols_05101519.xls, label dec(5)
									
									
								}



probit clase1 				/// 
c.sde_mun_agri 				///
if female==0 & per==4		///
[pweight=fac], 				///
vce(cluster count_entmun) 

probit clase1 				/// 
c.sde_mun_indu 				///
if female==1 & per==4		///
[pweight=fac], 				///
vce(cluster count_entmun) 

probit clase1 				/// 
c.sde_mun_indu 				///
if female==0 & per==4		///
[pweight=fac], 				///
vce(cluster count_entmun) 


probit clase1 				/// 
c.sde_mun_serv 				///
if female==1 & per==4		///
[pweight=fac], 				///
vce(cluster count_entmun) 

probit clase1 				/// 
c.sde_mun_serv 				///
if female==0 & per==4		///
[pweight=fac], 				///
vce(cluster count_entmun) 




probit clase1 				/// 
c.sde_mun_agri 				///
ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==1 				///
[pweight=fac], 				///
vce(cluster count_entmun) 

probit clase1 				/// 
c.sde_mun_agri 				///
ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==0				///
[pweight=fac], 				///
vce(cluster count_entmun) 

probit clase1 				/// 
c.sde_mun_indu 				///
ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==1				///
[pweight=fac], 				///
vce(cluster count_entmun) 

probit clase1 				/// 
c.sde_mun_indu 				///
ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==0 				///
[pweight=fac], 				///
vce(cluster count_entmun) 


probit clase1 				/// 
c.sde_mun_serv 				///
ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==1 				///
[pweight=fac], 				///
vce(cluster count_entmun) 

probit clase1 				/// 
c.sde_mun_serv 				///
ib(4).per					/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==0				///
[pweight=fac], 				///
vce(cluster count_entmun) 





probit clase1 					/// 
c.sde_mun_agri##c.sde_mun_agri 	///
ib(4).per						/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==1 					///
[pweight=fac], 					///
vce(cluster count_entmun) 

probit clase1 					/// 
c.sde_mun_agri##c.sde_mun_agri 	///
ib(4).per						/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==0					///
[pweight=fac], 					///
vce(cluster count_entmun) 


probit clase1 					/// 
c.sde_mun_indu##c.sde_mun_indu	///
ib(4).per						/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==1 					///
[pweight=fac], 					///
vce(cluster count_entmun) 

probit clase1 					/// 
c.sde_mun_indu##c.sde_mun_indu	///
ib(4).per						/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==0					///
[pweight=fac], 					///
vce(cluster count_entmun) 


probit clase1 					/// 
c.sde_mun_serv##c.sde_mun_serv 	///
ib(4).per						/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==1 					///
[pweight=fac], 					///
vce(cluster count_entmun) 

probit clase1 					/// 
c.sde_mun_serv##c.sde_mun_serv 	///
ib(4).per						/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
if female==0					///
[pweight=fac], 					///
vce(cluster count_entmun) 

*/