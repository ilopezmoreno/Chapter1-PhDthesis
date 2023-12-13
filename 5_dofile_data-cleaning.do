clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

/* 

In the first do-file for data cleaning, I used the command "iecodebook" to 
	1. Drop variables
	2. Recode variables
	3. Rename variables

In this do-file I clean the dataset by making:   
 	
	- Drop observations with specific variable values. 
	- Missing value decisions 
	- Destring variables. 
	- Check consistency across variables.
	
	
The data-cleaning do-file should include a clear explanation of all my corrections to the dataset.


	- Missing value decisions. 
	For example, remove values like -88, 999, etc that are commonly use to represent answers 
	like "Don't know" or "declined to answer". In certain cases you will have to convert 
	them in missing values, in other cases, you can drop them.
	You can use extended missing values instead of regular missing values "."
	The options of extended missing values are: 
	.d = "Dont know"
	.r = "Refused to answer"
	.s = "Skipped"
	Note: This missing values can also be labeled.
	
	- Destring variables. 
	For example, Transform categorical string variables into destring labeled variables.
	
	- Check consistency across variables. For example:
	If a respondent is male, then it cannot be pregnant. 
	If a respondent said they are not working, then they shouldn't have a salary.
	You can fin errors in the dataset by exploring the data using tabulations, 
	summaries and descriptive plots.
	
	- Unique ID
	Make sure that the unique ID has no duplicates, and anonymize/de-identify 
	if its necessary. (You can use command "ieduplicates")
	
	- Relabel 
	Change variable labels to English (You can use the command "label variable")

	- Recode 
	For example, in certain cases 
	
Data cleaning should usually consider
	

	
	2.  
	
		
	4. 
	
	5. 
	
	6.  
	
	7. 
	
	8. Try not to change the variables names/codes, unless it is necessary. 
	Renaming variables make it harder to find correspondance between variables and survey questions.
	
	9. Check consistency across variables. For example:
	If a respondent is male, then it cannot be pregnant. 
	If a respondent said they are not working, then they shouldn't have a salary. 

	10. High frequency checks and data quality checks.
	
	11. Create flag variables that identify observations with inconsistent values. 
	
	12. Compress your dataset to reduce the 
	
A few pieces of documentation should accompany the clean dataset	
	1. A variable dictionary/codebook listing details about each variable  
	What does this variable mean? Summary of its content
	2. The instruments used to collect the data
	3. A complete record of any corrections made to the raw data, including 
	careful explanations about the decision-making process involved. 
	4. A report documenting any irregularities and distributional patterns 
	encountered in the data
	

*/

use	"${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-tidy.dta" 



// DROPPING DECISIONS

/* As it was mentioned in a previous do-file, INEGI recommends to drop all the kids below 12 years old from the sample because those kids where not interviewed in the employment survey. 

According to both the International Labour Organization (ILO), and to INEGI the 
labour force participation rates are estimated by considering individuals who are over 15 years old. 

So it is still necessary to remove from the sample all kids below 15 years old. */

tab clase1 if eda<=14 /* Data quality check: 
There are kids betwen 12 and 14 years old that reported being economically active. 
However, according to ILO and INEGI standards, there shouldn't be in the sample. */ 
drop if eda<=14 
assert eda>=15 & !missing(eda) // Data quality check: Assertion is true. 
summarize eda // Data quality check: Minimum age in the sample 15, maximum age 98.


// MISSING VALUES DECISIONS

fre hij5c /* The variable hij5c captures the number of sons or daughters that women have had.
This variable includes observation that were categorize as "0" for those who "Doesn't apply" */
tab hij5c sex /* As it can be observed, the people who doesn't apply are only men. 
* Therefore, I will replace "0" as a missing value */
replace hij5c=. if hij5c==0
/* In addition, there are very few cases where the female respondents did not 
specified if they had kids. Therefore, I will replace "5" as a missing value*/
tab hij5c if hij5c==5 & sex==2
replace hij5c=. if hij5c==5 & sex==2
fre hij5c   

fre e_con /* The variable "e_con" captures the marital status of the respondents. 
This variable has few observations that were categorize as "9" for those who "Doesn't 
know their marital situation". Therefore, I will replace "9" as a missing value */
replace e_con=.d if e_con==9 

* The variable "cs_p13_1" that captures the level of education, includes 273 observations that were categorized as "99" for those who answered "Doesn't Know"
tab cs_p13_1
tab cs_p13_1, nolabel
* Therefore, I will replace "99" as a missing value
replace cs_p13_1=.d if cs_p13_1==99 

