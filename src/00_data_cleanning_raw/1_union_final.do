
clear
clear all
set more off
mat drop _all

global 	root = "C:\Users\DELL\Documents\GitHub\vulnerabilidad_empleo_urbano_mujeres" 
	
global data = "$root\data"



**# Unir bases
*------------------------------------------------------------------------------*
	

use "$data\enaho_unite_16_19.dta", clear

/*
*unimos con la parte del 2020 que quedo en el panel 2017-2021
append using "$data\enaho_20_21_17.dta"

*unimos la parte del 16 que quedo en el panel 2012-2016
append using "$data\enaho_15_16_12.dta"

*gen bianual_ano=substr(num_panel, -5, .)
 */


duplicates drop num ano perpanel, force

**# Filtros iniciales (años y areas)
*------------------------------------------------------------------------------*
	

*panel 2016-2020 & 2020-2021
*drop if bianual_ano=="15_16" | bianual_ano=="20_21"

**********  FILTRO DE ENCUESTA 

*AHORA ESTA POR HOGAR

*residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))
keep if resi==1

*resultado de la encuesta
*keep if result==1

**# Reconstrucción de variables individuales
*------------------------------------------------------------------------------*

* estado civil

gen est_civil=.
replace est_civil=1 if p209==1 | p209==2
replace est_civil=2 if p209==3 | p209==4
replace est_civil=3 if p209==5 | p209==6
drop p209

lab def estc 1 "Convivienda/Casada" 2 "Viuda/Divorciada" 3 "Separado/Soltero/"

label values est_civil estc
label variable est_civil "Estado civil"


********** lenguaje materno *********
*estandarizar a lenguajes otros
replace p300a=3 if inlist(p300a, 10, 11, 12, 13, 14, 15)

label var p300a "Lenguaje materno"

** ///// Construcción de variables preestablecidas //////////////////

********** ingreso primario dependiente *********
gen y_pri_dep = 0 if !missing(p524a1) & !missing(p523)

*Daily (assume 260 payments each year, so 260/12 payments each month)
				replace y_pri_dep   = p524a1 * 260/12 if p523 == 1
			*Weekly (assume 52 payments each year, so 52/12 payments each month)	
				replace y_pri_dep   = p524a1 * 52/12  if p523 == 2
			*Bi-Weekly ("quincenal" in spanish, assume 2 each month)
				replace y_pri_dep   = p524a1 * 2      if p523 == 3
			*Monthly
				replace y_pri_dep   = p524a1 * 1      if p523 == 4

******* ingreso primario independiente

		rename p530a y_pri_indep
******* ingreso primario total
		egen y_pri = rowtotal(y_pri_dep y_pri_indep)  if  !missing(y_pri_dep) | !missing(y_pri_ind)

******* ingreso laboral secundario dependiente
		rename p538a1  y_sec_dep
******* ingreso laboral secundario independiente
		rename p541a   y_sec_ind
******* ingreso secundario total
		egen y_sec = rowtotal(y_sec_dep y_sec_ind) 
******* ingreso laboral total
		egen y_mkt = rowtotal(y_pri y_sec)  
		
	
******* sector de ocupacion principal
gen sector=.

replace sector=1 if p506r4>=100 & p506r4<300   // OK
replace sector=2 if p506r4>=300 & p506r4<500   // OK
replace sector=3 if p506r4>=500 & p506r4<1000  // OK
replace sector=4 if p506r4>=1000 & p506r4<3500 // OK
replace sector=5 if p506r4>=3500 & p506r4<4000 // OK
replace sector=6 if p506r4>=4000 & p506r4<4500 // OK
replace sector=7 if p506r4>=4500 & p506r4<4900 // OK
replace sector=8 if p506r4>=8400 & p506r4<8500 // OK
replace sector=9 if p506r4>=4900 & p506r4<8400 // OK
replace sector=9 if p506r4>=8500 & p506r4<9998 // OK

lab def sectorv 1 "Agricultura" 2 "Pesca" 3 "Mineria" ///
4 "Manofactura" 5 "Electriciada y Agua" 6 "Construccion" 7 "Comercio" ///
8 "Gobierno" 9 "Servicios"
lab val sector sectorv

replace sector=10 if ocu500!=1 // no aplica para los desempleados

*drop p506r4

******** nivel educacion
label define niveduc 0 "No nivel" 1 "Primaria" 2 "Secundaria" 3 "Superior No Universitaria" 4 "Superior universitaria" 5 "Postgraduado" 

gen educ=.
replace educ=0 if p301a==1 | p301a==2
replace educ=1 if p301a==3 | p301a==4
replace educ=2 if p301a==5 | p301a==6
replace educ=3 if p301a==7 | p301a==8
replace educ=4 if p301a==9 | p301a==10
replace educ=5 if p301a==11
label values educ niveduc
label variable educ "Nivel educativo"

drop p301a

********* departamento
gen dpto=substr(ubigeo, 1,2)
destring dpto, replace

label variable dpto "dpto"
label define dpto 1 "Amazonas"
label define dpto 2 "Ancash", add
label define dpto 3 "Apurimac", add
label define dpto 4 "Arequipa", add
label define dpto 5 "Ayacucho", add
label define dpto 6 "Cajamarca", add
label define dpto 7 "Callao", add
label define dpto 8 "Cusco", add
label define dpto 9 "Huancavelica", add
label define dpto 10 "Huanuco", add
label define dpto 11 "Ica", add
label define dpto 12 "Junin", add
label define dpto 13 "La_Libertad", add
label define dpto 14 "Lambayeque", add
label define dpto 15 "Lima", add
label define dpto 16 "Loreto", add
label define dpto 17 "Madre_de_Dios", add
label define dpto 18 "Moquegua", add
label define dpto 19 "Pasco", add
label define dpto 20 "Piura", add
label define dpto 21 "Puno", add
label define dpto 22 "San_Martin", add
label define dpto 23 "Tacna", add
label define dpto 24 "Tumbes", add
label define dpto 25 "Ucayali", add
label values dpto dpto
label var dpto "Departamento"


*********deflactores
preserve
use "$data\deflactores_base2019_new.dta", clear
keep dpto i0* aniorec
ren aniorec ano
replace ano=ano-2000
keep if ano>=16

tempfile deflactor
	save `deflactor'
restore

merge m:1 dpto ano using `deflactor'


**********regiones naturales
gen     regnat=1 if dominio<=3 | dominio==8
replace regnat=2 if dominio>=4 & dominio<=6
replace regnat=3 if dominio==7
lab var regnat "Region natural"
lab def regnat 1 "Costa" 2 "Sierra" 3 "Selva"
lab val regnat regnat

*esta se usara para el CV estratificado

******** Dominio geografico
replace estrato = 1 if dominio ==8 

/*
*dominio geografico
gen     domin02=1 if dominio>=1 & dominio<=3 & area==1
replace domin02=2 if dominio>=1 & dominio<=3 & area==2
replace domin02=3 if dominio>=4 & dominio<=6 & area==1
replace domin02=4 if dominio>=4 & dominio<=6 & area==2
replace domin02=5 if dominio==7 & area==1
replace domin02=6 if dominio==7 & area==2
replace domin02=7 if dominio==8
label define domin02 1 "Costa_urbana" 2 "Costa_rural" 3 "Sierra_urbana" /// 
 4 "Sierra_rural" 5 "Selva_urbana" 6 "Selva_rural" 7 "Lima_Metropolitana"
label value domin02 domin02
*/

*****Pobreza Monetaria total (pobreza= pobre3, pobreza (1/2==1) (3==2) > pobre2 ***
recode pobreza (1/2=1 "Pobre") (3=2 "No Pobre"), gen(pobre2)
drop pobreza

******* Gasto mensual promedio
gen gpcm=gashog2d/(mieperho*12)


*********** Necesidades básicas del hogar
gen          nbihog=nbi1 + nbi2 + nbi3 + nbi4 + nbi5

gen    		 nbi1_pobre=.
replace 	 nbi1_pobre=1 if nbihog>0
replace		 nbi1_pobre=0 if nbihog==0

label define nbi1_pobre2 0 "ninguna NBI" 1 "al menos un NBI"
label value  nbi1_pobre nbi1_pobre2
label var    nbi1_pobre "Con al menos una NBI"

drop nbi1 nbi2 nbi3 nbi4 nbi5 nbihog

*ingreso promedio mensual proveniente de trabajo
egen ingtrabw=rowtotal(i524a1 d529t i530a d536 i538a1 d540t i541a d543 d544t)

*sum ingtrabw if ocu500 == 1 & ingtrabw> 0 , d \\ para sacar cuadros

*** Ingresos

recode ingtpu01 ingtpu02 ingtpu03 ingtpu04 ingtpu05 ig03hd1 ig03hd2 ig03hd3 ig03hd4 (.= 0)

*Calculamos el factor de ponderacion
gen factornd07=round(factor07*mieperho,1)

*svyset [pweight = factornd07], psu(conglome)

*** Ingresos ***
gen ipcr_2 = (ingbruhd +ingindhd)/(12*mieperho*ld*i00)
gen ipcr_3 = (insedthd + ingseihd)/(12*mieperho*ld*i00)
gen ipcr_4 = (pagesphd + paesechd + ingauthd + isecauhd)/(12*mieperho*ld*i00)
gen ipcr_5 = (ingexthd)/(12*mieperho*ld*i00)
gen ipcr_1 = (ipcr_2 + ipcr_3 + ipcr_4 + ipcr_5)

gen ipcr_7 = (ingtrahd)/(12*mieperho*ld*i00)
gen ipcr_8 = (ingtexhd)/(12*mieperho*ld*i00)
gen ipcr_6 = (ipcr_7 + ipcr_8)

gen ipcr_9  = (ingtprhd)/(12*mieperho*ld*i00)
gen ipcr_10 = (ingtpuhd)/(12*mieperho*ld*i00)
gen ipcr_11 = (ingtpu01)/(12*mieperho*ld*i00)
gen ipcr_12 = (ingtpu03)/(12*mieperho*ld*i00)
gen ipcr_13 = (ingtpu05)/(12*mieperho*ld*i00)
gen ipcr_14 = (ingtpu04)/(12*mieperho*ld*i00)
gen ipcr_15 = (ingtpu02)/(12*mieperho*ld*i00)
gen ipcr_16 = (ingrenhd)/(12*mieperho*ld*i00)
gen ipcr_17 = (ingoexhd + gru13hd3 + gru23hd3 + gru33hd3 + gru43hd3 + gru53hd3 + gru63hd3 + gru73hd3 + /*
*/  gru83hd3 + gru24hd +gru44hd + gru54hd + gru74hd + gru84hd + gru14hd5)/(12*mieperho*ld*i00)

*ajuste por el alquiler imputado
gen ipcr_18 =(ia01hd +gru34hd - ga04hd + gru64hd)/(12*mieperho*ld*i00)

gen ipcr_19 = (gru13hd1 + sig24 + gru23hd1 + gru33hd1 + gru43hd1 + gru53hd1 + gru63hd1 + gru73hd1 + gru83hd1 /* 
*/+ gru14hd3 + sig26)/(12*mieperho*ld*i00)

gen ipcr_20 = (gru13hd2 + ig06hd + gru23hd2 + gru33hd2 + gru43hd2 + gru53hd2 + gru63hd2 + ig08hd + gru73hd2 + /*
*/ gru83hd2 + gru14hd4 + sg42d + sg42d1 + sg42d2 + sg42d3)/(12*mieperho*ld*i00)


gen  ipcr_0= ipcr_2 + ipcr_3 + ipcr_4 + ipcr_5+ ipcr_7 + ipcr_8 + ipcr_16 + ipcr_17 + ipcr_18 + ipcr_19 + ipcr_20

label var ipcr_0 "Ingreso percapita mensual a precios de Lima monetario"
label var ipcr_1 "Ingreso percapita mensual a precios de Lima monetario por trabajo"
label var ipcr_2 "Ingreso percapita mensual a precios de Lima monetario por trabajo principal"
label var ipcr_3 "Ingreso percapita mensual a precios de Lima monetario por trabajo secundario"
label var ipcr_4 "Ingreso percapita mensual a precios de Lima pago en especie y autocon"
label var ipcr_5 "Ingreso percapita mensual a precios de Lima pago extraordinario por trabajo"
label var ipcr_6 "Ingreso percapita mensual a precios de Lima transferencia corriente"
label var ipcr_7 "Ingreso percapita mensual a precios de Lima transferencia monetaria del pais"
label var ipcr_8 "Ingreso percapita mensual a precios de Lima transferencia monetaria extranjero"
label var ipcr_9  "Ingreso percapita mensual a precios de Lima transferencia monetaria privada"
label var ipcr_10 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica total"
label var ipcr_11 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica Juntos"
label var ipcr_12 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica Pensión65"
label var ipcr_13 "Ingreso percapita mensual a precios de Lima transferencia monetaria Bono Gas"
label var ipcr_14 "Ingreso percapita mensual a precios de Lima transferencia monetaria Beca 18"
label var ipcr_15 "Ingreso percapita mensual a precios de Lima transferencia monetaria Otros Publica"
label var ipcr_16 "Ingreso percapita mensual a precios de Lima renta"
label var ipcr_17 "Ingreso percapita mensual a precios de Lima extraordinario"
label var ipcr_18 "Ingreso percapita mensual a precios de Lima alquiler imputado"
label var ipcr_19 "Ingreso percapita mensual a precios de Lima donacion publica"
label var ipcr_20 "Ingreso percapita mensual a precios de Lima donacion privada"

******* Tamaño de la empresa
gen     tamahno=1 if p512b>=1  & p512b<11
replace tamahno=2 if p512b>=11 & p512b<51
replace tamahno=3 if p512b>50
replace tamahno=4 if p512b==. & (p512a==1 | p512a==2 )
label define tamahno 1 "De 1 a 10 trabajadores" 2 "De 11 a 50 trabajadores" /// 
3 "De 51 a más trabajadores" 4 "No especificado", replace
label value tamahno tamahno

******** Ramas de actividad segun CIIU
gen      ciiu_aux1 =substr("0"+string(p506r4),1,.)
replace  ciiu_aux1 =substr(string(p506r4),1,.) if p506r4>999
gen      ciiu_aux2 =substr(ciiu_aux1 ,1,2)
destring ciiu_aux2, generate(ciiu_2d)
gen      ciiu_1d=1 if  ciiu_2d<=2
replace  ciiu_1d=2 if  ciiu_2d==3
replace  ciiu_1d=3 if  ciiu_2d>=5  & ciiu_2d<=9
replace  ciiu_1d=4 if  ciiu_2d>=10 & ciiu_2d<=33
replace  ciiu_1d=5 if  ciiu_2d>=41 & ciiu_2d<=43
replace  ciiu_1d=6 if  ciiu_2d>=45 & ciiu_2d<=47
replace  ciiu_1d=7 if (ciiu_2d>=49 & ciiu_2d<=53) | (ciiu_2d>=58 & ciiu_2d<=63)
replace  ciiu_1d=8 if  ciiu_2d==84
replace  ciiu_1d=9 if  ciiu_2d>=55 & ciiu_2d<=56
replace  ciiu_1d=10 if ciiu_2d==68 | (ciiu_2d>=69 & ciiu_2d<=82)
replace  ciiu_1d=11 if ciiu_2d==85 					 
replace  ciiu_1d=12 if (ciiu_2d>=35 & ciiu_2d<=39) | (ciiu_2d>=64 & ciiu_2d<=66)  | ///
  (ciiu_2d>=86 & ciiu_2d<=88) |  (ciiu_2d>=90 & ciiu_2d<=93)| (ciiu_2d>=94 & ciiu_2d<=98) |  ciiu_2d==99
					 				 
label var ciiu_1d "Division CIIU"
la de ciiu_1d 1 "Agricultura" 2 "Pesca"  3 "Mineria" 4 "Manufactura" 5 "Construccion" ///
 6 "Comercio" 7 "Transportes y Comunicaciones"  8 "Gobierno" 9 "Hoteles y Restaurantes" ///
 10 "Inmobiliarias y alquileres" 11 "Ensehnanza" 12 "Otros Servicios 1/"
 label values ciiu_1d ciiu_1d
*1/ Otros Servicios lo componen las ramas de actividad de Electricidad, Gas y Agua, 
*Intermediación Financiera, Actividades de Servicios Sociales y de Salud, Otras activ.
*de Serv. Comunitarias, Sociales y Personales y Hogares privados con servicio doméstico.

tab ciiu_1d [iw= fac500a]  if resi==1 & ocu500==1, m

************* Población ocupada en empleo informal por Rama de Actividad
gen      ciiu_6c=1 if ciiu_1d<4
replace  ciiu_6c=2 if ciiu_1d==4
replace  ciiu_6c=3 if ciiu_1d==5
replace  ciiu_6c=4 if ciiu_1d==6
replace  ciiu_6c=5 if ciiu_1d==7
replace  ciiu_6c=6 if ciiu_1d>7

label var ciiu_6c "Division CIIU-6 categorias"
la de ciiu_6c 1 "Agricultura/Pesca/Mineria" 2 "Manufactura" 3 "Construccion" ///
 4 "Comercio" 5 "Transportes y Comunicaciones" 6 "Otros Servicios 1/"
 label values ciiu_6c ciiu_6c
*1/ Otros Servicios lo componen las ramas de actividad de Electricidad, Gas y Agua, 
*Intermediación Financiera, Actividades de Servicios Sociales y de Salud, Otras activ.
*de Serv. Comunitarias, Sociales y Personales y Hogares privados con servicio doméstico.
*Adicionalmente incluye Gobierno, Hoteles y Restaurantes, Inmobiliarias y alquileres y Ensehnanza


************** Pobreza relativa
*Estimamos el gasto mensual promedio de los hogares en terminos per capita
*gen    gpcm=gashog2d/(mieperho*12) //ya esta creada
gen    facpob=factor07*mieperho
*sum gpcm  [w=facpob]
gen p_relativa=(gpcm<r(mean))*100

*brecha digital nacional
*tab p314a mujer [iw=factora07] , nofreq col

*********** Inclusion financiera
*Crear variable inclusion (para mas de 18 años)
recode p558e6 (6=0 "no accede")(0=1 "accede"), gen(inclusion)

*********** Tiene celular
gen celular = p1142 

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

gen    	gpcrg16= ((gru51hd + gru52hd1 + gru53hd1 + gru53hd2 + gru53hd3 + gru54hd)/(12*mieperho*ld*i05))
lab var gpcrg16	"Cuidados de la salud" // FALTA + gru52hd2

gen     gpcrg18= ((gru61hd + gru62hd1 + gru62hd2 + gru63hd1 + gru63hd2 + gru63hd3 + gru64hd + g07hd + ig08hd + sg422 + sg42d2)/(12*mieperho*ld*i06))
lab var gpcrg18	"Transporte y comunicaciones"

gen     gpcrg19= ((gru71hd + gru72hd1 + gru72hd2 + gru73hd1 + gru73hd2 + gru73hd3 + gru74hd + sg42 + sg42d)/(12*mieperho*ld*i07))
lab var gpcrg19	"Esparcimiento diversión y cultura"

gen     gpcrg21= ((gru81hd + gru82hd1 + gru82hd2 + gru83hd1 + gru83hd2 + gru83hd3 + gru84hd)/(12*mieperho*ld*i08))
lab var gpcrg21	"Otros gastos de bienes y servicios"


*recodificando grupo de gastos
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

*ANALFABETISMO
gen       analfa=0       if p208a>=15 & p204==1
replace analfa=1       if p208a>=15 & p204==1 &  p302==2
*tab        analfa [iweight=factora07]


**# Reconstrucción de variables por hogar
*------------------------------------------------------------------------------*

*MATRICULA
*Definimos la poblacion segun edad normativa: 
*de 6 a 11 anios (Primaria) & de 12 a 17 anios (Secundaria)
gen            edad_norma_pri=(p208a>=6 & p208a<=11)
gen    		   edad_norma_sec=(p208a>=12 & p208a<=17)
label var      edad_norma_pri "Edad Normativa en primaria"
label var      edad_norma_sec "Edad Normativa en secundaria"

*ninos que deberian estar en primaria por hogar
bysort conglome vivienda hogar ano: egen n_edad_prim=total(edad_norma_pri)
bysort conglome vivienda hogar ano: egen n_edad_sec=total(edad_norma_sec)
bysort conglome vivienda hogar ano: gen n_edad_esc=n_edad_prim+n_edad_sec

*ninos en escuela por hogar
gen          matri_esc_prim=(p208a>=6 & p208a<=17 & p306==1)
gen		     matri_esc_sec=(p208a>=6 & p208a<=17 & p306==2)
label var    matri_esc_prim "Matricula Escolar Primaria"
label var    matri_esc_sec "Matricula Escolar Primaria"

bysort conglome vivienda hogar ano: egen n_matr_prim=total(matri_esc_prim)
bysort conglome vivienda hogar ano: egen n_matr_sec=total(matri_esc_sec)

bysort conglome vivienda hogar ano: gen n_matr_esc=matri_esc_prim+matri_esc_sec

/*
*Usamos el factor de expansion de la base para obtener los resultados a nivel nacional
tab          matri_esc  edad_norma [iweight=factora07] , col nofreq

*ASISTENCIA ESCOLAR
*/
replace p307=0 if p307==2
bysort conglome vivienda hogar ano: egen n_asist=total(p307)

/*
tab         p307  area [iweight=factora07] if p208a>=6 & p208a<=17, col nofreq
tab         p307  edad_norma [iweight=factora07] 
tab         p307  edad_norma [iweight=factora07] , col nofreq

tab        p308c p208a [iweight=factora07] if p208a>=6  & p208a<=11

*p308b, Ahno de estudios al que asiste (secundaria)
tab        p308b p208a [iweight=factora07] if p308a==3 &p208a>=12 & p208a<=17
*/

*NIVEL DE ESCOLARIDAD
*tab         p301a [iweight=factora07] if p208a>=18
gen      TI_5_17=0 if  (p208a >= 5 & p208a <= 17)
replace  TI_5_17=1 if ((p208a >= 5 & p208a <= 17) & ((p210==1) | (p210==2 & (t211~=9 & t211~=11)))) 

bysort conglome vivienda hogar ano: egen menor_trabaja=total(TI_5_17)


**# Filtro final
*------------------------------------------------------------------------------*

*edad (dropeamos a aquellas que tenian menos de 14 años en alguno de los años: 13+14-027 menos o igual q 27 años entre todos sus años)

by num_panel, sort: gen n_ano = _n

order num_panel, first
sort num_panel ano

*solo nos quedamos con las clasificadas como mujeres en el area urbano
*sexo
keep if p207==2
drop p207

*area
recode estrato(1/5=1 "Urbano") (6/8=0 "Rural"), gen(area) 
keep if area==1

*quedarnos con los que tienen pareja por dos años(ya no importan las de nivel de hogar porque estan para todos los miembros de ese hogar las variables)

bysort num_panel: egen rep=count(1)

drop if rep==1

 *falta delimitar de q este entre 14 y 65 años o la edad en que deberian de trabajar -> solo mujeres en la edad trabajadoras
 
gen age_out= ((p208a<=13 & n_ano==1) | (p208a<=13 & n_ano==2)) 

gen age_out2= ((p208a>=65 & n_ano==1) |(p208a>=65 & n_ano==2))


bysort num_panel: egen drop_age_out=total(age_out)

bysort num_panel: egen drop_age_out2=total(age_out2)

drop if inlist(drop_age_out, 1,2)

drop if inlist(drop_age_out2, 1,2)

***************** MISSINGS ***********************************************

*dropear las que en verdad no necesitamos pq ya formamos 

*drop i524 d529t i530a d536 i538a1 d540t i541 d543  p506r4 p523 p203a area i524a1 d529t i530a d536 i538a1 d540t i541a d543 p524a p524a1 p523 p506r4 ubigeo dominio gashog2d  i524a1 d529t i530a d536 i538a1 d540t i541a d543 d544t ingbruhd ingindhd insedthd ingseihd pagesphd paesechd  ingauthd  isecauhd ingexthd  ingtrahd ingtexhd ingtprhd ingtpuhd ingtpu01 ingtpu03 ingtpu05 ingtpu04 ingtpu02 ingrenhd ingoexhd gru13hd3  gru23hd3  gru33hd3  gru43hd3  gru53hd3  gru63hd3  gru73hd3  gru83hd3  gru24hd gru44hd  gru54hd  gru74hd  gru84hd  gru14hd5 ia01hd gru34hd  ga04hd gru64hd gru13hd1 sig24 gru23hd1 gru33hd1 gru43hd1 gru53hd1 gru63hd1 gru73hd1 gru83hd1 gru14hd3 sig26 gru13hd2  ig06hd  gru23hd2 gru33hd2 gru43hd2 gru53hd2 gru63hd2 ig08hd gru73hd2 gru83hd2  gru14hd4  sg42d  sg42d1  sg42d2  sg42d3 ld  p512b  p506r4 ciiu_aux1 ciiu_aux2  ciiu_2d p558e6 p1142 gru11hd gru12hd1 gru12hd2  gru13hd1 gru13hd2 gru13hd3 g05hd g05hd1 g05hd2 g05hd3 g05hd4 g05hd5 g05hd6 ig06hd sg23 sig24 gru14hd  gru14hd1  gru14hd2 gru14hd3 gru14hd4  gru14hd5 sg25 sig26 gru21hd gru22hd1  gru22hd2  gru23hd1 gru23hd2  gru23hd3 gru24hd gru31hd gru32hd1  gru32hd2  gru33hd1 gru33hd2 gru33hd3 gru34hd gru41hd gru42hd1 gru42hd2 gru43hd1  gru43hd2 gru43hd3 gru44hd  sg421  sg42d1  sg423  sg42d3 gru51hd gru52hd1  gru53hd1  gru53hd2  gru53hd3 gru54hd gru61hd gru62hd1 gru62hd2 gru63hd1 gru63hd2 gru63hd3 gru64hd g07hd ig08hd sg422 sg42d2 gru71hd gru72hd1 gru72hd2 gru73hd1 gru73hd2 gru73hd3 gru74hd sg42 sg42d gru81hd gru82hd1 gru82hd2 gru83hd1 gru83hd2 gru83hd3 gru84hd gpcrg3 gpcrg6 gpcrg8 gpcrg9 gpgru2  gpgru3 gpcrg10 gpcrg12 gpcrg14 gpcrg16 gpcrg18 gpcrg19 gpcrg21 edad_norma_pri edad_norma_sec n_prim p307 p204  p302 p210 TI_5_17 

drop conglome panh vivienda hogar codperso num fac500a keep factor07  facpanel  result resi _merge  factornd07 num panh codperso factornd07  
 
 

*********************************************************************************



**************** variable que se usara para cv estratificado
gen ano_reg_s=strofreal(ano)+"_"+strofreal(regnat)
encode ano_reg_s, gen (ano_reg)
drop ano_reg_s

*dummy para variar missing en ingresos laborales
*gen y_mkt_d=(ocu500!=1)

*https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fcdn.www.gob.pe%2Fuploads%2Fdocument%2Ffile%2F2078164%2F7%2520Departamentos_empleo_rango%2520de%2520edad%25202004-2020.xlsx&wdOrigin=BROWSELINK  



***************************** INDICADOR DE DESEMPLEO ***************************


*by numper_panel , sort: gen año_n = _n 
by num_panel , sort: gen año_1 = 1 if ocu500[1] ==1  // ocupado
by num_panel , sort: gen año_2 = 1 if ocu500[_N] ==2 // desempleo abierto
by num_panel , sort: replace año_2 = 1 if ocu500[_N] ==3 // desempleo oculto (desalentados)

order num_panel año_1 año_2 ocu500, first

by num_panel , sort: replace año_2 = 1 if ocu500[_N] ==4 // añadiedo a las "inactivas"
gen deg_desemp=(año_1==1 & año_2==1) 

tab deg_desemp // 1.59% de mujeres y 11% con inactivas (esto podria cambiar con la edad de las mujeres)

br deg_desemp ocu500 if deg_desemp==1


*order n_ano deg_desemp, first
replace n_ano= 0 if n_ano==1
replace n_ano= 1 if n_ano==2


*drop if x>200
/*
save "$data\enaho_final_double_stata.dta", replace
export excel "$data\enaho_final_double_stata.xlsx", firstrow(var) replace
*/

keep if n_ano==0
order ano, first

drop if ano==20

drop año_1 año_2 n_ano
*no dropeamos deg_desemp


*quedamos solo con las variables transformadas + algunas individuales que si sirven: 

keep p300a y_pri_dep y_pri_indep y_pri y_sec_dep  y_sec_ind  y_sec   y_mkt sector educ dpto regnat estrato pobre2  gpcm pobre2 nbi1_pobre ingtrabw ipcr_* tamahno ciiu_1d ciiu_6c p_relativa p558e6 celular gpgru* analfa  n_edad_* n_matr_*  menor_trabaja ano_reg deg_desemp p208a ocupinf emplpsec p517 p22 p101 p102 p103 p103a p104a p104b1 p104b2  p105a p106a p110   p111a p1141 p1142 p1143  p1144 p1145 i1172_01 i1172_02 i1173_01 i1173_02 p203 p204 p208a est_civil p302 p306  p314a  p203a p401c p401f p401h1 p401h2 p401h3 p401h4 p401h5 p401h6 p4191 p4192 p4193 p4194 p4195 p4196 p4197 p4198 p501 p506r4 p510a1 p511a  p512b p512a p513t p523 p558c p599 num_panel ano


save "$data\enaho_final_one_python_230823.dta", replace

export excel using "$data\enaho_final_one_python_230823.xlsx", firstrow (variable) nolabel replace


***************************** AÑO 2020 ******************************************

use "$data\enaho_final_double_stata.dta", clear

keep if ano==20

export excel "$data\enaho_final_2020_python.xlsx", firstrow (variable) nolabel replace



