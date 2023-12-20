clear
use "C:\Users\d57917il\Documents\1paper1\tidydata_2019.dta"






cd "C:\Users\d57917il\Desktop\mprobit\4_outputs\regressions" // Change directory to store results of the regression. 

**************************
*** MULTINOMIAL PROBIT ***
**************************

mprobit work_sector /// work_sector: 0 - Non economically active / 1 - Agriculture / 2 - Industry / 3 - Services / 4 - Unspecified activities  
ib(5).e_con##c.eda /// interaction between marital status and age, using "5 = being married" as the base category for marital status.  
c.eda#c.eda /// age squared
ib(0).cs_p13_1 /// level of education, using " 0 = no studies at all" as the base category.
ib(1).soc_str /// social stratum, using "10 = low social stratum" as the base category. 
ib(4).t_loc /// locality size, using "4 = Less than 2,500 inhabitants" as the base category. 
ib(1).ur /// rural/urban, using "1 = urban" as the base category. 
ib(0).num_kids /// Total live-born kids, using "0 = No sons or daughters" as the base category. 
ib(9).ent /// Fixed effects at the state level using " 9 = Mexico City" as the base category. This allows to control for unobserved heterogeneity. 
if female==1 /// Regression restricted only to women in the sample. 
[pweight=fac], /// Probability weights 
vce (robust) // Robust standard errors. 
outreg2 using mprobit_work_sector_marital.xls, replace label // Save regression results in excel format
outreg2 using mprobit_work_sector_marital.doc, replace label // Save regression results in word format
estimates save mprobit_work_sector_marital.ster, replace // Save regression results in .ster format

/* Important note:
Este codigo funciono! No le hagas cambios.
Si le quieres hacer cambios, hazlos abajo de este codigo. 
Esto evitara que te salga un error y despues no sepas cual fue la razon del error. 
*/

/* Important note:
Remember to save all the outputs obtained from the regression with the same name as the new folder you just created. For example:

mprobit_work_sector_marital.xls // Regression results as excel file
mprobit_work_sector_marital.doc // Regression results as word file
mprobit_work_sector_marital.ster // Margins estimates as .ster file
marginsplot_work_sector_marital.gph // Graph
marginsplot_work_sector_marital.png // Image
*/







// Para cargar los resultados de la regresion multinomial anterior, requieres correr el siguiente codigo: 

clear // Elimina todo lo hecho anteriormente y carga los resultados de la regresion. 
use "C:\Users\d57917il\Documents\1paper1\tidydata_2019.dta" // Es necesario que vuelvas a cargar la base de datos que usaste como referencia para que puedas correr el codigo.
cd "C:\Users\d57917il\Documents\mprobit\4_outputs\regressions" // Indicale a stata el directorio donde guardaste los resultados de la regresion. 

estimates use mprobit_work_sector_marital.ster // Indicale a Stata que cargue los resultados de la regresion en formato .ster 
estimates esample:
mprobit // Al escribir este comando se cargaran los resultados de la regresion en Stata, ya que los obtuviste con el comando mprobit


// Una vez cargados los resultados, puedes pedirle a Stata que te calcule los average marginal effects. 
*margins female, at(eda=(20(5)65)) atmeans post 
*estimates save 2margins_mprobit_work_sector_marital.ster, replace 
margins e_con, at(eda=(20(5)80)) nose post // Por alguna razon, solo funciona con nose "no standard errors"
estimates save margins_mprobit_work_sector_marital.ster, replace 
*margins e_con, at(eda=(20(5)80)) atmeans vsquish 










// Para cargar los resultados de los average marginal effects, requieres correr el siguiente codigo. 

clear // Elimina todo lo hecho anteriormente y carga los resultados de la regresion. 
use "C:\Users\d57917il\Documents\1paper1\tidydata_2019.dta" // Es necesario que vuelvas a cargar la base de datos que usaste como referencia para que puedas correr el codigo.
cd "C:\Users\d57917il\Desktop\mprobit\4_outputs\regressions" // Indicale a stata el directorio donde guardaste los resultados de la regresion. 

estimates use margins_mprobit_work_sector_marital.ster
margins // Al escribir este comando se cargaran los resultados de los margenes en Stata

marginsplot, ///
by(_predict, label("Not Working" "Working in agriculture" "Working in industry" "Working in Services" )) ///
byopts(holes(3) title("Predicted probability that a woman is working in a economic sector" "depending on their age & their marital status.")) ///
title(, size(vsmall)) /// legend(order(4 "Married" 3 "Single")) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Age") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) ///
ylabel(0(0.1)1) /// 
legend(size(vsmall)) ///
plotopts(msize(vsmall))
gr_edit .plotregion1.plotregion1[5].draw_view.setstyle, style(no)
gr_edit .plotregion1.subtitle[5].draw_view.setstyle, style(no)
gr_edit .plotregion1.xaxis1[5].draw_view.setstyle, style(no)
gr_edit .title.style.editstyle size(medsmall) editcopy
gr_edit .legend.Edit , style(rows(1)) style(cols(0)) keepstyles 
gr_edit .legend.Edit , style(rows(1)) style(cols(0)) style(key_xsize(10)) keepstyles 
gr_edit .legend.Edit , style(rows(1)) style(cols(0)) keepstyles 
cd "C:\Users\d57917il\Desktop\mprobit\4_outputs\graphs"
graph export "C:\Users\d57917il\Desktop\mprobit\4_outputs\graphs\marginsplot_mprobit_work_sector_marital.png", replace
graph save "Graph" "C:\Users\d57917il\Desktop\mprobit\4_outputs\graphs\marginsplot_mprobit_work_sector_marital.gph", replace






































**************
*** PROBIT ***
**************

/* En estas regresiones analizaremos si las mujeres casadas son 
menos propensas a trabajar que las mujeres solteras, en distintos sectores economicos. Solamente consideraremos mujeres entre 18 y 65 anios de edad.  */

cd "C:\Users\d57917il\Desktop\mprobit\4_outputs\regressions"


local XXX ///
work_fem_agri /// 1 = Working in agriculture
work_fem_ind /// 1 = Working in industry
work_fem_serv /// 1 = Working in services
work_fem_const /// 1 = Working in construction
work_fem_textile // 1 = Working in textile

foreach dependent_variable of local XXX {
probit `dependent_variable' /// 
ib(5).e_con##c.eda /// Base category 5=Married, interaction with age
c.eda#c.eda /// Age squared
ib(0).educ /// Education level, Base Category=0 "no studies at all"
ib(1).soc_str /// Socio-Economic Stratum, Base Category=1 "Low"
ib(0).num_kids /// Total live-born kids, Base category=0 "No sons or daughters".
ib(3).t_loc /// Locality size, Base category=4 "Between 2,500 and 15,000 inhabitants"
ib(1).ur /// Rural/urban identifier, Base Category=1 "Urban" 
ib(9).ent /// State identifier, Base category=9 "Mexico City", to control for unobserved heterogeneity
[pweight=fac], vce (robust)
outreg2 using reg_work_sector_marital.xls,append label dec(5)
}





**************************
*** MULTINOMIAL PROBIT ***
**************************



/* Important note #2:

Para no tener que hacer todo desde cero cada que estas trabajando con regresiones multinomiales, puedes cargar los resultados de las regresiones o los average marginal effects que ya obtuviste. 
Para hacerlo, tienes que usar tres comandos:

estimates use 
estimates esample: 
margins 

// El comando "estimates use" sirve para cargar los resultados que estimaste. 

// El comando "estimates esample:" sirva para que los resultados puedan utilizarse sin que Stata marque error. 

// En este caso el comando que se utiliza de ejemplos es "margins" porque estas cargando resultados que se obtuvieron con el comando margins. No obstante, si los resultados que cargaste fueron obtenidos con el comando mprobit, entonces deberas poner "mprobit"  

Mas info en: https://www.stata.com/manuals13/restimatessave.pdf 
*/


global main_folder "C:\Users\d57917il\Desktop\mprobit"

cd "$main_folder\4_outputs\regressions"

/* Important note:  

You need to run all the commands at once to get the marginsplot result. If you don't want to run all the commands together, you need to use the command "estimates save"

For example: 
estimates save reg_mprobit_work_marital.ster

It is important to save the results in ".ster" format so you can charge the results back again into stata. Para que esto funcione, 
es necesario que tambien cargues la base de datos con la que calculaste los resultados. En este caso la base de datos es: tidydata_2019

*/


/////////////////////////////
// Execute regression /////
////////////////////////

/* El siguiente codigo eliminara de la variable "work_sector" a 
todos aquellos que tengan menos de 18 y mas de 65 anios. 
Es decir, contemplara solo a working age population */

replace work_sector=. if eda<=17
replace work_sector=. if eda>=66
tab work_sector if female==1












mprobit work_sector ///
ib(5).e_con##c.eda /// interaction between marital status and age, using "5 = being married" as the base category for marital status.  
c.eda#c.eda /// age squared
ib(0).cs_p13_1 /// level of education, using " 0 = no studies at all" as the base category.
ib(1).soc_str /// social stratum, using "10 = low social stratum" as the base category. 
ib(4).t_loc /// locality size, using "4 = Less than 2,500 inhabitants" as the base category. 
ib(1).ur /// rural/urban, using "1 = urban" as the base category. 
ib(0).num_kids /// Total live-born kids, using "0 = No sons or daughters" as the base category. 
ib(9).ent /// Fixed effects at the state level using " 9 = Mexico City" as the base category. This allows to control for unobserved heterogeneity. 
if female==1 /// Regression restricted only to women in the sample. 
[pweight=fac], /// Probability weights 
vce (robust) // Robust standard errors. 
outreg2 using mprobit_work_sector_marital.xls, replace label // Save regression results in excel format
outreg2 using mprobit_work_sector_marital.doc, replace label // Save regression results in word format
estimates save mprobit_work_sector_marital.ster // Save regression results in .ster format


// Para cargar los resultados de la regresion multinomial anterior, requieres correr el siguiente codigo: 
estimates use mprobit_work_sector_marital.ster 
estimates esample:
mprobit // Al escribir este comando se cargaran los resultados de la regresion en Stata, ya que los obtuviste con el comando mprobit


// Ahora es momento de obtener los average marginal effects. 

*margins e_con, at(eda=(20(5)80)) nose post 
margins e_con, at(eda=(20(5)80)) atmeans vsquish 
estimates save margins_mprobit_work_sector_marital.ster

* STEP 5
* After saving the .ster file, you ask stata to open it so you can run the marginsplot

* estimates use mprobit_work_marital.ster
* margins // Al escribir este comando se cargaran los resultados de los margenes en Stata

marginsplot, ///
by(_predict, label("Not Working" "Working in agriculture" "Working in industry" "Working in Services" )) ///
byopts(holes(3) title("Predicted probability that a woman is working in a economic sector" "depending on their age & their marital status.")) ///
title(, size(vsmall)) /// legend(order(4 "Married" 3 "Single")) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Age") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) ///
ylabel(0(0.1)1) /// 
legend(size(vsmall)) ///
plotopts(msize(vsmall))
gr_edit .plotregion1.plotregion1[5].draw_view.setstyle, style(no)
gr_edit .plotregion1.subtitle[5].draw_view.setstyle, style(no)
gr_edit .plotregion1.xaxis1[5].draw_view.setstyle, style(no)
gr_edit .title.style.editstyle size(medsmall) editcopy
gr_edit .legend.Edit , style(rows(1)) style(cols(0)) keepstyles 
gr_edit .legend.Edit , style(rows(1)) style(cols(0)) style(key_xsize(10)) keepstyles 
gr_edit .legend.Edit , style(rows(1)) style(cols(0)) keepstyles 
graph export "$main_folder\mprobit_work_marital_kids\mprobit_work_marital.png", replace
graph save "Graph" "$main_folder\mprobit_work_marital_kids\mprobit_work_marital.gph", replace

























estimates use margins_mprobit_work_marital.ster
estimates esample: 
margins 

marginsplot, ///
by(_predict, label("Not Working" "Working in agriculture" "Working in industry" "Working in Services" )) ///
byopts(holes(3) title("Predicted probability that a woman is working in a economic sector" "depending on their age & their marital status.")) ///
title(, size(vsmall)) /// legend(order(4 "Married" 3 "Single")) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Age") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) ///
ylabel(0(0.1)1) /// 
legend(size(vsmall)) ///
plotopts(msize(vsmall))
gr_edit .plotregion1.plotregion1[5].draw_view.setstyle, style(no)
gr_edit .plotregion1.subtitle[5].draw_view.setstyle, style(no)
gr_edit .plotregion1.xaxis1[5].draw_view.setstyle, style(no)
gr_edit .title.style.editstyle size(medsmall) editcopy
gr_edit .legend.Edit , style(rows(1)) style(cols(0)) keepstyles 
gr_edit .legend.Edit , style(rows(1)) style(cols(0)) style(key_xsize(10)) keepstyles 
gr_edit .legend.Edit , style(rows(1)) style(cols(0)) keepstyles 

graph export "$main_folder\mprobit_work_marital_kids\mprobit_work_marital.png", replace
graph save "Graph" "$main_folder\mprobit_work_marital_kids\mprobit_work_marital.gph", replace
