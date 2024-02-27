clear 
*global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

/* 

A data-cleaning do-file should consider: 
	- Dropping variables that are not needed for the analysis. This has already been done. 
	- Relabel variable names and values from spanish to english. I already did this using iecodebook
	- Recode variables. I already did this in several variables using iecodebook
	
A data-cleaning do-file should also consider:    
 	- Dropping observations with specific variable values. 
	- Document missing value decisions 
	- Destring variables. 
	- Check consistency across variables.

Therefore, this data-cleaning do-file document changes to the dataset that require a clear explanation.	
	
A few pieces of documentation should also accompany a clean dataset	
	
	- 	A variable dictionary/codebook listing details about each variable  
		What does this variable mean? Summary of its content
		In the following link, INEGI has a codebook for each variable:
		https://www.inegi.org.mx/rnm/index.php/catalog/497/data-dictionary
		
	- 	The instruments used to collect the data
		This was not required for this research project, as I am using secondary data.
		 
	- 	A report documenting any irregularities and distributional patterns 
		encountered in the data.  */
	

	
use	"${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-tidy-codebook.dta"


//  Destring variables. 
	ds, has(type string) // This command shows which variables are in a string format.
	// Result: person_id_per, house_id_per	
	// I don't want to destring the ID variables, so I will continue with the data cleaning. 

	
/* 	Dropping observations with specific variable values

	As it was mentioned in a previous do-file, INEGI recommends to drop all the kids below 12 years old 
	from the sample because those kids where not interviewed in the employment survey. 

	According to both the International Labour Organization (ILO), and to INEGI the 
	labour force participation rates are estimated by considering individuals who are over 15 years old. 

	So it is still necessary to remove from the sample all kids below 15 years old. */

		tab clase1 if eda<=14 /* Data quality check: 
		There are kids betwen 12 and 14 years old that reported being economically active. 
		However, according to ILO and INEGI standards, there shouldn't be in the sample. */ 
		drop if eda<=14 
		assert eda>=15 & !missing(eda) // Consistency check: Assertion is true. 
		summarize eda // Data quality check: Minimum age in the sample 15, maximum age 98.
		
	
		
/*	Missing value decisions. 
	In this section I replace values like -88, 999, etc that are commonly use to represent answers 
	like "Don't know" or "declined to answer". 
	I will use extended missing values instead of a regular missing value "."
	The options of extended missing values are: 
	.d = "Dont know"
	.r = "Refused to answer"
	.s = "Skipped"
	.n = "Not Applicable"
	Note: These "extender" missing values can also be labeled. */ 
	

		/* The variable hij5c captures the number of sons or daughters that women have had.
		This variable includes observation that were categorize as "0" for those who "Doesn't apply" */
		fre hij5c 
		tab hij5c sex 
		// Consistency check: People who doesn't apply are men, so I will replace "0" as a normal missing value
		replace hij5c=. if hij5c==0  
		/* Moreover, there are a few cases where the female respondents did not 
		specified if they had kids. Therefore, I will replace "5" as a missing value */
		replace hij5c=.r if hij5c==5 // .r is used to identified those women that refused to answer or just didn't answer.

		
/*	Unique ID
	I will check again that the unique ID has no duplicates. 
	Remember to anonymize/de-identify if necessary. */
			
		duplicates report person_id 	
		// Consistency check: The unique ID has no duplicates.  		

		
			
		
/* 	Changes to the variable "socioeconomic stratum"

	Renaming variable. 
	Try not to change the variables names/codes, unless it is necessary. 
	Renaming variables make it harder to find correspondance between variables and survey questions.
	
	I need to rename this variable as it is currently under the variable name "est", and Stata
	has a command called "estimates", and the abbreviation is "est".
	To avoid potential problems, I will change the name of that variable. */
		rename est soc_str 

	// 	I also need to recode this variable.
		
		/* 	According to INEGI, the variable in 2019 has 4 categorical values
				10 - Low socioeconomic stratum
				20 - Medium-low socioeconomic stratum
				30 - Medium-high socioeconomic stratum
				40 - High socioeconomic stratum
			Check the data dictionary here:
				https://www.inegi.org.mx/rnm/index.php/catalog/497/data-dictionary/F17?file_name=SDEMT119
			
			INEGI also indicates that this variable is built using multivariate statistical methods 
			based on 34 indicators that capture the economic situation of the individuals, as well as 
			the physical characteristics and the equipment in their households. Some of the indicators
			considered are access to medical services, educational attainment, illiteracy, a solid floor 
			in the household (cement, wood, mosaic), overcrowding in the household, access to electricity,
			water and drainage piping as well as possession of items such as televisions, cars, cell phones,
			refrigerators and washing machines. 
				Check the following link to open the document "Como se hace la ENOE. Metodos y procedimientos" 
				hhttps://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/nueva_estruc/702825190613.pdf 

				Page 51 (42 in the report), indicates that it was built using 34 indicators.
				Page 66 (57 in the report), includes an explanation of the 34 indicators that were considered. 	*/
					replace soc_str=1 if soc_str==10
					replace soc_str=2 if soc_str==20 
					replace soc_str=3 if soc_str==30 
					replace soc_str=4 if soc_str==40 
		
	//	However, in 2005 and 2010, they had more values.	
					tab soc_str per // Consistency check
	/* 	In this document INEGI explains the methodology for the first versions of the ENOE survey, which started in 2005.
		https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/historicos/2104/702825444204/702825444204_1.pdf
		Page 12 (Page 6 in the report)
		The document indicates that in the first versions, they divided the sample in 4 socioeconomic stratum, and 
		then they also did sub-divisions of socio-economic stratum.
		Therefore, I need to replace those values as well */
					replace soc_str=1 if inlist(soc_str, 11, 12, 13, 14)
					replace soc_str=2 if inlist(soc_str, 21, 22, 23, 24) 
					replace soc_str=3 if inlist(soc_str, 31, 32, 33, 34)
					replace soc_str=4 if inlist(soc_str, 41, 42, 43, 44)
	
	// 	Finally, I need to re-label the variable 
					label define soc_str 1 "Low" 2 "Medium-Low" 3 "Medium-High" 4 "High", replace 
					label value soc_str soc_str
					fre soc_str
	

	
	
/* 	Changes to the variable "sex"	
			As this research is oriented to analysing female labour participation, 
			instead of using the variable "sex", I will create the variable "female", 
			that will take value of 1 for women, and 0 for men.  */
			gen female=.
			replace female=1 if sex==0
			replace female=0 if sex==1
			label variable female "Female Identificator" 
			label define female 0 "Men" 1 "Women", replace
			label value female female
			fre female

			
			
/* 	Changes to the variable "n_hij"
			This variable captures the number of sons or daughers that women have had.
			It currently has values from 0 to 25.
			To simply the analysis, all women with 5 sons or more, will be categorized as "5" */
 			fre n_hij
			replace n_hij=5 if n_hij>4 & n_hij<30
/*			Now it is important check consistency in this variable. 
			Value 0 corresponds to respondents that have less than 12 years, 
			are men or are women without sons or daughters.	
			I want to be sure that all values equal to 0 are only for women */		
			assert female==1 if n_hij==0 // Consistency check: All values equal to 0 are women
/*	 		Now I need to replace the few cases equal to "99" that correspond to 
			women that didn't specified if they had sons or daughters. */
			replace n_hij=.d if n_hij==99
//			Now I need to re-label the categorical values of the variable.
			label define n_hij /// 
			0 	"No sons or daughters" ///
			1 	"One son or daughter" ///
			2 	"Two sons or daughters" ///
			3 	"Three sons or daughters" ///
			4 	"Four sons or daughters" ///
			5 	"Five or more sons or daughters" ///
			.d 	"Not specified", replace 
			label value n_hij n_hij
			fre n_hij
			tab n_hij if female==1

			
			
// Generate variable to identify people working in different economics sector, without considering non-economically active population. 				
			generate P4A_Sector=.
			replace  P4A_Sector=. if rama_est1==0
			replace  P4A_Sector=1 if rama_est1==1
			replace  P4A_Sector=2 if rama_est1==2
			replace  P4A_Sector=3 if rama_est1==3
			replace  P4A_Sector=4 if rama_est1==4
			label variable 	P4A_Sector "Economic Sector Categories"
			label define 	P4A_Sector 1 "Agriculture" 2 "Industry" 3 "Services" 4 "Unspecified activities"
			label value 	P4A_Sector P4A_Sector	  
			fre P4A_Sector 
						
save "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-cleaned.dta", replace	
	

	
/* 	The following actions were not required for this dataset.
	  
	- 	Check consistency across variables. 
		For example:
		If a respondent is male, then it cannot be pregnant. 
		If a respondent said they are not working, then they shouldn't have a salary.
		You can fin errors in the dataset by exploring the data using tabulations, 
		summaries and descriptive plots. 
	
	- 	High frequency checks 
	- 	Data quality checks.
	- 	Create flag variables that identify observations with inconsistent values.		*/