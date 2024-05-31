clear

cd "C:\Users\d57917il\Documents\GitHub\Chapter1-PhDthesis\4_outputs\figures\Percentage of women in agriculture and percentage of jobs in agriculture\datasets"

use SL.AGR.EMPL.ZS.2022.dta

merge 1:m countryname using SL.AGR.EMPL.FE.ZS.2022.dta
drop _merge

merge 1:m countryname using SP.POP.TOTL.2022.dta
drop _merge
sort sppoptotl022

drop if slagremplzs2022==.
drop if slagremplfezs2022==.

drop if inlist(countryname, 		///
"Low & middle income", 				///
"Low income", 						///
"High income",						///
"Lower middle income", 				///
"Middle income", 					///
"Upper middle income")

drop if inlist(countryname, 		///
"Early-demographic dividend", 		///
"Late-demographic dividend", 		///
"Post-demographic dividend", 		///
"Pre-demographic dividend")

drop if inlist(countryname, 		///
"Africa Eastern and Southern", 		///
"Africa Western and Central", 		///
"Middle East & North Africa", 		///
"Sub-Saharan Africa")

drop if inlist(countryname, 								///
"Middle East & North Africa (IDA & IBRD countries)", 		///
"Middle East & North Africa (excluding high income)", 		///
"Sub-Saharan Africa (IDA & IBRD countries)", 				///
"Sub-Saharan Africa (excluding high income)")

drop if inlist(countryname, 						///
"Central Europe and the Baltics", 					///
"Europe & Central Asia", 							///
"Europe & Central Asia (IDA & IBRD countries)", 	///
"Europe & Central Asia (excluding high income)",	///
"European Union",									///
"Euro area")

drop if inlist(countryname, 					///
"South Asia (IDA & IBRD)",						///
"South Asia",									///
"East Asia & Pacific", 							///
"East Asia & Pacific (IDA & IBRD countries)", 	///
"East Asia & Pacific (excluding high income)")

drop if inlist(countryname, 								///
"Latin America & Caribbean", 								///
"Latin America & Caribbean (excluding high income)", 		///
"North America",											///
"Caribbean small states",									///
"Latin America & the Caribbean (IDA & IBRD countries)")

drop if inlist(countryname, ///
"IBRD only", 				///
"IDA & IBRD total", 		///
"IDA blend",				///
"IDA only",					///
"IDA total")				

drop if inlist(countryname, ///
"Fragile and conflict affected situations", 	///
"Heavily indebted poor countries (HIPC)", 		///
"Least developed countries: UN classification",	///
"Small states",									///
"Other small states",							///
"Pacific island small states")				

drop if inlist(countryname, ///
"Fragile and conflict affected situations", 	///
"Heavily indebted poor countries (HIPC)", 		///
"Least developed countries: UN classification",	///
"Other small states",							///
"Pacific island small states")	

drop if inlist(countryname, ///
"Arab World", 				///
"OECD members", 			///
"World")	



sort countrycode


merge 1:m countrycode using Regions_2.dta


drop if slagremplzs2022==.
drop if slagremplfezs2022==.
drop alpha2 iso_31662 countrynumber
drop regioncode subregioncode intermediateregioncode
drop _merge


rename region continent
rename subregion region
rename intermediateregion subregion

order countryname name, first


sort continent   
replace continent="Americas" 	if countryname=="Argentina"
replace continent="Oceania" 	if countryname=="Australia"
replace continent="Africa" 		if countryname=="Algeria"
replace continent="Africa" 		if countryname=="Angola"
replace continent="Europe" 		if countryname=="Austria"
replace continent="Europe" 		if countryname=="Albania"
replace continent="Europe" 		if countryname=="Channel Islands"
replace continent="Asia" 		if countryname=="Armenia"
replace continent="Asia" 		if countryname=="Azerbaijan"
replace continent="Asia" 		if countryname=="Afghanistan"

/*
sort region
replace region="Latin America and the Caribbean" 	if countryname=="Argentina"
replace region="Australia and New Zealand" 			if countryname=="Australia"
replace region="Northern Africa" 					if countryname=="Algeria"
replace region="Northern Africa" 					if countryname=="Angola"
replace region="Eastern Europe" 					if countryname=="Austria"
replace region="Southern Europe" 					if countryname=="Albania"
replace region="Western Europe" 					if countryname=="Channel Islands"
replace region="Western Asia" 						if countryname=="Armenia"
replace region="Western Asia" 						if countryname=="Azerbaijan"
replace region="Southern Asia" 						if countryname=="Afghanistan"

sort continent region   
*/

replace name="Argentina" 					if countryname=="Argentina"
replace name="North Korea" 					if countryname=="Korea, Dem. People's Rep."
replace name="South Korea" 					if countryname=="Korea, Rep."
replace name="Lao PDR" 						if countryname=="Lao PDR"
replace name="Iran" 						if countryname=="Iran, Islamic Rep."
replace name="Afghanistan" 					if countryname=="Afghanistan"
replace name="Azerbaijan" 					if countryname=="Azerbaijan"
replace name="Palestine" 					if countryname=="West Bank and Gaza"
replace name="Syria" 						if countryname=="Syrian Arab Republic"
replace name="Armenia" 						if countryname=="Armenia"
replace name="Austria" 						if countryname=="Austria"
replace name="Russia" 						if countryname=="Russian Federation"
replace name="Moldova" 						if countryname=="Moldova"
replace name="United Kingdom"				if countryname=="United Kingdom"
replace name="Albania"						if countryname=="Albania"
replace name="Channel Islands"				if countryname=="Channel Islands"
replace name="Australia"					if countryname=="Australia"
replace name="Algeria"						if countryname=="Algeria"
replace name="Angola"						if countryname=="Angola"
replace name="Bolivia"						if countryname=="Bolivia"
replace name="Congo Democratic Republic"	if countryname=="Congo, Dem. Rep."
replace name="Venezuela"					if countryname=="Venezuela, RB"
replace name="Tanzania"						if countryname=="Tanzania"



sort sppoptotl022
generate population_category=.
replace  population_category=100 if sppoptotl022>99.999     & sppoptotl022<999.999
replace  population_category=200 if sppoptotl022>999.999    & sppoptotl022<4999.999
replace  population_category=300 if sppoptotl022>4999.999   & sppoptotl022<9999.999
replace  population_category=400 if sppoptotl022>9999.999   & sppoptotl022<19999.999
replace  population_category=500 if sppoptotl022>19999.999  & sppoptotl022<39999.999
replace  population_category=600 if sppoptotl022>39999.999  & sppoptotl022<69999.999
replace  population_category=700 if sppoptotl022>69999.999  & sppoptotl022<99999.999
replace  population_category=800 if sppoptotl022>99999.999  & sppoptotl022<999999.999
replace  population_category=900 if sppoptotl022>999999.999 
sort population_category 



*drop 	 big_countries
clonevar big_countries=name
replace  big_countries="."  			if population_category<899
replace  big_countries="Mexico" 		if name=="Mexico"
replace  big_countries="South Africa" if name=="South Africa"

*drop medium_countries
clonevar medium_countries=name
replace  medium_countries="." 				if population_category<500
replace  medium_countries="." 				if continent=="Europe"
replace  medium_countries="." 				if name=="Congo Democratic Republic"
replace  medium_countries="." 				if name=="Côte d'Ivoire"
replace  medium_countries="." 				if name=="Uzbekistan"
replace  medium_countries="." 				if name=="South Korea"
replace  medium_countries="." 				if name=="Venezuela"
replace  medium_countries="." 				if name=="Saudi Arabia"
replace  medium_countries="." 				if name=="Peru"
replace  medium_countries="." 				if name=="Sri Lanka"
replace  medium_countries="." 				if name=="Syria"
replace  medium_countries="." 				if name=="Iraq"
replace  medium_countries="." 				if name=="Japan"
replace  medium_countries="." 				if name=="Australia"
replace  medium_countries="." 				if name=="Malaysia"
replace  medium_countries="." 				if name=="Algeria"
replace  medium_countries="." 				if name=="United States of America"
replace  medium_countries="." 				if name=="Canada"
replace  medium_countries="." 				if name=="Niger"
replace  medium_countries="." 				if name=="Madagascar"
replace  medium_countries="." 				if name=="Kenya"
replace  medium_countries="." 				if name=="Egypt"
replace  medium_countries="." 				if name=="North Korea"
replace  medium_countries="." 				if name=="Zambia"
replace  medium_countries="." 				if name=="Angola"
replace  medium_countries="." 				if name=="Philippines"
replace  medium_countries="." 				if name=="Malawi"
replace  medium_countries="." 				if name=="Uganda"
replace  medium_countries="." 				if name=="Nepal"
replace  medium_countries="." 				if name=="Mali"
replace  medium_countries="." 				if name=="Thailand"
replace  medium_countries="." 				if name=="Afghanistan"
replace  medium_countries="." 				if name=="Argentina"
replace  medium_countries="." 				if name=="Iran"
replace  medium_countries="." 				if name=="Turkey"
replace  medium_countries="." 				if name=="Mexico"
replace  medium_countries="." 				if name=="South Africa"
replace  medium_countries="." 				if name=="China"
replace  medium_countries="." 				if name=="India"

*drop 	 small_countries
clonevar small_countries=name
replace  small_countries="." 				if population_category>500
replace  small_countries="." 				if continent=="Africa"
replace  small_countries="." 				if continent=="Asia"
replace  small_countries="." 				if continent=="Europe"
replace  small_countries="." 				if continent=="Americas"
replace  small_countries="." 				if continent=="Oceania"
replace  small_countries="." 				if name=="Solomon Islands"
replace  small_countries="." 				if name=="New Zealand"
replace  small_countries="." 				if name=="Papua New Guinea"
replace  small_countries="." 				if name=="Vanuatu"
replace  small_countries="."			 	if name=="Sierra Leone"
replace  small_countries="."			 	if name=="Samoa"
replace  small_countries="."			 	if name=="Fiji"
replace  small_countries="Iran" 			if name=="Iran"
replace  small_countries="Turkey" 			if name=="Turkey"
replace  small_countries="Afghanistan" 		if name=="Afghanistan"
replace  small_countries="Philippines" 		if name=="Philippines"
replace  small_countries="Zambia" 			if name=="Zambia"
replace  small_countries="Angola" 			if name=="Angola"
replace  small_countries="Burundi" 			if name=="Burundi"
replace  small_countries="Mali" 			if name=="Mali"
replace  small_countries="Nepal" 			if name=="Nepal"
replace  small_countries="Malawi" 			if name=="Malawi"
replace  small_countries="Ghana" 			if name=="Ghana"
replace  small_countries="Gabon" 			if name=="Gabon"
replace  small_countries="Armenia" 			if name=="Armenia"
replace  small_countries="Honduras" 		if name=="Honduras"
replace  small_countries="Zimbabwe" 		if name=="Zimbabwe"
replace  small_countries="Haiti" 			if name=="Haiti"
replace  small_countries="." 				if name=="Cameroon"
replace  small_countries="Azerbaijan" 		if name=="Azerbaijan"
replace  small_countries="Rwanda" 			if name=="Rwanda"
replace  small_countries="Guatemala" 		if name=="Guatemala"
replace  small_countries="Benin" 			if name=="Benin"
replace  small_countries="Uganda" 			if name=="Uganda"
replace  small_countries="Iraq" 			if name=="Iraq"
replace  small_countries="Thailand" 		if name=="Thailand"
replace  small_countries="." 				if name=="Ghana"








/*
replace  labeled_countries="Burundi" 		if name=="Burundi"
replace  labeled_countries="Mali" 			if name=="Mali"
replace  labeled_countries="Nepal" 			if name=="Nepal"
replace  labeled_countries="Malawi" 		if name=="Malawi"
replace  labeled_countries="Ghana" 			if name=="Ghana"
replace  labeled_countries="Gabon" 			if name=="Gabon"
replace  labeled_countries="Armenia" 		if name=="Armenia"
replace  labeled_countries="Honduras" 		if name=="Honduras"
replace  labeled_countries="Zimbabwe" 		if name=="Zimbabwe"
replace  labeled_countries="Haiti" 			if name=="Haiti"
replace  labeled_countries="Cameroon" 		if name=="Cameroon"
replace  labeled_countries="Azerbaijan" 	if name=="Azerbaijan"
replace  labeled_countries="Rwanda" 		if name=="Rwanda"
replace  labeled_countries="Guatemala" 		if name=="Guatemala"
replace  labeled_countries="Benin" 			if name=="Benin"
replace  labeled_countries="Sierra Leone" 	if name=="Sierra Leone"
replace  labeled_countries="Uganda" 		if name=="Uganda"
replace  labeled_countries="Iraq" 			if name=="Iraq"
*/



/*
replace  labeled_countries="." if name=="Russia"
replace  labeled_countries="." if name=="United Kingdom"
replace  labeled_countries="." if name=="Poland"
replace  labeled_countries="." if name=="Italy"
*/

/*
clonevar labeled_countries=name if population_category>799
clonevar   latam_countries=name if region=="Latin America and the Caribbean"
clonevar            africa=name if continent=="Africa"
*/

*replace  labeled_countries = "South Africa" 	if countryname="South Africa"
*replace  latam_countries = . 		if sppoptotl022 > 9999.999






// En los siguientes codigos encontraras el grafico para ilustrar como se ven los paises de forma global y diferenciando por continente.


// 1er grafica: Todos los paises. La grafica es en formato "bubble" e incluye los weights
scatter slagremplzs2022 slagremplfezs2022 															///
[w=sppoptotl022], 																					///
msymbol(Oh)	mlwidth(vthin) mcolor(navy) 															///
|| scatter slagremplzs2022 slagremplfezs2022,														///
msymbol(none) mlabcolor(red)																		///
mlabposition(center)																				///
mlabsize(vsmall)																					///
mlab(medium_countries)																				///
|| scatter slagremplzs2022 slagremplfezs2022,														///
msymbol(none) mlabcolor(red)																		///
mlabposition(center)																				///
mlabsize(tiny)																						///
mlab(small_countries)																				///
|| scatter slagremplzs2022 slagremplfezs2022,														///
msymbol(none) mlabcolor(red)																		///
mlabposition(center)																				///
mlabsize(small)																						///
mlab(big_countries)																					///
graphregion(color(white)) 																			///
xtitle("Employment in agriculture, female" "(% of female employment) (modeled ILO estimate)")		///
xtitle(, size(small))																				///
ytitle("Employment in agriculture " "(% of total employment) (modeled ILO estimate)")  				///
ytitle(, size(small))																				///
ylabel(0(10)90)  																					///
xlabel(0(10)100)  																					///							
yline(16) xline(12) 																				///
legend(off)		


















/// Graficas continentales

// Solo paises del continente Africano. 

preserve

keep if continent=="Africa" | name=="China" | name=="Saint Vincent and the Grenadines"

scatter slagremplzs2022 slagremplfezs2022 							/// 
[w=sppoptotl022],													///
msymbol(Oh)	mlwidth(vthin) mcolor(navy) 							///
|| scatter slagremplzs2022 slagremplfezs2022,						///
msymbol(none)														///
mlabcolor(none)														///
mlabposition(center)												///
mlabsize(tiny)														///
mlab(name)															///
ylabel(0(10)90)  													///
xlabel(0(10)100)  													///							
legend(off)		

restore




// Solo paises del continente Americano. 

preserve

keep if continent=="Americas" | name=="China" | name=="Saint Vincent and the Grenadines"

scatter slagremplzs2022 slagremplfezs2022 							/// 
[w=sppoptotl022],													///
msymbol(Oh)	mlwidth(vthin) mcolor(navy) 							///
|| scatter slagremplzs2022 slagremplfezs2022,						///
msymbol(none)														///
mlabcolor(none)														///
mlabposition(center)												///
mlabsize(tiny)														///
mlab(name)															///
ylabel(0(10)90)  													///
xlabel(0(10)100)  													///							
legend(off)		

restore


// Solo paises del continente Europeo. 

preserve

keep if continent=="Europe" | name=="China" | name=="Saint Vincent and the Grenadines"

scatter slagremplzs2022 slagremplfezs2022 							/// 
[w=sppoptotl022],													///
msymbol(Oh)	mlwidth(vthin) mcolor(navy) 							///
|| scatter slagremplzs2022 slagremplfezs2022,						///
msymbol(none)														///
mlabcolor(none)														///
mlabposition(center)												///
mlabsize(tiny)														///
mlab(name)															///
ylabel(0(10)90)  													///
xlabel(0(10)100)  													///							
legend(off)		

restore



// Solo paises de Asia u Oceania. 

preserve

keep if continent=="Asia" | continent=="Oceania" | name=="China" | name=="Saint Vincent and the Grenadines"

scatter slagremplzs2022 slagremplfezs2022 							/// 
[w=sppoptotl022],													///
msymbol(Oh)	mlwidth(vthin) mcolor(navy) 							///
|| scatter slagremplzs2022 slagremplfezs2022,						///
msymbol(none)														///
mlabcolor(none)														///
mlabposition(center)												///
mlabsize(tiny)														///
mlab(name)															///
ylabel(0(10)90)  													///
xlabel(0(10)100)  													///							
legend(off)		

restore





















preserve

keep if continent=="Africa" | name=="China" | name=="Saint Vincent and the Grenadines"

scatter slagremplzs2022 slagremplfezs2022 												/// 
[w=sppoptotl022],																		///
msymbol(Oh)	mlwidth(vthin) mcolor(white) 												///

if continent=="Africa" 	msymbol(Oh)	mlwidth(vthin) mcolor(navy) 						///
if name=="China" 		msymbol(Oh)	mlwidth(vthin) mcolor(white) 						///
if name=="Saint Vincent and the Grenadines" msymbol(Oh)	mlwidth(vthin) mcolor(white) 	///
|| scatter slagremplzs2022 slagremplfezs2022,											///
msymbol(none) mlabcolor(red)															///
mlabposition(center)																	///
mlabsize(tiny)																			///
mlab(name)																				///
ylabel(0(10)90)  																		///
xlabel(0(10)100)  																		///							
legend(off)		

restore



























yline(16) xline(12) yline(50)


///
ytitle ("")		///
xtitle ("") 


ytitle(Female labor Participation Rate) ytitle(, size(vsmall)) ylabel(, labsize(vsmall)) /// 




// 2da grafica. Todos los paises. La grafica no es formato bubble ni tampoco incluye weights.
scatter slagremplzs2022 slagremplfezs2022, ///
msymbol(Oh) 


scatter slagremplzs2022 slagremplfezs2022 [w=sppoptotl022], ///
msymbol(Oh)										///
if name=="China" mcolor(white)


scatter slagremplzs2022 slagremplfezs2022 [w=population_category]































// 1st graph: All countries
twoway 													/// 
(scatter 	slagremplzs2022 slagremplfezs2022 			///
			[aweight = sppoptotl022], 					/// 
			msize(small) msymbol(Oh)) 					///
(lfit 		slagremplzs2022 slagremplfezs2022 			///
			[pweight = sppoptotl022])


// 2nd graph: European countries



// 3rd graph: Latam countries



























twoway 													/// 
(scatter 	slagremplzs2022 slagremplfezs2022 			///
			[aweight = sppoptotl022], 					/// 
			msize(small) msymbol(smcircle_hollow)) 		///
(qfit 		slagremplzs2022 slagremplfezs2022 			///
			[pweight = sppoptotl022])





			
			
			
			
			

twoway /// 
(scatter slagremplzs2022 slagremplfezs2022) 	/// 
[w=sppoptotl022],							 	///
(lfit slagremplzs2022 slagremplfezs2022)	







scatter slagremplzs2022 slagremplfezs2022 	///
[w=sppoptotl022], 							///
msymbol(Oh)


scatter slagremplzs2022 slagremplfezs2022 	///
[w=sppoptotl022], 							///
msymbol(Oh)									///
mlabel(labeled_countries)				







scatter slagremplzs2022 slagremplfezs2022 	///
[w=sppoptotl022], 							///
msymbol(Oh)	|| 								///
scatter slagremplzs2022 slagremplfezs2022,	///
msymbol(none) mlab(labeled_countries)

scatter slagremplzs2022 slagremplfezs2022 	///
[w=sppoptotl022], 							///
msymbol(Oh)	mcolor(navy) || 				///
scatter slagremplzs2022 slagremplfezs2022,	///
msymbol(none) mcolor(blue)					///
mlabposition(center)						///
mlabsize(tiny)								///
mlab(labeled_countries)












preserve
drop if region!="Latin America and the Caribbean"

scatter slagremplzs2022 slagremplfezs2022 	///
[w=sppoptotl022], 							///
msymbol(Oh)	mcolor(navy) || 				///
scatter slagremplzs2022 slagremplfezs2022,	///
ylabel(0(10)100)  							///
xlabel(0(10)100)  							///
msymbol(none) mcolor(blue)					///
mlabposition(center)						///
mlabsize(vsmall)							///
mlab(latam_countries)						


restore




















								///
mlabel(labeled_countries)


scatter slagremplzs2022 slagremplfezs2022

scatter slagremplzs2022 slagremplfezs2022, ///
msymbol(Oh) 		///
msize(vsmall) 		/// 
mlabsize(vsmall)




scatter slagremplzs2022 slagremplfezs2022, 		///
ytitle ("% of agricultural jobs"),				///
xtitle ("% of female in agriculture") 
























scatter slagremplzs2022 slagremplfezs2022 

scatter slagremplzs2022 slagremplfezs2022, msize(vsmall) mlabsize(vsmall) mlabel(labeled_countries)
scatter slagremplzs2022 slagremplfezs2022, msize(vsmall) mlabsize(vsmall) mlabel(latam_countries) 
scatter slagremplzs2022 slagremplfezs2022, msize(vsmall) mlabsize(vsmall) mlabel(africa) 				




 		

scatter slagremplzs2022 slagremplfezs2022 ///
[w=sppoptotl022], 	///
msymbol(Oh),		/// 	
mlabel(labeled_countries)






scatter slagremplzs2022 slagremplfezs2022 [w=sppoptotl022], ///
msymbol(Oh) 		

///
msize(vsmall) 		











preserve
drop if region!="Latin America and the Caribbean"
scatter slagremplzs2022 slagremplfezs2022 [w=sppoptotl022], /// 
mlabel(name) ///

restore







scatter slagremplzs2022 slagremplfezs2022 	/// 
[w=sppoptotl022],							///
 
mlabel(labeled_countries) 	///
msize(tiny) 				///
mlabsize(tiny) 				///
mcolor(continent) 
 

scatter slagremplzs2022 slagremplfezs2022 






sort sppoptotl022

sort name continent


twoway (scatter slagremplzs2022 slagremplfezs2022 [w=sppoptotl022]) 





scatter slagremplzs2022 slagremplfezs2022 [w=sppoptotl022]
