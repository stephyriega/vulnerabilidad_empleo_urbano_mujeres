
clear
clear all
set more off
mat drop _all

global 	root = "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres" 
	
global data = "$root\data"


***************************************************************************************
**************************** TABLA RESUMEN *****************
***************************************************************************************

use "$data\enaho_final_double_stata.dta", clear

keep if ano>15 & ano<21

duplicates drop num ano perpanel, force

*keep if n_ano==0
order ano, first
drop if perpanel==""

*area region domin02 dpto resi p209 educ 
*grupos etarios
*recode p208a (14=1 "14 años") (15/29=2 "15 - 29 años") (30/44=3 "30 - 44 años") (45/64=4 "45 - 64 años") (65/98=5 ">= 65 años"), gen (age)

recode p208a (14/24=1 "14/24 años") (25/59=2 "15/59 años") (60/64=3 "60/64 años") (64/100=4 "64 o mas años"), gen (edad)


svyset [pweight=facpob], psu(conglome) strata(estrato)

*resi==1 & ano==20 & result==1 


******************* PET (0 1)**********************************************************

tab area  p207 [iw= fac500a] if resi==1 & ano==20 & p208a>15

estpost tabstat area  p207  [aw=fac500a], by(ano) stat(n) col(stat)

egen area_sexo = group(area p207), lab
tab area_sexo 

tabout area_sexo ano [aw=fac500a] ///
if resi==1 & p208a>15 using table2.txt, ///
cells(col) format(1p) clab(_ _ _) ///
layout(rb) h3(nil) ///
replace


style(tex) bt font(bold) cl1(2-4) ///
topf(top.tex) botf(bot.tex) topstr(11cm) botstr(nlsw88.dta)


***************** PEA ************************************************************
tab area   ocu500 [iw= fac500a] if resi==1 & ocu500<3  p208a>13
*replace y_pri=0 if y_pri==.


tabout p207 ano [aw=fac500a] ///
if resi==1 & ocu500<3 & p208a>13 using table3.txt, ///
cells(col) format(1p) clab(_ _ _) ///
layout(rb) h3(nil) ///
replace


************************* TASA DE ACTIVIDAD *************************************
*El cociente de la Población Económicamente Activa entre el total de Población en Edad de Trabajar
gen     t_act=0  if p208a>=14
replace t_act=1  if ocu500==1 | ocu500==2
lab def t_act 0 "" 1 "Tasa de Actividad"
lab val t_act t_act

tab t_act p207   [aw= fac500a] if resi==1 & ano==19, col nofreq
*tab t_act region [iw= fac500a] if  resi==1, col nofreq

egen tasa_sexo = group(t_act p207), lab
*replace tasa_sexo =. if t_act==0
tab tasa_sexo 

*hombre
tabout tasa_sexo ano [aw=fac500a] ///
if resi==1 & p207==1 using table4.txt, ///
cells(col) format(1p) clab(_ _ _) ///
layout(rb) h3(nil) ///
replace

*append con calculo de mujer

*mujer
tabout tasa_sexo ano [aw=fac500a] ///
if resi==1 & p207==2 using table4.txt, ///
cells(col) format(1p) clab(_ _ _) ///
layout(rb) h3(nil) ///
replace

************************* DEPARTAMENTO *************************************

egen tasa_dpto = group(t_act dpto), lab
*replace tasa_sexo =. if t_act==0
tab tasa_sexo 

tabout tasa_dpto ano [aw=fac500a] ///
if resi==1 & dpto==1 using table4.txt, ///
cells(col) format(1p) clab(_ _ _) ///
layout(rb) h3(nil) ///
replace

************************* POR GRUPO DE CLASIFICACION DE RESPUESTA  *************************************

tab ciiu_6c [iw= fac500a]  if resi==1 & ocu500==1 & ano==20 & p207==2, m

*tab p517 [iw= fac500a]  if resi==1 & ocu500==1 & ano==20 & p207==2 & p517!=., m


**************** VARIANZA POR GRUPOS (entre 2019 y 2016) ***********************

encode perpanel, gen(perp)
sort perp
by perp: cv2 dpto if resi==1 & ocu500==1 & p207==2 & area==1

by perp: cv2 estrato if resi==1 & ocu500==1 & p207==2 & area==1

by perp: cv2 regnat if resi==1 & ocu500==1 & p207==2 & area==1

by perp: cv2 pobre2 if resi==1 & ocu500==1 & p207==2 & area==1


/*
recode y_pri (0=1 "Sin ingresos") (1/499=2 "<500") (500/999=3 "500 - 999") (1000/1499=4 "1000 - 1499") (1500/1001569=5 ">=1500"), gen (ing)


foreach var of varlist age educ ing ocupinf p209 pobreza {

tab `var', gen(`var'_)
}

/*
la var age_1 "14 años"
la var age_2 "15 - 29 años"
la var age_3 "30 - 44 años"
la var age_4 "45 - 64 años"
la var age_5 ">= 65 años"

la var p209_1 "Conviviente"
la var p209_2 "Casado"
la var p209_3 "Viudo"
la var p209_4 "Divorciado"
la var p209_5 "Separado"
la var p209_6 "Soltero"

la var pobreza_1 "Pobre extremo"
la var pobreza_2 "Pobre no extremo"
la var pobreza_3 "No pobre"

la var educ_1 "Conviviente"
la var educ_2 "Casado"
la var educ_3 "Viudo"
la var educ_4 "Divorciado"
la var educ_5 "Separado"
la var educ_6 "Soltero"

la var p513t "Horas semanales"

la var ing_1 "Sin ingresos"
la var ing_2 "<500 soles"
la var ing_3 "500 - 999 soles"
la var ing_4 "1000 - 1499 soles"
la var ing_5 ">=1500 soles"

la var ocupinf_1 "Empleo informal"
la var ocupinf_2 "Empleo informal"
la var ocupinf_3 ""

*/

preserve

keep if ocu500==1

estpost tabstat p513t age_* p209_* pobreza_* educ_* ing_* ocupinf_* [aw=fac500a], by(ano) stat(n mean sd min max) col(stat)


restore

preserve

estpost tabstat age_* p209_* pobreza_* educ_*  [aw=fac500a], by(ano) stat(n mean sd min max) col(stat)

restore

*https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fcdn.www.gob.pe%2Fuploads%2Fdocument%2Ffile%2F2078164%2F7%2520Departamentos_empleo_rango%2520de%2520edad%25202004-2020.xlsx&wdOrigin=BROWSELINK

*https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fcdn.www.gob.pe%2Fuploads%2Fdocument%2Ffile%2F2078167%2F10%2520Departamentos_empleo_rango%2520de%2520ingresos%25202004-2020.xlsx&wdOrigin=BROWSELINK

**************************** TABLA CORRELACION *****************
/*
use "$data\enaho_final_double_stata.dta", clear

keep if n_ano==0
order ano, first

foreach var of varlist y_pri_dep y_pri_indep y_pri y_sec_dep y_sec_ind {

replace `var'=0 if `var'==.

}

drop 

pwcorr *, obs sig star(0.01) // significativo al (*) 1%

/* o tambien puede ser mediante edad al cuadrado:
gen age2=age*age
corr ing_lab age2 */

* Graficamos correlaciones

graph matrix ing_lab age age_sq male urban, diagonal(,bfcolor(eggshell)) graphregion(color(white)) // rel entre distintas variables
graph export "$graphs/matrix 1.png", replace

*/



restore

****************************************************************