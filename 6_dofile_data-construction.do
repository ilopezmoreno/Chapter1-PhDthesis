


/* 

EN ESTE DOFILE SE VAN A CONSTRUIR TODOS LOS INDICADORES A NIVEL MUNICIPAL QUE USARAS PARA TU ANALISIS. 

Data CONSTRUCTION transforms clean data into analysis data. 

I shouldn't CONSTRUCT indicators during the CLEANING PROCESS or the ANALYSIS process.
In cleaning you can correct typos, make missing value decisions, etc. But not construct indicators.  

Data cleaning makes raw/original data easy to use. 
Data construction transforms clean data into data ready for analysis. 


Unit of observation -> Unit of analysis 
Observed measurements -> Analysis indicators.

	•  	Create new variables instead of overwriting the original information.
	•  	Constructed variables should have intuitive and functional names.
	•  	Harmonizing variable measures and scales.
	•  	Order the data set so that related variables are close to each other.
	•  	Document in the code how research questions has influenced variable construction.
	•  	Clearly note each decision made in the script, the reasons behind them, and 
		any alternatives considered. Be considerate to your future self or teammembers.
	•  	Set up expectations for an indicator. For example, never negative, within arange, 
		always smaller than some other variable, etc. Build in tests for thoseexpectations.
	•   List all observations with missing values in constructed variables. Make sure 
		you can explain why they are missing.
	•   Test that ID is uniquely and fully identifying after construct.
	•	Test as much as you can. Useassertin Stata

*/ 


help assert
// assert es muy bueno para hacer data quality checks. 
