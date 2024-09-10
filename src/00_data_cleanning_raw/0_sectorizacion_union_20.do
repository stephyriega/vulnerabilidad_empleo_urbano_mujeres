
clear
clear all
set more off
mat drop _all

global 	root = "G:\Mi unidad\PUCP\2021-2\TESIS_1\" 
	
	
global data = "$root\3_datos"

*					2012-2016						*

*nos limitamos a 2,4,5: educacion, empleo y sumarias 
*ampliamos a 1,3,6

******************* (1) CARACTERISTICAS DE LA VIVIENDA Y DEL HOGAR *******************************
use "$data/enaho_1_17.dta", clear
duplicates drop conglome vivienda hogar_17 hogar_18 hogar_19 hogar_20 hogar_21, force

gen num=_n
*ren hpanelel* hpanel*

ren numpanh panh

*destring estratosocio_17, replace

keep conglome* vivienda* hogar* ubigeo* dominio* estrato* result_* p22_* p101_* p102_* p103_* p103a_* p104a_* p104b1_* p104b2_* p105a_* p106a_* p107b1_* p107b2_* p107b3_* p107b4_* p110_* p110a1_*  p111a_* p1121_* p1123_* p1124_* p1125_* p1126_* p1127_* p1131_* p1132_* p1133_* p1135_* p1136_* p1137_* p1138_* p114*_* p600a* p600d2* p600m2* p612i1_* p612i2_* i106_* i1172_01_* i1172_02_* i1173_01_* i1173_02_* nbi*_* hpanel* result_* num panh

*save "$data/enaho_1_1_17.dta", replace

forvalues i=19/20 {
    
preserve

local j=`i'+1

gen panh_`i'=panh
gen panh_`j'=panh

keep if hpanel_`i'`j'==1

keep *_`i' *_`j' num

*keep if result_`i'<=2
*drop result_`i' result_`j'

/*
drop if p106a_`i'==. // no tiene vivienda
drop if p104a_`i'==. // no tiene vivienda
drop if i1172_02_`i'==. // no tiene vivienda
drop if p612i1_`i'==. // no tiene vivienda
*/

reshape long conglome_ vivienda_ hogar_ ubigeo_ dominio_ estrato_ estratosocio_  p22_ p101_ p102_ p103_ p103a_ p104a_ p104b1_ p104b2_ p105a_ p106a_ p107b1_ p107b2_ p107b3_ p107b4_ p110_  p111a_ p1121_ p1123_ p1124_ p1125_ p1126_ p1127_ p1131_ p1132_ p1133_ p1135_ p1136_ p1137_ p1138_ p1141_ p1142_ p1143_ p1144_ p1145_ p600a1_ p600a2_ p600d2_ p600m2_ p612i1_ p612i2_ i106_ i1172_01_ i1172_02_ i1173_01_ i1173_02_ nbi1_ nbi2_ nbi3_ nbi4_ nbi5_ result_ panh_, i(num) j(ano)

save "$data/enaho_1_`i'_`j'_17.dta", replace

restore 
}

************************* EDUCACION (2) ****************************************

use "$data/enaho_2_17.dta", clear
duplicates drop conglome vivienda hogar_17 hogar_18 hogar_19 hogar_20 hogar_21 codperso_17 codperso_18 codperso_19 codperso_20 codperso_21, force

drop conglome
ren numper num
ren hpan* hpanel*

ren numpanh* panh_*

*15 variables
keep num conglome_* vivienda_* hogar_* codperso_* ubigeo_* dominio_* p300a_* p301a_* p306_* p310_* p314a_* p203_* p204_* p205_* p206_* p207_* p208a_* p209_* p307_* p308a_* p302_* perpanel* panh_*

*p3122_* p3122a* p3122b* p3122c* p313_* p314a_* p315a_* p315b_* p316_* i311b_* i311d_* i3121* i3122* i315* i307_* p203_* p207_* p208a_* p209_* perpanel*

*num conglome_* vivienda_* hogar_* codperso_* ubigeo_* dominio_* p300a_* p301a_* p306_* p310_* p203_* p204_* p207_* p208a_* p209_* perpanel*


*save "$data/enaho_2_1_16.dta", replace

forvalues i = 19/20 {

preserve

local j=`i'+1

keep if perpanel`i'`j'==1

keep *_`i' *_`j' num

/*
drop if p301a_`i'==. // no tiene nivel de educacion
drop if p300a_`i'==. // no tiene lengua maternal 
drop if p306_`i'==. // no tiene info si esta estudiando algo
drop if p209_`i'==. // si no se sabe su estado civil
drop if p207_`i'==. // si no se sabe su sexo
drop if p204_`i'==. // si no se sabe si es miembro de hogar
drop if p203_`i'==. // si no se sabe parentesco con jefe de hogar

drop if p301a_`j'==. // no tiene nivel de educacion
drop if p300a_`j'==. // no tiene lengua maternal 
drop if p306_`j'==. // no tiene info si esta estudiando algo
drop if p209_`j'==. // si no se sabe su estado civil
drop if p207_`j'==. // si no se sabe su sexo
drop if p204_`j'==. // si no se sabe si es miembro de hogar
drop if p203_`j'==. // si no se sabe parentesco con jefe de hogar
*/

gen perpanel="`i'`j'"

reshape long conglome_ vivienda_ hogar_ codperso_ ubigeo_ dominio_ p300a_ p301a_  p306_ p310_  p314a_ p203_ p204_ p205_ p206_ p207_ p208a_ p209_ p307_ p308a_ p302_ panh_, i(num) j(ano)


save "$data/enaho_2_`i'_`j'_17.dta", replace

restore
}

******************* SALUD (3) *********

use "$data/enaho_3_17.dta", clear
duplicates drop conglome vivienda hogar_17 hogar_18 hogar_19 hogar_20 hogar_21 codperso_17 codperso_18 codperso_19 codperso_20 codperso_21, force

drop conglome
ren numper num

*ren numpanh* panh_*

*p401c_ p401f_ p401h1_ p401h2_ p401h3_ p401h4_ p401h5_ p401h6_ p401_ p4021_ p4022_ p4023_ p4024_ p4025_ p413b1_ p413b2_ p414_01_ p414_02_ p414_03_ p414_04_ p414_05_ p414_06_ p414_07_ p414_08_ p414_09_ p414_10_ p414_11_ p414_12_ p414_13_ p414_14_  p414_15_ p414_16_ p4191_ p4192_ p4193_ p4194_ p4196_ p4197_ p4198_


*15 variables

forvalues i=19/20 {

preserve
local j=`i'+1
keep if perpanel`i'`j'==1

keep *_`i' *_`j' num


*49 variables
keep num conglome_* vivienda_* hogar_* codperso_* p401c_* p401f_* p401h*_* p401_* p4021_* p4022_* p4023_* p4024_* p4025_* p413b1_* p413b2_* p414_0*_* p414_1*_* p4191_* p4192_* p4193_* p4194_* p4195_* p4196_* p4197_* p4198_*

drop if p401c_`i'==. // no responde sobre trabajo, asi q no sabemos
drop if p401c_`j'==. // no responde sobre trabajo, asi q no sabemos


reshape long conglome_ vivienda_ hogar_ codperso_ p401c_ p401f_ p401h1_ p401h2_ p401h3_ p401h4_ p401h5_ p401h6_ p401_ p4021_ p4022_ p4023_ p4024_ p4025_ p413b1_ p413b2_ p414_01_ p414_02_ p414_03_ p414_04_ p414_05_ p414_06_ p414_07_ p414_08_ p414_09_ p414_10_ p414_11_ p414_12_ p414_13_ p414_14_  p414_15_ p414_16_ p4191_ p4192_ p4193_ p4194_ p4195_ p4196_ p4197_ p4198_ , i(num) j(ano)

save "$data/enaho_3_`i'_`j'_17.dta", replace

restore

}


******************************** EMPLEO (4) ***************************************
/*
use "$data/enaho_4_1_16.dta", clear
duplicates drop conglome vivienda hogar_16 hogar_17 hogar_18 hogar_19 hogar_20 codperso_16 codperso_17 codperso_18 codperso_19 codperso_20, force

preserve
use "$data/enaho_4_2_16.dta", clear
duplicates drop conglome vivienda hogar_16 hogar_17 hogar_18 hogar_19 hogar_20 codperso_16 codperso_17 codperso_18 codperso_19 codperso_20, force

*estrato_* p203a_* p501_* p506r4_* p510a1_* p511a_* p513t_* p523_* p524a1_*   p530a_* p538a1_* p541a_* p5561a_* p5562a_* p5563a_* p5564a_* p5565a_* p5566a_* p5567a_* p5568a_*  p5571a_*  p5572a_*  p5573a_*  p5574a_*  p5575a_*  p5576a_*  p5577a_*  p5578a_* p5581a_* p5582a_* p5583a_* p5584a_* p5585a_* p5586a_* p5587a_* p558a1_* p558a2_* p558a3_* p558a4_* p558a5_* p558c_* p559_01_* p559_02_* p559_03_* p559_04_* p560t_01_* p560t_02_* p560t_03_* p560t_04_* p560t_05_* p560t_06_* p560t_07_* p560t_08_* p560t_09_* p560t_10_* p599_* i524a1_* i530a_* i538a1_*  d529t_* d536_* d540t_* i541a_* d543_* d544t_* ocu500_* ocupinf_* emplpsec_* fac500a_*


keep conglome* vivienda hogar_16 hogar_17 hogar_18 hogar_19 hogar_20 codperso_16 codperso_17 codperso_18 codperso_19 codperso_20 i524a1_* i530a_* i538a1_*  d529t_* d536_* d540t_* i541a_* d543_* d544t_*

	tempfile temp_emp2
	save `temp_emp2'
	
restore

merge 1:1 conglome* vivienda hogar_* codperso_* using `temp_emp2', gen(_merge2)

*p502_* p503_* p504* p505_* p511* p512a_* p513a1_* p514_* p517b1_* p517c_* p535_* p536_* p537* d524* d529* d530* d536* d538* d556* d560* i518_* i513t_* i520_* i524a1_* i538a1_* i5404b_* i559d1_* i559d2_* i559d3_* i560d*


ren numper num
drop conglome
duplicates drop num, force

save "$data/enaho_4_16.dta", replace
*/

use "$data/enaho_4_17.dta", clear
duplicates drop conglome vivienda hogar_17 hogar_18 hogar_19 hogar_20 hogar_21 codperso_17 codperso_18 codperso_19 codperso_20 codperso_21, force

ren numper num
ren numpanh* panh_*

forvalues i=19/20 {

preserve
local j=`i'+1
keep if perpanel`i'`j'==1
*drop if p214_`i'==.

keep *_`i' *_`j' num


*49 variables
keep num conglome_* vivienda_* hogar_* codperso_* ubigeo_* estrato_* p203a_* p501_* p506r4_* p510a1_* p511a_*  p512b_*  p512a_* p513t_* p517_* p523_* p524a1_*   p530a_* p538a1_* p541a_* p5561a_* p5562a_* p5563a_* p5564a_* p5565a_* p5566a_* p5567a_* p5568a_*  p5571a_*  p5572a_*  p5573a_*  p5574a_*  p5575a_*  p5576a_*  p5577a_*  p5578a_* p5581a_* p5582a_* p5583a_* p5584a_* p5585a_* p5586a_* p5587a_* p558a1_* p558a2_* p558a3_* p558a4_* p558a5_* p558c_* p559_01_* p559_02_* p559_03_* p559_04_* p560t_01_* p560t_02_* p560t_03_* p560t_04_* p560t_05_* p560t_06_* p560t_07_* p560t_08_* p560t_09_* p560t_10_* p599_* i524a1_* i530a_* i538a1_*  d529t_* d536_* d540t_* i541a_* d543_* d544t_* ocu500_* ocupinf_* emplpsec_* fac500a_* panh_*

*p558e6_*

/*
drop if p501_`i'==. // no responde sobre trabajo, asi q no sabemos
drop if p501_`j'==. // no responde sobre trabajo, asi q no sabemos
drop if p599_`i'==. // no responde para independiente pero 
drop if p599_`j'==. //  no responde para independiente pero 
*/

reshape long conglome_ vivienda_ hogar_ codperso_ ubigeo_ estrato_ p203a_ p501_ p506r4_ p510a1_ p511a_  p512b_  p512a_ p513t_ p517_ p523_ p524a1_  p530a_ p538a1_ p541a_ p5561a_ p5562a_ p5563a_ p5564a_ p5565a_ p5566a_ p5567a_ p5568a_  p5571a_  p5572a_  p5573a_  p5574a_  p5575a_  p5576a_  p5577a_  p5578a_ p5581a_ p5582a_ p5583a_ p5584a_ p5585a_ p5586a_ p5587a_ p558a1_ p558a2_ p558a3_ p558a4_ p558a5_ p558c_ p559_01_ p559_02_ p559_03_ p559_04_ p560t_01_ p560t_02_ p560t_03_ p560t_04_ p560t_05_ p560t_06_ p560t_07_ p560t_08_ p560t_09_ p560t_10_ p599_ i524a1_ i530a_ i538a1_  d529t_ d536_ d540t_ i541a_ d543_ d544t_ ocu500_ ocupinf_ emplpsec_ fac500a_ panh_, i(num) j(ano)
*p558e6_
save "$data/enaho_4_`i'_`j'_17.dta", replace

restore
}


********************************** SUMARIA (5) **********************************

use "$data/enaho_5_17.dta", clear
duplicates drop conglome_* vivienda_* hogar_*, force

*save "$data/enaho_5_1_16.dta", replace

*use "$data/enaho_5_1_16.dta", clear

gen num=_n

*drop conglome 
ren numpanh panh

*destring estratosocio_17, replace

/*
keep if hpanel1617==1
keep *_16 *_17 num facpanel1617 factor07_16
ren facpanel1617 facpanel_16
*/

*ingbruhd_16 ingindhd_16 mieperho_16 insedthd_16 ingseihd_16 pagesphd_16 paesechd_16 ingauthd_16 isecauhd_16 ld_16 ingexthd_16 ingtprhd_16 ingtpuhd_16 ingtpu01_16 ingtpu03_16 ingtpu05_16 ingtpu04_16 ingtpu02_16 ingrenhd_16 ingoexhd_16 gru13hd3_16 gru23hd3_16 gru33hd3_16 gru43hd3_16 gru53hd3_16 gru63hd3_16 gru73hd3_16 gru83hd3_16 gru24hd_16 gru44hd_16 gru54hd_16 gru74hd_16 gru84hd_16 gru14hd5_16 ia01hd_16 gru34hd_16 ga04hd_16 gru64hd_16 gru13hd1_16 sig24_16 gru23hd1_16 gru33hd1_16 gru43hd1_16 gru53hd1_16 gru63hd1_16 gru73hd1_16 gru83hd1_16 gru14hd_16 sg42d_16 sg42d1_16 sg42d2_16 sg42d3_16

*gru11hd_ gru12hd1_ gru12hd2_ gru13hd1_ gru13hd2_ gru13hd3_ g05hd_ g05hd1_ g05hd2_ g05hd3_ g05hd4_ g05hd5_ g05hd6_ ig06hd_ sg23_ sig24_ gru14hd_ gru14hd1_ gru14hd2_ gru14hd3_ gru14hd4_ gru14hd5_ sg25_ sig26_ gru21hd_ gru22hd1_ gru22hd2_ gru23hd1_ gru23hd2_ gru23hd3_ gru24hd_ gru31hd_ gru32hd1_ gru32hd2_ gru33hd1_ gru33hd2_ gru33hd3_ gru34hd_ gru41hd_ gru42hd1_ gru42hd2_ gru43hd1_ gru43hd2_ gru43hd3_ gru44hd_ sg421_ sg42d1_ sg423_ sg42d3_ gru51hd_ gru52hd1_ gru52hd2_ gru53hd1_ gru53hd2_ gru53hd3_ gru54hd_ gru61hd_ gru62hd1_ gru62hd2_ gru63hd1_ gru63hd2_ gru63hd3_ gru64hd_ g07hd_ ig08hd_ sg422_ sg42d2_ gru71hd_ gru72hd1_ gru72hd2_ gru73hd1_ gru73hd2_ gru74hd_ gru73hd3_ sg42_ sg42d_ gru81hd_ gru82hd1_ gru82hd2_  gru83hd1_ gru83hd2_ gru83hd3_ gru84hd_

*ingtrahd  ingtexhd gru14hd3 gru13hd2 sig26 ig06hd gru23hd2 gru33hd2 gru43hd2 gru53hd2 gru63hd2 ig08hd gru73hd2 gru83hd2 gru14hd4

forvalues i=19/20 {

preserve
local j=`i'+1

gen panh_`i'=panh
gen panh_`j'=panh

keep if hpanel_`i'`j'==1
*drop if p214_`i'==.

keep *_`i' *_`j' num facpanel`i'`j' factor07_`i'

gen facpanel_`i'= facpanel`i'`j'
ren facpanel`i'`j' facpanel_`j'

/*
drop if mieperho_`i'==. // si no tiene info de los mimebros del hogar
drop if mieperho_`j'==. // si no tiene info de los mimebros del hogar
drop if ingmo1hd_`i'==. // si no tiene info de ingresos del hogar
drop if ingmo1hd_`j'==. // si no tiene info de ingresos del hogar
*/

*49 variables
keep num conglome_* vivienda_* hogar_*  ubigeo_* dominio_* estrato* linpe_* linea_* mieperho_*  ingmo1hd_* ingmo2hd_* inghog1d_* inghog2d_* gashog1d_* gashog2d_* pobreza_* factor* facpanel* ingbruhd_* ingindhd_* insedthd_* ingseihd_* pagesphd_* paesechd_* ingauthd_* isecauhd_* ld_* ingexthd_* ingtprhd_* ingtpuhd_* ingtpu01_* ingtpu03_* ingtpu05_* ingtpu04_* ingtpu02_* ingrenhd_* ingoexhd_* gru13hd3_* gru23hd3_* gru33hd3_* gru43hd3_* gru53hd3_* gru63hd3_* gru73hd3_* gru83hd3_* gru24hd_* gru44hd_* gru54hd_* gru74hd_* gru84hd_* gru14hd5_* ia01hd_* gru34hd_* ga04hd_* gru64hd_* gru13hd1_* sig24_* gru23hd1_* gru33hd1_* gru43hd1_* gru53hd1_* gru63hd1_* gru73hd1_* gru83hd1_* gru14hd_* sg42d_* sg42d1_* sg42d2_* sg42d3_* ig03hd1_* ig03hd2_* ig03hd3_* ig03hd4_* ingtrahd_*  ingtexhd_* gru14hd3_* gru13hd2_* sig26_* ig06hd_* gru23hd2_* gru33hd2_* gru43hd2_* gru53hd2_* gru63hd2_* ig08hd_* gru73hd2_* gru83hd2_* gru14hd4_* gru11hd_* gru12hd1_* gru12hd2_* gru13hd3_* g05hd_* g05hd1_* g05hd2_* g05hd3_* g05hd4_* g05hd5_* g05hd6_* sg23_* gru14hd1_* gru14hd2_* sg25_* gru21hd_* gru22hd1_* gru22hd2_* gru31hd_* gru32hd1_* gru32hd2_* gru41hd_* gru42hd1_* gru42hd2_* sg421_* sg423_* gru51hd_* gru52hd1_* gru61hd_* gru62hd1_* gru62hd2_* g07hd_* sg422_* gru71hd_* gru72hd1_* gru72hd2_* sg42_* gru81hd_* gru82hd1_* gru82hd2_* panh_*

*gru52hd2_*

reshape long conglome_ vivienda_ hogar_ ubigeo_ dominio_ estrato_ linpe_ linea_  mieperho_  ingmo1hd_ ingmo2hd_ inghog1d_ inghog2d_ gashog1d_ gashog2d_ pobreza_ estratosocio_ factor07_  facpanel_ ingbruhd_ ingindhd_ insedthd_ ingseihd_ pagesphd_ paesechd_ ingauthd_ isecauhd_ ld_ ingexthd_ ingtprhd_ ingtpuhd_ ingtpu01_ ingtpu03_ ingtpu05_ ingtpu04_ ingtpu02_ ingrenhd_ ingoexhd_ gru13hd3_ gru23hd3_ gru33hd3_ gru43hd3_ gru53hd3_ gru63hd3_ gru73hd3_ gru83hd3_ gru24hd_ gru44hd_ gru54hd_ gru74hd_ gru84hd_ gru14hd5_ ia01hd_ gru34hd_ ga04hd_ gru64hd_ gru13hd1_ sig24_ gru23hd1_ gru33hd1_ gru43hd1_ gru53hd1_ gru63hd1_ gru73hd1_ gru83hd1_ gru14hd_ sg42d_ sg42d1_ sg42d2_ sg42d3_ ig03hd1_ ig03hd2_ ig03hd3_ ig03hd4_ ingtrahd_ ingtexhd_ gru14hd3_ gru13hd2_ sig26_ gru23hd2_ gru33hd2_ gru43hd2_ gru53hd2_ gru63hd2_ ig08hd_ gru73hd2_ gru83hd2_ gru14hd4_ gru11hd_ gru12hd1_ gru12hd2_ g05hd_ g05hd1_ g05hd2_ g05hd3_ g05hd4_ g05hd5_ g05hd6_ ig06hd_ sg23_ gru14hd1_ gru14hd2_ sg25_ gru21hd_ gru22hd1_ gru22hd2_  gru31hd_ gru32hd1_ gru32hd2_ gru41hd_ gru42hd1_ gru42hd2_ sg421_ sg423_ gru51hd_ gru52hd1_ gru61hd_ gru62hd1_ gru62hd2_ g07hd_ sg422_ gru71hd_ gru72hd1_ gru72hd2_ sg42_ gru81hd_ gru82hd1_ gru82hd2_ panh_, i(num) j(ano)
*gru52hd2_

save "$data/enaho_5_`i'_`j'_17.dta", replace

restore
}



************** (6) CARACTERISTICAS DE LA PERSONA**********************

*
use "$data\enaho_6_17.dta", clear

duplicates drop conglome vivienda hogar_17 hogar_18 hogar_19 hogar_20 hogar_21  codperso_17 codperso_18 codperso_19 codperso_20 codperso_21, force

/*
keep if hpanel1617==1

keep *_16 *_17
*/

*keep conglome* vivienda* hogar* ubigeo* dominio* estrato* t211_* perpanel* numper
ren numper num
ren numpanh* panh_*

forvalues i=19/20 {

preserve
local j=`i'+1
keep if perpanel`i'`j'==1
*drop if p214_`i'==.

keep *_`i' *_`j' num


*49 variables
keep conglome* vivienda* hogar* codperso* t211_* p210_* panh_* num

/*
drop if p501_`i'==. // no responde sobre trabajo, asi q no sabemos
drop if p501_`j'==. // no responde sobre trabajo, asi q no sabemos
drop if p599_`i'==. // no responde para independiente pero 
drop if p599_`j'==. // no responde para independiente pero 
*/

reshape long keep conglome_ vivienda_ hogar_ codperso_ t211_ p210_ panh_, i(num) j(ano)

save "$data/enaho_6_`i'_`j'_17.dta", replace

restore
}


********************** UNION DE TODOS FINAL *********************

*uniendo modulos
forvalues i=19/20{

local j=`i'+1

preserve 
*empleo
use "$data\enaho_4_`i'_`j'_17.dta", clear
*educacion
merge 1:1 num ano using "$data\enaho_2_`i'_`j'_17.dta", gen (merge2)
*salud
merge 1:1 num ano using "$data\enaho_3_`i'_`j'_17.dta", gen (merge3)
*caracteristicas de las personas en la vivienda
merge 1:1 num ano using "$data\enaho_6_`i'_`j'_17.dta", gen (merge6)
*sumaria
merge m:1 panh_ ano using "$data\enaho_5_`i'_`j'_17.dta", gen(merge4)
*características de la vivienda
merge m:1 panh_ ano using "$data\enaho_1_`i'_`j'_17.dta", gen(merge5)


*solo los que tenemos info de empleo
*keep if merge2==3
*los q completan la encuesta
keep if merge5==3

gen num_panel=strofreal(num)+"_"+"`i'"+"_"+"`j'"

ren (*_) (*)
save "$data\enaho_`i'_`j'_17.dta", replace
restore
}

*uniendo modulos unidos

/*
use "$data\enaho_16_17.dta", replace

forvalues i=17/19 {
local j=`i'+1

append using "$data\enaho_`i'_`j'.dta"

}

drop merge*


*>10%, <30%

*>30%, 100%
*p510a1 p511a p523 p524a1 p530a p538a1 p541a ocuoinf emplpsec d529t d536 d540t d543 d544t i530a i524a1 i538a1 i541a

save "$data\enaho_unite_16_19.dta", replace
*/