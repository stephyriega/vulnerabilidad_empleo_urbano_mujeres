clear
clear all
set more off
mat drop _all

global 	root = "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres" 
	
global data = "$root\data"
	
**************************** MATRICES DE TRANSICION ***********************************
	
use "$data\enaho_final_double_stata.dta", clear

gen panel=substr(num_panel, -5,.)

egen num_panel_e = group(num_panel)
egen panel_e = group(panel)
xtset num_panel_e ano

sort num_panel
order num_panel ano, first

gen desemp=(ocu500!=1)
sort panel_e

xttrans desemp, freq

by panel_e: xttrans desemp, freq

******************** COMPARACION DE EMPLEADAS Y DESEMPLEADAS *******************

by num_panel , sort: gen año_1 = 1 if ocu500[1] ==1  // ocupado
by num_panel , sort: gen año_2 = 1 if ocu500[_N] ==1 // desempleo abierto

gen nodeg_desemp=2 if año_1==1 & año_2==1
*replace nodeg_desemp=0 if nodeg_desemp==.

gen desemp= nodeg_desemp
replace desemp=deg_desemp if nodeg_desemp==.
replace desemp=. if desemp==0

keep if n_ano==0
order ano, first

*grupos etarios
recode p208a (14=1 "14 años") (15/29=2 "15 - 29 años") (30/44=3 "30 - 44 años") (45/64=4 "45 - 64 años") (65/98=5 ">= 65 años"), gen (age)

replace y_pri=0 if y_pri==.

recode y_pri (0=1 "Sin ingresos") (1/499=2 "<500") (500/999=3 "500 - 999") (1000/1499=4 "1000 - 1499") (1500/1001569=5 ">=1500"), gen (ing)


foreach var of varlist age educ ing ocupinf est_civil pobreza {

tab `var', gen(`var'_)
}



foreach var of varlist age_* est_civil_* pobreza_* educ_* ing_* ocupinf_* {

ttest `var', by(desemp)
matrix ttest= (r(mu_1), r(N_1), r(mu_2), r(N_2), r(mu_1) - r(mu_2), r(p))
matrix rownames ttest= `var'
*matrix colnames ttest= Media-1 N1 Media-2 N2 Diff P-value
mat2txt, matrix(ttest) sav("$data/ttest_DE2.xls") append
}

