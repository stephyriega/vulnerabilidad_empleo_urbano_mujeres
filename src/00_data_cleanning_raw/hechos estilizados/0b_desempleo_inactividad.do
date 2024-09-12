import excel "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres\data\inactividad_desempleo.xlsx", clear firstrow

*Unemployment  
graph twoway (line desempleo ano, color(edkblue) ) ///
             (scatter desempleo ano, msymbol(circle) mcolor(edkblue)) ///
             (line d_hombre ano, color(red) ) ///
             (scatter d_hombre ano, msymbol(circle) mcolor(red)) ///
             (line d_mujer ano, color(green) ) ///
             (scatter d_mujer ano, msymbol(circle) mcolor(green)) ///
             , ylabel(4(1)10) ///
               graphregion(color(white)) ///
               legend(order(2 "Total" 4 "Masculino" 6 "Femenino") rows(3) region(lcolor(white))) ///
               xtitle("Año") ///
               ytitle("%")




	graph export "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres\output\desempleo.png", as(png) replace 
	
*inactivity
graph twoway (line i_urbana ano, color(edkblue) ) ///
             (scatter i_urbana ano, msymbol(circle) mcolor(edkblue)) ///
             (line i_hombre ano, color(red) ) ///
             (scatter i_hombre ano, msymbol(circle) mcolor(red)) ///
             (line i_mujer ano, color(green) ) ///
             (scatter i_mujer ano, msymbol(circle) mcolor(green)) ///
             , ylabel(27(2)40) ///
               graphregion(color(white)) ///
               legend(order(2 "Total" 4 "Masculino" 6 "Femenino") rows(3) region(lcolor(white))) ///
               xtitle("Año") ///
               ytitle("%")
	
	graph export "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres\output\inactividad.png", as(png) replace 	
	
