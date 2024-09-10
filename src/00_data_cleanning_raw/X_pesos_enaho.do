svyset [pweight=facpob], psu(conglome) strata(estrato)


/*

//////////////// Pobreza Monetaria 7/////////////////////////
*Calculamos el factor de ponderacion a nivel de la poblacion
gen facpob=factor07*mieperho

**
*Contrastamos gpcm con la linea de pobreza alimentaria (linpe) y pobreza total (linea)

gen          pobre3=1 if gpcm <  linpe
replace      pobre3=2 if gpcm >= linpe & gpcm < linea
replace      pobre3=3 if gpcm >= linea

*Etiquetamos los valores de la variable 
label define pobre3 1 "pobre_extremo" 2 "pobre_no_extremo" 3 "no_pobre"
label value  pobre3 pobre3
label var    pobre3 "Pobreza Monetaria"


gen          pobre_2=1 if gpcm <  linea
replace      pobre_2=0 if gpcm >= linea

*Etiquetamos los valores de la variable 
label define pobre_2 1 "pobre" 0 "no_pobre"
label value  pobre_2 pobre_2
label var    pobre_2 "Pobreza Monetaria Total"


*\///////////// NBI ///////////////////
gen    		 NBI2_POBRE=.
replace		 NBI2_POBRE=1 if nbihog>1
replace		 NBI2_POBRE=0 if nbihog<2

label define NBI2_POBRE 0 "menos de dos NBI" 1 "al menos dos NBI"
label value  NBI2_POBRE NBI2_POBRE
label var    NBI2_POBRE "Con al menos dos NBI"
tab          NBI2_POBRE

*/


*GASTOS REALES
*******************************************************************************/
*CREANDO VARIABLES DEL GASTO DEFLACTADO A PRECIOS DE LIMA Y BASE 2018 a nivel total**/
*******************************************************************************/
*Gasto por 8 grupos de la canastas*
gen 	gpcrg3= (gru11hd + gru12hd1 + gru12hd2 + gru13hd1 + gru13hd2 + gru13hd3 )/(12*mieperho*ld*i01)
lab var gpcrg3	"Preparados dentro del hogar"

gen 	gpcrg6 = ((g05hd + g05hd1 + g05hd2 + g05hd3 + g05hd4 + g05hd5 +g05hd6 +ig06hd)/(12*mieperho*ld*i01))
lab var gpcrg6	"Adquiridos Fuera del hogar 559"

gen 	gpcrg8= ((sg23 + sig24)/(12*mieperho*ld*i01))
lab var gpcrg8	"Adquiridos de instituciones beneficas 602a"

gen 	gpcrg9= ((gru14hd + gru14hd1 +  gru14hd2 + gru14hd3 + gru14hd4 + gru14hd5 + sg25 + sig26)/(12*mieperho*ld*i01))
lab var gpcrg9	"Adquiridos fuera del hogar item 47 y 50 y 602"

gen    	gpcrg10= ((gru21hd + gru22hd1 + gru22hd2 + gru23hd1 + gru23hd2 + gru23hd3 + gru24hd)/(12*mieperho*ld*i02))
lab var gpcrg10	"Vestido y calzado"

gen     gpcrg12= ((gru31hd + gru32hd1 + gru32hd2 + gru33hd1 + gru33hd2 + gru33hd3 + gru34hd)/(12*mieperho*ld*i03))
lab var gpcrg12	"Gasto Alquiler de vivienda y combustible"

gen     gpcrg14= ((gru41hd + gru42hd1 + gru42hd2 + gru43hd1 + gru43hd2 + gru43hd3 + gru44hd + sg421 + sg42d1 + sg423 + sg42d3)/(12*mieperho*ld*i04))
lab var gpcrg14	"Muebles y enseres"

gen    	gpcrg16= ((gru51hd + gru52hd1 + gru52hd2 + gru53hd1 + gru53hd2 + gru53hd3 + gru54hd)/(12*mieperho*ld*i05))
lab var gpcrg16	"Cuidados de la salud"

gen     gpcrg18= ((gru61hd + gru62hd1 + gru62hd2 + gru63hd1 + gru63hd2 + gru63hd3 + gru64hd + g07hd + ig08hd + sg422 + sg42d2)/(12*mieperho*ld*i06))
lab var gpcrg18	"Transporte y comunicaciones"

gen     gpcrg19= ((gru71hd + gru72hd1 + gru72hd2 + gru73hd1 + gru73hd2 + gru73hd3 + gru74hd + sg42 + sg42d)/(12*mieperho*ld*i07))
lab var gpcrg19	"Esparcimiento diversión y cultura"

gen     gpcrg21= ((gru81hd + gru82hd1 + gru82hd2 + gru83hd1 + gru83hd2 + gru83hd3 + gru84hd)/(12*mieperho*ld*i08))
lab var gpcrg21	"Otros gastos de bienes y servicios"


*RECODIFICANDO POR grupo de gastos
gen 	gpgru2= gpcrg3
lab var gpgru2 "G011.Alimentos dentro del hogar real"
gen		gpgru3= gpcrg6 + gpcrg8 + gpcrg9
lab var gpgru3 "G012.Alimentos fuera del hogar real"
gen 	gpgru1 = gpgru2 + gpgru3
lab var gpgru1 "G01.Total en Alimentos real"

gen		gpgru4 = gpcrg10
lab var gpgru4 "G02.Vestido y calzado real"

gen		gpgru5 = gpcrg12
lab var gpgru5 "G03.Alquiler de Vivienda y combustible real"

gen		gpgru6 = gpcrg14
lab var gpgru6 "G04.Muebles y enseres real"

gen		gpgru7= gpcrg16
lab var gpgru7 "G05.Cuidados de la salud real"

gen		gpgru8 = gpcrg18
lab var gpgru8 "G06.Transportes y comunicaciones real"

gen		gpgru9 = gpcrg19
lab var gpgru9 "G07.Esparcimiento diversion y cultura real"

gen		gpgru10 = gpcrg21 
lab var gpgru10 "G08.otros gastos en bienes y servicios real"

gen  	gpgru0 = gpgru1 + gpgru4 + gpgru5 + gpgru6 + gpgru7 + gpgru8 + gpgru9 + gpgru10 
lab var gpgru0 "Gto real promedio pc mensual"
