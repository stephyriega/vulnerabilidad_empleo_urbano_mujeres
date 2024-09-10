clear
clear all
set more off
mat drop _all

global 	root = "G:\Mi unidad\2021-2\TESIS_1" 
	
global data = "$root\3_datos"
*****************************************************************************
import excel using "G:\Mi unidad\2021-2\TESIS_1\3_datos\classified_2020.xlsx", clear firstrow

*************************** TABLA COMPARACION DE CARACTERÍSTICAS **************

*grupos etarios
recode p208a (14=1 "14 años") (15/29=2 "15 - 29 años") (30/44=3 "30 - 44 años") (45/64=4 "45 - 64 años") (65/98=5 ">= 65 años"), gen (age)

replace y_pri=0 if y_pri==.

recode y_pri (0=1 "Sin ingresos") (1/499=2 "<500") (500/999=3 "500 - 999") (1000/1499=4 "1000 - 1499") (1500/1001569=5 ">=1500"), gen (ing)


foreach var of varlist age ing {

tab `var', gen(`var'_)
}


foreach var of varlist age_* p209_* pobreza_* educ_* ing_* ocupinf_* {

ttest `var', by(y_pred)
matrix ttest= (r(mu_1), r(N_1), r(mu_2), r(N_2), r(mu_1) - r(mu_2), r(p))
matrix rownames ttest= `var'
*matrix colnames ttest= Media-1 N1 Media-2 N2 Diff P-value
mat2txt, matrix(ttest) sav("$data/ttest_predichas_2019.xls") append
}


************************* TEST DE HIPOTESIS ***********************


*Ho: 0.18 y Ha: !=0.18



*Ho: 0.18 y Ha: 0.6


************ EVALUACION DE AÑO 2020 A 2019 **********************

ttest y_pred=0.18
matrix ttest= (r(mu_1), r(N_1), r(mu_2), r(N_2), r(mu_1) - r(mu_2), r(p))
matrix rownames ttest= y_pred
*matrix colnames ttest= Media-1 N1 Media-2 N2 Diff P-value
mat2txt, matrix(ttest) sav("$data/ttest_predichas_2020.xls") append
