
 // si nacio en distrito, si tiene contrato o no

drop año_1 año_2

drop merge*

drop ocu500 estrato

*entreo 70 y 100%
*TI_5_17 p110a1_15 

*drop if ingmo1hd==.
*drop if educ==.

////////////// Completar con los no aplica a las variables: //////////

*si tienen ruc
replace p510a1=4 if p510a1==. // no aplica a formales puesto q solo les pregunta  a los informales

*si tienen contrato
replace p511a=9 if p511a==. // no aplica a los informales puesto q solo se les preunta a los formale

*horas de trabajo semanales
replace p513t=0 if p513t==. // no aplica a  a los desempleados puesto q solo aplica a empleados

*empleo formal/informales
replace ocupinf=3 if ocu500!=1 // no aplica para los desempleados

*empleo informal en sector formal/informal: 
replace emplpsec=3 if emplpsec==. // no aplica para los q no trbajan en sector informal



****************************** PROCESAMIENTO DE VARIABLES *******************


use "$data\enaho_final_double_stata.dta", clear

********************** CREACION DE VARIABLES *****************

keep if n_ano==0
order ano, first

*one-hot-encoding
/*
foreach var of varlist p501 p5571a p5572a p5573a p5574a p5575a p5576a p5577a p5578a p5581a p5582a p5583a p5584a p5585a p5586a p5587a p560t_01 p560t_02 p560t_03 p560t_04 p560t_05 p560t_06 p560t_07 p560t_08 p560t_09 p560t_10 {

replace `var'=3 if `var'==. // no aplica para estas vars
}
*/

drop if p560t_10==.

drop if ano==20

foreach var of varlist dominio estrato p203 p300a p558c educ sector p510a1 p511a ocupinf emplpsec p5571a p5572a p5573a p5574a p5575a p5576a p5577a p5578a p5581a p5582a p5583a p5584a p5585a p5586a p5587a p560t_01 p560t_02 p560t_03 p560t_04 p560t_05 p560t_06 p560t_07 p560t_08 p560t_09 p560t_10 p599 p209 pobreza ano dep{

tab `var', gen(`var'_)
drop `var'
}

foreach var of varlist p501 p5561a p5562a p5563a p5564a p5565a p5566a p5567a p5568a p559_01 p559_02 p559_03 p559_04 p306 p310 p204 p207 {
replace `var'=0 if `var'==2
}

replace p558a2=1 if p558a2==2
replace p558a3=1 if p558a3==3
replace p558a4=1 if p558a4==4
replace p558a5=1 if p558a5==5

*interacciones para el cv estartificado

*pregunta: data splitting (test y train) tbm estratificado? como? 

*pregunta: si voy a usar el ano y departamento para CV (division), puedo usarla como predictor?

*xi i.ano*i.dep


*************************  DELIMITANDO VARIABLES  *******************
* completamos con los missings con valor 0 oq no gana en ese 

foreach var of varlist y_pri_dep y_pri_indep y_pri y_sec_dep y_sec_ind {

replace `var'=0 if `var'==.
}


*eliminamos outliers
foreach var of varlist y_pri_dep y_pri_indep y_pri y_sec_dep y_sec_ind y_sec y_mkt p513t {

sum `var', d
replace `var'=r(p95) if `var'>=r(p95)
}


drop n_ano ocu500 num conglome vivienda hogar codperso ubigeo d544t fac500a


drop  y_sec_dep y_sec_ind y_pri_indep y_pri_dep
 drop if  p5587a_2 ==.

*no dropeamos deg_desemp

save "$data\enaho_final_one_python.dta", replace

export excel using "$data\enaho_final_one_python.xlsx", firstrow (variable) nolabel replace

***************************** AÑO 2020 ******************************************

use "$data\enaho_final_double_stata.dta", clear

keep if ano==20

********************** CREACION DE VARIABLES *****************

order ano, first

*one-hot-encoding
/*
foreach var of varlist p501 p5571a p5572a p5573a p5574a p5575a p5576a p5577a p5578a p5581a p5582a p5583a p5584a p5585a p5586a p5587a p560t_01 p560t_02 p560t_03 p560t_04 p560t_05 p560t_06 p560t_07 p560t_08 p560t_09 p560t_10 {

replace `var'=3 if `var'==. // no aplica para estas vars
}
*/

drop if p560t_10==.

forvalues i=1/8{
replace p557`i'a =0 if p557`i'a==.
}

forvalues i=1/7{
replace p558`i'a =0 if p558`i'a==.
}


foreach var of varlist dominio estrato p203 p300a p558c educ sector p510a1 p511a ocupinf emplpsec p5571a p5572a p5573a p5574a p5575a p5576a p5577a p5578a p5581a p5582a p5583a p5584a p5585a p5586a p5587a p560t_01 p560t_02 p560t_03 p560t_04 p560t_05 p560t_06 p560t_07 p560t_08 p560t_09 p560t_10 p599 p209 pobreza dep{

tab `var', gen(`var'_)
drop `var'
}

foreach var of varlist p501 p5561a p5562a p5563a p5564a p5565a p5566a p5567a p5568a p559_01 p559_02 p559_03 p559_04 p306 p310 p204 p207 {
replace `var'=0 if `var'==2
}

replace p558a2=1 if p558a2==2
replace p558a3=1 if p558a3==3
replace p558a4=1 if p558a4==4
replace p558a5=1 if p558a5==5




*interacciones para el cv estartificado

*pregunta: data splitting (test y train) tbm estratificado? como? 

*pregunta: si voy a usar el ano y departamento para CV (division), puedo usarla como predictor?

*xi i.ano*i.dep


*************************  DELIMITANDO VARIABLES  *******************
* completamos con los missings con valor 0 oq no gana en ese 

foreach var of varlist y_pri_dep y_pri_indep y_pri y_sec_dep y_sec_ind {

replace `var'=0 if `var'==.
}


*eliminamos outliers
foreach var of varlist y_pri_dep y_pri_indep y_pri y_sec_dep y_sec_ind y_sec y_mkt p513t {

sum `var', d
replace `var'=r(p95) if `var'>=r(p95)
}



drop n_ano ocu500 num conglome vivienda hogar codperso ubigeo d544t fac500a


drop  y_sec_dep y_sec_ind y_pri_indep y_pri_dep

gen p511a_8=0
gen p511a_9=0
gen p560t_10_2=0

forvalues i=1/4{

gen ano_`i'=0
}
*no dropeamos deg_desemp

export excel "$data\enaho_final_2020_python.xlsx", firstrow (variable) nolabel replace
*/

