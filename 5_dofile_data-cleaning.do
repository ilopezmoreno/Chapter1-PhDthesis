clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

cd	"${root}/2_data-storage/pool_dataset" 
use pool_enoe_105_110_115_119.dta





// DROPPING DECISIONS

/* As it was mentioned in a previous do-file, INEGI recommends to drop all the kids below 12 years old from the sample because those kids where not interviewed in the employment survey. 

According to both the International Labour Organization (ILO), and to INEGI the 
labour force participation rates are estimated by considering individuals who are over 15 years old. 

So it is still necessary to remove from the sample all kids below 15 years old. */

tab clase1 if eda<=14 /* Data quality check: 
There are kids betwen 12 and 14 years old that reported being economically active. 
However, according to ILO and INEGI standards, there shouldn't be in the sample. */ 
drop if eda<=14 
summarize eda // Minimum age in the sample 15. Maximum age in the sample 98.




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
fre hij5c // Data quality check: Now there are no  

fre e_con /* The variable "e_con" captures the marital status of the respondents. 
This variable has few observations that were categorize as "9" for those who "Doesn't 
know their marital situation". Therefore, I will replace "9" as a missing value */
replace e_con=. if e_con==9


* The variable "cs_p13_1" that captures the level of education, includes 273 observations that were categorized as "99" for those who answered "Doesn't Know"
tab cs_p13_1
tab cs_p13_1, nolabel
* Therefore, I will replace "99" as a missing value
replace cs_p13_1=. if cs_p13_1==99 // Data quality check: 273 real changes made.

