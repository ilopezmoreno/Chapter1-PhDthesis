clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"




use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta"

cd "${root}/4_outputs/regression_results"
capture mkdir probit_sde
cd "${root}/4_outputs/regression_results/probit_sde"
capture mkdir regressions
capture mkdir margins_results
capture mkdir marginsplots










global municipal_characteristics /// 
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

global household_characteristics /// 
ib(1).ur 			/// Urban/rural identifier (Base category: 1. Living in urban areas)
ib(4).t_loc 		/// Locality population size (Base category: 4. Locality with less than 2,500 inhabitants)
ib(9).ent			//  Mexican state where the household is located - Fixed effect at the state level (Base category: 9. Mexico City) 
 
global individual_characteristics /// 
c.eda##c.eda 		/// Age and age squared
ib(5).e_con 		/// Marital status (Base category: 5. Being married)
ib(0).cs_p13_1 		/// Level of education (Base category: 0. No studies at all)
ib(4).soc_str 		//  Socio-economic stratum (Base category: 4. High socioeconomic stratum)














// PROBIT REGRESSIONS  
cd "${root}/4_outputs/regression_results/probit_sde/regressions"

	// Creating the loop 
	local sde 		///
	sde_mun_agri 	///
	sde_mun_indu	/// 
	sde_mun_serv 	
	
	
	foreach sde_mun of local sde {

	// REGRESSIONS FOR WOMEN
	// WITH MUNICIPAL CONTROLS AND WITHOUT INTERACTION (SDE##SDE)
	probit clase1 	/// 
	$municipal_characteristics 		///
	$individual_characteristics 	///
	$household_characteristics 		///
	ib(0).n_hij 	/// Number of sons or daughters (Base category: 0. No sons or daughters)
	c.`sde_mun'	 	/// SECTORAL DISTRIBUTION OF EMPLOYMENT
	ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
	if female==1	///
	[pweight=fac], 	/// 
	vce(cluster count_entmun) // Clustered standard errors 
	outreg2 using 	probit_sde_05101519.xls, label dec(5)
	estimates save 	probit_sde_05101519_women_`sde_mun'.ster, replace	
		
	
	// REGRESSIONS FOR WOMEN
	// WITH MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
	probit clase1 	/// 
	$municipal_characteristics 		///
	$individual_characteristics 	///
	$household_characteristics 		///
	ib(0).n_hij 	/// Number of sons or daughters (Base category: 0. No sons or daughters)
	c.`sde_mun'##c.`sde_mun'	 	/// SECTORAL DISTRIBUTION OF EMPLOYMENT
	ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
	if female==1	///
	[pweight=fac], 	/// 
	vce(cluster count_entmun) // Clustered standard errors 
	outreg2 using 	probit_sde_05101519.xls, label dec(5)
	estimates save 	probit_sde_05101519_womeninteraction_`sde_mun'.ster, replace	
	
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
	
	// REGRESSIONS FOR MEN 
	// WITHOUT MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
	probit clase1 	/// 
	$individual_characteristics 	///
	$household_characteristics 		///
	c.`sde_mun'##c.`sde_mun'	 	/// SECTORAL DISTRIBUTION OF EMPLOYMENT 
	ib(4).per		/// Year/quarter fixed effect (Base category: 4. 1st quarter of 2019)
	if female==0	///
	[pweight=fac], 	/// 
	vce(cluster count_entmun) // Clustered standard errors 
	outreg2 using 	probit_sde_05101519.xls, label dec(4)
	estimates save 	probit_sde_05101519_meninteraction_`sde_mun'.ster, replace			
		
	}

 

 
 
 
 

 
 
 
 
 
 
 
// MARGINS

clear // 
use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta" // Charge the dataset 


// AVERAGE MARGINAL EFFECTS FOR WOMEN
// WITH MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
// Creating loop 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	
foreach sde_mun of local sde {
	cd	"${root}/4_outputs/regression_results/probit_sde/regressions" // Indicate the working directory where the regression results were saved.
	estimates use probit_sde_05101519_womeninteraction_`sde_mun'.ster // Ask stata to open the regression results 
	estimates esample:
	probit // Indicate stata that the regression results were obtained using the command "probit"
	
	// Now that you have the regression results, you can ask stata to calculate the average marginal effects
	margins, at(`sde_mun'=(0(1)100)) atmeans post
	// Now ask stata to save the estimation results 
	cd "${root}/4_outputs/regression_results/probit_sde/margins_results"
	outreg2 using  margins_probit_sde_05101519_womeninteraction_`sde_mun'.xls, label dec(4)
	estimates save margins_probit_sde_05101519_womeninteraction_`sde_mun'.ster, replace 
							  }


// AVERAGE MARGINAL EFFECTS FOR WOMEN
// WITH MUNICIPAL CONTROLS AND WITHOUT INTERACTION (SDE##SDE)					  
// Creating loop 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	
foreach sde_mun of local sde {
	cd	"${root}/4_outputs/regression_results/probit_sde/regressions" // Indicate the working directory where the regression results were saved.
	estimates use probit_sde_05101519_women_`sde_mun'.ster // Ask stata to open the regression results 
	estimates esample:
	probit // Indicate stata that the regression results were obtained using the command "probit"
	
	// Now that you have the regression results, you can ask stata to calculate the average marginal effects
	margins, at(`sde_mun'=(0(1)100)) atmeans post
	// Now ask stata to save the estimation results 
	cd "${root}/4_outputs/regression_results/probit_sde/margins_results"
	outreg2 using  margins_probit_sde_05101519_women_`sde_mun'.xls, label dec(4)
	estimates save margins_probit_sde_05101519_women_`sde_mun'.ster, replace 
							  }							  
							  						  
													  
// AVERAGE MARGINAL EFFECTS FOR MEN
// WITH MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
// Creating loop 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	
foreach sde_mun of local sde {
	cd	"${root}/4_outputs/regression_results/probit_sde/regressions" // Indicate the working directory where the regression results were saved.
	estimates use probit_sde_05101519_meninteraction_`sde_mun'.ster // Ask stata to open the regression results 
	estimates esample:
	probit // Indicate stata that the regression results were obtained using the command "probit"
	
	// Now that you have the regression results, you can ask stata to calculate the average marginal effects
	margins, at(`sde_mun'=(0(1)100)) atmeans post
	// Now ask stata to save the estimation results 
	cd "${root}/4_outputs/regression_results/probit_sde/margins_results"
	outreg2 using  margins_probit_sde_05101519_meninteraction_`sde_mun'.xls, label dec(4)
	estimates save margins_probit_sde_05101519_meninteraction_`sde_mun'.ster, replace 
							  }
							  
							  
// AVERAGE MARGINAL EFFECTS FOR MEN
// WITH MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)
// Missing 							  
							  
							  
							  
					  
							  
							  
	
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  


// MARGINSPLOT
/*
Running the command "margins" takes a lot of time to stata. 
Usually, Stata only allows to use the command "marginsplot" inmediately after using the command "margins".
This is problematic, because I created loops to run both the "probit" and the "margins" command. 
However, there are some steps that I will follow to load the results obtained from the loops I created to use the command "margins".  

To load the results obtained with the command "margins" (also known as average marginal effects), 
I need to start by asking Stata to clear the interface. 
*/
clear 
// Next step is to ask Stata to open the dataset that was used to obtained the margins results.
use "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-municipal.dta"
// Next step is to change the working directory to the path where the margins results were stored in my computer. 
cd "${root}/4_outputs/regression_results/probit_sde/margins_results"


/* The next and final step is to ask Stata to open the regressions results that were stored in the .ster format. 
   Then, you need to indicate that those results were obtained using the command "margins"  */

   
   
// Creating the loops
// MARGINSPLOT FOR WOMEN
// WITH MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)

local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	

	foreach sde_mun of local sde {
	estimates use margins_probit_sde_05101519_womeninteraction_`sde_mun'.ster
	margins // This indicates Stata that the results were obtained using this command. 

	// After following these steps, you can ask stata to run the command "marginsplot"
	marginsplot, ///
	title("Predicted probability that mexican women are economically active" "depending on the % of XYZ jobs in the municipality where they live") title(, size(small)) ///
	ytitle("Predicted probability") ytitle(, size(vsmall)) ///
	xtitle("Percentage of XYZ jobs in the municipality where they live") xtitle(, size(vsmall)) ///
	ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) ///
	ylabel(0(0.1)1) ///
	xlabel(0(20)100) ///
	plotopts(msize(vsmall)) ///
	legend(size(vsmall)) ///
	graphregion(color(white)) 
	graph save "Graph" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.gph", replace
	graph close 
	
	graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.gph"
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(width(vthin))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(size(tiny)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(symbol(smsquare)) editcopy
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(pink))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(pink)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(pink))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle line(color(pink)) editcopy
	graph save "Graph" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.gph", replace
	graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.png", replace 
	graph close
	}


// Creating the loops
// MARGINSPLOT FOR MEN
// WITHOUT MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)

local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	

	foreach sde_mun of local sde {
	estimates use margins_probit_sde_05101519_meninteraction_`sde_mun'.ster
	margins // This indicates Stata that the results were obtained using this command. 

	// After following these steps, you can ask stata to run the command "marginsplot"
	marginsplot, ///
	title("Predicted probability that mexican men are economically active" "depending on the % of XYZ jobs in the municipality where they live") title(, size(small)) ///
	ytitle("Predicted probability") ytitle(, size(vsmall)) ///
	xtitle("Percentage of XYZ jobs in the municipality where they live") xtitle(, size(vsmall)) ///
	ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) ///
	ylabel(0(0.1)1) ///
	xlabel(0(20)100) ///
	plotopts(msize(vsmall)) ///
	legend(size(vsmall)) ///
	graphregion(color(white)) 
	graph save "Graph" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.gph", replace
	graph close 
	
	graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.gph"
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(width(vthin))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(size(tiny)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(symbol(smsquare)) editcopy
	graph save "Graph" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.gph", replace
	graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.png", replace 
	graph close
	}


	
	
// Editing the marginsplots 

// WOMEN AGRICULTURE	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_agri.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican women are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of agricultural jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of agricultural jobs in the municipality where they live
graph save "graph1" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_agri.gph", replace 
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_agri.png", replace 

// WOMEN INDUSTRY	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_indu.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican women are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of industrial jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of industrial jobs in the municipality where they live
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_indu.png", replace 
graph save "graph2" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_indu.gph", replace 	

// WOMEN SERVICES
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_serv.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican women are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of service jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of service jobs in the municipality where they live
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_serv.png", replace 
graph save "graph3" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_serv.gph", replace 
	
// MEN AGRICULTURE	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_agri.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican men are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of agricultural jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of agricultural jobs in the municipality where they live
graph save "graph4" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_agri.gph", replace 
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_agri.png", replace 	
	
// MEN INDUSTRY	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_indu.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican men are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of industrial jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of industrial jobs in the municipality where they live
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_indu.png", replace 
graph save "graph5" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_indu.gph", replace 	

// MEN SERVICES
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_serv.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican men are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of service jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of service jobs in the municipality where they live
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_serv.png", replace 
graph save "Graph" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_serv.gph", replace
	
	

	
// WOMEN AGRICULTURE	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_agri.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Women - Agriculture
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_agriculture.png", replace 
graph save "graph1" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_agriculture.gph", replace


// WOMEN INDUSTRY	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_indu.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Women - Industry 
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_industry.png", replace 
graph save "graph2" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_industry.gph", replace


// WOMEN SERVICES	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_serv.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Women - Services 
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_services.png", replace 
graph save "graph3" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_services.gph", replace

// MEN AGRICULTURE	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_agri.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Men - Agriculture 
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_men_agriculture.png", replace 
graph save "graph4" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_men_agriculture.gph", replace


// MEN INDUSTRY	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_indu.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Men - Industry 
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_men_industry.png", replace 
graph save "graph5" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_men_industry.gph", replace


// MEN SERVICES	
graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_serv.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Men - Services	
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_men_services.png", replace 
graph save "Graph" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_men_services.gph", replace
	
	

	
	
	
	
	
	
	
// Graph combine 

cd "${root}/4_outputs/regression_results/probit_sde/marginsplots"

graph combine ///
marginsplot_probit_sde_05101519_women_agriculture.gph  ///
marginsplot_probit_sde_05101519_women_industry.gph  ///
marginsplot_probit_sde_05101519_women_services.gph  ///
marginsplot_probit_sde_05101519_men_agriculture.gph  ///
marginsplot_probit_sde_05101519_men_industry.gph  ///
marginsplot_probit_sde_05101519_men_services.gph
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability than mexican men and women are economically active depending on the"'
gr_edit .title.text.Arrpush `"percentage of agricultural /industrial / service jobs in the municipality where they live"'
gr_edit .title.style.editstyle size(small) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/combined_marginsplot_probit_sde_05101519.png", replace 
graph save "Graph" 	"${root}/4_outputs/regression_results/probit_sde/marginsplots/combined_marginsplot_probit_sde_05101519.gph", replace 


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	













// MARGINSPLOT FOR WOMEN 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	

	foreach sde_mun of local sde {

	graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.gph"
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(pink))) editcopy
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(width(vthin))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(size(tiny)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(pink)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(pink))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(symbol(smsquare)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle line(color(pink)) editcopy
	graph export 		"${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.png", replace
	graph save "Graph" 	"${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.gph", replace
	clear 
	
	}

// MARGINSPLOT FOR MEN 
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	

	foreach sde_mun of local sde {

	graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.gph"
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(width(vthin))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(size(tiny)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(symbol(smsquare)) editcopy
	graph export 		"${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.png", replace
	graph save "Graph" 	"${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.gph", replace
	clear
	
	}

	
	















