clear 
global root "C:/Users/d57917il/Documents/GitHub/Chapter1-PhDthesis"

/* 

iecodebook is a command from the Stata package "iefieldkit" created by DIME Analytics

iecodebook allows the to automatically perform the repetitive steps involved in cleaning data before further analysis. 

The command "iecodebook" is particularly useful to 
	1. Drop variables in the dataset that are not going to be used
	2. Re-label variable description in the dataset from spanish to english
	3. Recode variables in your dataset.

iecodebooks allow researchers to document the cleaned data in a format that is both human and machine-readable.

To install the command "iecodebook", you need to ask stata to install the pacakge "iefieldkit" using the following command
ssc install iefieldkit

More info in DIME Wiki: 
https://dimewiki.worldbank.org/iecodebook
https://www.youtube.com/watch?v=zm6eoMU09dA&t=1174s

*/

use	"${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-tidy.dta" 

/* The following line of code is used to generate the excel file "iecodebook"
However, those that want to replicate my code, doesn't need to generate a iecodebook. 
Instead, they just need to charge the one that I already prepared.   

Therefore, the code to generate a new iecodebook is current de-activated.
Instead, code-replicants just need to ask stata to apply 
the iecodebook.xlsx that I already did. 
*/
		// De-activated for reproducibility purposes. 
		*  iecodebook template using "${root}/iecodebook.xlsx", replace 
		// De-activated for reproducibility purposes. 

/* 	Note to myself: The first time I ran this command, it took a 
	considerable amount of time as the current dataset had almost 400 variables 
	and 1.2 million observations. Therefore, I decided to drop the variables 
	using stata rather than using iecodebook. 
	I will use the iecodebook only to re-label and re-code variables. */ 

iecodebook apply using "${root}/iecodebook.xlsx", replace // This is the code that asks stata to apply my iecodebook to my dataset.

fre e_con
fre emp_ppal
fre cs_p13_1
fre p3o
fre per

save "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119-tidy.dta", replace


