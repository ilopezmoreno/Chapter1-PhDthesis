	**************************
	***** MASTER DO FILE *****
	**************************
	
/* 	This master do-file include the following instructions to Stata
	1. Installing required settings and packages 
	2. Establish a dynamic and absolute file path to the working directory. 
	3. Create the basic folder structure
	4. Running the rest of the do-files */

	
	// Installing required settings and packages
		ssc install stata_linter
		ssc install fre
		ssc install mdesc
		ssc isntall bcstats
		ssc install iefieldkit
		ssc install ietoolkit

		
	// Establish dynamic and absolute file path to the working directory.
		clear
		global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis" // Establish a dynamic and absolute file path.
		/* Important notes: 
		Always remember to use forward slashes "/" in file paths to working directories
		For Stata, globals must only be defined in the master do-file
		*/


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
