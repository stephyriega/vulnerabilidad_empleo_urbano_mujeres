*desempleo

import excel "G:\Mi unidad\2021-2\TESIS_1\3_datos\desem-cuad-2_1.xlsx", sheet("DESEM cuad 2") cellrange(A6:N10) firstrow clear

ren (B C D E F G H I J K L M N ) (a_2007 a_2008 a_2009 a_2010 a_2011 a_2012 a_2013 a_2014 a_2015 a_2016 a_2017 a_2018 a_2019)

drop if A=="Sexo"

reshape long a_, i(A) j(año)

label var año "Año"
ren a_ tasa_desemp
label var tasa_desemp "Tasa de desempleo urbana"

graph twoway (line tasa_desemp año if A=="Hombre", color(edkblue)) (line tasa_desemp año if A=="Mujer", color(red)) (line tasa_desemp año if A=="Total", color(green)), ///
	graphregion(color(white)) legend(label(1 "Hombre") label(2 "Mujer") label(3 "Total")rows(1) region(lcolor(white))) xtitle("Año") ytitle("Tasa de desempleo urbana (%)") xlabel(2007(2)2019 , labsize(small)) ylabel(3(1)8, labsize(small)) xline(2015, lcolor(black*.8) lpattern(dash))
	
	
graph export "G:\Mi unidad\2021-2\TESIS_1\4_grafico\tasa_desempleo.png", as(png) replace 	