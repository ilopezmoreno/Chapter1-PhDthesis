clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta"



probit clase1 				/// 
c.sde_mun_agri 				///
if female==1 & per==4		///
[pweight=fac], 				///
vce(cluster count_entmun) 

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

