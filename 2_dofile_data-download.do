clear 
global root "C:/Users/d57917il/Documents/GitHub/thesis-chapter1"

/* 	Brief explanation of the datasets

	The National Occupation and Employment Survey (ENOE) is the main source of information on the Mexican labor market.
	- It provides monthly and quarterly data about labor force, employment, labor informality, unemployment, etc. 
	- It is the largest continuous statistical project in the country. 
	- It provides representative information for each of the 32 mexican states, 39 cities, and 4 locality sizes. 
	- The first trimester of each year it is an AMPLIFIED survey.
	- The 2nd, 3rd and 4th trimester of each year it is a BASIC survey.

	INEGI separates ENOE surveys in five different categories:
	1) coe1 - This database stores the FIRST part of the questions of the ENOE survey (Basic or amplified).
	2) coe2 - This database stores the SECOND part of the questions of the ENOE survey (Basic or amplified).
	3) hog - This database stores questions about household characteristics.
	4) sdem - This database stores the sociodemographic characteristics of all household members.
	5) viv - This database stores the data from the front side of the sociodemographic questionnaire  */

/* 	For this research project I will be using the datasets for the 1st quarters of 2005, 2010, 2015 & 2019.
	And I will only need the following categories: SDEM, COE1, COE2 */

// 	I need to start by establishing the working directories and creating the folders. 
	cd "${root}/2_data-storage" // Change directory to the data storage folder
	capture mkdir bases_enoe // Creating a folder where the downloaded data is going to be stored.
	cd "${root}/2_data-storage/bases_enoe"
	
// 	1st quarter of 2005
	copy 						/// copy is a command that will ask Stata to download the data from INEGI website.
	"https://www.inegi.org.mx/contenidos/programas/enoe/15ymas/microdatos/2005trim1_dta.zip" /// 
	enoe_105.zip, replace 		// This is the name that the downloaded zip file will have in the computer

	unzipfile 	enoe_105.zip 	// Ask stata to unzip the downloaded dataset
	erase 		enoe_105.zip 	// Ask stata to erase the zip file once you have unzip it. 
	erase 		HOGT105.dta		// Ask stata to erase the HOG dataset as I will not use it for this research project.
	erase 		VIVT105.dta		// Ask stata to erase the VIV dataset as I will not use it for this research project.

// 	1st quarter of 2010
	copy 						/// copy is a command that will ask Stata to download the data from INEGI website.
	"https://www.inegi.org.mx/contenidos/programas/enoe/15ymas/microdatos/2010trim1_dta.zip" /// 
	enoe_110.zip, replace 		// This is the name that the downloaded zip file will have in the computer

	unzipfile 	enoe_110.zip 	// Ask stata to unzip the downloaded dataset
	erase 		enoe_110.zip 	// Ask stata to erase the zip file once you have unzip it. 
	erase 		HOGT110.dta		// Ask stata to erase the HOG dataset as I will not use it for this research project.
	erase 		VIVT110.dta		// Ask stata to erase the VIV dataset as I will not use it for this research project.

// 	1st quarter of 2015
	copy 						/// copy is a command that will ask Stata to download the data from INEGI website.
	"https://www.inegi.org.mx/contenidos/programas/enoe/15ymas/microdatos/2015trim1_dta.zip" /// 
	enoe_115.zip, replace 		// This is the name that the downloaded zip file will have in the computer

	unzipfile 	enoe_115.zip 	// Ask stata to unzip the downloaded dataset
	erase 		enoe_115.zip 	// Ask stata to erase the zip file once you have unzip it. 
	erase 		HOGT115.dta		// Ask stata to erase the HOG dataset as I will not use it for this research project.
	erase 		VIVT115.dta		// Ask stata to erase the VIV dataset as I will not use it for this research project.

// 	1st quarter of 2019
	copy 						/// copy is a command that will ask Stata to download the data from INEGI website.
	"https://www.inegi.org.mx/contenidos/programas/enoe/15ymas/microdatos/2019trim1_dta.zip" /// 
	enoe_119.zip, replace 		// This is the name that the downloaded zip file will have in the computer

	unzipfile 	enoe_119.zip 	// Ask stata to unzip the downloaded dataset
	erase 		enoe_119.zip 	// Ask stata to erase the zip file once you have unzip it. 
	erase 		HOGT119.dta		// Ask stata to erase the HOG dataset as I will not use it for this research project.
	erase 		VIVT119.dta		// Ask stata to erase the VIV dataset as I will not use it for this research project.

	use			sdemt119.dta 	// As this dataset is in lower case, I need to rename it. 
	save 		"$root/2_data-storage/bases_enoe/SDEMT119.dta", replace // Save the dataset with uppercases
	erase 		sdemt119.dta 	// Erase the dataset with lower cases. 

	use			coe1t119.dta 	// As this dataset is in lower case, I need to rename it. 
	save 		"$root/2_data-storage/bases_enoe/COE1T119.dta", replace // Save the dataset with uppercases
	erase 		coe1t119.dta 	// Erase the dataset with lower cases. 

	use			coe2t119.dta 	// As this dataset is in lower case, I need to rename it. 
	save 		"$root/2_data-storage/bases_enoe/COE2T119.dta", replace // Save the dataset with uppercases
	erase 		coe2t119.dta 	// Erase the dataset with lower cases. 



/* 	I could have done the same process using a loop.
	However, for some reason it takes way more time to download the datasets if I use a loop.
	This is a reference of the loop that can be used to download the datasets. */

/*	Now, I have to create a loop for the specific quarters that I need to download for the research project.	

// 	Creating the loop  	
	local year_quarters ///
	05 /// 	1st quarter of 2005
	10 /// 	1st quarter of 2010
	15 ///	1st quarter of 2015
	19 //	1st quarter of 2019

foreach year_quarter of local year_quarters {

copy /// copy is a command that will ask Stata to download the data from INEGI website.
"https://www.inegi.org.mx/contenidos/programas/enoe/15ymas/microdatos/20`year_quarter'trim1_dta.zip" /// 
enoe_1`year_quarter'.zip, replace // This is the name that the downloaded zip file will have in the computer

unzipfile 	enoe_1`year_quarter'.zip 	// Ask stata to unzip the downloaded dataset
erase 		enoe_1`year_quarter'.zip 	// Ask stata to erase the zip file once you have unzip it. 
erase 		HOGT1`year_quarter'.dta		// Ask stata to erase the HOG dataset as I will not use it for this research project.
erase 		VIVT1`year_quarter'.dta		// Ask stata to erase the VIV dataset as I will not use it for this research project.

}

*/