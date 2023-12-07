clear 
global root "C:/Users/d57917il/Documents/GitHub/thesis-chapter1"

/* 

iecodebook is a command from the Stata package "iefieldkit" created by DIME Analytics

iecodebook allows the to automatically perform the repetitive steps involved in cleaning data before further analysis. 

It is particularly useful to drop, rename and recode variables in your dataset.

iecodebooks allow researchers to document the cleaned data in a format that is both human and machine-readable.

To install the command "iecodebook", you need to ask stata to install the pacakge "iefieldkit" using the following command
ssc install iefieldkit

More info in DIME Wiki: 
https://dimewiki.worldbank.org/iecodebook
https://www.youtube.com/watch?v=zm6eoMU09dA&t=1174s

*/

cd	"${root}/2_data-storage/pool_dataset" 
use pool_enoe_105_110_115_119.dta


/* The following line of code is used to generate the excel file "iecodebook"
However, those that want to replicate my code, doesn't need to generate a iecodebook. 
Instead, they just need to charge the one that I already prepared.   

Therefore, the code to generate a new iecodebook is current de-activated.
Instead, code-replicants just need to ask stata to apply 
the iecodebook.xlsx that I already did. 
*/

* iecodebook template using "${root}/iecodebook.xlsx", replace // *** De-activated for reproducibility purposes. 

/* Note to myself: Running the above command to generate a iecodebook takes 
a considerable amount of time as the current dataset had almost 400 variables and 
1.2 million observations. If you want to run this command in less time, a possible
option is to ask stata in advance to drop the variables that you don't need for 
the analysis, and just use the iecodebook to re-label and re-code variables. */ 

iecodebook apply using "${root}/iecodebook.xlsx", replace // This is the code that asks stata to apply my iecodebook to my dataset.

save "${root}/2_data-storage/pool_dataset/pool_enoe_105_110_115_119.dta", replace


