clear
**# Se necesita cambiar este global "root" por otro nombre
global 	root "C:/Users/d57917il/Documents/1paper1/ENOE_2005q1 - 2019q1" 
**# Se necesita asociar el folder "root" al folder donde se ubicaran las bases de datos.
global 	tidy_data "C:/Users/d57917il/Documents/1paper1/ENOE_2005q1/2_databases/final"
cd 		"$tidy_data"			
use 	tidydata_2005q1

tab per, nolabel // Data quality check: All observations are equal to 105, which mean we are using the dataset for the 1st quarter of 2005

global municipal_characteristics /// 
c.migration_mun		/// % of residents in the municipality who migrated for their current job.
c.w_educ_mun_pr		/// % of women in the municipality with primary school or less
c.w_educ_mun_s		/// % of women in the municipality with secondary school 
c.w_educ_mun_h 		/// % of women in the municipality with high school 
c.w_econ_mun_sing 	/// % of women in the municipality that are single
c.w_econ_mun_mafr 	/// % of women in the municipality that are married or in a free-union relationship
c.ss_mun_low 		/// % of people in the municipality from a low socioeconomic stratum
c.ss_mun_mlow		/// % of people in the municipality from a medium-low socioeconomic stratum
c.w_mun_nkids 		/// Average children per woman aged 20-35 in the municipality.
c.w_mun_eda 		//  Average age of women in the municipality


global household_characteristics /// 
ib(1).ur 			/// Urban/rural identifier (Base category: 1. Living in urban areas)
ib(4).t_loc 		/// Locality population size (Base category: 4. Locality with less than 2,500 inhabitants)
ib(9).ent			//  Mexican state where the household is located - Fixed effect at the state level (Base category: 9. Mexico City) 
 
global individual_characteristics /// 
c.eda##c.eda 		/// Age and age squared
ib(5).e_con 		/// Marital status (Base category: 5. Being married)
ib(0).cs_p13_1 		/// Level of education (Base category: 0. No studies at all)
ib(40).soc_str 		//  Socio-economic stratum (Base category: 40. High socioeconomic stratum)
**# Se necesita cambiar el codigo de 40 a 4 en socio economic stratum



probit clase1 /// 
c.sde_mun_agri##c.sde_mun_agri ///
$municipal_characteristics ///
$household_characteristics ///
$individual_characteristics ///
ib(0).num_kids /// Number of sons or daughters (Base category: 0. No sons or daughters)
if female==1 & eda>=15 ///
[pweight=fac], ///
vce(cluster count_entmun) 

margins, at(sde_mun_agri=(0(1)100)) atmeans post
marginsplot 
graph export "$marginsplot\women_sde_agriculture.png", replace
graph save "Graph" "$marginsplot\women_sde_agriculture.gph", replace
**# Falta crear el comando global para marginsplot



probit clase1 /// 
c.sde_mun_agri##c.sde_mun_agri ///
$municipal_characteristics ///
$household_characteristics ///
$individual_characteristics ///
ib(0).num_kids /// Number of sons or daughters (Base category: 0. No sons or daughters)
if female==1 & eda>=15 ///
[pweight=fac], ///
vce(cluster count_entmun) 

margins, at(sde_mun_agri=(0(1)100)) atmeans post
marginsplot 
graph export "$marginsplot\women_sde_agriculture.png", replace
graph save "Graph" "$marginsplot\women_sde_agriculture.gph", replace
**# Falta crear el comando global para marginsplot























**# Bookmark #5 - Hace falta agregar la interaccion c.sde_mun_agri#c.sde_mun_agri   

// Regression: Probability that WOMEN work depending on the % of AGRICULTURAL jobs in their municipality  
probit clase1 /// 
c.sde_mun_agri ///
$municipal_characteristics ///
$household_characteristics ///
$individual_characteristics ///
ib(0).num_kids /// Number of sons or daughters (Base category: 0. No sons or daughters)
if female==1 & eda>=15 ///
[pweight=fac], ///
vce(cluster count_entmun) 



// Regression: Probability that MEN work depending on the % of AGRICULTURAL jobs in their municipality  
probit clase1 /// 
c.sde_mun_agri ///
$household_characteristics ///
$individual_characteristics ///
if female==0 & eda>=15 ///
[pweight=fac], ///
vce(cluster count_entmun) 








**# Bookmark #2
probit clase1 /// 
c.sde_mun_agri ///
$municipal_characteristics ///
$household_characteristics ///
$individual_characteristics ///
if female==0 & eda>=15 /// Restricting the regression to men above 15 years old.
[pweight=fac], /// Including probability weights in the regression. 
vce(cluster count_entmun) // Clustering standard errors at the municipal level