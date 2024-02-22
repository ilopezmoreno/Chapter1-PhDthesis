clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta"

cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols"
capture mkdir margins_results


 
// MARGINS

clear // 
use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta" // Charge the dataset 


// AVERAGE MARGINAL EFFECTS FOR WOMEN
// WITH MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
// Creating loop 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	

foreach sde_mun of local sde {
	
	// Indicate the working directory where the regression results were saved.
	cd	"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/regressions" 
	estimates use probit_sde_05101519_womeninteraction_`sde_mun'.ster // Ask stata to open the regression results 
	estimates esample:
	probit // Indicate stata that the regression results were obtained using the command "probit"
	
	// Now that you have the regression results, you can ask stata to calculate the average marginal effects
	margins, at(`sde_mun'=(0(1)100)) atmeans post
	// Now ask stata to save the estimation results 
	cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/margins_results"
	outreg2 using  margins_probit_sde_05101519_womeninteraction_`sde_mun'.xls, label dec(4)
	estimates save margins_probit_sde_05101519_womeninteraction_`sde_mun'.ster, replace 
							  }

							  
							  
// AVERAGE MARGINAL EFFECTS FOR MEN
// WITHOUT MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
// Creating loop 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	
foreach sde_mun of local sde {
	// Indicate the working directory where the regression results were saved.
	cd	"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/regressions" 
	estimates use probit_sde_05101519_meninteraction_`sde_mun'.ster // Ask stata to open the regression results 
	estimates esample:
	probit // Indicate stata that the regression results were obtained using the command "probit"
	
	// Now that you have the regression results, you can ask stata to calculate the average marginal effects
	margins, at(`sde_mun'=(0(1)100)) atmeans post
	// Now ask stata to save the estimation results 
	cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/margins_results"
	outreg2 using  margins_probit_sde_05101519_meninteraction_`sde_mun'.xls, label dec(4)
	estimates save margins_probit_sde_05101519_meninteraction_`sde_mun'.ster, replace 
							  }

							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
/*							  
							  
							  
// AVERAGE MARGINAL EFFECTS FOR MEN
// WITH MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
// Missing 							  
							  
							  
							  
// AVERAGE MARGINAL EFFECTS - ALL TOGETHER
// MEN AND WOMEN (SDE##FEMALE)
// Creating loop 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	
foreach sde_mun of local sde {
	cd	"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/regressions" // Indicate the working directory where the regression results were saved.
	estimates use probit_sde_05101519_together_`sde_mun'.ster // Ask stata to open the regression results 
	estimates esample:
	probit // Indicate stata that the regression results were obtained using the command "probit"
	
	// Now that you have the regression results, you can ask stata to calculate the average marginal effects
	margins, at(`sde_mun'=(0(1)100)) atmeans post
	// Now ask stata to save the estimation results 
	cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/margins_results"
	outreg2 using  margins_probit_sde_05101519_together_`sde_mun'.xls, label dec(4)
	estimates save margins_probit_sde_05101519_together_`sde_mun'.ster, replace 
							  }

							  
							  
*/							  
							  
							  
							  
							  
							  
							  
/*							  
							  
							  
// AVERAGE MARGINAL EFFECTS FOR WOMEN
// WITH MUNICIPAL CONTROLS AND WITHOUT INTERACTION (SDE##SDE)					  
// Creating loop 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	
foreach sde_mun of local sde {
	cd	"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/regressions" // Indicate the working directory where the regression results were saved.
	estimates use probit_sde_05101519_women_`sde_mun'.ster // Ask stata to open the regression results 
	estimates esample:
	probit // Indicate stata that the regression results were obtained using the command "probit"
	
	// Now that you have the regression results, you can ask stata to calculate the average marginal effects
	margins, at(`sde_mun'=(0(1)100)) atmeans post
	// Now ask stata to save the estimation results 
	cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/margins_results"
	outreg2 using  margins_probit_sde_05101519_women_`sde_mun'.xls, label dec(4)
	estimates save margins_probit_sde_05101519_women_`sde_mun'.ster, replace 
							  }							  
							  
							  
							  
*/							  
