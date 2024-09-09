*desempleo

*https://www.inei.gob.pe/estadisticas/indice-tematico/ocupacion-y-vivienda/

import excel "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres\data\desem-cuad-2_3_1.xlsx", sheet("DESEM cuad 2") cellrange(A6:P10) firstrow clear

ren (B C D E F G H I J K L M N O P) (a_2007 a_2008 a_2009 a_2010 a_2011 a_2012 a_2013 a_2014 a_2015 a_2016 a_2017 a_2018 a_2019 a_2020 a_2021)

drop if A=="Sexo"

keep A a_2016 a_2017 a_2018 a_2019 a_2020

reshape long a_, i(A) j(año)

label var año "Año"
ren (a_ A) (tasa_desemp sexo)
label var tasa_desemp "Tasa de desempleo urbana"

graph twoway (line tasa_desemp año if sexo=="Hombre", color(edkblue)) (line tasa_desemp año if sexo=="Mujer", color(red)) (line tasa_desemp año if sexo=="Total", color(green)),graphregion(color(white)) legend(label(1 "Hombre") label(2 "Mujer") label(3 "Total")rows(1) region(lcolor(white))) xtitle("Año") ytitle("Tasa de desempleo urbana (%)") xlabel(2016(1)2020 , labsize(small)) ylabel(3(1)10, labsize(small)) xline(2019, lcolor(black*.8) lpattern(dash))

graph export "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres\output\tasa_desempleo.png", as(png) replace

*empleo

import excel "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres\data\peao-cuad-8_3_1.xls", sheet("PEAO cuad 8") cellrange(A5:P10) firstrow clear

ren (B C D E F G H I J K L M N O P) (a_2007 a_2008 a_2009 a_2010 a_2011 a_2012 a_2013 a_2014 a_2015 a_2016 a_2017 a_2018 a_2019 a_2020 a_2021)

drop if A=="   Sexo" | A ==""

keep A a_2016 a_2017 a_2018 a_2019 a_2020

reshape long a_, i(A) j(año)

label var año "Año"
ren (a_ A) (tasa_desemp sexo)
label var tasa_desemp "Tasa de empleo urbana"

graph twoway (line tasa_desemp año if sexo=="Hombre", color(edkblue)) ///
(line tasa_desemp año if sexo=="Mujer", color(red)) ///
(line tasa_desemp año if sexo=="Total", color(green)), ///
graphregion(color(white)) ///
legend(label(1 "Hombre") label(2 "Mujer") label(3 "Total")rows(1) region(lcolor(white))) xtitle("Año") ytitle("Tasa de empleo urbana (%)") xlabel(2016(1)2020 , labsize(small)) ylabel(90(1)97, labsize(small)) xline(2019, lcolor(black*.8) lpattern(dash))
	
graph export "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres\output\tasa_empleo.png", as(png) replace


*inactividad

graph twoway (line tasa_desemp año if sexo=="Hombre", color(edkblue)) ///
             (scatter tasa_desemp año if sexo=="Hombre", msymbol(circle) mcolor(edkblue)) ///
             (line tasa_desemp año if sexo=="Mujer", color(red)) ///
             (scatter tasa_desemp año if sexo=="Mujer", msymbol(circle) mcolor(red)) ///
             (line tasa_desemp año if sexo=="Total", color(green)) ///
             (scatter tasa_desemp año if sexo=="Total", msymbol(circle) mcolor(green)) ///
             , graphregion(color(white)) ///
               legend(label(1 "Hombre") label(2 "Mujer") label(3 "Total") rows(1) region(lcolor(white))) ///
              

