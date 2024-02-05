	**************************
	***** MASTER DO FILE *****
	**************************
	
/* 	This master do-file include the following instructions to Stata
		- Indicating the stata version that was used during the creation of this do-files
		- Installing required settings and packages 
		- Establish a dynamic and absolute file path to the working directory. 
		- Create the basic folder structure
		- Running the rest of the do-files  */

	
	// These do-files were created using Stata 17. 
	// There is a chance that certain commands used in this do-file will not work if you are using a Stata version lower than 17. 
	// You can still try to run the do-files in other stata versions, but you will have to identify if there are some commands that are not working. 
		version 17
		clear all
		set more off
		cls
	 	
	// Installing required settings and packages
		ssc install stata_linter 	// Detects and corrects bad coding practices in Stata do-files following the DIME Analytics Stata Style Guide.
		ssc install fre 			// This command is very similar to "tabulate" command, but in certain cases is more useful. 
		ssc install mdesc 			// Displays the number and proportion of missing values for each variable.
		ssc isntall bcstats 		// bcstats compares back check data (i.e., field audit, reinterview) and original survey data, producing a comparison dataset. 
		ssc install iefieldkit		// DIME Analytics package with useful commands: iecodebook, ietestform, ieduplicates, iecompdup
		ssc install ietoolkit 		// DIME Analytics package with useful commands for data management: iefolder, iegitaddmd, ieboilstart 		
		
		
		
	// Establish dynamic and absolute file path to the working directory.
		clear
		global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis" // Establish a dynamic and absolute file path.
		/* Important notes: 
				- Always remember to use forward slashes "/" in file paths to working directories. Macbooks doesn't reproduce file paths with backward slashes "\"
				- For Stata, globals must only be defined in the master do-file */


	// Create the basic folder structure
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



// Run do-files
cd 		"$root"
lint 	"$root/2_dofile_data-download.do"

do "2_dofile_folder-creation.do"	





* folder_creation

* data_download

* data_cleaning

* merge

* data_transformation
* rename
* recode
* relabel

* data_analysis

* descriptive_statistics

* regressions

* tables

* graphs

*  






** Es importante empezar mencionando que este codigo se creo utilizando la version de Stata 17. 
** Es posible que si cuentas con una version menor a stata 17, algunos de los codigos no funciones. 
** Debido a esto, se utiliza el siguiente codigo para especificar que el codigo requiere de stata 17 o mas para funcionar correctamente. 
