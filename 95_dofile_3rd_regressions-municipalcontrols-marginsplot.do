clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"
cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols"
capture mkdir marginsplots



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
cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/margins_results"








// MARGINSPLOT FOR WOMEN
// WITH MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)



// Next step is to create loops to generate the different marginsplots figures
local sde ///
sde_mun_agri sde_mun_indu sde_mun_serv 	

	foreach sde_mun of local sde {
	
	/* 	The next step is to ask Stata to open the regressions results that were stored in the .ster format. 
		Then, you need to indicate that those results were obtained using the command "margins"  */
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
	graph save "Graph" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.gph", replace
	graph close 
	
	graph use "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.gph"
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(width(vthin))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(size(tiny)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(symbol(smsquare)) editcopy
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(pink))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(pink)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(pink))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle line(color(pink)) editcopy
	graph save "Graph" 	"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.gph", replace
	graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_`sde_mun'.png", replace 
	graph close
	}


	
	
	
	
	
	
	
// MARGINSPLOT FOR MEN
// WITHOUT MUNICIPAL CONTROLS AND WITH INTERACTION (SDE##SDE)


// Next step is to create loops to generate the different marginsplots figures
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
	graph save "Graph" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.gph", replace
	graph close 
	
	graph use "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.gph"
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(width(vthin))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(size(tiny)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(symbol(smsquare)) editcopy
	graph save "Graph" 	"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.gph", replace
	graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_`sde_mun'.png", replace 
	graph close
	}



	
	
	
	
	
	
	
	
// Editing the marginsplots 

// WOMEN AGRICULTURE	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_agri.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican women are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of agricultural jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of agricultural jobs in the municipality where they live
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_agri.png", replace 
graph save "graph1" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_agri.gph", replace 


// WOMEN INDUSTRY	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_indu.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican women are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of industrial jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of industrial jobs in the municipality where they live
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_indu.png", replace 
graph save "graph2" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_indu.gph", replace 	

// WOMEN SERVICES
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_serv.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican women are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of service jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of service jobs in the municipality where they live
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_serv.png", replace 
graph save "graph3" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_serv.gph", replace 
	
// MEN AGRICULTURE	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_agri.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican men are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of agricultural jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of agricultural jobs in the municipality where they live
graph save "graph4" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_agri.gph", replace 
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_agri.png", replace 	
	
// MEN INDUSTRY	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_indu.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican men are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of industrial jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of industrial jobs in the municipality where they live
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_indu.png", replace 
graph save "graph5" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_indu.gph", replace 	

// MEN SERVICES
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_serv.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability that mexican men are economically active"'
gr_edit .title.text.Arrpush `"depending on the % of service jobs in the municipality where they live"'
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Percentage of service jobs in the municipality where they live
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_serv.png", replace 
graph save "Graph" 	"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_serv.gph", replace
	
	

	

	
	
	
	
	
	
// WOMEN AGRICULTURE	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_agri.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Women - Agriculture
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_women_agriculture.png", replace 
graph save "graph1" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_women_agriculture.gph", replace


// WOMEN INDUSTRY	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_indu.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Women - Industry 
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_women_industry.png", replace 
graph save "graph2" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_women_industry.gph", replace


// WOMEN SERVICES	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_womeninteraction_sde_mun_serv.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Women - Services 
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_women_services.png", replace 
graph save "graph3" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_women_services.gph", replace

// MEN AGRICULTURE	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_agri.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Men - Agriculture 
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_men_agriculture.png", replace 
graph save "graph4" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_men_agriculture.gph", replace


// MEN INDUSTRY	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_indu.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Men - Industry 
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_men_industry.png", replace 
graph save "graph5" "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_men_industry.gph", replace


// MEN SERVICES	
graph use 			"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_meninteraction_sde_mun_serv.gph"
gr_edit .title.text = {}
gr_edit .title.text.Arrpush Men - Services	
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_men_services.png", replace 
graph save "Graph" 	"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/marginsplot_probit_sde_05101519_men_services.gph", replace
	
	

	
	
	
	
	
	
	
// Graph combine 

cd "${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots"

graph combine ///
marginsplot_probit_sde_05101519_women_agriculture.gph  	///
marginsplot_probit_sde_05101519_women_industry.gph  	///
marginsplot_probit_sde_05101519_women_services.gph  	///
marginsplot_probit_sde_05101519_men_agriculture.gph  	///
marginsplot_probit_sde_05101519_men_industry.gph  		///
marginsplot_probit_sde_05101519_men_services.gph
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Predicted probability than mexican men and women are economically active depending on the"'
gr_edit .title.text.Arrpush `"percentage of agricultural /industrial / service jobs in the municipality where they live"'
gr_edit .title.style.editstyle size(small) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
graph export 		"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/combined_marginsplot_probit_sde_05101519.png", replace 
graph save "Graph" 	"${root}/4_outputs/regression_results/3_probit_sde_municipalcontrols/marginsplots/combined_marginsplot_probit_sde_05101519.gph", replace 


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
/*	
	
	
	
	
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
	estimates use margins_probit_sde_05101519_women_`sde_mun'.ster
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
	graph save "Graph" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_`sde_mun'.gph", replace
	graph close 
	
	graph use "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_`sde_mun'.gph"
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(width(vthin))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(size(tiny)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(symbol(smsquare)) editcopy
	gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(pink))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(pink)) editcopy
	gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(pink))) editcopy
	gr_edit .plotregion1.plot2.style.editstyle line(color(pink)) editcopy
	graph save "Graph" "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_`sde_mun'.gph", replace
	graph export "${root}/4_outputs/regression_results/probit_sde/marginsplots/marginsplot_probit_sde_05101519_women_`sde_mun'.png", replace 
	graph close
	}

	
	
	*/
	