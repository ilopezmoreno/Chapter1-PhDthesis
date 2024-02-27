	**************************
	***** MASTER DO FILE *****
	**************************
	
/* 	This master do-file include the following instructions to Stata
		- Indicating the stata version that was used during the creation of the do-files
		- Installing required settings and packages 
		- Establish a dynamic and absolute file path to the working directory. 
		- Create the basic folder structure
		- Running the do-files  */

	
	// These do-files were created using Stata 17. 
	// There is a chance that certain commands used in this do-file will not work if you are using a Stata version lower than 17. 
	// You can still try to run the do-files in other stata versions, but you will have to identify if there are some commands that are not working. 
		version 17
		clear all
		set more off
		cls
	 	
	// Installing required settings and packages (if required)
	
	*	ssc install stata_linter 	// Detects and corrects bad coding practices in Stata do-files following the DIME Analytics Stata Style Guide.
	 	ssc install fre 			// This command is very similar to "tabulate" command, but in certain cases is more useful. 
	*	ssc install mdesc 			// Displays the number and proportion of missing values for each variable.
	*	ssc install iefieldkit		// DIME Analytics package with useful commands: iecodebook, ietestform, ieduplicates, iecompdup
	*	ssc install ietoolkit 		// DIME Analytics package with useful commands for data management: iefolder, iegitaddmd, ieboilstart 		
		
		
		
	// Establish dynamic and absolute file path to the working directory.
		clear
		// Please change the following working directory to the file path of your computer.
		global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"  
		/* Important notes: 
		 - Always use forward slashes "/" in file paths to working directories. ( Macbooks doesn't reproduce file paths with backward slashes "\" )
		 - For Stata, globals must only be defined in the master do-file */


	// Creating a basic folder structure
		capture mkdir 1_do-files
		capture mkdir 2_data-storage
		capture mkdir 3_documentation
		capture mkdir 4_outputs
		
		/*
		cd "$root/4_outputs"
		capture mkdir descriptive_statitistics
		capture mkdir tables
		capture mkdir figures
		capture mkdir regression_results
		capture mkdir margins_results
		capture mkdir marginsplots
		*/


	
		/*
		*lint "$root/2_dofile_data-download.do"
		*lint "$root/3_dofile_data-merge.do"
		*lint "$root/4-1_dofile_data-cleaning-drop.do"
		*lint "$root/4-2_dofile_data-cleaning-iecodebook.do"
		*lint "$root/4-3_dofile_data-cleaning-transformation.do"
		*lint "$root/5-1_dofile_data-construction-household.do"
		*lint "$root/5-2_dofile_data-construction-municipal.do"
		*lint "$root/5-3_dofile_data-construction-consistency.do"
		*lint "$root/6_dofile_data-merge-municipal.do"
		*lint "$root/3_dofile_data-merge.do"
		*lint "$root/3_dofile_data-merge.do"
		*/

	
	
// Running the do-files

cd "$root"
do "2_dofile_data-download.do"
// This do-file includes an explanation of Mexico's ENOE surveys and it download the datasets required for the analysis.

cd "$root"
do "3_dofile_data-merge.do"	
// This do-file merges the downloaded datasets following INEGI's criteria. 

cd "$root"
do "4-1_dofile_data-cleaning-drop.do"
// This do-file drops variables that will not be required for the analysis and compress the dataset.

cd "$root"
do "4-2_dofile_data-cleaning-iecodebook.do"
// This do-file uses the iecodebook developed by DIME Analytics to recode and relable variable names and variable values.

cd "$root"
do "4-3_dofile_data-cleaning-transformation.do"
// This do-file document specific changes to the dataset that require a clear explanation. 

cd "$root"
do "5-1_dofile_data-construction-household.do"
// This do-file constructs variables at the household level. 

cd "$root"
do "5-2_dofile_data-construction-municipal.do"
// This do-file constructs variables at the municipal level. 

cd "$root"
do "5-3_dofile_data-construction-consistency.do"
// This do-file is to execute an intensive consistency check throughout the data.

cd "$root"
do "6_dofile_data-merge-municipal.do"
// This do-file merges the main dataset with the data constructed at the municipal level. 

cd "$root"
do "7_dofile_exploratory-data-analysis.do"
// This do-file is to look for patterns in the data, in a descriptive fashion (Not used currently)

cd "$root"
do "8-1_dofile_descriptive-statistics.do"
// This do-file is for to generate the descriptive statistics of the variable employed in the econometric model. 

cd "$root"
do "8-2_dofile_final-data-analysis_main-figures.do"
// This do-file is for the data analysis of FIGURES that will appear in the paper. 

cd "$root"
do "9-1_dofile_1st_regressions-nocontrols.do"
// This do-file executes the regression analysis without control variables, just fixed effects.

cd "$root"
do "9-2_dofile_2nd_regressions-withcontrols.do"
// This do-file executes the regression analysis with most of the control variables, excluding the municipal controls.

cd "$root"
do "9-4_dofile_3rd_regressions-municipalcontrols-margins.do"
// This do-file executes the regression analysis with most of the control variables, including the municipal controls.

cd "9-5_dofile_3rd_regressions-municipalcontrols-marginsplot.do"
// This do-file ask stata to run the margins command for the regressions that included all the control variables (individual, household, municipal)

cd "9-6_dofile_robustness-check.do"
// This do-file ask stata to plot the margins results obtained with the previous do-file. 






* data_analysis

* descriptive_statistics

* regressions

* tables

* graphs