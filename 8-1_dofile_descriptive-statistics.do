clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta"	


// Missing value report
misstable summarize clase1 /// 


sde_mun_agri sde_mun_indu sde_mun_serv sde_mun_unsp eda 

// Descriptive statistics 

// Dependent variable: Economically active. 0=No, 1=Yes
bysort female: summarize clase1  

// Sectoral distribution of employment
bysort female: summarize sde_mun_agri sde_mun_indu sde_mun_serv sde_mun_unsp  

// Individual characteristics 
bysort female: summarize eda

// Individual characteristics
bysort female: fre e_con 

// Individual characteristics
bysort female: fre cs_p13_1 

// Household characteristics 
bysort female: summarize ur


// Household characteristics 
bysort female: summarize hh_members hh_kids ur							

// Household characteristics 
bysort female: fre t_loc

// Household characteristics 
bysort female: fre soc_str

// Household head characteristics 

	



bysort female:  summarize 							/// 
clase1 												/// Economically active. 0=No, 1=Yes
sde_mun_agri sde_mun_indu sde_mun_serv sde_mun_unsp 
eda sex												/// Individual characteristics
hh_members   hh_female 			 	/// Household characteristics
migration_mun w_educ_mun_pr w_educ_mun_s			/// Municipal characteristics
w_educ_mun_h w_econ_mun_singl w_econ_mun_marri		/// Municipal characteristics
w_econ_mun_freeu ss_mun_low ss_mun_mlow				/// Municipal characteristics
w_mun_nkids w_mun_eda								//  Municipal characteristics

// Descriptive statistics of categorical variables

bysort female: tab e_con

bysort female: tab cs_p13_1

bysort female: tab hh_cs_p13_1 

bysort female: fre t_loc



