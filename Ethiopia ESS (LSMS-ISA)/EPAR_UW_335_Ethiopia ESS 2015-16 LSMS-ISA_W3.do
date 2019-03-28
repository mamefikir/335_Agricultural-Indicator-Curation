
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Ethiopia Socioeconomic Survey (ESS) LSMS-ISA Wave 3 (2015-16)
*Author(s)		: Didier Alia, David Coomes, Jack Knauer, Josh Merfeld, Isabella Sun, Emma Weaver, Ayala Wineman, Pierre Biscaye, C. Leigh Anderson, & Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 26 December 2018
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Ethiopia Socioeconomic Survey was collected by the Ethiopia Central Statistical Agency (CSA) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period September - November 2015, and February - April 2016.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2783

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Ethiopia Socioeconomic Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Ethiopia ESS (ETH LSMS) data set.
*Using data files from within the "Ethiopia ESS LSMS - ISA Wave 3 (2015-16)" folder within the "Raw DTA files" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "/Ethiopia ESS LSMS - ISA Wave 3 (2015-16)/ETH_W3_created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Ethiopia ESS LSMS - ISA Wave 3 (2015-16)" within the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Ethiopia_ESS_LSMS_ISA_W3_summary_stats.rtf" in the "Ethiopia ESS LSMS - ISA Wave 3 (2015-16)" within the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".

 
/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 	
	
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Ethiopia_ESS_LSMS_ISA_W3_hhids.dta
*WEIGHTS AND GENDER OF HEAD			Ethiopia_ESS_LSMS_ISA_W3_male_head
*INDIVIDUAL GENDER					Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta
*PLOT-CROP DECISION MAKERS			Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta

*PLOT AREA							Ethiopia_ESS_LSMS_ISA_W3_field_area.dta
*AGRICULTURAL LAND DUMMY AND AREA 	Ethiopia_ESS_LSMS_ISA_W3_fields_agland.dta
*AG LAND AREA HOUSEHOLD				Ethiopia_ESS_LSMS_ISA_W3_farmsize_all_agland.dta

*GROSS CROP PRODUCTION				Ethiopia_ESS_LSMS_ISA_W3_crop_production_household.dta
	PARCEL							Ethiopia_ESS_LSMS_ISA_W3_crop_production_parcel.dta
	PLOT							Ethiopia_ESS_LSMS_ISA_W3_crop_production_field.dta
*CROP LOSSES						Ethiopia_ESS_LSMS_ISA_W3_crop_losses.dta

*CROP EXPENSES
	PLANTING LABOR					Ethiopia_ESS_LSMS_ISA_W3_wages_postplanting.dta
	HARVEST LABOR					Ethiopia_ESS_LSMS_ISA_W3_wages_postharvest.dta
	FERTILIZER						Ethiopia_ESS_LSMS_ISA_W3_fertilizer_costs.dta
	SEEDS							Ethiopia_ESS_LSMS_ISA_W3_seed_costs.dta
	LAND RENTAL						Ethiopia_ESS_LSMS_ISA_W3_land_rental_costs.dta
	CROP TRANSPORT					Ethiopia_ESS_LSMS_ISA_W3_transportation_cropsales.dta
	
*LIVESTOCK EXPENSES					Ethiopia_ESS_LSMS_ISA_W3_livestock_expenses.dta
*LIVESTOCK PRODUCTS					Ethiopia_ESS_LSMS_ISA_W3_livestock_products.dta
*LIVESTOCK SALES					Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_sales.dta
*TROPICAL LIVESTOCK UNIT			Ethiopia_ESS_LSMS_ISA_W3_TLU.dta

*SELF EMPLOYMENT INCOME				Ethiopia_ESS_LSMS_ISA_W3_self_employment_income.dta
*WAGE INCOME						Ethiopia_ESS_LSMS_ISA_W3_wage_income.dta
*AG WAGE INCOME						Ethiopia_ESS_LSMS_ISA_W3_agwage_income.dta
*OTHER INCOME						Ethiopia_ESS_LSMS_ISA_W3_other_income.dta
*ASSISTANCE INCOME					Ethiopia_ESS_LSMS_ISA_W3_assistance_income.dta
*RENTAL INCOME						Ethiopia_ESS_LSMS_ISA_W3_land_rental_income.dta

*FARM SIZE							Ethiopia_ESS_LSMS_ISA_W3_land_size.dta
*LAND SIZE							Ethiopia_ESS_LSMS_ISA_W3_land_size_all.dta

*FAMILY PLANTING LABOR				Ethiopia_ESS_LSMS_ISA_W3_farmlabor_postplanting.dta
*FAMILY HARVEST LABOR				Ethiopia_ESS_LSMS_ISA_W3_farmlabor_postharvest.dta

*VACCINE USE						Ethiopia_ESS_LSMS_ISA_W3_vaccine.dta
*INORGANIC FERTILIZER USE			Ethiopia_ESS_LSMS_ISA_W3_fert_use.dta
*IMPROVED SEED USE					Ethiopia_ESS_LSMS_ISA_W3_improvedseed_use
*AG EXTENSION USE					Ethiopia_ESS_LSMS_ISA_W3_any_ext.dta
*FINANCIAL SERVICES USE				Ethiopia_ESS_LSMS_ISA_W3_fin_serv.dta

*MILK PRODUCTIVITY					Ethiopia_ESS_LSMS_ISA_W3_milk_animals.dta
*EGG PRODUCTIVITY					Ethiopia_ESS_LSMS_ISA_W3_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE
	LAND RENTAL VALUE				Ethiopia_ESS_LSMS_ISA_W3_hh_rental_value.dta
	VALUE OF OWNED LAND				Ethiopia_ESS_LSMS_ISA_W3_hh_cost_land.dta
	PLANTING INPUT COST				Ethiopia_ESS_LSMS_ISA_W3_hh_pp_inputs_value.dta
	HARVEST LABOR COST				Ethiopia_ESS_LSMS_ISA_W3_hh_cost_harv_labor.dta
	SEED COST						Ethiopia_ESS_LSMS_ISA_W3_hh_cost_seed.dta
	
*FERTILIZER APPLICATION RATE		Ethiopia_ESS_LSMS_ISA_W3_fertilizer_application.dta
*DIETARY DIVERSITY					Ethiopia_ESS_LSMS_ISA_W3_household_diet.dta

*WOMEN'S OWNERSHIP OF ASSETS		Ethiopia_ESS_LSMS_ISA_W3_women_asset.dta
*WOMNE'S CONTROL OF AG DECISION		Ethiopia_ESS_LSMS_ISA_W3_ag_decision.dta
*WOMEN'S CONTROL OF INCOME			Ethiopia_ESS_LSMS_ISA_W3_control_income.dta

*WAGE INCOME						Ethiopia_ESS_LSMS_ISA_W3_wage_income.dta
*CROP YIELDS						Ethiopia_ESS_LSMS_ISA_W3_yield_hh_level.dta
	
	
*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD-LEVEL VARIABLES			Ethiopia_ESS_LSMS_ISA_W3_household_variables.dta
*FIELD-LEVEL VARIABLES				Ethiopia_ESS_LSMS_ISA_W3_field_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Ethiopia_ESS_LSMS_ISA_W3_individual_variables.dta	
*SUMMARY STATISTICS					Ethiopia_ESS_LSMS_ISA_W3_summary_stats.xlsx

*/


clear
clear matrix
clear mata
set more off
set maxvar 10000		
ssc install findname

*Set directories
global ETH_W3_raw_data			"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\Ethiopia\Ethiopia ESS Wave 3 2015-16 (LSMS-ISA)\Raw DTA Files"
global ETH_W3_created_data		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\Ethiopia\Ethiopia ESS Wave 3 2015-16 (LSMS-ISA)\Final DTA Files\created_data"
global ETH_W3_final_data		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\Ethiopia\Ethiopia ESS Wave 3 2015-16 (LSMS-ISA)\Final DTA Files\final_data" 



************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD IDS
************************
global ETH_LSMS_ISA_W3_exchange_rate 21.2389
global ETH_LSMS_ISA_W3_gdp_ppp_dollar 8.678
global ETH_LSMS_ISA_W3_cons_ppp_dollar 8.673


******************
*HOUSEHOLD IDS
******************
use "$ETH_W3_raw_data/Household/sect_cover_hh_w3.dta", clear
rename saq01 region
rename saq02 zone
rename saq03 woreda
rename saq04 town
rename saq05 subcity
rename saq06 kebele
rename saq07 ea
rename saq08 household
rename pw_w3 weight
rename rural rural2
gen rural = (rural2==1)
lab var rural "1=Rural"
keep region zone woreda town subcity kebele ea household rural household_id2 weight
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", replace


******************
*WEIGHTS AND GENDER OF HEAD
******************
use "$ETH_W3_raw_data/Household/sect1_hh_w3.dta", clear
gen fhh = hh_s1q03==2 if hh_s1q02==1		// assuming missing is male - 1 if hh_s1q03==2 and 0 otherwise

*We need to change the strata based on sampling methodology (see BID for more information)
gen clusterid = ea_id2
gen strataid=saq01 if rural==1 //assign region as strataid to rural respondents; regions from from 1 to 7 and then 12 to 15
gen stratum_id=.
replace stratum_id=16 if rural==2 & saq01==1 	//Tigray, small town
replace stratum_id=17 if rural==2 & saq01==3 	//Amhara, small town
replace stratum_id=18 if rural==2 & saq01==4 	//Oromiya, small town
replace stratum_id=19 if rural==2 & saq01==7 	//SNNP, small town
replace stratum_id=20 if rural==2 & (saq01==2 | saq01==5 | saq01==6 | saq01==12 | saq01==13 | saq01==15) //Other regions, small town
replace stratum_id=21 if rural==3 & saq01==1 	//Tigray, large town
replace stratum_id=22 if rural==3 & saq01==3 	//Amhara, large town
replace stratum_id=23 if rural==3 & saq01==4 	//Oromiya, large town
replace stratum_id=24 if rural==3 & saq01==7 	//SNNP, large town
replace stratum_id=25 if rural==3 & saq01==14 	//Addis Ababa, large town
replace stratum_id=26 if rural==3 & (saq01==2 | saq01==5 | saq01==6 | saq01==12 | saq01==13 | saq01==15) //Other regions, large town
replace strataid=stratum_id if rural!=1 		//assign new strata IDs to urban respondents, stratified by region and small or large towns

gen hh_members = 1 
gen hh_women = hh_s1q03==2
gen hh_adult_women = (hh_women==1 & hh_s1q04a>14 & hh_s1q04a<65)			//Adult women from 15-64 (inclusive)
gen hh_youngadult_women = (hh_women==1 & hh_s1q04a>14 & hh_s1q04a<25) 		//Adult women from 15-24 (inclusive) 
collapse (max) fhh (firstnm) pw_w3 clusterid strataid (sum) hh_members, by(household_id2)

lab var hh_members "Number of household members"
lab var fhh "1=Female-headed household"
lab var strataid "Strata ID (updated) for svyset"
lab var clusterid "Cluster ID for svyset"
lab var pw_w3 "Household weight"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", replace


******************
*INDIVIDUAL GENDER
******************
*Using gender from planting and harvesting
use "$ETH_W3_raw_data/Post-Harvest/sect1_ph_w3.dta", clear
gen personid = ph_s1q00
gen female = ph_s1q03==2	// NOTE: Assuming missings are MALE
replace female =. if ph_s1q03==.
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop household_id2 personid, force
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_ph.dta", replace		

*Planting
use "$ETH_W3_raw_data/Post-Planting/sect1_pp_w3.dta", clear
ren pp_s1q00 personid
gen female = pp_s1q03==2	// NOTE: Assuming missings are MALE
replace female =. if pp_s1q03==.
duplicates drop household_id2 personid, force
merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_ph.dta", nogen 		
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", replace

*Using household roster for missing gender 
use "$ETH_W3_raw_data/Household/sect1_hh_w3.dta", clear
rename hh_s1q00 personid
merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta"	// 5,474 were in roster but not planting/harvesting modules
duplicates drop household_id2 personid, force			//no duplicates
replace female = hh_s1q03==2 if female==.
*Assuming missings are male
recode female (.=0)		// no changes
duplicates drop individual_id2, force
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", replace


*******************
*PLOT DECISION-MAKERS
*******************
*Gender/age variables
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen cultivated = pp_s3q03==1			// if plot was cultivated

*First owner/decision maker
gen personid = pp_s3q10a
merge m:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(dm1_merge) keep(1 3)			
*10,057 not matched from master
*23,248 matched
tab dm1_merge cultivate		// Almost all unmatched observations are due to field not being cultivated
*First decision-maker variables
gen dm1_female = female
drop female personid

*Second owner/decision maker
gen personid = pp_s3q10c_a
merge m:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(dm2_merge) keep(1 3)			
*17,293 not matched from master
*16,012 matched
gen dm2_female = female
drop female personid

*Third owner/decision maker
gen personid = pp_s3q10c_b
merge m:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(dm3_merge) keep(1 3)			
*29,644 not matched from master
*3,661 matched
gen dm3_female = female
drop female personid

*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & (dm3_female==0 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & (dm3_female==1 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==. & dm3_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var dm_gender "Gender of decision-maker(s)"
keep dm_gender holder_id household_id2 field_id parcel_id
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", replace



*******************
* ALL AREA CONSTRUCTION
*******************
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen cultivated = pp_s3q03==1			// if plot was cultivated
*Generating some conversion factors
gen area = pp_s3q02_a 
gen local_unit = pp_s3q02_c
gen area_sqmeters_gps = pp_s3q05_a
replace area_sqmeters_gps = . if area_sqmeters_gps<0

*Constructing geographic medians for local unit per square meter ratios
preserve
	keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
	drop if _merge==2
	drop _merge
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region zone local_unit)
	rename sqmeters_per_unit sqmeters_per_unit_zone 
	rename observations obs_zone
	lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_zone.dta", replace
restore
preserve
	replace area_sqmeters_gps=. if area_sqmeters_gps<0
	keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
	drop if _merge==2
	drop _merge
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region local_unit)
	rename sqmeters_per_unit sqmeters_per_unit_region
	rename observations obs_region
	lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_region.dta", replace
restore
preserve
	replace area_sqmeters_gps=. if area_sqmeters_gps<0
	keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
	drop if _merge==2
	drop _merge
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (local_unit)
	rename sqmeters_per_unit sqmeters_per_unit_country
	rename observations obs_country
	lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_country.dta", replace
restore

*Now creating area - starting with sq meters
gen area_meas_hectares = pp_s3q02_a*10000 if pp_s3q02_c==1			// hectares to sq m
replace area_meas_hectares = pp_s3q02_a if pp_s3q02_c==2			// already in sq m

*For rest of units, we need to use the conversion factors
gen region = saq01
gen zone = saq02
gen woreda = saq03
merge m:1 region zone woreda local_unit using "$ETH_W3_raw_data/Land Area Conversion Factor/ET_local_area_unit_conversion.dta", gen(conversion_merge) keep(1 3)	// 66 not matched from using, dropped
*20,826 not matched from master
*12,479 matched
replace area_meas_hectares = pp_s3q02_a*conversion if !inlist(pp_s3q02_c,1,2) & pp_s3q02_c!=.			// non-traditional units

*Field area is currently farmer reported - replacing with GPS area when available
replace area_meas_hectares = pp_s3q05_a if pp_s3q05_a!=. & pp_s3q05_a>0			// 32,205 changes
replace area_meas_hectares = area_meas_hectares*0.0001						// Changing back into hectares

*Using our own created conversion factors for still missings observations
merge m:1 region zone local_unit using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_zone.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & area_meas_hectares==. & obs_zone>=10		
merge m:1 region local_unit using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_region.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & area_meas_hectares==. & obs_region>=10
merge m:1 local_unit using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_country.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & area_meas_hectares==.

count if area!=. & area_meas_hectares==.
replace area_meas_hectares = 0 if area_meas_hectares == .
lab var area_meas_hectares "Field area measured in hectares, with missing obs imputed using local median per-unit values"

merge 1:1 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
gen area_meas_hectares_male = area_meas_hectares if dm_gender==1
gen area_meas_hectares_female = area_meas_hectares if dm_gender==2
gen area_meas_hectares_mixed = area_meas_hectares if dm_gender==3
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area.dta", replace

*Parcel Area
collapse (sum) land_size = area_meas_hectares, by(household_id2 holder_id parcel_id)
lab var land_size "Parcel area measured in hectares, with missing obs imputed using local median per-unit values"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_parcel_area.dta", replace

*Household Area
collapse (sum) area_meas_hectares_hh = land_size, by(household_id2)
lab var area_meas_hectares_hh "Total area measured in hectares, with missing obs imputed using local median per-unit values"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_household_area.dta", replace

*Cultivated (HH) area
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area.dta", clear
keep if cultivated==1
collapse (sum) farm_area = area_meas_hectares, by (household_id2)
lab var farm_area "Land size, all cultivated plots (denominator for land productivitiy), in hectares" 
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farm_area.dta", replace

*Agricultural land summary and area
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area.dta", clear
gen agland = (pp_s3q03==1 | pp_s3q03==2 | pp_s3q03==3 | pp_s3q03==5) // Cultivated, prepared for Belg season, pasture, or fallow. Excludes forest and "other" (which seems to include rented-out)
keep if agland==1
keep household_id2 parcel_id field_id holder_id agland area_meas_hectares
rename area_meas_hectares farm_size_agland_field
lab var farm_size_agland "Field size in hectares, including all plots cultivated, fallow, or pastureland"
lab var agland "1= Plot was used for cultivated, pasture, or fallow"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_fields_agland.dta", replace

*Agricultural land area household
collapse (sum) farm_size_agland = farm_size_agland_field, by (household_id2)
lab var farm_size_agland "Total land size in hectares, including all plots cultivated, fallow, or pastureland"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmsize_all_agland.dta", replace


*******************
*MONOCROPPED CROPS*
*******************

//List of crops for this instrument - including 12 priority crops and any additional crops from the top 10
/*
maize
rice 
wheat
sorghum
millet 
cowpea  		// not reported in this instrument 
groundnut
common bean (includes haricot, kidney, pinto, navy, and black beans) - only haricot (12) and red kidney (19) in this instrument
yam				// no yam in this wave
sweet potato
cassava 
banana
teff
barley
coffee
sesame
horse beans
nueg (Niger seed)
*/

global topcropname_area "maize rice wheat sorgum millet grdnt bean swtptt cassav banana teff barley coffee sesame hsbean nueg"		
global topcrop_area "2 5 8 6 3 24 12 62 10 42 7 1 72 27 13 25"
global comma_topcrop_area "2, 5, 8, 6, 3, 24, 12, 62, 10, 42, 7, 1, 72, 27, 13, 25"
global topcropname_full "maize rice wheat sorghum millet groundnut bean sweetpotato cassava banana teff barley coffee sesame horsebean nueg"

forvalues k=1(1)16 {
	local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	use "${ETH_W3_raw_data}/Post-Planting/sect4_pp_w3.dta", clear
	drop crop_code
	ren pp_s4q01_b crop_code
	*recoding common beans to a single category
	recode crop_code (19=12)
	
	xi i.crop_code, noomit
	egen crop_count = rowtotal(_Icrop_code_*)

	gen percent_`cn'=1 if pp_s4q02==1 & crop_code==`c'
	replace percent_`cn' = pp_s4q03/100 if pp_s4q02==2 & pp_s4q03!=. & crop_code==`c'		
	collapse (max) percent_`cn' _Icrop_code_*, by(household_id2 parcel_id field_id holder_id)
	egen crop_count = rowtotal(_Icrop_code_*)
	keep if _Icrop_code_`c'==1 & crop_count==1
	
	*merging in plot areas
	merge m:1 field_id parcel_id household_id2 holder_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_field_area.dta", nogen keep(1 3)
	gen `cn'_monocrop_ha= area_meas_hectares*percent_`cn'
	gen `cn'_monocrop_ha_female = area_meas_hectares*percent_`cn' if dm_gender==2
	gen `cn'_monocrop_ha_male = area_meas_hectares*percent_`cn' if dm_gender==1
	gen `cn'_monocrop_ha_mixed = area_meas_hectares*percent_`cn' if dm_gender==3
	save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop.dta", replace

	collapse (sum) `cn'_monocrop_ha*, by(household_id2)
	gen `cn'_monocrop=1 
	lab var `cn'_monocrop "1=hh has monocropped `cn' plots"
	recode `cn'_monocrop_ha* (0=.)
	lab var `cn'_monocrop_ha "monocropped `cnfull' area(ha) planted"
	
	foreach i in male female mixed {
		local l`cn'_monocrop_ha : var lab `cn'_monocrop_ha
		la var `cn'_monocrop_ha_`i' "`l`cn'_monocrop_ha' - `i' managed plots"
	}

	save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop_hh_area.dta", replace
}

*TLU (Tropical Livestock Units)
use "$ETH_W3_raw_data/Livestock/sect8_2_ls_w3.dta", clear
gen tlu=0.5 if (ls_code==1|ls_code==2|ls_code==3|ls_code==4|ls_code==5|ls_code==6)
replace tlu=0.1 if (ls_code==7|ls_code==8|ls_code==9|ls_code==10|ls_code==11|ls_code==12)
replace tlu=0.7 if (ls_code==13|ls_code==14|ls_code==15)
replace tlu=0.01 if (ls_code==16|ls_code==17|ls_code==18|ls_code==19)
replace tlu=0.5 if (ls_code==20)
replace tlu=0.6 if (ls_code==21)
replace tlu=0.3 if (ls_code==22)
lab var tlu "Tropical Livestock Unit coefficient"
ren tlu tlu_coefficient
*Owned
gen lvstckid=ls_code
gen cattle=inrange(lvstckid,1,6)
gen smallrum=inrange(lvstckid,7, 12)
gen poultry=inrange(lvstckid,16,19)
gen other_ls=inlist(lvstckid,13, 14, 15,20,21, 21, 23)

ren ls_sec_8_2aq01 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_poultry_1yearago=nb_ls_1yearago if poultry==1 
gen nb_other_ls_1yearago=nb_ls_1yearago if other_ls==1 

rename ls_sec_8_2aq02 nb_ls_born 
rename ls_sec_8_2aq04 nb_ls_purchased 
rename ls_sec_8_2aq07 nb_ls_gifts_received 
rename ls_sec_8_2aq09 nb_ls_gifts_given 
rename ls_sec_8_2aq11 nb_ls_lost 
rename ls_sec_8_2aq13 nb_ls_sold 
rename ls_sec_8_2aq16 nb_ls_slaughtered
rename ls_sec_8_2aq14 value_sold
replace nb_ls_sold = value_sold if nb_ls_sold > value_sold /* columns seem to be switched */
rename ls_sec_8_2aq05 value_purchased 
replace nb_ls_purchased = value_purchased if nb_ls_purchased > value_purchased
replace nb_ls_purchased = 0 if nb_ls_purchased >= 1000 & value_purchased ==.
replace nb_ls_gifts_received = 0 if nb_ls_gifts_received >= 1000 /* Seem to have reported value of gifts, not number of animals */
replace nb_ls_born = 0 if nb_ls_born >= 1000
recode nb_ls_1yearago nb_ls_born nb_ls_purchased nb_ls_gifts_received nb_ls_gifts_given nb_ls_lost nb_ls_sold nb_ls_slaughtered (.=0)
replace nb_ls_slaughtered = 0 if nb_ls_slaughtered > (nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received)
replace nb_ls_sold = 0 if nb_ls_sold > (nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received)
gen nb_ls_today = nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received - nb_ls_gifts_given - nb_ls_lost - nb_ls_sold - nb_ls_slaughtered
replace nb_ls_today = 0 if nb_ls_today < 0 /* My best effort to clean this up */
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
collapse (sum) tlu_* nb_*  , by (household_id2)
lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminant owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_ls_1yearago "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (dog, donkey, and other) owned as of the time of survey"
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_1yearago  "Number of livestock owned as of 12 months ago"
lab var nb_ls_1yearago  "Number of livestock owned as of 12 months ago"
lab var nb_ls_today "Number of livestock owned as of today"
drop tlu_coefficient nb_ls_born nb_ls_purchased nb_ls_gifts_received nb_ls_gifts_given nb_ls_lost nb_ls_sold nb_ls_slaughtered 
save "${ETH_W3_created_data}\Ethiopia_ESS_LSMS_ISA_W3_TLU_Coefficients.dta", replace 


************
*GROSS CROP REVENUE
************

*Crops excluding tree crops, vegetables, root crops
use "$ETH_W3_raw_data/Post-Harvest/sect11_ph_w3.dta", clear
rename saq01 region
rename saq02 zone
rename saq03 woreda
rename saq04 kebele
rename saq05 ea
rename saq06 household
rename ph_s11q01 sell_yesno
rename ph_s11q03_a quantity_sold
rename ph_s11q03_b quantity_sold_unit
gen unit_cd = quantity_sold_unit
rename ph_s11q04 value_sold
rename ph_s11q22_e percent_sold
keep if sell_yesno==1
drop if value_sold==0 | value_sold==.
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales_1.dta", replace

*Tree crops, vegetables, root crops
use "$ETH_W3_raw_data/Post-Harvest/sect12_ph_w3.dta", clear
rename saq01 region
rename saq02 zone
rename saq03 woreda
rename saq04 kebele
rename saq05 ea
rename saq06 household
rename ph_s12q06 sell_yesno
rename ph_s12q07 quantity_sold
rename ph_s12q0b quantity_sold_unit
gen unit_cd = quantity_sold_unit
rename ph_s12q08 value_sold
rename ph_s12q19_f percent_sold
keep if sell_yesno==1 
drop if value_sold==0 | value_sold==.
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales_2.dta", replace

use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales_1.dta", clear
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales_2.dta"
merge m:1 crop_code unit_cd using "$ETH_W3_raw_data/Food and Crop Conversion Factors/Crop_CF_Wave3.dta", nogen keep(1 3)
gen kgs_sold = quantity_sold * mean_cf_nat /* Here, if conversion value is missing, this will be a missing observation in the imputed median price estimation. */
collapse (sum) kgs_sold value_sold (max) percent_sold, by (household_id2 crop_code) /* For duplicated obs, we'll take the maximum reported % sold. */
gen price_kg = value_sold / kgs_sold
lab var price_kg "Price received per kgs sold"
drop if price_kg==. | price_kg==0
keep household_id2 crop_code price_kg value_sold percent_sold kgs_sold
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)
replace crop_code=6 if household_id2=="030101088800204020" & crop_code==1 /* Typo, crops mismatched between files on production and sales */
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", replace 


use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region zone woreda kebele ea crop_code: egen obs_ea = count(observation)
collapse (median) price_kg [aw=weight], by (region zone woreda kebele ea crop_code obs_ea)
rename price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_ea.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region zone woreda kebele crop_code: egen obs_kebele = count(observation)
collapse (median) price_kg [aw=weight], by (region zone woreda kebele crop_code obs_kebele)
rename price_kg price_kg_median_kebele
lab var price_kg_median_kebele "Median price per kg for this crop in the kebele"
lab var obs_kebele "Number of sales observations for this crop in the kebele"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_kebele.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region zone woreda crop_code: egen obs_woreda = count(observation)
collapse (median) price_kg [aw=weight], by (region zone woreda crop_code obs_woreda)
rename price_kg price_kg_median_woreda
lab var price_kg_median_woreda "Median price per kg for this crop in the woreda"
lab var obs_woreda "Number of sales observations for this crop in the woreda"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_woreda.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region zone crop_code: egen obs_zone = count(observation)
collapse (median) price_kg [aw=weight], by (region zone crop_code obs_zone)
rename price_kg price_kg_median_zone
lab var price_kg_median_zone "Median price per kg for this crop in the zone"
lab var obs_zone "Number of sales observations for this crop in the zone"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_zone.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
rename price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_region.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
rename price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_country.dta", replace

use "$ETH_W3_raw_data/Post-Harvest/sect9_ph_w3.dta", clear 
rename ph_s9q05 kgs_harvest			
keep household_id2 crop_name crop_code kgs_harvest
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)
collapse (sum) kgs_harvest, by (household_id2 region zone woreda kebele ea crop_code)
merge 1:1 household_id2 crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", nogen


*Kebele and ea are the same thing.
merge m:1 region zone woreda kebele crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_kebele.dta", nogen
merge m:1 region zone woreda crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_woreda.dta", nogen
merge m:1 region zone crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_zone.dta", nogen
merge m:1 region crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_region.dta", nogen
merge m:1 crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_country.dta", nogen
rename price_kg price_kg_hh
gen price_kg = price_kg_hh
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
gen value_harvest = kgs_harvest * price_kg
lab var value_harvest "Value of harvest"
*For Ethiopia LSMS, "other" crops are at least categorized as being legumes, cereals, etc. So we will take the median per-kg price to value these crops.
count if value_harvest==. /* 149 household-crop observations can't be valued. Assume value is zero for now. */
replace value_harvest = value_sold if percent_sold==100 /* If the household sold 100% of this crop, then that is the value of production, even if odd units had been reported. */
replace value_harvest = value_sold if (kgs_harvest==0 | kgs_harvest==.) & value_sold>0 & value_sold!=.
replace value_harvest = value_sold if value_sold>value_harvest & value_sold!=. & value_harvest!=. /* In a few cases, the kgs sold exceeds the kgs harvested */	
replace value_harvest=0 if value_harvest==.		
collapse (sum) value_harvest kgs_harvest value_sold, by (household_id2 crop_code)

gen value_crop_production = value_harvest
lab var value_crop_production "Gross value of crop production, summed over main and short season"
gen value_crop_sales = value_sold
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"

save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_values_production.dta", replace
collapse (sum) value_harvest value_sold, by (household_id2)
rename value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using local median values of observed sales in which the sales unit is also found in the conversion table.
*For "Other" crops,these are valued as though "other spice", "other cereal" is its own crop code.
**If a crop is never, ever sold, it receives a value of zero using this method.
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
drop if household_id2==""
save  "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_production.dta", replace

*Value crop production by parcel
use "$ETH_W3_raw_data/Post-Harvest/sect9_ph_w3.dta", clear
rename ph_s9q05 kgs_harvest
keep household_id2 crop_name crop_code kgs_harvest parcel_id field_id holder_id
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)
collapse (sum) kgs_harvest, by (household_id2 region zone woreda kebele ea crop_code parcel_id field_id holder_id)
merge m:1 household_id2 crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", nogen
merge m:1 region zone woreda kebele crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_kebele.dta", nogen
merge m:1 region zone woreda crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_woreda.dta", nogen
merge m:1 region zone crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_zone.dta", nogen
merge m:1 region crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_region.dta", nogen
merge m:1 crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_country.dta", nogen
rename price_kg price_kg_hh
gen price_kg = price_kg_hh
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
gen value_harvest = kgs_harvest * price_kg
lab var value_harvest "Value of harvest"
*For Ethiopia LSMS, "other" crops are at least categorized as being legumes, cereals, etc. 
*So we will take the median per-kg price to value these crops.
count if value_harvest==. /* 149 household-crop observations can't be valued. Assume value is zero for now. */
replace value_harvest=0 if value_harvest==.
preserve
	collapse (sum) value_harvest, by (household_id2 holder_id parcel_id)
	rename value_harvest value_crop_production
	lab var value_crop_production "Gross value of crop production for this parcel"
	drop if household_id2==""
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_parcel.dta", replace
	*9,700 parcels cultivated
restore
collapse (sum) value_harvest kgs_harvest, by (household_id2 holder_id parcel_id field_id)
rename value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production"
drop if household_id2==""
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_field.dta", replace

merge 1:1 household_id2 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen keep(1 3)
gen value_harvest_male = value_crop_production if dm_gender==1
gen value_harvest_female = value_crop_production if dm_gender==2
gen value_harvest_mixed = value_crop_production if dm_gender==3
collapse (sum) value_harvest* value_crop_production kgs_harvest, by (household_id2)
lab var value_crop_production "Gross value of crop production"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_household.dta", replace

*Crop losses and value of consumption
use "$ETH_W3_raw_data/Post-Harvest/sect11_ph_w3.dta", clear
rename ph_s11q15_1 quantity_lost
rename ph_s11q15_2 quantity_lost_units /* We can't value this for now */
rename ph_s11q15_4 percent_lost
append using "$ETH_W3_raw_data/Post-Harvest/sect12_ph_w3.dta"
rename ph_s12q12 share_lost
rename ph_s12q13 value_lost /* It's not clear why different types of crops were valued so differently. */
replace percent_lost = share_lost if percent_lost==.
merge m:1 household_id2 crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_values_production.dta"
drop if _merge==2
drop _merge
*It is evident that sometimes crops were harvested but then the module on sales was not asked.
*91 cases where the amount lost was reported in quantity (crop-units) but no percent lost is given.
*Use conversion file to get from units to kgs, then use the price files to get from kgs to monetary values.
rename quantity_lost_units unit_cd
merge m:1 crop_code unit_cd using "$ETH_W3_raw_data/Food and Crop Conversion Factors/Crop_CF_Wave3.dta", nogen keep(1 3)
gen kgs_lost = quantity_lost * mean_cf_nat
sum kgs_lost if percent_lost==0 /* If both a quantity and share lost were given, we'll take the share to be consistent with section 12. */
lab var kgs_lost "Estimated number of kgs of this crop that were lost post-harvest"
merge m:1 household_id2 crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", nogen
merge m:1 region zone woreda kebele crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_kebele.dta", nogen
merge m:1 region zone woreda crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_woreda.dta", nogen
merge m:1 region zone crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_zone.dta", nogen
merge m:1 region crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_region.dta", nogen
merge m:1 crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_country.dta", nogen
rename price_kg price_kg_hh
gen price_kg = price_kg_hh
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
count if (kgs_lost>0 & kgs_lost!=.) | (percent_lost>0 & percent_lost!=.)
replace kgs_lost = 0 if percent_lost!=0 & percent_lost!=.
recode kgs_lost percent_lost (.=0)
gen value_quantity_lost = kgs_lost * price_kg
/*If the estimated value lost (just 10 obs) exceeds the value produced (We're relying on kg-estimates to value harvest, 
and the units reported can also differ across files), then we'll cap the losses at the value of production */
replace value_quantity_lost = value_crop_production if value_quantity_lost > value_crop_production & value_quantity_lost!=.
gen crop_value_lost = (value_crop_production * (percent_lost/100)) + value_quantity_lost
recode crop_value_lost (.=0)

*Also including transport costs for crop sales here
rename ph_s11q09 value_transport_cropsales
recode value_transport_cropsales (.=0)

collapse (sum) crop_value_lost value_transport_cropsales, by (household_id2)
lab var crop_value_lost "Value of crop losses"
lab var value_transport_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_losses.dta", replace



************
*CROP EXPENSES
************

*Expenses: Hired labor
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
rename pp_s3q28_a number_men
rename pp_s3q28_b number_days_men
rename pp_s3q28_c wage_perday_men
rename pp_s3q28_d number_women
rename pp_s3q28_e number_days_women
rename pp_s3q28_f wage_perday_women
rename pp_s3q28_g number_children
rename pp_s3q28_h number_days_children
rename pp_s3q28_i wage_perday_children
gen wages_paid_men = number_days_men * wage_perday_men
gen wages_paid_women = number_days_women * wage_perday_women 
gen wages_paid_children = number_days_children * wage_perday_children
recode wages_paid_men wages_paid_women wages_paid_children (.=0)
gen wages_paid_aglabor_postplant =  wages_paid_men + wages_paid_women + wages_paid_children		

*Top crops
foreach cn in $topcropname_area {
	preserve
		merge 1:1 household_id2 parcel_id field_id holder_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen assert(1 3) keep(3)	// only in master and matched; keeping only matched, because these are the monocropped plots
		collapse (sum) wg_paid_aglabor_postplant_`cn' = wages_paid_aglabor_postplant, by(household_id2)		//renaming all to crop suffix
		lab var wg_paid_aglabor_postplant_`cn' "Wages paid for hired labor (crops) - Monocropped `cn' plots only, as captured in post-planting survey"
		save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_wages_postplanting_`cn'.dta", replace
	restore
}
	
collapse (sum) wages_paid_aglabor_postplant, by (household_id2)
lab var wages_paid_aglabor_postplant "Wages paid for hired labor (crops), as captured in post-planting survey"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_wages_postplanting.dta", replace

use "$ETH_W3_raw_data/Post-Harvest/sect10_ph_w3.dta", clear
rename ph_s10q01_a number_men
rename ph_s10q01_b number_days_men
rename ph_s10q01_c wage_perday_men
rename ph_s10q01_d number_women
rename ph_s10q01_e number_days_women
rename ph_s10q01_f wage_perday_women
rename ph_s10q01_g number_children
rename ph_s10q01_h number_days_children
rename ph_s10q01_i wage_perday_children
gen wages_paid_men = number_days_men * wage_perday_men
gen wages_paid_women = number_days_women * wage_perday_women 
gen wages_paid_children = number_days_children * wage_perday_children
recode wages_paid_men wages_paid_women wages_paid_children (.=0)
gen wages_paid_aglabor_postharvest =  wages_paid_men + wages_paid_women + wages_paid_children

*Top crops
foreach cn in $topcropname_area {
	preserve 
		merge m:1 household_id2 parcel_id field_id holder_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen assert(1 3) keep(3)	// only in master and matched; keeping only matched, because these are the monocropped plots
		collapse wg_paid_aglabor_postharv_`cn' = wages_paid_aglabor_postharvest, by(household_id2)
		lab var wg_paid_aglabor_postharv_`cn' "Wages paid for hired labor (crops) - Monocropped `cn' plots only, as captured in post-harvest survey"
		save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_wages_postharvest_`cn'.dta", replace
	restore
}

collapse (sum) wages_paid_aglabor_postharvest, by (household_id2)
lab var wages_paid_aglabor_postharvest "Wages paid for hired labor (crops), as captured in post-harvest survey"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_wages_postharvest.dta", replace

*Expenses: Inputs
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
rename pp_s3q16d value_urea
rename pp_s3q19d value_DAP
rename pp_s3q20a_5 value_NPS
rename pp_s3q20c value_other_chemicals
recode value_urea value_DAP value_NPS value_other_chemicals (.=0)

*Top crops
foreach cn in $topcropname_area {
	preserve
		merge m:1 household_id2 parcel_id field_id holder_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen assert(1 3) keep(3)
		gen value_urea_`cn' = value_urea
		gen value_DAP_`cn' = value_DAP 
		gen value_NPS_`cn' = value_NPS
		gen value_other_chem_`cn' = value_other_chemicals
		lab var value_urea_`cn' "Value of urea used on the farm - Monocropped `cn' plots"
		lab var value_DAP_`cn' "Value of DAP used on the farm - Monocropped `cn' plots"
		lab var value_other_chem_`cn' "Value of any other chemicals used on the farm - Monocropped `cn' plots"
		egen value_fertilizer_`cn' = rowtotal(value_urea_`cn' value_DAP_`cn' value_NPS_`cn' value_other_chem_`cn')
		la var value_fertilizer_`cn' "Value of all fertilizer on `cn' monocropped plots"
		merge 1:1 household_id2 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen keep(3)
		gen value_fertilizer_`cn'_male = value_fertilizer_`cn' if dm_gender==1
		gen value_fertilizer_`cn'_female = value_fertilizer_`cn' if dm_gender==2
		gen value_fertilizer_`cn'_mixed = value_fertilizer_`cn' if dm_gender==3
		collapse (sum) value_fertilizer_`cn'*, by(household_id2)
		save "${ETH_W3_created_data}\Ethiopia_ESS_LSMS_ISA_W3_fertilizer_costs_`cn'.dta", replace
	restore
}

collapse (sum) value_urea value_DAP value_NPS value_other_chemicals, by (household_id2)
lab var value_urea "Value of urea used on the farm"
lab var value_DAP "Value of DAP used on the farm"
lab var value_NPS "Value of NPS used on the farm"
lab var value_other_chemicals "Value of any other chemicals used on the farm"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_fertilizer_costs.dta", replace

*Other chemicals, manure (Values not captured for Ethiopia LSMS)

*Seeds
use "$ETH_W3_raw_data/Post-Planting/sect5_pp_w3.dta", clear
rename pp_s5q07 cost_transport_purchased_seed
rename pp_s5q08 value_purchased_seed
rename pp_s5q16 cost_transport_free_seed
recode value_purchased_seed cost_transport_purchased_seed cost_transport_free_seed (.=0)

collapse (sum) value_purchased_seed cost_transport_purchased_seed cost_transport_free_seed , by (household_id2)
lab var value_purchased_seed "Value of purchased seed"
lab var cost_transport_purchased_seed "Cost of transport for purchased seed"
lab var cost_transport_free_seed "Cost of transport for free seed"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_seed_costs.dta", replace
*Value of seed purchased (not just improved seed) is also captured here.

*Land rental
use "$ETH_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
gen rented_plot = (pp_s2q03==3)
rename pp_s2q07_a rental_cost_cash
rename pp_s2q07_b rental_cost_inkind
rename pp_s2q07_c rental_cost_share /* This will have to be picked up after we've valued the plot harvest. */
gen formal_land_rights = pp_s2q04==1

*Individual level (for women)
*starting with first owner
preserve
	ren pp_s2q06_a personid
	merge m:1 household_id2 personid using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", nogen keep(3)		//keep only matched
	keep household_id2 personid female formal_land_rights
	tempfile p1
	save `p1', replace
restore
*Now second owner
preserve
	ren pp_s2q06_b personid
	merge m:1 household_id2 personid using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", nogen keep(3)		//keep only matched
	keep household_id2 personid female formal_land_rights
	append using `p1'
	gen formal_land_rights_f = formal_land_rights==1 if female==1
	collapse (max) formal_land_rights_f, by(household_id2 personid)
	save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_land_rights_ind.dta", replace
restore

preserve
	collapse (max) formal_land_rights_hh= formal_land_rights, by(household_id2)		// taking max at household level; equals one if they have official documentation for at least one plot
	save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_land_rights_hh.dta", replace
restore


merge 1:1 household_id2 holder_id parcel_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_parcel.dta", nogen keep(1 3)
replace rental_cost_cash = rental_cost_share if rental_cost_share>100 & rental_cost_share!=. /* These two columns seem to be switched for a few parcels */
replace rental_cost_share = 0 if rental_cost_share>100 & rental_cost_share!=.
gen rental_cost_sharecrop = value_crop_production * (rental_cost_share/100)
recode rental_cost_cash rental_cost_inkind rental_cost_sharecrop (.=0)
gen rental_cost_land =  rental_cost_cash + rental_cost_inkind + rental_cost_sharecrop

collapse (sum) rental_cost_land, by (household_id2)
lab var rental_cost_land "Rental costs for land(paid in cash and in kind or paid as sharecrop)"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_land_rental_costs.dta", replace

*Rental of agricultural tools, machines = Not captured.

*Transport costs for crop sales
use "$ETH_W3_raw_data/Post-Harvest/sect11_ph_w3.dta", clear
rename ph_s11q09 transport_costs_cropsales
recode transport_costs_cropsales (.=0)
collapse (sum) transport_costs_cropsales, by (household_id2)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_transportation_cropsales.dta", replace



************
*LIVESTOCK INCOME
************

*Expenses
use "$ETH_W3_raw_data/Livestock/sect8_4_ls_w3.dta", clear
append using "$ETH_W3_raw_data/Livestock/sect8_5_ls_w3.dta"
append using  "$ETH_W3_raw_data/Livestock/sect8_3_ls_w3.dta"
rename ls_sec_8_4q05 cost_water_livestock
rename ls_sec_8_4q08 cost_fodder_livestock
rename ls_sec_8_5q05 cost_vaccines_livestock
rename ls_sec_8_5q07 cost_treatment_livestock
rename ls_sec_8_3q04 cost_breeding_livestock
recode cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock (.=0)

*Dairy costs
preserve
	keep if ls_sec_8_type_code == 1
	collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (household_id2)
	egen cost_lrum = rowtotal (cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock)
	keep household_id2 cost_lrum
save "${ETH_W3_created_data}\Ethiopia_ESS_LSMS_ISA_W3_lrum_expenses", replace
restore 

collapse (sum) cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (household_id2)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines for livestock"
lab var cost_treatment_livestock "Cost for veterinary treatment for livestock"
lab var cost_breeding_livestock "Cost for breeding (insemination?) for livestock"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_expenses", replace
*Note that costs for hired labor are not captured.

*Livestock products
use "$ETH_W3_raw_data/Livestock/sect8_6_ls_w3.dta", clear
rename ls_code livestock_code 
rename ls_sec_8_6aq01 animals_milked
rename ls_sec_8_6aq02 months_milked
rename ls_sec_8_6aq04 liters_per_day /* Based on values, I assume this is per cow */
recode animals_milked months_milked liters_per_day (.=0)
gen milk_liters_produced = (animals_milked * months_milked * 30 * liters_per_day) /* 30 days per month */
rename ls_sec_8_6aq10 earnings_milk_week
rename ls_sec_8_6aq09 liters_sold_week
rename ls_sec_8_6aq12 earnings_milk_products /* Note that we can't value the milk inputs here. They'll get double-counted as income */
gen price_per_liter = earnings_milk_week / liters_sold_week
rename ls_sec_8_6bq16 egg_laying_hens
rename ls_sec_8_6bq14 clutching_periods
rename ls_sec_8_6bq15 eggs_per_clutching_period
recode egg_laying_hens clutching_periods eggs_per_clutching_period (.=0)
gen eggs_produced = (egg_laying_hens * clutching_periods * eggs_per_clutching_period)
rename ls_sec_8_6bq18 eggs_sold
rename ls_sec_8_6bq19 earnings_egg_sales
gen price_per_egg = earnings_egg_sales / eggs_sold
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)
keep household_id2 weight region zone woreda kebele ea livestock_code milk_liters_produced price_per_liter eggs_produced price_per_egg earnings_milk_products /*
	*/earnings_milk_week months_milked earnings_egg_sales liters_sold_week eggs_sold
gen price_per_unit = price_per_liter
replace price_per_unit = price_per_egg if price_per_unit==.
recode price_per_unit (0=.)
gen earnings_milk_year = earnings_milk_week*4*months_milked		//assuming 4 weeks per month
gen liters_sold_year = liters_sold_week*4*months_milked
gen eggs_sold_year = eggs_sold
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_products", replace

use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
rename price_per_unit price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock product in the kebele"
lab var obs_kebele "Number of sales observations for this livestock product in the kebele"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_kebele.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda livestock_code: egen obs_woreda = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda livestock_code obs_woreda)
rename price_per_unit price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock product in the woreda"
lab var obs_woreda "Number of sales observations for this livestock product in the woreda"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_woreda.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone livestock_code obs_zone)
rename price_per_unit price_median_zone
lab var price_median_zone "Median price per unit for this livestock product in the zone"
lab var obs_zone "Number of sales observations for this livestock product in the zone"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_zone.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_region.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_country.dta", replace

use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_products", clear
merge m:1 region zone woreda kebele livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_zone.dta", nogen
merge m:1 region livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_kebele if price_per_unit==. & obs_kebele >= 10
replace price_per_unit = price_median_woreda if price_per_unit==. & obs_woreda >= 10
replace price_per_unit = price_median_zone if price_per_unit==. & obs_zone >= 10
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10
replace price_per_unit = price_median_country if price_per_unit==. 
lab var price_per_unit "Price per liter (milk) or per egg, imputed with local median prices if household did not sell"
gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = eggs_produced * price_per_unit
gen value_milk_sold = liters_sold_year * price_per_unit
gen value_eggs_sold = eggs_sold_year * price_per_unit
recode earnings_milk_products (.=0)

egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced)
egen sales_livestock_products = rowtotal(value_milk_sold value_eggs_sold)

collapse (sum) value_milk_produced value_eggs_produced earnings_milk_products value_livestock_products sales_livestock_products, by (household_id2)
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
*NOTE: there are quite a few that seem to have higher sales than production; going to cap these at one
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 

lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var earnings_milk_products "Earnings from milk products sold (gross earnings only)"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products", replace

*Sales (live animals)
use "$ETH_W3_raw_data/Livestock/sect8_2_ls_w3.dta", clear
rename ls_code livestock_code
rename ls_sec_8_2aq13 number_sold 
rename ls_sec_8_2aq14 income_live_sales 
rename ls_sec_8_2aq16 number_slaughtered 
rename ls_sec_8_2aq18 income_slaughtered 
rename ls_sec_8_2aq05 value_livestock_purchases
rename ls_sec_8_2aq04 number_purchased 
*We can't estimate the value of animals slaughtered because we don't know the number of slaughtered animals that were sold.
*Although we might be able to estimate the value as though they were live sales.	
replace number_purchased = income_live_sales if number_purchased > income_live_sales
replace number_purchased = 0 if number_purchased >= 1000 & value_livestock_purchases ==.
recode number_sold number_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
drop if _merge==2
drop _merge
keep household_id2 weight region zone woreda kebele ea livestock_code number_sold income_live_sales number_slaughtered income_slaughtered price_per_animal value_livestock_purchases
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_sales", replace

*Implicit prices
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
rename price_per_animal price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock in the kebele"
lab var obs_kebele "Number of sales observations for this livestock in the kebele"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_kebele.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda livestock_code: egen obs_woreda = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda livestock_code obs_woreda)
rename price_per_animal price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock in the woreda"
lab var obs_woreda "Number of sales observations for this livestock in the woreda"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_woreda.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone livestock_code obs_zone)
rename price_per_animal price_median_zone
lab var price_median_zone "Median price per unit for this livestock in the zone"
lab var obs_zone "Number of sales observations for this livestock in the zone"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_zone.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_region.dta", replace
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_country.dta", replace

use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_livestock_sales", clear
merge m:1 region zone woreda kebele livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_zone.dta", nogen
merge m:1 region livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_kebele if price_per_animal==. & obs_kebele >= 10
replace price_per_animal = price_median_woreda if price_per_animal==. & obs_woreda >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
replace value_slaughtered = income_slaughtered if (value_slaughtered < income_slaughtered) & number_slaughtered!=0 & income_slaughtered!=. /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
gen value_livestock_sales = value_sold + value_slaughtered
collapse (sum) value_livestock_sales value_livestock_purchases, by (household_id2)
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_sales", replace


*TLU (Tropical Livestock Units)
use "$ETH_W3_raw_data/Livestock/sect8_2_ls_w3.dta", clear
gen tlu=0.5 if (ls_code==1|ls_code==2|ls_code==3|ls_code==4|ls_code==5|ls_code==6)
replace tlu=0.1 if (ls_code==7|ls_code==8|ls_code==9|ls_code==10|ls_code==11|ls_code==12)
replace tlu=0.7 if (ls_code==13|ls_code==14|ls_code==15)
replace tlu=0.01 if (ls_code==16|ls_code==17|ls_code==18|ls_code==19)
replace tlu=0.5 if (ls_code==20)
replace tlu=0.6 if (ls_code==21)
replace tlu=0.3 if (ls_code==22)
lab var tlu "Tropical Livestock Unit coefficient"
rename ls_code livestock_code
rename tlu tlu_coefficient
rename ls_sec_8_2aq01 number_1yearago
rename ls_sec_8_2aq02 number_born 
rename ls_sec_8_2aq04 number_purchased 
rename ls_sec_8_2aq07 number_gifts_received 
rename ls_sec_8_2aq09 number_gifts_given 
rename ls_sec_8_2aq11 animals_lost12months
rename ls_sec_8_2aq13 number_sold 
rename ls_sec_8_2aq16 number_slaughtered
rename ls_sec_8_2aq14 value_sold
replace number_sold = value_sold if number_sold > value_sold /* columns seem to be switched */
rename ls_sec_8_2aq05 value_purchased 
replace number_purchased = value_purchased if number_purchased > value_purchased
replace number_purchased = 0 if number_purchased >= 1000 & value_purchased ==.
replace number_gifts_received = 0 if number_gifts_received >= 1000 /* Seem to have reported value of gifts, not number of animals */
replace number_born = 0 if number_born >= 1000
recode number_1yearago number_born number_purchased number_gifts_received number_gifts_given animals_lost12months number_sold number_slaughtered (.=0)
replace number_slaughtered = 0 if number_slaughtered > (number_1yearago + number_born + number_purchased + number_gifts_received)
replace number_sold = 0 if number_sold > (number_1yearago + number_born + number_purchased + number_gifts_received)
gen number_today = number_1yearago + number_born + number_purchased + number_gifts_received - number_gifts_given - animals_lost12months - number_sold - number_slaughtered
replace number_today = 0 if number_today < 0 
gen tlu_1yearago = number_1yearago * tlu_coefficient

*Livestock mortality rate
ren livestock_code ls_code
merge m:1 ls_code household_id2 holder_id using "$ETH_W3_raw_data/Livestock/sect8_1_ls_w3.dta", nogen
ren ls_code livestock_code
replace number_today = ls_sec_8_1q01
gen tlu_today = number_today * tlu_coefficient
egen mean_12months = rowmean(number_today number_1yearago)
ren ls_sec_8_1q02 number_today_exotic 
gen share_imp_herd_cows = number_today_exotic/number_today if livestock_code==1
gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8,9,10,11,12)) + 3*(inlist(livestock_code,13,14,15)) + 4*(inlist(livestock_code,20,21,22)) + 5*(inlist(livestock_code,16,17,18,19))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Camels" 4 "Equine (horses, donkies, mules)" 5 "Poultry"
la val species species

preserve
	*Now to household level
	*First, generating these values by species
	collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lvstck_holding=number_today, by(household_id2 species)
	egen mean_12months = rowmean(number_today number_1yearago)
	gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
	foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding{
		gen `i'_lrum = `i' if species==1
		gen `i'_srum = `i' if species==2
		gen `i'_camel = `i' if species==3
		gen `i'_equine = `i' if species==4
		gen `i'_poultry = `i' if species==5
	}
	collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *camel *equine *poultry share_imp_herd_cows, by(household_id2)
	gen any_imp_herd = number_today_exotic!=0 if number_today!=0
	drop number_today_exotic number_today
	foreach i in lvstck_holding animals_lost12months mean_12months {
		gen `i' = .
	}
	la var lvstck_holding "Total number of livestock holdings (# of animals)"
	la var any_imp_herd "At least one improved animal in herd"
	la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
	lab var animals_lost12months  "Total number of livestock  lost to disease"
	lab var  mean_12months  "Average number of livestock  today and 1  year ago"
	foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_camel "`l`i'' - camels"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
	la var any_imp_herd "At least one improved animal in herd - all animals"
	gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
	la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
	*any improved large ruminants, small ruminants, or poultry
	gen any_imp_herd_all = 0 if any_imp_herd_lrum==0 | any_imp_herd_srum==0 | any_imp_herd_poultry==0
	replace any_imp_herd_all = 1 if  any_imp_herd_lrum==1 | any_imp_herd_srum==1 | any_imp_herd_poultry==1
	lab var any_imp_herd_all "1=hh has any improved lrum, srum, or poultry"
	recode lvstck_holding* (.=0)
	*Now dropping these missing variables, which we only used to construct the labels above
	drop lvstck_holding animals_lost12months mean_12months
	save "${ETH_W3_created_data}\Ethiopia_ESS_LSMS_ISA_W3_herd_characteristics", replace
restore

*Bee colonies not captured in TLU.
gen price_per_animal = value_sold / number_sold
recode price_per_animal (0=.)
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)
merge m:1 region zone woreda kebele livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_zone.dta", nogen
merge m:1 region livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_kebele if price_per_animal==. & obs_kebele >= 10
replace price_per_animal = price_median_woreda if price_per_animal==. & obs_woreda >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (household_id2)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_TLU.dta", replace



************
*SELF-EMPLOYMENT INCOME
************

use "$ETH_W3_raw_data/Household/sect11b_hh_w3.dta", clear
rename hh_s11bq09 months_activ  
rename hh_s11bq13 avg_monthly_sales
egen monthly_expenses = rowtotal(hh_s11bq14_a- hh_s11bq14_e)
*2 observations with positive expenses but missing info on business income. These won't be considered at all.		
recode avg_monthly_sales monthly_expenses (.=0)
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)

collapse (sum) annual_selfemp_profit, by (household_id2)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_self_employment_income.dta", replace

*Female non-farm business owners
use "$ETH_W3_raw_data/Household/sect11b_hh_w3.dta", clear
rename hh_s11bq09 months_activ  
rename hh_s11bq13 avg_monthly_sales
egen monthly_expenses = rowtotal(hh_s11bq14_a- hh_s11bq14_e)
*2 observations with positive expenses but missing info on business income. These won't be considered at all.		
recode avg_monthly_sales monthly_expenses (.=0)
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)

local busowners "hh_s11bq03_a hh_s11bq03_b"
foreach v of local busowners {
	preserve
	keep household_id2 `v'
	ren `v' bus_owner
	drop if bus_owner==. | bus_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `hh_s11bq03_a', clear
foreach v of local busowners {
	if "`v'"!="`hh_s11bq03_a'" {
		append using ``v''
	}
}
duplicates drop
gen business_owner=1 if bus_owner!=.
ren bus_owner personid
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_W3_business_owners_ind.dta", replace



***************
*OFF-FARM HOURS
***************

use "${ETH_W3_raw_data}\Household\sect4_hh_w3.dta", clear
rename hh_s4q10_b occupation_code 
rename hh_s4q11_b industry_code 
gen primary_hours = hh_s4q15 if occupation_code!=6 | industry_code!=1 | industry_code!=2
gen secondary_hours = hh_s4q26 if occupation_code!=6 | industry_code!=1 | industry_code!=2
*Instrument doesn't ask about the number of hours worked for own business or PSNP
egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1

collapse (sum) off_farm_hours off_farm_any_count member_count, by(household_id2)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_off_farm_hours.dta", replace



************
*WAGE INCOME
************

use "$ETH_W3_raw_data/Household/sect4_hh_w3.dta", clear
rename hh_s4q10_b occupation_code 
rename hh_s4q11_b industry_code 
rename hh_s4q09 mainwage_yesno
rename hh_s4q13 mainwage_number_months
rename hh_s4q14 mainwage_number_weeks
rename hh_s4q15 mainwage_number_hours
rename hh_s4q16 mainwage_recent_payment
replace mainwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2		
rename hh_s4q17 mainwage_payment_period
rename hh_s4q20 secwage_yesno
rename hh_s4q24 secwage_number_months
rename hh_s4q25 secwage_number_weeks
rename hh_s4q26 secwage_number_hours
rename hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2
rename hh_s4q28 secwage_payment_period
local vars main sec
foreach p of local vars {
gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
recode `p'wage_salary_cash (.=0)
gen `p'wage_annual_salary = `p'wage_salary_cash
}
rename hh_s4q33 income_psnp
recode mainwage_annual_salary secwage_annual_salary income_psnp (.=0)
gen annual_salary = mainwage_annual_salary + secwage_annual_salary + income_psnp		

*Individual agwage earners
preserve
	rename hh_s4q00 personid
	merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", nogen
	gen wage_worker = (annual_salary!=0 & annual_salary!=.)
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_wage_worker.dta", replace
restore

collapse (sum) annual_salary, by (household_id2)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_wage_income.dta", replace
*Occupation = Ag or Industry = Ag or Fisheries.

*Agwage
use "$ETH_W3_raw_data/Household/sect4_hh_w3.dta", clear
rename hh_s4q10_b occupation_code 
rename hh_s4q11_b industry_code 
rename hh_s4q09 mainwage_yesno
rename hh_s4q13 mainwage_number_months
rename hh_s4q14 mainwage_number_weeks
rename hh_s4q15 mainwage_number_hours
rename hh_s4q16 mainwage_recent_payment
replace mainwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
rename hh_s4q17 mainwage_payment_period
rename hh_s4q20 secwage_yesno
rename hh_s4q24 secwage_number_months
rename hh_s4q25 secwage_number_weeks
rename hh_s4q26 secwage_number_hours
rename hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
rename hh_s4q28 secwage_payment_period
local vars main sec
foreach p of local vars {
gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
recode `p'wage_salary_cash (.=0)
gen `p'wage_annual_salary = `p'wage_salary_cash
}
recode mainwage_annual_salary secwage_annual_salary (.=0)
gen annual_salary_agwage = mainwage_annual_salary + secwage_annual_salary

*Individual agwage earners
preserve
	rename hh_s4q00 personid
	merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", nogen
	gen agworker = (annual_salary_agwage!=0 & annual_salary_agwage!=.)
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_agworker.dta", replace
restore

collapse (sum) annual_salary_agwage, by (household_id2)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_agwage_income.dta", replace



************
*OTHER INCOME
************

use "$ETH_W3_raw_data/Household/sect12_hh_w3.dta", clear
rename hh_s12q02 amount_received
gen transfer_income = amount_received if hh_s12q00==101|hh_s12q00==102|hh_s12q00==103 /* cash, food, other in-kind transfers */
gen investment_income = amount_received if hh_s12q00==104
gen pension_income = amount_received if hh_s12q00==105
gen rental_income = amount_received if hh_s12q00==106|hh_s12q00==107|hh_s12q00==108|hh_s12q00==109
gen sales_income = amount_received if hh_s12q00==110|hh_s12q00==111|hh_s12q00==112
gen inheritance_income = amount_received if hh_s12q00==113
recode transfer_income pension_income investment_income sales_income inheritance_income (.=0)
collapse (sum) transfer_income pension_income investment_income rental_income sales_income inheritance_income, by (household_id2)
lab var transfer_income "Estimated income from cash, food, or other in-kind gifts/transfers over previous 12 months"
lab var pension_income "Estimated income from a pension over previous 12 months"
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var sales_income "Estimated income from sales of real estate or other assets over previous 12 months"
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var inheritance_income "Estimated income from cinheritance over previous 12 months"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_other_income.dta", replace

use "$ETH_W3_raw_data/Household/sect13_hh_w3.dta", clear
rename hh_s13q00 assistance_code
rename hh_s13q03 amount_received 
gen psnp_income = amount_received if assistance_code=="A"			
gen assistance_income = amount_received if assistance_code=="B"|assistance_code=="C"|assistance_code=="D"|assistance_code=="E"
recode psnp_income assistance_income (.=0)
collapse (sum) psnp_income assistance_income, by (household_id2)
lab var psnp_income "Estimated income from a PSNP over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_assistance_income.dta", replace

use "$ETH_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
rename pp_s2q13_a land_rental_income_cash
rename pp_s2q13_b land_rental_income_inkind
rename pp_s2q13_c land_rental_income_share
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
collapse (sum) land_rental_income_upfront, by (household_id2)
lab var land_rental_income_upfront "Estimated income from renting out land over previous 12 months (upfront payments only)"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_land_rental_income.dta", replace



************
*FARM SIZE
************

use "$ETH_W3_raw_data/Post-Harvest/sect9_ph_w3.dta", clear
*All parcels here (which are subdivided into fields) were cultivated, whether in the belg or meher season.
gen cultivated=1

*Including area of permanent crops
preserve
	use "$ETH_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
	gen cultivated = 1 if (pp_s4q17!=0 & pp_s4q17!=.) 		// not including any harvest because not separated out for tree crops in ETH
	collapse (max) cultivated, by (household_id2 parcel_id field_id)
	tempfile tree
	save `tree', replace
restore
append using `tree'

collapse (max) cultivated, by (household_id2 parcel_id field_id)
lab var cultivated "1= Field was cultivated in this data set"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_parcels_cultivated.dta", replace

use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
rename pp_s3q02_a area 
rename pp_s3q02_c local_unit 
rename pp_s3q05_a area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region zone local_unit)
rename sqmeters_per_unit sqmeters_per_unit_zone 
rename observations obs_zone
lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_zone.dta", replace
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
rename pp_s3q02_a area 
rename pp_s3q02_c local_unit 
rename pp_s3q05_a area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region local_unit)
rename sqmeters_per_unit sqmeters_per_unit_region
rename observations obs_region
lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_region.dta", replace
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
rename pp_s3q02_a area 
rename pp_s3q02_c local_unit 
rename pp_s3q05_a area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (local_unit)
rename sqmeters_per_unit sqmeters_per_unit_country
rename observations obs_country
lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_country.dta", replace

use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
rename pp_s3q02_a area 
rename pp_s3q02_c local_unit 
rename pp_s3q05_a area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id2 parcel_id holder_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region zone woreda local_unit using "$ETH_W3_raw_data/Land Area Conversion Factor/ET_local_area_unit_conversion.dta"
drop if _merge==2
drop _merge
gen area_est_hectares = area if local_unit==1
replace area_est_hectares = (area/10000) if local_unit==2
replace area_est_hectares = (area*conversion/10000) if (local_unit!=1 & local_unit!=2 & local_unit!=11)
merge m:1 region zone local_unit using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_zone.dta"
drop _merge
replace area_est_hectares = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & area_est_hectares==. & obs_zone>=10
merge m:1 region local_unit using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_region.dta"
drop _merge
replace area_est_hectares = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & area_est_hectares==. & obs_region>=10
merge m:1 local_unit using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_country.dta"
drop _merge
replace area_est_hectares = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & area_est_hectares==.
gen area_meas_hectares = (area_sqmeters_gps/10000)
replace area_meas_hectares = area_est_hectares if area_meas_hectares==.
count if area!=. & area_meas_hectares==.
replace area_meas_hectares = 0 if area_meas_hectares == .
lab var area_meas_hectares "Area measured in hectares, with missing obs imputed using local median per-unit values"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_plot_sizes.dta", replace
merge m:1 household_id2 parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_parcels_cultivated.dta"
keep if cultivated==1
collapse (sum) area_meas_hectares, by (household_id2)
rename area_meas_hectares farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" /* Uses measures */
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_land_size.dta", replace


*All Agricultural Land
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen agland = (pp_s3q03==1 | pp_s3q03==2 | pp_s3q03==3 | pp_s3q03==5) // Cultivated, prepared for Belg season, pasture, or fallow. Excludes forest and "other" (which seems to include rented-out)

*Including area of permanent crops
preserve
	use "$ETH_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
	gen cultivated = 1 if (pp_s4q17!=0 & pp_s4q17!=.)		 //not including any harvest because not separated out for tree crops in ETH
	collapse (max) cultivated, by (household_id2 parcel_id field_id)
	tempfile tree
	save `tree', replace
restore
append using `tree'
replace agland=1 if cultivated==1

keep if agland==1
keep household_id2 parcel_id field_id holder_id agland
lab var agland "1= Plot was used for cultivated, pasture, or fallow"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_parcels_agland.dta", replace

use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_plot_sizes.dta", clear
merge 1:1 household_id2 parcel_id holder_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_parcels_agland.dta"
drop if _merge==1
collapse (sum) area_meas_hectares, by (household_id2)
rename area_meas_hectares farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmsize_all_agland.dta", replace



************
*LAND SIZE
************

use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_plot_sizes.dta", clear
collapse (sum) area_meas_hectares, by (household_id2)
rename area_meas_hectares land_size
lab var land_size "Land size in hectares, including all plots listed by the household (and not rented out)" /* Uses measures */
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_land_size_all.dta", replace



************
*FARM LABOR
************

*Farm labor
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
rename pp_s3q28_a number_men
rename pp_s3q28_b number_days_men
rename pp_s3q28_d number_women
rename pp_s3q28_e number_days_women
rename pp_s3q28_g number_children
rename pp_s3q28_h number_days_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
recode days_men days_women days_children (.=0)
gen days_hired_postplant =  days_men + days_women + days_children
ren days_men days_hired_male_postplant
ren days_women days_hired_female_postplant
rename pp_s3q27_b weeks_1 
rename pp_s3q27_c days_week_1 
rename pp_s3q27_f weeks_2
rename pp_s3q27_g days_week_2
rename pp_s3q27_j weeks_3
rename pp_s3q27_k days_week_3
rename pp_s3q27_n weeks_4
rename pp_s3q27_o days_week_4
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 (.=0)
gen days_famlabor_postplant = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4)
rename pp_s3q29_a number_men_other
rename pp_s3q29_b days_men_other
rename pp_s3q29_c number_women_other
rename pp_s3q29_d days_women_other
rename pp_s3q29_e number_child_other
rename pp_s3q29_f days_child_other
recode number_men_other days_men_other number_women_other days_women_other number_child_other days_child_other (.=0)
gen days_otherlabor_postplant = (number_men_other * days_men_other) + (number_women_other * days_women_other) + (number_child_other * days_child_other)

*Labor productivity at the plot level 
collapse (sum) days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_male_postplant days_hired_female_postplant, by (holder_id household_id2 parcel_id field_id)
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_otherlabor_postplant "Workdays for other labor (crops), as captured in post-planting survey"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_plot_farmlabor_postplanting.dta", replace

collapse (sum) days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_male_postplant days_hired_female_postplant, by (household_id2)
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_otherlabor_postplant "Workdays for other labor (crops), as captured in post-planting survey"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmlabor_postplanting.dta", replace


use "$ETH_W3_raw_data/Post-Harvest/sect10_ph_w3.dta", clear
rename ph_s10q01_a number_men
rename ph_s10q01_b number_days_men
rename ph_s10q01_d number_women
rename ph_s10q01_e number_days_women
rename ph_s10q01_g number_children
rename ph_s10q01_h number_days_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
recode days_men days_women days_children (.=0)
gen days_hired_postharvest =  days_men + days_women + days_children
ren days_men days_hired_male_postharvest
ren days_women days_hired_female_postharvest
rename ph_s10q02_b weeks_1 
rename ph_s10q02_c days_week_1 
rename ph_s10q02_f weeks_2
rename ph_s10q02_g days_week_2
rename ph_s10q02_j weeks_3
rename ph_s10q02_k days_week_3
rename ph_s10q02_n weeks_4
rename ph_s10q02_o days_week_4
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 (.=0)
gen days_famlabor_postharvest = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4)
rename ph_s10q03_a number_men_other
rename ph_s10q03_b days_men_other
rename ph_s10q03_c number_women_other
rename ph_s10q03_d days_women_other
rename ph_s10q03_e number_child_other
rename ph_s10q03_f days_child_other
recode number_men_other days_men_other number_women_other days_women_other number_child_other days_child_other (.=0)
gen days_otherlabor_postharvest = (number_men_other * days_men_other) + (number_women_other * days_women_other) + (number_child_other * days_child_other)
*Labor productivity at the plot level 
collapse (sum) days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest days_hired_male_postharvest days_hired_female_postharvest, by (holder_id household_id2 parcel_id field_id)
lab var days_hired_postharvest "Workdays for hired labor (crops), as captured in post-harvest survey"
lab var days_famlabor_postharvest "Workdays for family labor (crops), as captured in post-harvest survey"
lab var days_otherlabor_postharvest "Workdays for other labor (crops), as captured in post-harvest survey"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_plot_farmlabor_postharvest.dta", replace


*Labor productivity at the plot level = total labor
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_plot_farmlabor_postplanting.dta"
egen labor_hired =rowtotal(days_hired_postharvest days_hired_postplant)
egen labor_family = rowtotal(days_famlabor_postharvest days_famlabor_postplant)
egen labor_other =  rowtotal(days_otherlabor_postharvest days_otherlabor_postplant) 
egen labor_total = rowtotal(days_famlabor_postharvest days_famlabor_postplant days_otherlabor_postharvest days_otherlabor_postplant days_hired_postharvest days_hired_postplant)
*egen labor_hired_male = rowtotal(days_hired_male_postharvest days_hired_male_postplant)
*egen labor_hired_female = rowtotal(days_hired_female_postharvest days_hired_female_postplant)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
*lab var labor_hired_male "Workdays for male hired labor allocated to the farm in the past year"
*lab var labor_hired_female "Workdays for female hired labor allocated to the farm in the past year"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_plot_family_hired_labor.dta", replace

collapse (sum) labor_*, by (household_id2)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
*lab var labor_hired_male "Workdays for male hired labor allocated to the farm in the past year"
*lab var labor_hired_female "Workdays for female hired labor allocated to the farm in the past year"
lab var labor_other "Total labor days (other/gang/communal) allocated to the farm in the past year"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmlabor_all.dta", replace



*****************
* VACCINE USAGE *
*****************

use "$ETH_W3_raw_data/Livestock/sect8_5_ls_w3.dta", clear
gen vac_animal=.
replace vac_animal=1 if ls_sec_8_5q01==1
replace vac_animal=0 if ls_sec_8_5q01==2
replace vac_animal=. if ls_sec_8_5q01==3

*Disagregating vaccine use by animal type
ren ls_sec_8_type_code livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
recode species (0=.)
la def species 1 "Large ruminants" 2 "Small ruminants" 3 "Camels" 4 "Equine" 5 "Poultry"
la val species species

*Creating species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_camels = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (max) vac_animal*, by (household_id2)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_camels "`l`i'' - camels"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}

save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_vaccine.dta", replace


*Vaccine use livestock keeper (holder)
use "$ETH_W3_raw_data/Livestock/sect8_5_ls_w3.dta", clear
ren pp_saq07 farmerid 
gen all_vac_animal=.
replace all_vac_animal=1 if ls_sec_8_5q01==1
replace all_vac_animal=0 if ls_sec_8_5q01==2
replace all_vac_animal=. if ls_sec_8_5q01==3
collapse (max) all_vac_animal , by(household_id2 farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
drop household_id- pp_s1q05 ph_saq07- f_merge

gen female_vac_animal=all_vac_animal if female==1
gen male_vac_animal=all_vac_animal if female==0
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmer_vaccine.dta", replace


 
****************************
* INORGANIC FERTILIZER USE *
****************************

use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen use_inorg_fert=0
replace use_inorg_fert=1 if pp_s3q15==1 | pp_s3q18==1 | pp_s3q20a_1==1 | pp_s3q20a==1
replace use_inorg_fert=0 if pp_s3q14==2 | pp_s3q15==2 & pp_s3q18==2 & pp_s3q20a_1==2 & pp_s3q20a==2
replace use_inorg_fert=. if pp_s3q14==1 & pp_s3q15==. & pp_s3q18==. & pp_s3q20a_1==. & pp_s3q20a==.
collapse (max) use_inorg_fert, by (household_id2)
lab var use_inorg_fert "1= Household uses inorganic fertilizer"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_fert_use.dta", replace

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen all_use_inorg_fert=0
replace all_use_inorg_fert=1 if pp_s3q15==1 | pp_s3q18==1 | pp_s3q20a_1==1 | pp_s3q20a==1
replace all_use_inorg_fert=0 if pp_s3q14==2 | pp_s3q15==2 & pp_s3q18==2 & pp_s3q20a_1==2 & pp_s3q20a==2
replace all_use_inorg_fert=. if pp_s3q14==1 & pp_s3q15==. & pp_s3q18==. & pp_s3q20a_1==. & pp_s3q20a==.
ren pp_saq07 farmerid 
collapse (max) all_use_inorg_fert , by(household_id2 farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
drop household_id- pp_s1q05 ph_saq07- f_merge
gen female_use_inorg_fert=all_use_inorg_fert if female==1
gen male_use_inorg_fert=all_use_inorg_fert if female==0
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
lab var male_use_inorg_fert "1 = Individual male farmers (plot manager) uses inorganic fertilizer"
lab var female_use_inorg_fert "1 = Individual female farmers (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmer_fert_use.dta", replace



*********************
* IMPROVED SEED USE *
*********************

use "$ETH_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen imprv_seed_use=.
replace imprv_seed_use=1 if pp_s4q11==2
replace imprv_seed_use=0 if pp_s4q11==1
replace imprv_seed_use=. if pp_s4q11==.

forvalues k=1(1)16 {
	local c: word `k' of $topcrop_area	
	local cn: word `k' of $topcropname_area
	gen imprv_seed_`cn'=imprv_seed_use if crop_code==`c'
	gen hybrid_seed_`cn'=.		//instrument doesn't ask about hybrid seeds
}
collapse (max) imprv_seed_* hybrid_seed_*, by(household_id2)
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	lab var imprv_seed_`cn' "1= Household uses improved `cnfull' seed"
	lab var hybrid_seed_`cn' "1= Household uses hybrid `cnfull' seed"
}
lab var imprv_seed_use "1= Household uses improved seed"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_improvedseed_use.dta", replace


*Seed adoption by farmers (a farmer is an individual listed as plot manager)
use "$ETH_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen all_imprv_seed_use=.
replace all_imprv_seed_use=1 if pp_s4q11==2
replace all_imprv_seed_use=0 if pp_s4q11==1
replace all_imprv_seed_use=. if pp_s4q11==.
ren pp_saq07 farmerid
collapse (max) all_imprv_seed_use, by(household_id2 farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
drop household_id- pp_s1q05 ph_saq07- f_merge
gen female_imprv_seed_use=all_imprv_seed_use if female==1
gen male_imprv_seed_use=all_imprv_seed_use if female==0
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
lab var male_imprv_seed_use "1 = Individual male farmers (plot manager) uses improved seeds"
lab var female_imprv_seed_use "1 = Individual female farmers (plot manager) uses improved seeds"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmer_improvedseed_use.dta", replace

use "$ETH_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen all_imprv_seed_use=.
replace all_imprv_seed_use=1 if pp_s4q11==2
replace all_imprv_seed_use=0 if pp_s4q11==1
replace all_imprv_seed_use=. if pp_s4q11==.

forvalues k=1(1)16 {
	local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	preserve
		gen all_imprv_seed_`cn'=all_imprv_seed_use if crop_code==`c'
		gen all_hybrid_seed_`cn'=.		//Doesn't ask about hybrid seeds
		ren pp_saq07 farmerid
		gen `cn'_farmer= crop_code==`c' 
		collapse (max) all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer, by(household_id2 farmerid)
		gen personid=farmerid
		drop if personid==.
		merge m:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
		drop household_id- pp_s1q05 ph_saq07- f_merge
		gen female_imprv_seed_`cn'=all_imprv_seed_`cn' if female==1
		gen male_imprv_seed_`cn'=all_imprv_seed_`cn' if female==0
		lab var all_imprv_seed_`cn' "1 = Individual farmer (plot manager) uses improved `cnfull' seeds"
		lab var male_imprv_seed_`cn' "1 = Individual male farmers (plot manager) uses improved `cnfull' seeds"
		lab var female_imprv_seed_`cn' "1 = Individual female farmers (plot manager) uses improved `cnfull' seeds"
		gen farm_manager=1 if farmerid!=.
		recode farm_manager (.=0)
		lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
		save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmer_improvedseed_use_`cn'.dta", replace
	restore
}



***************************
* REACHED BY AG EXTENSION *
***************************

use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
merge m:m household_id using "$ETH_W3_raw_data/Post-Planting/sect5_pp_w3.dta", nogen
merge m:m household_id using "$ETH_W3_raw_data/Post-Planting/sect7_pp_w3.dta", nogen
gen ext_reach_all=0
replace ext_reach_all=1 if pp_s3q11==1 | pp_s7q04==1 | pp_s5q02==4

*Source of extension is not asked
gen advice_gov = .
gen advice_ngo = .
gen advice_coop = .
gen advice_farmer = .
gen advice_radio = .
gen advice_pub = .
gen advice_neigh = .
gen advice_other = . 
gen ext_reach_public = .
gen ext_reach_private = .
gen ext_reach_ict = .


collapse (max) ext_reach*, by (household_id2)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_any_ext.dta", replace



*********************************
* FORMAL FINANCIAL SERVICES USE *
*********************************

use "$ETH_W3_raw_data/Household/sect4b_hh_w3.dta", clear
merge m:m household_id2 using "$ETH_W3_raw_data/Household/sect11b_hh_w3.dta", nogen

gen borrow_bank = hh_s4bq03a==1 | hh_s4bq03b==1 | hh_s4bq09a==1 | hh_s4bq09b==1 | hh_s11bq04e_1==1 | hh_s11bq04e_2==1
gen borrow_micro = hh_s4bq03c==1 | hh_s4bq09c==1
gen borrow_mortgage = .
gen borrow_insurance = hh_s4bq15==1
gen borrow_other_fin = hh_s4bq03e==1 | hh_s4bq09e==1
gen borrow_neigh = hh_s4bq11a==1 | hh_s11bq04e_1==5 | hh_s11bq04e_2==5
gen borrow_merch = .
gen borrow_lender = hh_s11bq04e_1==2 | hh_s11bq04e_2==2
gen borrow_employer = .
gen borrow_relig = .
gen borrow_ngo = .
gen borrow_group = hh_s4bq03d==1 | hh_s4bq09d==1 | hh_s4bq11c==1 | hh_s11bq04e_1==4 | hh_s11bq04e_2==4
gen borrow_other = inlist(hh_s11bq04e_1,3,6) | inlist(hh_s11bq04e_2,3,6)

gen use_bank_acount = hh_s4bq02==1
gen use_MM = hh_s4bq04b==1 | hh_s4bq04c==1		// counting "online banking" and "mobile banking"
* Credit, Saving, Insurance, Bank account, Digital
gen use_fin_serv_bank = use_bank_acount==1
gen use_fin_serv_credit = borrow_mortgage==1 | borrow_bank==1 
gen use_fin_serv_insur = borrow_insurance==1
gen use_fin_serv_digital = use_MM==1
gen use_fin_serv_all = use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_digital==1 | borrow_other_fin==1

recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (household_id2)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
gen use_fin_serv_savings = .			
lab var use_fin_serv_savings "1= Household uses formal financial services - savings" 
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_fin_serv.dta", replace




*********************
* MILK PRODUCTIVITY *
*********************

use "$ETH_W3_raw_data/Livestock/sect8_6_ls_w3.dta", clear
gen cows = ls_code==3
keep if cows
gen milk_animals = ls_sec_8_6aq01			// number of livestock milked (by holder)
gen months_milked = ls_sec_8_6aq02			// average months milked in last year (by holder)
gen liters_day = ls_sec_8_6aq04				// average quantity (liters) per day
gen liters_per_cow = (liters_day*365*(months_milked/12))	// liters per day times 365 (for yearly total) times milk animals to get TOTAL across all animals times months milked over 12 to scale down to actual amount
lab var milk_animals "Number of large ruminants that were milked (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_cow "average quantity (liters) per year (household)"

collapse (sum) milk_animals liters_per_cow, by(household_id2)
keep if milk_animals!=0
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_milk_animals.dta", replace



********************
* EGG PRODUCTIVITY *
********************

use "$ETH_W3_raw_data/Livestock/sect8_6_ls_w3.dta", clear
gen clutching_periods = ls_sec_8_6bq14		// number of clutching periods per hen in last 12 months
gen eggs_clutch = ls_sec_8_6bq15			// number of eggs per clutch
gen hen_total = ls_sec_8_6bq16				// total laying hens
gen eggs_total_year = clutching_periods*eggs_clutch*hen_total		// total eggs in last 12 months (clutches per hen times eggs per clutch times number of hens)

collapse (sum) eggs_total_year hen_total, by(household_id2)
keep if hen_total!=0
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var hen_total "Total number of laying hens"

save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_eggs_animals.dta", replace



*************************************
* CROP PRODUCTION COSTS PER HECTARE *
*************************************


*Land rental rates
use "$ETH_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
drop if pp_s2q01b==2				// parcel no longer owned or rented
rename pp_s2q13_a land_rental_income_cash
rename pp_s2q13_b land_rental_income_inkind
rename pp_s2q13_c land_rental_income_share
rename pp_s2q07_a rental_cost_cash
rename pp_s2q07_b rental_cost_inkind
rename pp_s2q07_c rental_cost_share
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
gen rented_plot = (pp_s2q03==3)

*Need to merge in value harvested here
merge 1:1 household_id2 holder_id parcel_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_parcel.dta", nogen keep(1 3) 
*Now merging in area of PARCEL (the area this dataset is at); "land_size" is area variable
merge 1:1 holder_id parcel_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_parcel_area.dta", nogen keep(1 3)
replace rental_cost_cash = rental_cost_share if rental_cost_share>100 & rental_cost_share!=. /* These two columns seems to be switched for a few parcels */
replace rental_cost_share = 0 if rental_cost_share>100 & rental_cost_share!=.
gen rental_cost_sharecrop = value_crop_production * (rental_cost_share/100)
recode rental_cost_cash rental_cost_inkind rental_cost_sharecrop (.=0)
gen rental_cost_land = rental_cost_cash + rental_cost_inkind + rental_cost_sharecrop
*Saving at parcel level with rental costs
preserve
	keep rental_cost_land holder_id parcel_id 
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_parcel.dta", replace
restore

gen any_rent = rented_plot!=0 & rented_plot!=.
gen plot_rental_rate = rental_cost_land/land_size							// at the parcel level; rent divided by rented acres (birr per ha)
recode plot_rental_rate (0=.)												// we don't want to count zeros as valid observations
gen area_meas_hectares_parcel_rental = land_size if rented_plot==1

*Getting a household-level "average" rental rate
bys household_id2: egen plot_rental_total = total(rental_cost_land)
bys household_id2: egen plot_rental_total_area = total(area_meas_hectares_parcel_rental)
gen hh_rental_rate = plot_rental_total/plot_rental_total_area				// total divided by area for birr per ha for households that paid any
recode hh_rental_rate (0=.)					

*Creating geographic medians
*By EA
bys saq01 saq02 saq03 saq04 saq05: egen ha_rental_count_ea = count(plot_rental_rate)		
bys saq01 saq02 saq03 saq04 saq05: egen ha_rental_price_ea = median(plot_rental_rate)
*By kebele
bys saq01 saq02 saq03 saq04: egen ha_rental_count_keb = count(plot_rental_rate)
bys saq01 saq02 saq03 saq04: egen ha_rental_price_keb = median(plot_rental_rate)
*By woreda
bys saq01 saq02 saq03: egen ha_rental_count_wor = count(plot_rental_rate)
bys saq01 saq02 saq03: egen ha_rental_price_wor = median(plot_rental_rate)
*By zone
bys saq01 saq02: egen ha_rental_count_zone = count(plot_rental_rate)
bys saq01 saq02: egen ha_rental_price_zone = median(plot_rental_rate)
*By region
bys saq01: egen ha_rental_count_reg = count(plot_rental_rate)
bys saq01: egen ha_rental_price_reg = median(plot_rental_rate)
*National
egen ha_rental_price_nat = median(plot_rental_rate)

*Generating rental rate per hectare
gen ha_rental_rate = hh_rental_rate			// using household value when available
replace ha_rental_rate = ha_rental_price_ea if ha_rental_count_ea>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_keb if ha_rental_count_keb>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_wor if ha_rental_count_wor>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_zone if ha_rental_count_zone>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_reg if ha_rental_count_reg>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_nat if ha_rental_rate==.
collapse (sum) land_rental_income_upfront (firstnm) ha_rental_rate, by(household_id2)
lab var land_rental_income_upfront "Estimated income from renting out land over previous 12 months (upfront payments only)"
lab var ha_rental_rate "Household's `average' rental rate per hectare"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_rate.dta", replace

*Land value - rented land
*Starting at field area
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area", clear
*Merging in gender
merge 1:1 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
*Merging in rental costs paid
merge m:1 holder_id parcel_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_parcel.dta", nogen	
*Merging in parcel area ("land_size")
merge m:1 household_id2 holder_id parcel_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_parcel_area.dta", nogen
gen percent_field = area_meas_hectares/land_size			
gen value_rented_land = rental_cost_land			
*Note that rent is at the parcel level, but decision-maker is at the field level (below parcel).
*Allocating rental costs based on percent of parcel taken up by field
gen value_rented_land_male = value_rented_land*percent_field if dm_gender==1			
gen value_rented_land_female = value_rented_land*percent_field if dm_gender==2
gen value_rented_land_mixed = value_rented_land*percent_field if dm_gender==3

*Value of rented land for monocropped top crop plots
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	preserve
		merge 1:1 household_id2 parcel_id field_id holder_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen assert(1 3) keep(3)	
		gen value_rented_land_`cn' = value_rented_land
		gen value_rented_land_`cn'_male = value_rented_land_male
		gen value_rented_land_`cn'_female = value_rented_land_female
		gen value_rented_land_`cn'_mixed = value_rented_land_mixed
		collapse (sum) value_rented_land_`cn'*, by(household_id2)
		lab var value_rented_land_`cn' "Value of rented land (household expenditures) - `cnfull' monocropped plots only"
		lab var value_rented_land_`cn'_male "Value of rented land (household expenditures) for male-managed plots - `cnfull' monocropped plots only"
		lab var value_rented_land_`cn'_female "Value of rented land (household expenditures) for female-managed plots - `cnfull' monocropped plots only"
		lab var value_rented_land_`cn'_mixed "Value of rented land (household expenditures) for mixed-managed plots - `cnfull' monocropped plots only"
		save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_value_`cn'.dta", replace
	restore
}
	
collapse (sum) value_rented_*, by(household_id2)				// total rental costs at the household level
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures) for male-managed plots"
lab var value_rented_land_female "Value of rented land (household expenditures) for female-managed plots"
lab var value_rented_land_mixed "Value of rented land (household expenditures) for mixed-managed plots"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_value.dta", replace

*Value of area planted
use "$ETH_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen pure_stand = pp_s4q02==1
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = pp_s4q03/100
replace percent_field = 1 if pure_stand==1
*Merging in area
merge m:1 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area", nogen keep(1 3)	
*Merging in gender
merge m:1 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
*4 not matched from master
*30,337 matched
*NOTE: we will create ha_planted here but we won't save it in the datafile. We had to construct ha_planted above 
*for use in the crop production do-file, but we needed the crop production data for value. Therefore, we have to
*construct area_planted and value separately
gen area_plan = percent_field*area_meas_hectares
gen area_plan_male = percent_field*area_meas_hectares if dm_gender==1
gen area_plan_female = percent_field*area_meas_hectares if dm_gender==2
gen area_plan_mixed = percent_field*area_meas_hectares if dm_gender==3
gen area_plan_pure = percent_field*area_meas_hectares if any_pure==1
gen area_plan_inter = percent_field*area_meas_hectares if any_mixed==1
gen area_plan_pure_male = percent_field*area_meas_hectares if dm_gender==1 & any_pure==1
gen area_plan_pure_female = percent_field*area_meas_hectares if dm_gender==2 & any_pure==1
gen area_plan_pure_mixed = percent_field*area_meas_hectares if dm_gender==3 & any_pure==1
gen area_plan_inter_male = percent_field*area_meas_hectares if dm_gender==1 & any_mixed==1
gen area_plan_inter_female = percent_field*area_meas_hectares if dm_gender==2 & any_mixed==1
gen area_plan_inter_mixed = percent_field*area_meas_hectares if dm_gender==3 & any_mixed==1

*Merging in sect2 for rental variables
merge m:1 holder_id parcel_id using "$ETH_W3_raw_data/Post-Planting/sect2_pp_w3.dta", gen(sect2_merge) keep(1 3)		// 173 not matched from master
*Merging in rental rate
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_rate.dta", nogen keep(1 3) keepusing(ha_rental_rate)

*Value of all OWNED (that is, not rented) land
gen value_owned_land = ha_rental_rate*area_plan if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)	// cash AND in kind AND share must be zero or missing
gen value_owned_land_male = ha_rental_rate*area_plan_male if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_female = ha_rental_rate*area_plan_female if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_mixed = ha_rental_rate*area_plan_mixed if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
/*
gen value_owned_land_pure = ha_rental_rate*area_plan_pure if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_inter = ha_rental_rate*area_plan_inter if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_pure_male = ha_rental_rate*area_plan_pure_male if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_pure_female=  ha_rental_rate*area_plan_pure_female if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_pure_mixed = ha_rental_rate*area_plan_pure_mixed if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_inter_male = ha_rental_rate*area_plan_inter_male if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_inter_female = ha_rental_rate*area_plan_inter_female if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_inter_mixed = ha_rental_rate*area_plan_inter_mixed if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
*/

drop crop_code
ren pp_s4q01_b crop_code

collapse (sum) value_owned_land*, by(household_id2)
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land that was cultivated (male-managed)"
lab var value_owned_land_female "Value of owned land that was cultivated (female-managed)"
lab var value_owned_land_mixed "Value of owned land that was cultivated (mixed-managed)"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_land.dta", replace

*Post planting expenses - implicit and explicit
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
*Fertilizer expenses (EXPLICIT)
rename pp_s3q16d value_urea
rename pp_s3q19d value_DAP
rename pp_s3q20a_5 value_NPS
rename pp_s3q20c value_other_chemicals
egen value_fert = rowtotal(value_urea value_DAP value_NPS value_other_chemicals)
*Hired Labor
rename pp_s3q28_a number_men
rename pp_s3q28_b number_days_men
rename pp_s3q28_c wage_perday_men
rename pp_s3q28_d number_women
rename pp_s3q28_e number_days_women
rename pp_s3q28_f wage_perday_women
rename pp_s3q28_g number_children
rename pp_s3q28_h number_days_children
rename pp_s3q28_i wage_perday_children

gen wage_male = wage_perday_men/number_men				// wage per day for a single man
gen wage_female = wage_perday_women/number_women		// wage per day for a single woman
gen wage_child = wage_perday_child/number_children					// wage per day for a single child
recode wage_male wage_female wage_child (0=.)		// if they are "hired" but don't get paid, we don't want to consider that a wage observation below

*Getting household-level wage rate by taking a simple mean across crops and activities
preserve
	recode wage_male number_days_men wage_female number_days_women (.=0) // set missing to zero to count observation with no male hired labor or with no female hired labor
	gen all_wage = (wage_male*number_days_men + wage_female*number_days_women)/(number_days_men + number_days_women)	// weighted average at the HOUSEHOLD level
	recode wage_male number_days_men wage_female number_days_women (0=.) 
	* get average wage accross all plots and crops to obtain wage at household level by  activities
	collapse (mean) wage_male wage_female all_wage,by(rural saq01 saq02 saq03 saq04 saq05 household_id2)		
	** group activities
	*gen  labor_group=1  //"pre-planting + planting + other non-harvesting"
	lab var all_wage "Daily agricultural wage (local currency)"
	lab var wage_male "Daily male agricultural wage (local currency)"
	lab var wage_female "Daily female agricultural wage (local currency)"
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_eth_labor_group1", replace
restore

*Geographic medians of wages
foreach i in male female child{			// constructing for male, female, and child separately
	recode wage_`i' (0=.)
	*By EA
	bys saq01 saq02 saq03 saq04 saq05: egen `i'_count_ea = count(wage_`i')		// ea
	bys saq01 saq02 saq03 saq04 saq05: egen `i'_price_ea = median(wage_`i')
	*By kebele
	bys saq01 saq02 saq03 saq04: egen `i'_count_keb = count(wage_`i')			// kebele
	bys saq01 saq02 saq03 saq04: egen `i'_price_keb = median(wage_`i')
	*By woreda
	bys saq01 saq02 saq03: egen `i'_count_wor = count(wage_`i')					// woreda
	bys saq01 saq02 saq03: egen `i'_price_wor = median(wage_`i')
	*By zone
	bys saq01 saq02: egen `i'_count_zone = count(wage_`i')						// zoner
	bys saq01 saq02: egen `i'_price_zone = median(wage_`i')
	*By region
	bys saq01: egen `i'_count_reg = count(wage_`i')								// region
	bys saq01: egen `i'_price_reg = median(wage_`i')
	*National
	egen `i'_price_nat = median(wage_`i')
	
	*Generating wage
	gen `i'_wage_rate = `i'_price_ea if `i'_count_ea>=10			// by counstruction, there are no missing counts
	replace `i'_wage_rate = `i'_price_keb if `i'_count_keb>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_wor if `i'_count_wor>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_zone if `i'_count_zone>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_reg if `i'_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_nat if `i'_wage_rate==.
}

*Value of hired labor (EXPLICIT)
gen value_male_hired = wage_perday_men*number_days_men			// average wage times number of days
gen value_female_hired = wage_perday_women*number_days_women
gen value_child_hired = wage_perday_children*number_days_children

*Days of hired labor
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
egen days_hired_pp =  rowtotal(days_men days_women days_children)

*Value of family labor (IMPLICIT)
preserve
	*To do family labor, we first need to merge in individual gender
	use "$ETH_W3_raw_data/Post-Planting/sect1_pp_w3.dta", clear
	ren pp_s1q00 pid
	drop if pid==.
	isid holder_id pid				// check 
	ren pp_s1q02 age
	gen male = pp_s1q03==1
	keep holder_id pid age male
	tempfile members
	save `members', replace			// will use this temp file to merge in genders (and ages)
restore
*Starting with "member 1"
gen pid = pp_s3q27_a				// PID for member 1
merge m:1 holder_id pid using `members', gen(fam_merge1) keep(1 3)		// many not matched from master 
tab pp_s3q27_a fam_merge1, m											// most are due to household id=0 or missing in MASTER (0 means nobody engaged)
count if fam_merge1==1 & pp_s3q27_c!=. & pp_s3q27_c!=0					// just 30 observations
ren male male1		// renaming in order to merge again
ren pid pid1 
ren age age1
*Now "member 2"
gen pid = pp_s3q27_e				// PID for member 2
merge m:1 holder_id pid using `members', gen(fam_merge2) keep(1 3)		// many not matched from master 
ren male male2		// renaming in order to merge again
ren pid pid12
ren age age2
*Now "member 3"
gen pid = pp_s3q27_i				// PID for member 3
merge m:1 holder_id pid using `members', gen(fam_merge3) keep(1 3)		// many not matched from master 
ren male male3		// renaming in order to merge again
ren pid pid13
ren age age3
*Now "member 4"
gen pid = pp_s3q27_m				// PID for member 4
merge m:1 holder_id pid using `members', gen(fam_merge4) keep(1 3)		// many not matched from master 
ren male male4		// renaming in order to merge again
ren pid pid14
ren age age4

recode male1 male2 male3 male4 (.=1)			// NOTE: Assuming male if missing (there are a couple dozen)
gen male_fam_days1 = pp_s3q27_b*pp_s3q27_c if male1 & age1>=15		// if male and older than 15 or age is missing; NOTE: Assuming missing ages are adults
gen male_fam_days2 = pp_s3q27_f*pp_s3q27_g if male2 & age2>=15
gen male_fam_days3 = pp_s3q27_j*pp_s3q27_k if male3 & age3>=15
gen male_fam_days4 = pp_s3q27_n*pp_s3q27_o if male4 & age4>=15
gen female_fam_days1 = pp_s3q27_b*pp_s3q27_c if !male1 & age1>=15	//  NOTE: Assuming missing ages are adults
gen female_fam_days2 = pp_s3q27_f*pp_s3q27_g if !male2 & age2>=15
gen female_fam_days3 = pp_s3q27_j*pp_s3q27_k if !male3 & age3>=15
gen female_fam_days4 = pp_s3q27_n*pp_s3q27_o if !male4 & age4>=15
gen child_fam_days1 = pp_s3q27_b*pp_s3q27_c if age1<15
gen child_fam_days2 = pp_s3q27_f*pp_s3q27_g if age2<15
gen child_fam_days3 = pp_s3q27_j*pp_s3q27_k if age3<15
gen child_fam_days4 = pp_s3q27_n*pp_s3q27_o if age4<15

egen total_male_fam_days = rowtotal(male_fam_days*)					// total male family days
egen total_female_fam_days = rowtotal(female_fam_days*)
egen total_child_fam_days = rowtotal(child_fam_days*)

*"Free" labor days (IMPLICIT)
recode pp_s3q29* (.=0)
gen total_male_free_days = pp_s3q29_a*pp_s3q29_b
gen total_female_free_days = pp_s3q29_c*pp_s3q29_d
gen total_child_free_days = pp_s3q29_e*pp_s3q29_f

*Here are the total non-hired days (family plus free)
egen total_male_nonhired_days = rowtotal(total_male_fam_days total_male_free_days)		// family days plus "free" labor
egen total_female_nonhired_days = rowtotal(total_female_fam_days total_female_free_days)
egen total_child_nonhired_days = rowtotal(total_child_fam_days total_child_free_days)
egen days_nonhired_pp = rowtotal(total_male_nonhired_days total_female_nonhired_days total_child_nonhired_days)	

*And here are the total costs using geographically constructed wage rates
gen value_male_nonhired = total_male_nonhired_days*male_wage_rate
gen value_female_nonhired = total_female_nonhired_days*female_wage_rate
gen value_child_nonhired = total_child_nonhired_days*child_wage_rate

*Replacing with own wage rate where available
*First, getting wage at the HOUSEHOLD level	
bys household_id2: egen male_wage_tot = total(value_male_hired)			
bys household_id2: egen male_days_tot = total(number_days_men)			
bys household_id2: egen female_wage_tot = total(value_female_hired)		
bys household_id2: egen female_days_tot = total(number_days_women)		
bys household_id2: egen child_wage_tot = total(value_child_hired)		
bys household_id2: egen child_days_tot = total(number_days_children)	
gen wage_male_hh = male_wage_tot/male_days_tot					
gen wage_female_hh = female_wage_tot/female_days_tot			
gen wage_child_hh = child_wage_tot/child_days_tot				
recode wage_*_hh (0=.)											
sum wage_*_hh			// no zeros
*Now, replacing when household-level wage not missing
replace value_male_nonhired = total_male_nonhired_days*wage_male_hh if wage_male_hh!=.
replace value_female_nonhired = total_female_nonhired_days*wage_female_hh if wage_female_hh!=.
replace value_child_nonhired = total_child_nonhired_days*wage_child_hh if wage_child_hh!=.

egen value_hired_prep_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_prep_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)


*Generating gender variables 
*Merging in gender
merge m:1 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
*Fertilizer value
gen value_fert_male = value_fert if dm_gender==1
gen value_fert_female = value_fert if dm_gender==2
gen value_fert_mixed = value_fert if dm_gender==3
*Hired labor
gen value_hired_prep_labor_male = value_hired_prep_labor if dm_gender==1
gen value_hired_prep_labor_female = value_hired_prep_labor if dm_gender==2
gen value_hired_prep_labor_mixed = value_hired_prep_labor if dm_gender==3
gen days_hired_pp_male = days_hired_pp if dm_gender==1
gen days_hired_pp_female = days_hired_pp if dm_gender==2
gen days_hired_pp_mixed = days_hired_pp if dm_gender==3

*Hired labor expenses for top crops
foreach cn in $topcropname_area {
	preserve
		merge 1:1 household_id2 parcel_id field_id holder_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen assert(1 3) keep(3)	
		gen val_hire_prep_`cn' = value_hired_prep_labor
		gen val_hire_prep_`cn'_male = value_hired_prep_labor_male
		gen val_hire_prep_`cn'_female = value_hired_prep_labor_female
		gen val_hire_prep_`cn'_mixed = value_hired_prep_labor_mixed
		collapse (sum) val_hire_prep_`cn'*, by(household_id2)
		save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_pp_inputs_value_`cn'.dta", replace
	restore
}

*Family labor
gen value_fam_prep_labor_male = value_fam_prep_labor if dm_gender==1
gen value_fam_prep_labor_female = value_fam_prep_labor if dm_gender==2
gen value_fam_prep_labor_mixed = value_fam_prep_labor if dm_gender==3
gen days_nonhired_pp_male = days_nonhired_pp if dm_gender==1
gen days_nonhired_pp_female = days_nonhired_pp if dm_gender==2
gen days_nonhired_pp_mixed = days_nonhired_pp if dm_gender==3

*Collapsing to household-level input costs (explicit - value hired prep labor and value fert; implicit - value fam prep labor)
collapse (sum) value_hired* value_fam* value_fert* days_hired_pp* days_nonhired*, by(household_id2)
lab var value_hired_prep_labor "Wages paid for hired labor (crops), as captured in post-planting survey"
sum value_*
lab var value_hired_prep_labor "Value of all pre-harvest hired labor used on the farm"
lab var value_hired_prep_labor_male "Value of all pre-harvest hired labor used on male-managed plots"
lab var value_hired_prep_labor_female "Value of all pre-harvest hired labor used on female-managed plots"
lab var value_hired_prep_labor_mixed "Value of all pre-harvest hired labor used on mixed-managed plots"
lab var value_fam_prep_labor "Value of all pre-harvest non-hired labor used on the farm"
lab var value_fam_prep_labor_male "Value of all pre-harvest non-hired labor used on male-managed plots"
lab var value_fam_prep_labor_female "Value of all pre-harvest non-hired labor used on female-managed plots"
lab var value_fam_prep_labor_mixed "Value of all pre-harvest non-hired labor used on mixed-managed plots"
lab var value_fert "Value of all fertilizer used on the farm"
lab var value_fert_male "Value of all fertilizer used on male-managed plots"
lab var value_fert_female "Value of all fertilizer used on female-managed plots"
lab var value_fert_mixed "Value of all fertilizer used on mixed-managed plots"
lab var days_hired_pp "Days of pre-harvest hired labor used on farm"
lab var days_hired_pp_male "Days of pre-harvest hired labor used on male_managed-plots"
lab var days_hired_pp_female "Days of pre-harvest hired labor used on female_managed-plots"
lab var days_hired_pp_mixed "Days of pre-harvest hired labor used on mixed_managed-plots"
lab var days_nonhired_pp "Days of pre-harvest non-hired labor used on farm"
lab var days_nonhired_pp_male "Days of pre-harvest non-hired labor used on male_managed-plots"
lab var days_nonhired_pp_female "Days of pre-harvest non-hired labor used on female_managed-plots"
lab var days_nonhired_pp_mixed "Days of pre-harvest non-hired labor used on mixed_managed-plots"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_pp_inputs_value.dta", replace


*Harvest labor costs
use "$ETH_W3_raw_data/Post-Harvest/sect10_ph_w3.dta", clear		
*Hired labor (EXPLICIT)
rename ph_s10q01_a number_men
rename ph_s10q01_b number_days_men
rename ph_s10q01_c wage_perday_men
rename ph_s10q01_d number_women
rename ph_s10q01_e number_days_women
rename ph_s10q01_f wage_perday_women
rename ph_s10q01_g number_children
rename ph_s10q01_h number_days_children
rename ph_s10q01_i wage_perday_children

gen wage_male = wage_perday_men/number_men							// wage per day for a single man
gen wage_female = wage_perday_women/number_women					// wage per day for a single woman
gen wage_child = wage_perday_child/number_children					// wage per day for a single child
recode wage_male wage_female wage_child (0=.)						// if they are "hired" but don't get paid, we don't want to consider that a wage observation below

preserve
	recode wage_male number_days_men wage_female number_days_women (.=0) 			// set missing to zero to count observation with no male hired labor or with no female hired labor
	gen all_wage=(wage_male*number_days_men + wage_female*number_days_women)/(number_days_men + number_days_women)
	recode wage_male number_days_men wage_female number_days_women (0=.) 
	* get average wage accross all plots and crops to obtain wage at household level by  activities
	collapse (mean) wage_male wage_female all_wage, by(rural saq01 saq02 saq03 saq04 saq05 household_id2)
	** group activities
	*gen  labor_group=2  //"pre-planting + planting + other non-harvesting"
	lab var all_wage "Daily agricultural wage (local currency)"
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_eth_labor_group2", replace
restore

gen value_male_hired = number_days_men * wage_perday_men
gen value_female_hired = number_days_women * wage_perday_women 
gen value_child_hired = number_days_children * wage_perday_children

gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
egen days_hired_harv =  rowtotal(days_men days_women days_children)

*Geographic medians
foreach i in male female child{
	recode wage_`i' (0=.)
	*By EA
	bys saq01 saq02 saq03 saq04 saq05: egen `i'_count_ea = count(wage_`i')
	bys saq01 saq02 saq03 saq04 saq05: egen `i'_price_ea = median(wage_`i')
	*By kebele
	bys saq01 saq02 saq03 saq04: egen `i'_count_keb = count(wage_`i')
	bys saq01 saq02 saq03 saq04: egen `i'_price_keb = median(wage_`i')
	*By woreda
	bys saq01 saq02 saq03: egen `i'_count_wor = count(wage_`i')
	bys saq01 saq02 saq03: egen `i'_price_wor = median(wage_`i')
	*By zone
	bys saq01 saq02: egen `i'_count_zone = count(wage_`i')
	bys saq01 saq02: egen `i'_price_zone = median(wage_`i')
	*By region
	bys saq01: egen `i'_count_reg = count(wage_`i')
	bys saq01: egen `i'_price_reg = median(wage_`i')
	*National
	egen `i'_price_nat = median(wage_`i')
	
	*Generating wage
	gen `i'_wage_rate = `i'_price_ea if `i'_count_ea>=10
	replace `i'_wage_rate = `i'_price_keb if `i'_count_keb>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_wor if `i'_count_wor>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_zone if `i'_count_zone>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_reg if `i'_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_nat if `i'_wage_rate==.
}

*To do family labor, we first need to merge in individual gender
preserve
	use "$ETH_W3_raw_data/Post-Harvest/sect1_ph_w3.dta", clear
	ren ph_s1q00 pid
	drop if pid==.
	isid holder_id pid				// check 
	ren ph_s1q02 age
	gen male = ph_s1q03==1
	keep holder_id pid age male
	tempfile members
	save `members', replace
restore
*Starting with "member 1"
gen pid = ph_s10q02_a
merge m:1 holder_id pid using `members', gen(fam_merge1) keep(1 3)		// many not matched from master 
tab ph_s10q02_a fam_merge1, m											// most are due to household id=0 or missing in MASTER (0 means nobody engaged)
count if fam_merge==1 & ph_s10q02_c!=0 & ph_s10q02_c!=.					// just 17 observations with positive days that were not merged.
ren male male1
ren pid pid1 
ren age age1
*Now "member 2"
gen pid = ph_s10q02_e
merge m:1 holder_id pid using `members', gen(fam_merge2) keep(1 3)		// many not matched from master 
ren male male2
ren pid pid12
ren age age2
*Now "member 3"
gen pid = ph_s10q02_i
merge m:1 holder_id pid using `members', gen(fam_merge3) keep(1 3)		// many not matched from master 
ren male male3
ren pid pid13
ren age age3
*Now "member 4"
gen pid = ph_s10q02_m
merge m:1 holder_id pid using `members', gen(fam_merge4) keep(1 3)		// many not matched from master 
ren male male4
ren pid pid14
ren age age4

*Family labor (IMPLICIT)
recode male1 male2 male3 male4 (.=1)									// NOTE: Assuming male if missing (there are only a couple in post-harvest)
gen male_fam_days1 = ph_s10q02_b*ph_s10q02_c if male1 & age1>=15		// NOTE: Assuming missing ages are adults
gen male_fam_days2 = ph_s10q02_f*ph_s10q02_g if male2 & age2>=15
gen male_fam_days3 = ph_s10q02_j*ph_s10q02_k if male3 & age3>=15
gen male_fam_days4 = ph_s10q02_n*ph_s10q02_o if male4 & age4>=15
gen female_fam_days1 = ph_s10q02_b*ph_s10q02_c if !male1 & age1>=15
gen female_fam_days2 = ph_s10q02_f*ph_s10q02_g if !male2 & age2>=15
gen female_fam_days3 = ph_s10q02_j*ph_s10q02_k if !male3 & age3>=15
gen female_fam_days4 = ph_s10q02_n*ph_s10q02_o if !male4 & age4>=15
gen child_fam_days1 = ph_s10q02_b*ph_s10q02_c if age1<15
gen child_fam_days2 = ph_s10q02_f*ph_s10q02_g if age2<15
gen child_fam_days3 = ph_s10q02_j*ph_s10q02_k if age3<15
gen child_fam_days4 = ph_s10q02_n*ph_s10q02_o if age4<15

egen total_male_fam_days = rowtotal(male_fam_days*)				
egen total_female_fam_days = rowtotal(female_fam_days*)
egen total_child_fam_days = rowtotal(child_fam_days*)

*Also including "free" labor as priced (IMPLICIT)
recode ph_s10q03* (.=0)
gen total_male_free_days = ph_s10q03_a*ph_s10q03_b
gen total_female_free_days = ph_s10q03_c*ph_s10q03_d
gen total_child_free_days = ph_s10q03_e*ph_s10q03_f

*Here are the total days
egen total_male_nonhired_days = rowtotal(total_male_fam_days total_male_free_days)		// family days plus "free" labor
egen total_female_nonhired_days = rowtotal(total_female_fam_days total_female_free_days)
egen total_child_nonhired_days = rowtotal(total_child_fam_days total_child_free_days)
egen days_nonhired_harv = rowtotal(total_male_nonhired_days total_female_nonhired_days total_child_nonhired_days)	

*And here are the total costs using geographically constructed wage rates
gen value_male_nonhired = total_male_nonhired_days*male_wage_rate
gen value_female_nonhired = total_female_nonhired_days*female_wage_rate
gen value_child_nonhired = total_child_nonhired_days*child_wage_rate

*Replacing with own wage rate where available
*First, creating household average wage
bys household_id2: egen male_wage_tot = total(value_male_hired)	
bys household_id2: egen male_days_tot = total(number_days_men)		
bys household_id2: egen female_wage_tot = total(value_female_hired)		
bys household_id2: egen female_days_tot = total(number_days_women)				
bys household_id2: egen child_wage_tot = total(value_child_hired)		
bys household_id2: egen child_days_tot = total(number_days_children)				
gen wage_male_hh = male_wage_tot/male_days_tot					
gen wage_female_hh = female_wage_tot/female_days_tot			
gen wage_child_hh = child_wage_tot/child_days_tot				
recode wage_*_hh (0=.)											
sum wage_*_hh			// no zeros
*Now, replacing when not missing
replace value_male_nonhired = total_male_nonhired_days*wage_male_hh if wage_male_hh!=.
replace value_female_nonhired = total_female_nonhired_days*wage_female_hh if wage_female_hh!=.
replace value_child_nonhired = total_child_nonhired_days*wage_child_hh if wage_child_hh!=.

egen value_hired_harv_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_harv_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)		// note that "fam" labor includes free labor


*Generating gender variables 
*Merging in gender
merge m:1 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
gen value_hired_harv_labor_male = value_hired_harv_labor if dm_gender==1
gen value_hired_harv_labor_female = value_hired_harv_labor if dm_gender==2
gen value_hired_harv_labor_mixed = value_hired_harv_labor if dm_gender==3
gen days_hired_harv_male = days_hired_harv if dm_gender==1
gen days_hired_harv_female = days_hired_harv if dm_gender==2
gen days_hired_harv_mixed = days_hired_harv if dm_gender==3
gen value_fam_harv_labor_male = value_fam_harv_labor if dm_gender==1
gen value_fam_harv_labor_female = value_fam_harv_labor if dm_gender==2
gen value_fam_harv_labor_mixed = value_fam_harv_labor if dm_gender==3
gen days_nonhired_harv_male = days_nonhired_harv if dm_gender==1
gen days_nonhired_harv_female = days_nonhired_harv if dm_gender==2
gen days_nonhired_harv_mixed = days_nonhired_harv if dm_gender==3

*Harvest labor costs for top crops
foreach cn in $topcropname_area {
	preserve
		collapse (sum) value_hired_harv_labor*, by(household_id2 parcel_id field_id holder_id)
		merge 1:1 household_id2 parcel_id field_id holder_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen assert(1 3) keep(3)	
		gen val_hire_harv_`cn' = value_hired_harv_labor
		gen val_hire_harv_`cn'_male = value_hired_harv_labor_male
		gen val_hire_harv_`cn'_female = value_hired_harv_labor_female
		gen val_hire_harv_`cn'_mixed = value_hired_harv_labor_mixed
		collapse (sum) val_hire_harv_`cn'*, by(household_id2)
		save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_harv_labor_`cn'.dta", replace
	restore
}
	
collapse (sum) value_hired* days_hired* value_fam* days_nonhired*, by(household_id2)
sum value_*
lab var value_hired_harv_labor "Value of all harvest hired labor used on the farm"
lab var value_hired_harv_labor_male "Value of all harvest hired labor used on male-managed plots"
lab var value_hired_harv_labor_female "Value of all harvest hired labor used on female-managed plots"
lab var value_hired_harv_labor_mixed "Value of all harvest hired labor used on mixed-managed plots"
lab var value_fam_harv_labor "Value of all harvest non-hired labor used on the farm"
lab var value_fam_harv_labor_male "Value of all harvest non-hired labor used on male-managed plots"
lab var value_fam_harv_labor_female "Value of all harvest non-hired labor used on female-managed plots"
lab var value_fam_harv_labor_mixed "Value of all harvest non-hired labor used on mixed-managed plots"
lab var days_hired_harv "Days of harvest hired labor used on farm"
lab var days_hired_harv_male "Days of harvest hired labor used on male_managed-plots"
lab var days_hired_harv_female "Days of harvest hired labor used on female_managed-plots"
lab var days_hired_harv_mixed "Days of harvest hired labor used on mixed_managed-plots"
lab var days_nonhired_harv "Days of harvest non-hired labor used on farm"
lab var days_nonhired_harv_male "Days of harvest non-hired labor used on male_managed-plots"
lab var days_nonhired_harv_female "Days of harvest non-hired labor used on female_managed-plots"
lab var days_nonhired_harv_mixed "Days of harvest non-hired labor used on mixed_managed-plots"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_harv_labor.dta", replace



**************
*AGRICULTURAL WAGES
**************
use "${ETH_W3_raw_data}/Post-Planting/sect3_pp_w3.dta", clear
append using "${ETH_W3_raw_data}/Post-Harvest/sect10_ph_w3.dta"

*Hired Labor post-planting
rename pp_s3q28_a number_men_pp
rename pp_s3q28_b number_days_men_pp
rename pp_s3q28_c wage_perday_men_pp
rename pp_s3q28_d number_women_pp
rename pp_s3q28_e number_days_women_pp
rename pp_s3q28_f wage_perday_women_pp
rename pp_s3q28_g number_child_pp
rename pp_s3q28_h number_days_child_pp
rename pp_s3q28_i wage_perday_child_pp

*Hired labor post-harvest
rename ph_s10q01_a number_men_ph
rename ph_s10q01_b number_days_men_ph
rename ph_s10q01_c wage_perday_men_ph
rename ph_s10q01_d number_women_ph
rename ph_s10q01_e number_days_women_ph
rename ph_s10q01_f wage_perday_women_ph
rename ph_s10q01_g number_child_ph
rename ph_s10q01_h number_days_child_ph
rename ph_s10q01_i wage_perday_child_ph

collapse (sum) wage* number*, by(household_id2)

gen wage_male_pp = wage_perday_men_pp/number_men_pp						// wage per day for a single man
gen wage_female_pp = wage_perday_women_pp/number_women_pp				// wage per day for a single woman
gen wage_child_pp = wage_perday_child_pp/number_child_pp				// wage per day for a single child
recode wage_male_pp wage_female_pp wage_child_pp number* (.=0)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below

gen wage_male_ph = wage_perday_men_ph/number_men_ph						// wage per day for a single man
gen wage_female_ph = wage_perday_women_ph/number_women_ph				// wage per day for a single woman
gen wage_child_ph = wage_perday_child_ph/number_child_ph				// wage per day for a single child
recode wage_male_ph wage_female_ph wage_child_ph number* (.=0)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below

*getting weighted average across group of activities to get wage paid at HH level
gen wage_paid_aglabor = (wage_male_pp*number_men_pp+wage_female_pp*number_women_pp+wage_child_pp*number_child_pp+wage_male_ph*number_men_ph+wage_female_ph*number_women_ph+wage_child_ph*number_child_ph)/(number_men_pp+number_women_pp+number_child_pp+number_men_ph+number_women_ph+number_child_ph)
gen wage_paid_aglabor_male = (wage_male_pp*number_men_pp+wage_male_ph*number_men_ph)/(number_men_pp+number_men_ph)
gen wage_paid_aglabor_female = (wage_female_pp*number_women_pp+wage_female_ph*number_women_ph)/(number_women_pp+number_women_ph)
*gen wage_paid_aglabor_child = (wage_child_pp*number_child_pp+wage_child_ph*number_child_ph)/(number_child_pp+number_child_ph)
keep household_id wage_paid_aglabor*
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for female hired labor (local currency)"
*lab var wage_paid_aglabor_child "Daily agricultural wage paid for child hired labor (local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for male hired labor (local currency)"
save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_ag_wage.dta", replace 

*Cost of seeds
*Purchased, free, and left-over seeds are all seeds used (see question 19 in section 5)
use "$ETH_W3_raw_data/Post-Planting/sect5_pp_w3.dta", clear
recode pp_s5q05_a pp_s5q05_b pp_s5q14_a pp_s5q14_b pp_s5q18_a pp_s5q18_b (.=0)
gen kg_seed_purchased = pp_s5q05_a + pp_s5q05_b/1000		// kg + g/1000
gen seed_value = pp_s5q08
rename pp_s5q07 value_transport_purchased_seed
rename pp_s5q16 value_transport_free_seed

gen kg_seed_free = pp_s5q14_a + pp_s5q14_b/1000
gen kg_seed_own = pp_s5q18_a + pp_s5q18_b/1000
*Seed not purchased
egen kg_seed_not_purchased = rowtotal(kg_seed_free kg_seed_own)

*Constructing prices
gen seed_price_hh = seed_value/kg_seed_purchased			// value per kg
recode seed_price_hh (0=.)									// don't want to count zero as a "valid" price observation

*Geographic medians
bys crop_code saq01 saq02 saq03 saq04 saq05: egen seed_count_ea = count(seed_price_hh)		
bys crop_code saq01 saq02 saq03 saq04 saq05: egen seed_price_ea = median(seed_price_hh)
bys crop_code saq01 saq02 saq03 saq04: egen seed_count_keb = count(seed_price_hh)
bys crop_code saq01 saq02 saq03 saq04: egen seed_price_keb = median(seed_price_hh)
bys crop_code saq01 saq02 saq03: egen seed_count_wor = count(seed_price_hh)
bys crop_code saq01 saq02 saq03: egen seed_price_wor = median(seed_price_hh)
bys crop_code saq01 saq02: egen seed_count_zone = count(seed_price_hh)
bys crop_code saq01 saq02: egen seed_price_zone = median(seed_price_hh)
bys crop_code saq01: egen seed_count_reg = count(seed_price_hh)
bys crop_code saq01: egen seed_price_reg = median(seed_price_hh)
bys crop_code: egen seed_price_nat = median(seed_price_hh)

*A lot will be at higher levels of aggregation (region and national) due to lack of observations for many crops
gen seed_price = seed_price_ea if seed_count_ea>=10							
replace seed_price = seed_price_keb if seed_count_keb>=10 & seed_price==.	
replace seed_price = seed_price_wor if seed_count_wor>=10 & seed_price==.	
replace seed_price = seed_price_zone if seed_count_zone>=10 & seed_price==.	
replace seed_price = seed_price_reg if seed_count_reg>=10 & seed_price==.
replace seed_price = seed_price_nat if seed_price==.						

gen value_purchased_seed = seed_value
gen value_non_purchased_seed = seed_price*kg_seed_not_purchased
*Now, replacing with household price when available
*First, constructing "price" at the household level
bys household_id2 crop_code: egen seed_value_hh = total(seed_value)						// summing total value of seed to household
bys household_id2 crop_code: egen kg_seed_purchased_hh = total(kg_seed_purchased)		// summing total value of seed purchased to household
gen seed_price_hh_non = seed_value_hh/kg_seed_purchased_hh
*Now, replacing when household price is not missing
replace value_non_purchased_seed = (seed_price_hh_non)*kg_seed_not_purchased if seed_price_hh_non!=. & seed_price_hh_non!=0

*NOTE: We cannot appropriately value seeds by gender because seed module is at the holder-crop level, not field level.

collapse (sum) value_purchased_seed value_non_purchased_seed value_transport*, by(household_id2)		
lab var value_purchased_seed "Value of purchased seed"
lab var value_transport_purchased_seed "Cost of transport for purchased seed"
lab var value_transport_free_seed "Cost of transport for free seed"
lab var value_purchased_seed "Value of seed purchased (household)"
lab var value_non_purchased_seed "Value of seed not purchased (household)"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_seed.dta", replace




****************
* FERTILIZER APPLICATION (KG)
****************
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
*Merging in gender
merge m:1 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen

*For fertilizer 
egen fert_inorg_kg = rowtotal(pp_s3q16 pp_s3q19 pp_s3q20a_2 pp_s3q20a_7)	
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3

gen use_inorg_fert = 0
replace use_inorg_fert = 1 if pp_s3q15==1 | pp_s3q18==1 | pp_s3q20a_1==1 | pp_s3q20a==1
replace use_inorg_fert = 0 if (pp_s3q14==2 | pp_s3q15==2) & pp_s3q18==2 & pp_s3q20a_1==2 & pp_s3q20a==2
replace use_inorg_fert = . if pp_s3q14==1 & pp_s3q15==. & pp_s3q18==. & pp_s3q20a_1==. & pp_s3q20a==.

recode fert_inorg_kg* (.=0)
collapse (sum) fert_inorg_kg* (max) use_inorg_fert, by(household_id2)
lab var fert_inorg_kg "Inorganic fertilizer (kgs) for all plots"
lab var fert_inorg_kg_male "Inorganic fertilizer (kgs) for male-managed plots"
lab var fert_inorg_kg_female "Inorganic fertilizer (kgs) for female-managed plots"
lab var fert_inorg_kg_mixed "Inorganic fertilizer (kgs) for mixed-managed plots"
lab var use_inorg_fert "Household uses any inorganic fertilizer"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_fertilizer_application.dta", replace


************
*WOMEN'S DIET QUALITY
************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


*************
* DIETARY DIVERSITY
*************
use "$ETH_W3_raw_data/Household/sect5a_hh_w3.dta" , clear
* We recode food items to map HDD food categories
ta item_cd_cf
#delimit ;
recode item_cd_cf 	(1 2 3 4 5 6 60 195 196 197 901 				=1	"CEREALS")  
					(16 17 170 171 172 173 174    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES")
					(14 144 145 915 909	910 912 913 143 908			=3	"VEGETABLES")
					(907 15 151 152 906					 			=4	"FRUITS")
					(180 181 182									=5	"MEAT")
					(21												=6	"EGGS")
					(183 											=7  "FISH")
					(7/13  110 111 131 902 903 904 905	  			=8	"LEGUMES, NUTS AND SEEDS")
					(19 20											=9	"MILK AND MILK PRODUCTS")
					(201 202    									=10	"OILS AND FATS")
					(22	204							  				=11	"SWEETS")
					(23/26 141 142	911	198 203 205 206 905 914		=12	"SPICES, CONDIMENTS, BEVERAGES")
					, generate(Diet_ID)
					;
#delimit cr
* generate a dummy variable indicating whether the respondent or other member of the household has consumed a food item during the past 7 days 			
gen adiet_yes=(hh_s5aq01==1)
ta adiet_yes   
** Now, we collapse to food group level assuming that if a person consumes at least one food item in a food group, then they have consumed that food group. That is equivalent to taking the MAX of adiet_yes
collapse (max) adiet_yes, by(household_id2 Diet_ID) 
count // nb of obs = 54,494 remaining
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(household_id2)
count  // 4,954 obs remaining
/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS and WDDS. Because of
this it is recommended to use the mean score or distribution of scores for analytical
purposes and to set programme targets or goals.
*/
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
compress
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_household_diet.dta", replace




************
*WOMEN'S OWNERSHIP OF ASSETS
************

* FEMALE LAND OWNERSHIP
use "$ETH_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
*Female asset ownership
local landowners "pp_s2q03c_a pp_s2q03c_b pp_s2q06_a pp_s2q06_b pp_s2q08a_a pp_s2q08a_b"
keep household_id2  `landowners' 	// keep relevant variable
*transform data into long form
foreach v of local landowners   {
	preserve
	keep household_id2  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `pp_s2q03c_a', clear
foreach v of local landowners   {
	if "`v'"!="`pp_s2q03c_a'" {
		append using ``v''
	}
}
** remove duplicates by collapse (if a hh member appears at least one time, she/he own/control land)
duplicates drop 
gen type_asset="land"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_land_owner.dta", replace


*FEMALE LIVESTOCK OWNERSHIP
use "$ETH_W3_raw_data/Livestock/sect8_1_ls_w3.dta", clear
*Remove poultry-livestocks
drop if inlist(ls_sec_8_type_code,4,5,6,.)
local livestockowners "ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id2 `livestockowners' 	// keep relevant variables
*Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep household_id2  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `ls_sec_8_1q03_a', clear
foreach v of local landowners   {
	if "`v'"!="`ls_sec_8_1q03_a'" {
		append using ``v''
	}
}
*remove duplicates  (if a hh member appears at least one time, she/he owns livestock)
duplicates drop 
gen type_asset="livestock"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_livestock_owner.dta", replace


* FEMALE OTHER ASSETS
use "$ETH_W3_raw_data/Household/sect10_hh_w3.dta", clear
*keep only productive assets
drop if inlist(hh_s10q00, 4,5,6,9, 11, 13, 16, 26, 27)
local otherassetowners "hh_s10q02_a hh_s10q02_b"
keep household_id2  `otherassetowners'
*Transform the data into long form  
foreach v of local otherassetowners   {
	preserve
	keep household_id2  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `hh_s10q02_a', clear
foreach v of local landowners   {
	if "`v'"!="`hh_s10q02_a'" {
		append using ``v''
	}
}
*remove duplicates  (if a hh member appears at least one time, she/he owns a non-agricultural asset)
duplicates drop 
gen type_asset="otherasset"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_otherasset_owner.dta", replace

* Construct asset ownership variable
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_land_owner.dta", clear
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_livestock_owner.dta"
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_otherasset_owner.dta"
gen own_asset=1 

collapse (max) own_asset, by(household_id2 asset_owner)
gen hh_s1q00=asset_owner

*Own any asset
*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00  using   "$ETH_W3_raw_data/Household/sect1_hh_w3.dta"
gen personid = hh_s1q00
drop _m hh_s1q00 individual_id ea_id ea_id2 saq03- hh_s1q02 hh_s1q04b- obs
ren hh_s1q03 mem_gender 
ren hh_s1q04a age 
gen female = mem_gender==2
ren saq01 region
ren saq02 zone
recode own_asset (.=0)
gen women_asset= own_asset==1 & mem_gender==2
lab  var women_asset "Women ownership of asset"
drop if mem_gender==1
drop if age<18 & mem_gender==2
compress
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_asset.dta", replace



************
*WOMEN'S AG DECISION-MAKING
************
*SALES DECISION-MAKERS - INPUT DECISIONS
use "$ETH_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
*Women's decision-making in ag
local planting_input "pp_saq07 pp_s3q10a pp_s3q10c_a pp_s3q10c_b"
keep household_id2 `planting_input' 	// keep relevant variables
* Transform the data into long form  
foreach v of local planting_input   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `pp_saq07', clear
foreach v of local planting_input   {
	if "`v'"!="`pp_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make ag decisions)
duplicates drop 
gen type_decision="planting_input"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_planting_input.dta", replace

*SALES DECISION-MAKERS - ANNUAL SALES
use "$ETH_W3_raw_data/Post-Harvest/sect11_ph_w3.dta", clear
local control_annualsales "ph_s11q05_a ph_s11q05_b"
keep household_id2 `control_annualsales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_annualsales   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_s11q05_a', clear
foreach v of local control_annualsales   {
	if "`v'"!="`ph_s11q05_a'" {
		append using ``v''
	}
}
** Remove duplicates (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="control_annualsales"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_annualsales.dta", replace


*SALES DECISION-MAKERS - ANNUAL CROP
use "$ETH_W3_raw_data/Post-Harvest/sect11_ph_w3.dta", clear
local sales_annualcrop "ph_saq07 ph_s11q01b_1 ph_s11q01b_2 ph_s11q01c_1 ph_s11q01c_2 ph_s11q05_a ph_s11q05_b"
keep household_id2 `sales_annualcrop' 	// keep relevant variables
* Transform the data into long form  
foreach v of local sales_annualcrop   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_saq07', clear
foreach v of local sales_annualcrop   {
	if "`v'"!="`ph_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="sales_annualcrop"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_sales_annualcrop.dta", replace


*SALES DECISION-MAKERS - PERM SALES
use "$ETH_W3_raw_data/Post-Harvest/sect12_ph_w3.dta", clear
local control_permsales "ph_s12q08a_1 ph_s12q08a_2"
keep household_id2 `control_permsales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_permsales   {	
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_s12q08a_1', clear
foreach v of local control_permsales   {
	if "`v'"!="`ph_s12q08a_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="control_permsales"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_permsales.dta", replace


*SALES DECISION-MAKERS - PERM CROP
use "$ETH_W3_raw_data/Post-Harvest/sect12_ph_w3.dta", clear
local sales_permcrop "ph_saq07 ph_s12q08a_1 ph_s12q08a_2"
keep household_id2 `sales_permcrop' 	// keep relevant variables
* Transform the data into long form  
foreach v of local sales_permcrop   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_saq07', clear
foreach v of local sales_permcrop   {
	if "`v'"!="`ph_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="sales_permcrop"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_sales_permcrop.dta", replace


*SALES DECISION-MAKERS - HARVEST
use "$ETH_W3_raw_data/Post-Harvest/sect9_ph_w3.dta", clear
local harvest "ph_saq07 ph_s9q07a_1 ph_s9q07a_2"
keep household_id2 `harvest' 	// keep relevant variables
* Transform the data into long form  
foreach v of local harvest   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}	
use `ph_saq07', clear
foreach v of local harvest   {
	if "`v'"!="`ph_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="harvest"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_harvest.dta", replace



************
*WOMEN'S CONTROL OVER INCOME
************
*SALES DECISION-MAKERS - ANNUAL HARVEST
use "$ETH_W3_raw_data/Post-Harvest/sect9_ph_w3.dta", clear
local control_annualharvest "ph_s9q07a_1 ph_s9q07a_2"
keep household_id2 `control_annualharvest' // keep relevant variables
* Transform the data into long form  
foreach v of local control_annualharvest   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_s9q07a_1', clear
foreach v of local control_annualharvest   {
	if "`v'"!="`ph_s9q07a_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he controls harvest)
duplicates drop 
gen type_decision="control_annualharvest"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_annualharvest.dta", replace

* FEMALE LIVESTOCK DECISION-MAKING - MANAGEMENT
use "$ETH_W3_raw_data/Livestock/sect8_1_ls_w3.dta", clear
local livestockowners "pp_saq07  ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id2 `livestockowners' 	// keep relevant variables
* Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `pp_saq07', clear
foreach v of local livestockowners   {
	if "`v'"!="`pp_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he manages livestock)
duplicates drop 
gen type_decision="manage_livestock"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_manage_livestock.dta", replace


* Constructing decision-making ag variable *
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_planting_input.dta", clear
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_harvest.dta"
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_sales_annualcrop.dta"
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_sales_permcrop.dta"
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_manage_livestock.dta"

bysort household_id2 decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1

*Create group
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest" ///
							| type_decision=="sales_annualcrop" ///
							| type_decision=="sales_permcrop" 
recode 	make_decision_crop (.=0)

gen make_decision_livestock=1 if  type_decision=="manage_livestock"
recode 	make_decision_livestock (.=0)

gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)

collapse (max) make_decision_* , by(household_id2 decision_maker )  //any decision
ren decision_maker hh_s1q00 

*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00   using   "$ETH_W3_raw_data/Household/sect1_hh_w3.dta"
* 107 member ID in decision files not in member list
drop household_id- hh_s1q02 hh_s1q04b- _merge
recode make_decision_* (.=0)
*Generate women participation in Ag decision
ren hh_s1q03 mem_gender 
ren hh_s1q04a age 
gen female = mem_gender==2
drop if mem_gender==1
drop if age<18 & mem_gender==2

*Generate women control over income
local allactivity crop  livestock  ag
foreach v of local allactivity {
	gen women_decision_`v'= make_decision_`v'==1 & mem_gender==2
	lab var women_decision_`v' "Women make decision abour `v' activities"
	lab var make_decision_`v' "HH member involed in `v' activities"
} 
collapse (max) make_decision* women_decision*, by(household_id2 hh_s1q00)
gen personid = hh_s1q00
compress
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_ag_decision.dta", replace


* FEMALE LIVESTOCK DECISION-MAKING - SALES
use "$ETH_W3_raw_data/Livestock/sect8_1_ls_w3.dta", clear
local control_livestocksales "ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id2 `control_livestocksales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_livestocksales   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ls_sec_8_1q03_a', clear
foreach v of local control_livestocksales   {
	if "`v'"!="`ls_sec_8_1q03_a'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he controls livestock sales)
duplicates drop 
gen type_decision="control_livestocksales"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_livestocksales.dta", replace


* FEMALE DECISION-MAKING - CONTROL OF BUSINESS INCOME
use "$ETH_W3_raw_data/Household/sect11b_hh_w3.dta", clear
local control_businessincome "hh_s11bq03_a hh_s11bq03_b hh_s11bq03d_1 hh_s11bq03d_2"
keep household_id2 `control_businessincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_businessincome   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `hh_s11bq03_a', clear
foreach v of local control_businessincome   {
	if "`v'"!="`hh_s11bq03_a'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, controls business income)
duplicates drop 
gen type_decision="control_businessincome"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_businessincome.dta", replace


* FEMALE DECISION-MAKING - CONTROL OF OTHER INCOME
use "$ETH_W3_raw_data/Household/sect12_hh_w3.dta", clear
local control_otherincome "hh_s12q03_a hh_s12q03_b"
keep household_id2 `control_otherincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_otherincome   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `hh_s12q03_a', clear
foreach v of local control_otherincome   {
	if "`v'"!="`hh_s12q03_a'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, controls other income)
duplicates drop 
gen type_decision="control_otherincome"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_otherincome.dta", replace


*Constructing decision-making final variable 
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_annualharvest.dta", clear
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_annualsales.dta"
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_permsales.dta"
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_livestocksales.dta"
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_businessincome.dta"
append using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_otherincome.dta"

*Create group
gen control_cropincome=1 if  type_decision=="control_annualharvest" ///
							| type_decision=="control_annualsales" ///
							| type_decision=="control_permsales" 
recode 	control_cropincome (.=0)		
							
gen control_livestockincome=1 if  type_decision=="control_livestocksales"  
recode 	control_livestockincome (.=0)

gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)		
							
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)
																										
gen control_nonfarmincome=1 if  type_decision=="control_otherincome" ///
							  | control_businessincome== 1
recode 	control_nonfarmincome (.=0)															

gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
						
collapse (max) control_* , by(household_id2 controller_income )  //any decision

preserve
	*	We also need a variable that indicates if a source of income is applicable to a household
	*	and use it to condition the statistics on household with the type of income
	collapse (max) control_*, by(household_id2) 
	foreach v of varlist control_cropincome- control_all_income {
		local t`v'=subinstr("`v'",  "control", "hh_has", 1)
		ren `v'   `t`v''
	} 
	tempfile hh_has_income
	save `hh_has_income'
restore
merge m:1 household_id2 using `hh_has_income'
drop _m

ren controller_income hh_s1q00

*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00   using   "$ETH_W3_raw_data/Household/sect1_hh_w3.dta"
* 107 member ID in decision files not in member list
drop household_id- hh_s1q02 hh_s1q04b- _merge

ren hh_s1q03 mem_gender 
ren hh_s1q04a age 
gen female = mem_gender==2

recode control_* (.=0)
gen women_control_all_income= control_all_income==1 
gen personid = hh_s1q00
compress
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_control_income.dta", replace



************
*WAGE INCOME
************
use "$ETH_W3_raw_data/Household/sect4_hh_w3.dta", clear
rename hh_s4q10_b occupation_code 
rename hh_s4q11_b industry_code 
rename hh_s4q09 mainwage_yesno
rename hh_s4q13 mainwage_number_months
rename hh_s4q14 mainwage_number_weeks
rename hh_s4q15 mainwage_number_hours
gen mainwage_recent_payment = hh_s4q16
replace mainwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2

rename hh_s4q17 mainwage_payment_period
rename hh_s4q20 secwage_yesno
rename hh_s4q24 secwage_number_months
rename hh_s4q25 secwage_number_weeks
rename hh_s4q26 secwage_number_hours
gen secwage_recent_payment = hh_s4q27
replace secwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2
rename hh_s4q28 secwage_payment_period

local vars main sec
foreach p of local vars {
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	recode `p'wage_salary_cash (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash
}
rename hh_s4q33 income_psnp
recode mainwage_annual_salary secwage_annual_salary income_psnp (.=0)
gen annual_salary = mainwage_annual_salary + secwage_annual_salary + income_psnp

*Now ag wage
replace mainwage_recent_payment = hh_s4q16
replace mainwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
replace secwage_recent_payment = hh_s4q27
replace secwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2

local vars main sec
foreach p of local vars {
	gen `p'wage_salary_cash_ag = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash_ag = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash_ag = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	recode `p'wage_salary_cash_ag (.=0)
	gen `p'wage_annual_salary_ag = `p'wage_salary_cash_ag
}
recode mainwage_annual_salary_ag secwage_annual_salary_ag (.=0)
gen annual_salary_agwage = mainwage_annual_salary_ag + secwage_annual_salary_ag

collapse (sum) annual_salary annual_salary_agwage, by (household_id2)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_wage_income.dta", replace



**************
*CROP YIELDS
**************

*Starting with crops
use "$ETH_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
*Percent of area
gen pure_stand = pp_s4q02==1
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = pp_s4q03/100
replace percent_field = 1 if pure_stand==1

*Merging in area from et3_field
merge m:1 household_id2 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area.dta", nogen keep(1 3)	// dropping those only in using
*4 not matched from master
*30,337 matched

gen dm_male= dm_gender==1
gen dm_female= dm_gender==2
gen dm_mixed= dm_gender==3

//adding for method 4 intercropping
gen intercropped_yn = 1 if ~missing(pp_s4q02) 
replace intercropped_yn = 0 if pp_s4q02 == 1 
gen mono_field = percent_field if intercropped_yn==0 //not intercropped 
gen int_field = percent_field if intercropped_yn==1 //not intercropped 

*bys household_id household_id2 parcel_id field_id: egen total_percent_int_sum = total(int_field) 
bys household_id2 holder_id parcel_id field_id: egen total_percent_int_sum = total(int_field)	

*bys household_id household_id2 parcel_id field_id: egen total_percent_mono = total(mono_field) 
bys household_id2 holder_id parcel_id field_id: egen total_percent_mono = total(mono_field)		

replace total_percent_mono = 1 if total_percent_mono>1 
//4 changes made

//Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
generate oversize_plot = (total_percent_mono >1)
replace oversize_plot = 1 if total_percent_mono >=1 & total_percent_int_sum >0 		
//2 oversize plots in total
bys household_id2 holder_id parcel_id field_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>1 & oversize_plot ==1

gen total_percent_inter = 1-total_percent_mono 
bys household_id2 holder_id parcel_id field_id: egen inter_crop_number = total(intercropped_yn)
gen percent_inter = (int_field/total_percent_int_sum)*total_percent_inter if total_percent_field >1 
replace percent_inter=int_field if total_percent_field<=1
replace percent_inter = percent_field if oversize_plot ==1

gen ha_planted = percent_field*area_meas_hectares  if intercropped_yn == 0 
replace ha_planted = percent_inter*area_meas_hectares  if intercropped_yn == 1 

gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
gen ha_planted_purestand = ha_planted if any_pure==1
gen ha_planted_mixedstand = ha_planted if any_pure==0
gen ha_planted_male_pure = ha_planted if dm_gender==1 & any_pure==1
gen ha_planted_female_pure = ha_planted if dm_gender==2 & any_pure==1
gen ha_planted_mixed_pure = ha_planted if dm_gender==3 & any_pure==1
gen ha_planted_male_mixed = ha_planted if dm_gender==1 & any_mixed==1
gen ha_planted_female_mixed = ha_planted if dm_gender==2 & any_mixed==1
gen ha_planted_mixed_mixed = ha_planted if dm_gender==3 & any_mixed==1

rename pp_s4q14 number_trees_planted 

keep ha_planted* holder_id parcel_id field_id household_id2 crop_code dm_* any_* number_trees_planted 
save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_area_planted.dta", replace



*Before harvest, need to prepare the conversion factors
use "$ETH_W3_raw_data/Food and Crop Conversion Factors/Crop_CF_Wave3.dta", clear
ren mean_cf_nat mean_cf100
sort crop_code unit_cd mean_cf100
duplicates drop crop_code unit_cd, force

reshape long mean_cf, i(crop_code unit_cd) j(region)
recode region (99=5)
ren mean_cf conversion
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_cf.dta", replace


*Now to harvest
use "$ETH_W3_raw_data/Post-Harvest/sect9_ph_w3.dta", clear
ren saq01 region
ren ph_s9q04_b unit_cd		
gen percent_area_harv = ph_s9q09/100 if ph_s9q08==1
replace percent_area_harv = 1 if ph_s9q08==2	
merge m:1 crop_code unit_cd region using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_cf.dta", gen(cf_merge) 
*8,658 not matched
*21,664 matched
bys crop_code unit_cd: egen national_conv = median(conversion)
replace conversion = national_conv if conversion==.			// replacing with median if missing -- 1,517

bys unit_cd region: egen national_conv_unit = median(conversion)
replace conversion = national_conv_unit if conversion==. & unit_cd!=900		// Not for "other" ones -- 2,105 changes

tab unit_cd			// 0.43 percent (111) of field-crop observations are reported with "other" units
tab crop_name ph_s9qo4_b_other if unit_cd==900
*None of the "other" units are for cereal crops so will skip adding in those food conversion factors

gen kgs_harvest = ph_s9q04_a*conversion
replace kgs_harvest = ph_s9q05 if kgs_harvest==.
drop if kgs_harvest==.							// dropping those with missing kg

*recoding common beans to all one category
recode crop_code (19=12)

*kgs harvest by crop for monocropped plots
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	preserve
		merge m:1 household_id2 parcel_id field_id holder_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen keep(3)
		gen kgs_harv_mono_`cn' = kgs_harvest 
		merge 1:1 household_id2 parcel_id field_id holder_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen keep(3)
		gen kgs_harv_mono_`cn'_male= kgs_harv_mono_`cn' if dm_gender==1
		gen kgs_harv_mono_`cn'_female= kgs_harv_mono_`cn' if dm_gender==2
		gen kgs_harv_mono_`cn'_mixed= kgs_harv_mono_`cn' if dm_gender==3
		
		collapse (sum) kgs_harv_mono_`cn'*, by(household_id2)
		
		lab var kgs_harv_mono_`cn' "monocropped `cn' harvested(kg)"
		foreach i in male female mixed {
			local lkgs_harv_mono_`cn' : var lab kgs_harv_mono_`cn'
			la var kgs_harv_mono_`cn'_`i' "`lkgs_harv_mono_`cn'' - `i' managed plots"
			}
		save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_`cn'_harvest_monocrop", replace
	restore
}

keep crop_code holder_id parcel_id field_id kgs_harvest ph_s9q08 ph_s9q09 percent_area_harv
*Merging area
merge m:1 holder_id parcel_id field_id crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_area_planted", nogen 
*3 not matched from master
*25,283 matched

*renaming area planted variables to keep for analysis
gen area_plan = ha_planted
gen area_plan_male = ha_planted_male 
gen area_plan_female = ha_planted_female 
gen area_plan_mixed = ha_planted_mixed 
gen area_plan_pure = ha_planted_purestand 
gen area_plan_inter = ha_planted_mixedstand 
gen area_plan_pure_male = ha_planted_male_pure 
gen area_plan_pure_female = ha_planted_female_pure 
gen area_plan_pure_mixed = ha_planted_mixed_pure
gen area_plan_inter_male = ha_planted_male_mixed 
gen area_plan_inter_female = ha_planted_female_mixed 
gen area_plan_inter_mixed = ha_planted_mixed_mixed 

gen area_harv = area_plan*percent_area_harv

*Creating area and quantity variables by decision-maker and type of planting
gen harvest = kgs_harvest
ren any_mixed inter
gen harvest_male = harvest if dm_gender==1
gen area_harv_male = area_harv if dm_gender==1
gen harvest_female = harvest if dm_gender==2
gen area_harv_female = area_harv if dm_gender==2
gen harvest_mixed = harvest if dm_gender==3
gen area_harv_mixed = area_harv if dm_gender==3
gen area_harv_inter= area_harv if inter==1
gen area_harv_pure= area_harv if inter==0
gen harvest_inter= harvest if inter==1
gen harvest_pure= harvest if inter==0
gen harvest_inter_male= harvest if dm_gender==1 & inter==1
gen harvest_pure_male= harvest if dm_gender==1 & inter==0
gen harvest_inter_female= harvest if dm_gender==2 & inter==1
gen harvest_pure_female= harvest if dm_gender==2 & inter==0
gen harvest_inter_mixed= harvest if dm_gender==3 & inter==1
gen harvest_pure_mixed= harvest if dm_gender==3 & inter==0
gen area_harv_inter_male= area_harv if dm_gender==1 & inter==1
gen area_harv_pure_male= area_harv if dm_gender==1 & inter==0
gen area_harv_inter_female= area_harv if dm_gender==2 & inter==1
gen area_harv_pure_female= area_harv if dm_gender==2 & inter==0
gen area_harv_inter_mixed= area_harv if dm_gender==3 & inter==1
gen area_harv_pure_mixed= area_harv if dm_gender==3 & inter==0

*Collapsing to household-crop level
collapse (sum) harvest* area_harv* area_plan* kgs_harvest ha_planted* (max) dm_*  any_* number_trees_planted, by(household_id2 crop_code)	

*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(household_id2)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
lab var all_area_planted "Total area planted, all plots, crops, and seasons"
lab var all_area_harvested "Total area harvested, all plots, crops, and seasons"
save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_area_planted_harvested_allcrops.dta", replace
restore 

keep if inlist(crop_code, $comma_topcrop_area)

*Merging weights and survey variables
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", nogen keep(1 3)
*3 not matched from master
*15,656 matched
rename pw_w3 weight

save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_harvest_area_yield.dta", replace


*Yield at the household level
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_harvest_area_yield.dta", clear
gen total_planted_area = area_plan		
gen total_harv_area = area_harv	
merge 1:1 household_id2 crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_values_production.dta", nogen keep(1 3)
merge 1:1 household_id2 crop_code using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", nogen keep(1 3)
ren value_crop_production value_harv
drop value_harvest

local ncrop : word count $topcrop_area
foreach v of varlist  harvest*  area_harv* area_plan* total_planted_area total_harv_area kgs_harvest* kgs_sold* value_harv value_sold {
	separate `v', by(crop_code)
	forvalues i=1(1)`ncrop' {
		local p : word `i' of  $topcrop_area
		local np : word `i' of  $topcropname_area
		local `v'`p' = subinstr("`v'`p'","`p'","_`np'",1)	
		ren `v'`p'  ``v'`p''
	}
}

gen number_trees_planted_banana = number_trees_planted if crop_code==42 
recode number_trees_planted_banana (.=0) 
collapse (firstnm) harvest* area_harv*  area_plan*  total_planted_area* total_harv_area* kgs_harvest*  kgs_sold*  value_harv* value_sold* ha_planted* (sum) number_trees_planted_*, by(household_id2)
recode area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area* kgs_sold*  value_harv* value_sold ha_planted* (0=.)

lab var kgs_harvest "Kgs harvested (household) (all seasons)"
lab var kgs_sold "Kgs sold (household) (all seasons)"

*label variables
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (ETB) (household)" 
	lab var value_sold_`p' "Value sold of `p' (ETB) (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household)" 
	lab var kgs_sold_`p'  "Quantity sold of `p' (kgs) (household)" 
	lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household)" 	
	lab var total_planted_area_`p'  "Total area planted of `p' (ha) (household)" 

	lab var harvest_`p' "Quantity harvested of `p' (kgs) (household)" 
	lab var harvest_male_`p' "Quantity harvested of `p' (kgs) (male-managed plots)" 
	lab var harvest_female_`p' "Quantity harvested of `p' (kgs) (female-managed plots)" 
	lab var harvest_mixed_`p' "Quantity harvested of `p' (kgs) (mixed-managed plots)"
	lab var harvest_pure_`p' "Quantity harvested of `p' (kgs) - purestand (household)"
	lab var harvest_pure_male_`p'  "Quantity harvested of `p' (kgs) - purestand (male-managed plots)"
	lab var harvest_pure_female_`p'  "Quantity harvested of `p' (kgs) - purestand (female-managed plots)"
	lab var harvest_pure_mixed_`p'  "Quantity harvested of `p' (kgs) - purestand (mixed-managed plots)"
	lab var harvest_inter_`p' "Quantity harvested of `p' (kgs) - intercrop (household)"
	lab var harvest_inter_male_`p' "Quantity harvested of `p' (kgs) - intercrop (male-managed plots)" 
	lab var harvest_inter_female_`p' "Quantity harvested of `p' (kgs) - intercrop (female-managed plots)"
	lab var harvest_inter_mixed_`p' "Quantity harvested  of `p' (kgs) - intercrop (mixed-managed plots)"

	lab var area_harv_`p' "Area harvested of `p' (ha) (household)" 
	lab var area_harv_male_`p' "Area harvested of `p' (ha) (male-managed plots)" 
	lab var area_harv_female_`p' "Area harvested of `p' (ha) (female-managed plots)" 
	lab var area_harv_mixed_`p' "Area harvested of `p' (ha) (mixed-managed plots)"
	lab var area_harv_pure_`p' "Area harvested of `p' (ha) - purestand (household)"
	lab var area_harv_pure_male_`p'  "Area harvested of `p' (ha) - purestand (male-managed plots)"
	lab var area_harv_pure_female_`p'  "Area harvested of `p' (ha) - purestand (female-managed plots)"
	lab var area_harv_pure_mixed_`p'  "Area harvested of `p' (ha) - purestand (mixed-managed plots)"
	lab var area_harv_inter_`p' "Area harvested of `p' (ha) - intercrop (household)"
	lab var area_harv_inter_male_`p' "Area harvested of `p' (ha) - intercrop (male-managed plots)" 
	lab var area_harv_inter_female_`p' "Area harvested of `p' (ha) - intercrop (female-managed plots)"
	lab var area_harv_inter_mixed_`p' "Area harvested  of `p' (ha) - intercrop (mixed-managed plots)"

	lab var area_plan_`p' "Area planted of `p' (ha) (household)" 
	lab var area_plan_male_`p' "Area planted of `p' (ha) (male-managed plots)" 
	lab var area_plan_female_`p' "Area planted of `p' (ha) (female-managed plots)" 
	lab var area_plan_mixed_`p' "Area planted of `p' (ha) (mixed-managed plots)"
	lab var area_plan_pure_`p' "Area planted of `p' (ha) - purestand (household)"
	lab var area_plan_pure_male_`p'  "Area planted of `p' (ha) - purestand (male-managed plots)"
	lab var area_plan_pure_female_`p'  "Area planted of `p' (ha) - purestand (female-managed plots)"
	lab var area_plan_pure_mixed_`p'  "Area planted of `p' (ha) - purestand (mixed-managed plots)"
	lab var area_plan_inter_`p' "Area planted of `p' (ha) - intercrop (household)"
	lab var area_plan_inter_male_`p' "Area planted of `p' (ha) - intercrop (male-managed plots)" 
	lab var area_plan_inter_female_`p' "Area planted of `p' (ha) - intercrop (female-managed plots)"
	lab var area_plan_inter_mixed_`p' "Area planted  of `p' (ha) - intercrop (mixed-managed plots)"
}


drop if household_id2=="2030406088800801079" | household_id2=="030406088800801079" //not cultivated/agland but reports area planted/harvested

*Indicator variable for whether a household grew each crop
foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=0)
	lab var grew_`p' "1=Household grew `p'" 
}

replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 

foreach p of global cropname {
	recode kgs_harvest_`p' (.=0) if grew_`p'==1 
	recode value_sold_`p' (.=0) if grew_`p'==1 
	recode value_harv_`p' (.=0) if grew_`p'==1 
}	

drop harvest-harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_inter_mixed value_harv kgs_harvest kgs_sold value_sold total_planted_area total_harv_area number_trees_planted_*

save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_yield_hh_level.dta", replace



**************
*CONSUMPTION
************** 

use "${ETH_W3_raw_data}\Consumption Aggregate\cons_agg_w3.dta", clear

ren total_cons_ann total_cons
gen peraeq_cons = nom_totcons_aeq
la var peraeq_cons "Household consumption per adult equivalent per year"
gen daily_peraeq_cons = peraeq_cons/365
la var daily_peraeq_cons "Household consumption per adult equivalent per day"

gen percapita_cons = (total_cons / hh_size)
la var percapita_cons "Household consumption per household member per year"
gen daily_percap_cons = percapita_cons/365
la var daily_percap_cons "Household consumption per household member per day"

keep household_id2 adulteq total_cons peraeq_cons daily_peraeq_cons percapita_cons daily_percap_cons
save "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_consumption.dta", replace



**************************
*HOUSEHOLD FOOD PROVISION*
**************************

use "${ETH_W3_raw_data}/Household/sect7_hh_w3.dta", clear

numlist "1/12"
forval k=1/12{
	local num: word `k' of `r(numlist)'
	local alph: word `k' of `c(alpha)'
	rename hh_s7q07_`alph' hh_s7q07_`num'
}

forval k=1/12 {
	gen food_insecurity_`k' = (hh_s7q07_`k'=="X")
}

egen months_food_insec = rowtotal(food_insecurity_*) 
*replacing those that report over 12 months of food insecurity
replace months_food_insec = 12 if months_food_insec>12
lab var months_food_insec "Number of months of inadequate food provision"
keep household_id2 months_food_insec
save "${ETH_W3_created_data}\Ethiopia_ESS_LSMS_W3_food_insecurity.dta", replace



******************
*HOUSEHOLD ASSETS*
******************

*Cannot calculate in this instrument - questionnaire doesn't ask value of HH assets



**************************
*DISTANCE TO AGRO DEALERS*
**************************

*Cannot create in this instrument

 


************************
*HOUSEHOLD VARIABLES
************************
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", clear	
drop pw_w3	
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)

*Area dta files
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_household_area.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farm_area.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)

*Rental value, rent paid, and value of owned land
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_rate.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_value.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_land.dta", nogen keep(1 3)

*Top crop costs
foreach cn in $topcropname_area {
	merge 1:1 household_id2 using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_`cn'_monocrop_hh_area.dta", nogen keep(1 3) 
	merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_`cn'_harvest_monocrop", nogen keep(1 3)
	merge 1:1 household_id2 using "${ETH_W3_created_data}\Ethiopia_ESS_LSMS_ISA_W3_fertilizer_costs_`cn'.dta", nogen keep(1 3)	
	merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_value_`cn'.dta", nogen keep(1 3)
	merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_pp_inputs_value_`cn'.dta", nogen keep(1 3)		
	merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_harv_labor_`cn'.dta", nogen keep(1 3)		
}

*Generating crop expenses for top crops
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	recode `cn'_monocrop (.=0) 
	egen `cn'_exp = rowtotal(value_rented_land_`cn' value_fertilizer_`cn' val_hire_harv_`cn' val_hire_prep_`cn')
	replace `cn'_exp =. if `cn'_monocrop_ha==.
	la var `cn'_exp "Crop production expenditures (explicit) - Monocropped `cnfull' plots only"
	*disaggregate by gender of plot manager
	foreach i in male female mixed {
		egen `cn'_exp_`i' = rowtotal(value_rented_land_`cn'_`i' value_fertilizer_`cn'_`i' val_hire_harv_`cn'_`i' val_hire_prep_`cn'_`i')
		replace `cn'_exp_`i' =. if `cn'_monocrop_ha_`i'==.
		local l`cn': var lab `cn'_exp
		la var `cn'_exp_`i' "`l`cn'' - `i' managed plots"
	}
}

*Land rights
merge 1:1 household_id2 using  "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_land_rights_hh.dta", nogen keep(1 3) 
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Crop yields 
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_yield_hh_level.dta", nogen keep(1 3)
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
drop ha_planted_purestand - ha_planted_mixed_mixed 
*Household diet
merge 1:1 household_id2 using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_household_diet.dta", nogen keep(1 3)

*Post-planting inputs
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_fertilizer_application.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_pp_inputs_value.dta", nogen keep(1 3)

*Post-harvest inputs
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_harv_labor.dta", nogen keep(1 3)

*Other inputs
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_seed.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmlabor_all.dta", nogen keep(1 3)

*Crop production and losses
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_losses.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_household.dta", nogen keep(1 3)

*Use variables
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_any_ext.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_vaccine.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_fin_serv.dta", nogen keep(1 3)
recode ext_reach_all (.=0) 

*Livestock expenses and production
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_sales", nogen keep(1 3) 
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_expenses", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_TLU.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_milk_animals.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_eggs_animals.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data\Ethiopia_ESS_LSMS_ISA_W3_herd_characteristics", nogen keep(1 3)
merge 1:1 household_id2 using "${ETH_W3_created_data}\Ethiopia_ESS_LSMS_ISA_W3_TLU_Coefficients", nogen keep(1 3)

*Non-agricultural income
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_wage_income.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_agwage_income.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_self_employment_income.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_other_income.dta", nogen keep(1 3)
merge 1:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_assistance_income.dta", nogen keep(1 3)

*Off-farm hours
merge 1:1 household_id2 using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_off_farm_hours.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_ag_wage.dta", nogen keep(1 3)

*Consumption
merge 1:1 household_id2 using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_consumption.dta", nogen keep(1 3)

*Food security
merge 1:1 household_id2 using "${ETH_W3_created_data}\Ethiopia_ESS_LSMS_W3_food_insecurity.dta", nogen keep(1 3)


* recoding and creating new variables
gen annual_salary_aggregate = .
gen annual_salary_agwage_aggregate = .
recode annual_salary annual_salary_agwage annual_salary_aggregate annual_salary_agwage_aggregate (.=0)
rename annual_salary wage_income
rename annual_salary_agwage agwage_income
drop annual_salary_aggregate annual_salary_agwage_aggregate

*Crop income
recode value_crop_production crop_value_lost (.=0) 
replace crop_value_lost = 0 if crop_value_lost==. & value_crop_production!=.
replace value_crop_production = 0 if value_crop_production==. & crop_value_lost!=.
egen crop_production_expenses = rowtotal(value_rented_land value_transport_free_seed value_transport_purchased_seed value_purchased_seed value_fert value_hired_harv_labor value_hired_prep_labor value_transport_cropsales)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*Some final labor variables
*egen labor_total_male = rowtotal(days_hired_pp_male days_nonhired_pp_male days_hired_harv_male days_nonhired_harv_male)
*egen labor_total_female = rowtotal(days_hired_pp_female days_nonhired_pp_female days_hired_harv_female days_nonhired_harv_female)
*egen labor_total_mixed = rowtotal(days_hired_pp_mixed days_nonhired_pp_mixed days_hired_harv_mixed days_nonhired_harv_mixed)
drop *days_hired* *days_nonhired*

*Farm size
ren area_meas_hectares_hh land_size
recode land_size (.=0) /* If no farm, then no farm area */

*Livestock income
recode value_livestock_sales value_livestock_purchases value_milk_produced value_eggs_produced earnings_milk_products /*
*/ cost_breeding_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_water_livestock tlu_today (.=0)
gen livestock_income = value_livestock_sales - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + earnings_milk_products) /*
*/ - (cost_breeding_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_treatment_livestock + cost_water_livestock)
recode value_milk_produced value_eggs_produced (0=.)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
gen livestock_expenses = cost_breeding_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_treatment_livestock + cost_water_livestock
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
lab var livestock_expenses "Total livestock expenses"
drop value_livestock_purchases earnings_milk_products cost_breeding_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_water_livestock

*Other income
recode annual_selfemp_profit wage_income agwage_income transfer_income pension_income investment_income rental_income sales_income inheritance_income /*
*/ psnp_income assistance_income land_rental_income_upfront (.=0)
gen fish_trading_income = .
egen self_employment_income = rowtotal(annual_selfemp_profit fish_trading_income)
ren wage_income nonagwage_income
lab var self_employment_income "Income from self-employment (business)"

egen transfers_income = rowtotal (transfer_income pension_income assistance_income psnp_income) 
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (investment_income rental_income sales_income land_rental_income_upfront inheritance_income )
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop annual_selfemp_profit fish_trading_income transfer_income pension_income assistance_income psnp_income investment_income rental_income sales_income land_rental_income_upfront inheritance_income 

*Agricultural households
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)  
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"


*Ag activities
gen agactivities_hh = ag_hh==1 | (agwage_income!=0 & agwage_income!=.)
lab var agactivities_hh "1=Household has some land cultivated, livestock, crop income, livestock income, or ag wage income"

*Crop household and livestock household
gen crop_hh = (value_crop_production!=0  | farm_area!=0 )  
lab var crop_hh "1= Household has some land cultivated or some crop income"
gen livestock_hh = (livestock_income!=0 | tlu_today!=0)
lab  var livestock_hh "1= Household has some livestock or some livestock income"
count if value_crop_production==. /* 15 don't have crop production. Were these only interviewed post-planting? */

*households engaged in egg production 
gen egg_hh = (value_eggs_produced>0 & value_eggs_produced!=.)
lab var egg_hh "1=Household engaged in egg production"
*household engaged in dairy production
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 

*Farm size categories
recode farm_size_agland (.=0)
gen  farm_size_0_0=farm_size_agland==0
gen  farm_size_0_1=farm_size_agland>0 & farm_size_agland<=1
gen  farm_size_1_2=farm_size_agland>1 & farm_size_agland<=2
gen  farm_size_2_4=farm_size_agland>2 & farm_size_agland<=4
gen  farm_size_4_more=farm_size_agland>4
lab var farm_size_0_0 "1=Household has no farm"
lab var farm_size_0_1 "1=Household farm size > 0 Ha and <=1 Ha"
lab var farm_size_1_2 "1=Household farm size > 1 Ha and <=2 Ha"
lab var farm_size_2_4 "1=Household farm size > 2 Ha and <=4 Ha"
lab var farm_size_4_more "1=Household farm size > 4 Ha"

*Total costs (implicit + explicit)
egen cost_total_hh = rowtotal(value_owned_land value_rented_land value_hired_prep_labor value_fam_prep_labor value_hired_harv_labor value_fam_harv_labor value_fert value_purchased_seed value_non_purchased_seed value_transport_purchased_seed value_transport_free_seed)
lab var cost_total_hh "Explicit + implicit costs of crop production (household level)"

egen cost_total = rowtotal(value_owned_land value_rented_land value_hired_prep_labor value_fam_prep_labor value_hired_harv_labor value_fam_harv_labor value_fert) //excludes seed costs because we can't attribute this cost to plot managers   
lab var cost_total "Explicit + implicit costs of crop production that can be disaggregated at the plot manager level"
foreach i in male female mixed{
	egen cost_total_`i' = rowtotal(value_owned_land_`i' value_rented_land_`i' value_hired_prep_labor_`i' value_fam_prep_labor_`i' value_hired_harv_labor_`i' value_fam_harv_labor_`i' value_fert_`i')
	lab var cost_total_`i' "Explicit + implicit costs of crop production (`i'-managed plots)"
}

*Explicit costs only
egen cost_expli_hh = rowtotal(value_rented_land value_hired_prep_labor value_hired_harv_labor value_fert value_purchased_seed value_transport_purchased_seed value_transport_free_seed)
lab var cost_expli_hh "Total explicit crop production (household level)" 

*Creating explicit costs by gender (excludes seeds)
egen cost_expli = rowtotal(value_rented_land value_hired_prep_labor value_hired_harv_labor value_fert)
lab var cost_expli "Explicit costs of crop production that can be disaggregated at the plot manager level"
foreach i in male female mixed{
	egen cost_expli_`i' = rowtotal(value_rented_land_`i' value_hired_prep_labor_`i' value_hired_harv_labor_`i' value_fert_`i')
	lab var cost_expli_`i' "Crop production costs per hectare, explicit costs (`i'-managed plots)"
}

drop *value_owned_land* *value_rented_land* *value_hired_prep_labor* *value_fam_prep_labor* *value_hired_harv_labor* *value_fam_harv_labor* /*
*/  *value_fert* *value_purchased_seed* *value_non_purchased_seed* *value_transport_purchased_seed* *value_transport_free_seed* val_hire_* 


*Generating missing fishing variable - no fishing data in ET LSMS
gen fishing_income = . 
lab var fishing_income "Net fish income"

*Milk productivity
gen liters_milk_produced= liters_per_cow*milk_animals
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
drop liters_per_cow

*Dairy costs 
merge 1:1 household_id2 using "$ETH_W3_created_data\Ethiopia_ESS_LSMS_ISA_W3_lrum_expenses", nogen keep (1 3)
gen avg_cost_lrum = cost_lrum/mean_12months_lrum 
gen costs_dairy = avg_cost_lrum*milk_animals 
gen costs_dairy_percow=0
lab var avg_cost_lrum "Average cost per large ruminant"
lab var milk_animals "Number of large ruminants that were milked (household)"
lab var costs_dairy "Dairy production cost (explicit)"
lab var costs_dairy_percow "Dairy production cost (explicit) per cow"
drop avg_cost_lrum cost_lrum

****getting correct subpopulations*****  
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (nonmissing=.) if crop_hh==0
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses (nonmissing=.) if livestock_hh==0
*all rural households 
recode off_farm_hours crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income fishing_income all_other_income (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

drop value_harvest*

*** Begin addressing outliers  and estimating indicators that are ratios using winsorized values ***
global gender "female male mixed"

global wins_var_top1 /*
*/ cost_total_hh cost_expli_hh /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family labor_other /* 
*/ animals_lost12months* mean_12months*  /*
*/ liters_milk_produced costs_dairy eggs_total_year value_eggs_produced value_milk_produced /*
*/ off_farm_hours livestock_expenses crop_production_expenses kgs_harv_mono* sales_livestock_products value_livestock_products value_livestock_sales 

gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after

foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p(99) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	

global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp  
}
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli fert_inorg_kg wage_paid_aglabor  

foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight] , p(99) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
	
	*some variables are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	foreach g of global gender {
		gen w_`v'_`g'=`v'_`g'
		replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
		local l`v'_`g' : var lab `v'_`g'
		lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top 1%"
	}
}

drop *wage_paid_aglabor_mixed
*Generating labor_total as sum of winsorized labor_hired and labor_family
egen w_labor_total=rowtotal(w_labor_hired w_labor_family w_labor_other) 
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top 1%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income /*
*/ total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* 

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight] , p(1 99) 
	gen w_`v'=`v'
	replace w_`v'= r(r1) if w_`v' < r(r1) & w_`v'!=. & w_`v'!=0  /* we want to keep actual zeros */
	replace w_`v'= r(r2) if  w_`v' > r(r2)  & w_`v'!=.		
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top and bottom 1%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top and bottom 1% percentile to winsorize gender-disagregated variables
	if "`v'"=="ha_planted" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace w_`v'_`g'= r(r1) if w_`v'_`g' < r(r1) & w_`v'_`g'!=. & w_`v'_`g'!=0  /* we want to keep actual zeros */
			replace w_`v'_`g'= r(r2) if  w_`v'_`g' > r(r2)  & w_`v'_`g'!=.		
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top and bottom 1%"		
		}		
	}
}

*area_harv and area_plan are also winsorized both at the top 1% and bottom 1% because we need to analyze at the crop level 
global allyield male female mixed inter inter_male inter_female inter_mixed pure pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest 	
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		_pctile `v'_`c'  [aw=weight] , p(1 99)
		gen w_`v'_`c'=`v'_`c'
		replace w_`v'_`c' = r(r1) if w_`v'_`c' < r(r1)   &  w_`v'_`c'!=0   
		replace w_`v'_`c' = r(r2) if (w_`v'_`c' > r(r2) & w_`v'_`c' !=.)  		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winzorized top and bottom 1%"
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			replace w_`v'_`g'_`c' = r(r1) if w_`v'_`g'_`c' < r(r1) &  w_`v'_`g'_`c'!=0 
			replace w_`v'_`g'_`c' = r(r2) if (w_`v'_`g'_`c' > r(r2) & w_`v'_`g'_`c' !=.)  	
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winzorized top and bottom 1%"
			
		}
	}
}

*Estimate variables that are ratios then winsorize top 1% and bottom 1% of the ratios (do not replace 0 by the percentitles)

*generate yield and weights for yields using winsorized values 
*Yield by Area Planted
foreach c of global topcropname_area {
	gen yield_pl_`c'=w_harvest_`c'/w_area_plan_`c'
	lab var  yield_pl_`c' "Yield by area planted of `c' (kgs/ha) (household)" 
	gen ar_pl_wgt_`c' =  weight*w_area_plan_`c'
	lab var ar_pl_wgt_`c' "Planted area-adjusted weight for `c' (household)"
	foreach g of global allyield  {
		gen yield_pl_`g'_`c'=w_harvest_`g'_`c'/w_area_plan_`g'_`c'
		lab var  yield_pl_`g'_`c'  "Yield by area planted of `c' -  (kgs/ha) (`g')" 
		gen ar_pl_wgt_`g'_`c' =  weight*w_area_plan_`g'_`c'
		lab var ar_pl_wgt_`g'_`c' "Planted area-adjusted weight for `c' (`g')"
	}
}

*generate yield and weights for yields using winsorized values 
*Yield by area harvested
foreach c of global topcropname_area {
	gen yield_hv_`c'=w_harvest_`c'/w_area_harv_`c'
	lab var  yield_hv_`c' "Yield by area harvested of `c' (kgs/ha) (household)" 
	gen ar_h_wgt_`c' =  weight*w_area_harv_`c'
	lab var ar_h_wgt_`c' "Harvested area-adjusted weight for `c' (household)"
	foreach g of global allyield  {
		gen yield_hv_`g'_`c'=w_harvest_`g'_`c'/w_area_harv_`g'_`c'
		lab var  yield_hv_`g'_`c'  "Yield by area harvested of `c' -  (kgs/ha) (`g')" 
		gen ar_h_wgt_`g'_`c' =  weight*w_area_harv_`g'_`c'
		lab var ar_h_wgt_`g'_`c' "Harvested area-adjusted weight for `c' (`g')"
	}
}
 
 
*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
gen inorg_fert_rate=w_fert_inorg_kg/w_ha_planted
gen cost_total_ha=w_cost_total_hh/w_ha_planted
gen cost_expli_ha=w_cost_expli/w_ha_planted				
gen cost_explicit_hh_ha=w_cost_expli_hh/w_ha_planted

foreach g of global gender {
	gen inorg_fert_rate_`g'=w_fert_inorg_kg_`g'/ w_ha_planted_`g'
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g' 			
}

lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household level)"
lab var inorg_fert_rate_male "Rate of fertilizer application (kgs/ha) (male-managed crops)"
lab var inorg_fert_rate_female "Rate of fertilizer application (kgs/ha) (female-managed crops)"
lab var inorg_fert_rate_mixed "Rate of fertilizer application (kgs/ha) (mixed-managed crops)"
lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production (household level)"		
lab var cost_total_ha_male "Explicit + implicit costs (per ha) of crop production (male-managed plots)"
lab var cost_total_ha_female "Explicit + implicit costs (per ha) of crop production (female-managed plots)"
lab var cost_total_ha_mixed "Explicit + implicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_expli_ha_male "Explicit costs (per ha) of crop production (male-managed plots)"
lab var cost_expli_ha_female "Explicit costs (per ha) of crop production (female-managed plots)"
lab var cost_expli_ha_mixed "Explicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"

*mortality rate
global animal_species lrum srum camel equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost12months_`s'/mean_12months_`s'
	lab var mortality_rate_`s' "Mortality rate - `s'"
}

*Generating crop expenses by hectare for top crops
forvalues k=1/16 {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	gen `cn'_exp_ha = w_`cn'_exp / w_`cn'_monocrop_ha			
	la var `cn'_exp_ha "Costs per hectare - Monocropped `cnfull' plots"
	foreach g of global gender {
		gen `cn'_exp_ha_`g' = w_`cn'_exp_`g'/w_`cn'_monocrop_ha_`g'		
		local l`cn': var lab `cn'_exp_ha
		la var `cn'_exp_ha_`g' "`l`cn'' - `g' managed plots"
	}
}
		

*Off farm hours per capita using winsorized version off_farm_hours 
gen off_farm_hours_pc_all = w_off_farm_hours/member_count					// this is pc hours, counting all members in the module (supposed to be five or olders)
gen off_farm_hours_pc_any = w_off_farm_hours/off_farm_any_count				// this is pc hours, counting only members with positive hours
la var off_farm_hours_pc_all "Off-farm hours per capita, all members>5 years"
la var off_farm_hours_pc_any "Off-farm hours per capita, only members>5 years workings"

*generating total crop production costs per hectare
gen cost_expli_hh_ha = w_cost_expli_hh/w_ha_planted		
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

*Milk productivity
gen liters_per_cow = w_liters_milk_produced/milk_animals		
lab var liters_per_cow "average quantity (liters) per day (household) - cow"

*Egg productivity
gen egg_poultry_year = eggs_total_year/hen_total
ren hen_total poultry_owned
lab var egg_poultry_year "average number of eggs per year per hen"

*Calculate proportion of crop value sold using winsorized values of value_crop_sales and value_crop_production
gen w_proportion_cropvalue_sold = w_value_crop_sales /  w_value_crop_production
replace w_proportion_cropvalue_sold = 1 if w_proportion_cropvalue_sold>1 & w_proportion_cropvalue_sold!=.
lab var w_proportion_cropvalue_sold "Proportion of crop value produced (winsorized) that has been sold"

*Unit cost of production
*top crops
forvalues k=1/16 {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	gen `cn'_exp_kg = w_`cn'_exp / w_kgs_harv_mono_`cn'		
	la var `cn'_exp_kg "Costs per kilogram produced - `cnfull' monocropped plots"
	foreach g of global gender {
		gen `cn'_exp_kg_`g'= w_`cn'_exp_`g'/w_kgs_harv_mono_`cn'_`g'
		local l`cn': var lab `cn'_exp_kg
		la var `cn'_exp_kg_`g' "`l`cn'' - `g' mananged plots"
	}
}

*dairy
gen cost_per_lit_milk = w_costs_dairy/w_liters_milk_produced  
lab var cost_per_lit_milk "dairy production cost per liter"

*****getting correct subpopulations***
*all rural housseholds engaged in crop production 
recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0
*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode mortality_rate_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode mortality_rate_`i' (.=0) if lvstck_holding_`i'==1	
}
*all rural households 
recode off_farm_hours_pc_all (.=0)
*households engaged in monocropped production of specific crops
forvalues k=1/16 {
	local cn: word `k' of $topcropname_area
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}
*all rural households growing specific crops 
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	recode yield_pl_`cn' yield_hv_`cn' (.=0) if grew_`cn'==1
	recode yield_pl_`cn' yield_hv_`cn' (nonmissing=.) if grew_`cn'==0
}
*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' yield_hv_pure_`cn' (.=0) if grew_`cn'==1 & w_area_plan_pure_`cn'!=.
	recode yield_pl_pure_`cn' yield_hv_pure_`cn' (nonmissing=.) if grew_`cn'==0 | w_area_plan_pure_`cn'==. 
}

*households engaged in dairy production 
recode costs_dairy_percow cost_per_lit_milk liters_per_cow (.=0) if dairy_hh==1
recode costs_dairy_percow cost_per_lit_milk liters_per_cow (nonmissing=.) if dairy_hh==0
*households with egg-producing animals
recode egg_poultry_year (.=0) if egg_hh==1 
recode egg_poultry_year (nonmissing=.) if egg_hh==0


*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_cow egg_poultry_year costs_dairy_percow /*
*/ off_farm_hours_pc_all off_farm_hours_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p(99) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"

	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" {		
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top 1%"
		}	
	}
}

*Winsorizing top crop ratios
foreach v of global topcropname_area {
	*first winsorizing costs per hectare
	_pctile `v'_exp_ha [aw=weight] , p(99) 		
	gen w_`v'_exp_ha = `v'_exp_ha
	replace  w_`v'_exp_ha = r(r1) if  w_`v'_exp_ha > r(r1) &  w_`v'_exp_ha!=.
	local l`v'_exp_ha : var lab `v'_exp_ha
	lab var  w_`v'_exp_ha  "`l`v'_exp_ha' - Winzorized top 1%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_ha_`g'= `v'_exp_ha_`g'
		replace w_`v'_exp_ha_`g' = r(r1) if w_`v'_exp_ha_`g' > r(r1) & w_`v'_exp_ha_`g'!=.
		local l`v'_exp_ha_`g' : var lab `v'_exp_ha_`g'
		lab var w_`v'_exp_ha_`g' "`l`v'_exp_ha_`g'' - winsorized top 1%"
	}

	*winsorizing cost per kilogram
	_pctile `v'_exp_kg [aw=weight] , p(99) 
	gen w_`v'_exp_kg=`v'_exp_kg
	replace  w_`v'_exp_kg = r(r1) if  w_`v'_exp_kg > r(r1) &  w_`v'_exp_kg!=.
	local l`v'_exp_kg : var lab `v'_exp_kg
	lab var  w_`v'_exp_kg  "`l`v'_exp_kg' - Winzorized top 1%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_kg_`g'= `v'_exp_kg_`g'
		replace w_`v'_exp_kg_`g' = r(r1) if w_`v'_exp_kg_`g' > r(r1) & w_`v'_exp_kg_`g'!=.
		local l`v'_exp_kg_`g' : var lab `v'_exp_kg_`g'
		lab var w_`v'_exp_kg_`g' "`l`v'_exp_kg_`g'' - winsorized top 1%"
	}
}


*now winsorize ratio only at top 1% - yield 
foreach c of global topcropname_area {
	foreach i in yield_pl yield_hv{
		_pctile `i'_`c' [aw=weight] , p(99) 
		gen w_`i'_`c'=`i'_`c'
		replace  w_`i'_`c' = r(r1) if  w_`i'_`c' > r(r1) &  w_`i'_`c'!=.
		local w_`i'_`c' : var lab `i'_`c'
		lab var  w_`i'_`c'  "`w_`i'_`c'' - Winzorized top 1%"
		foreach g of global allyield  {
			gen w_`i'_`g'_`c'= `i'_`g'_`c'
			replace  w_`i'_`g'_`c' = r(r1) if  w_`i'_`g'_`c' > r(r1) &  w_`i'_`g'_`c'!=.
			local w_`i'_`g'_`c' : var lab `i'_`g'_`c'
			lab var  w_`i'_`g'_`c'  "`w_`i'_`g'_`c'' - Winzorized top 1%"
		}
	}
}

*Create final income variables using un_winzorized and winzorized values
egen total_income = rowtotal(crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income)
egen nonfarm_income = rowtotal(self_employment_income nonagwage_income transfers_income all_other_income)
egen farm_income = rowtotal(crop_income livestock_income agwage_income)
lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"

egen w_total_income = rowtotal(w_crop_income w_livestock_income w_self_employment_income w_nonagwage_income w_agwage_income w_transfers_income w_all_other_income)
egen w_nonfarm_income = rowtotal(w_self_employment_income w_nonagwage_income w_transfers_income w_all_other_income)
egen w_farm_income = rowtotal(w_crop_income w_livestock_income w_agwage_income)
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top 1%"
lab var w_farm_income "Farm income - Winzorized top 1%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top 1%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top 1%"

global income_vars crop livestock self_employment nonagwage agwage transfers all_other
foreach p of global income_vars {
gen `p'_income_s = `p'_income
replace `p'_income_s = 0 if `p'_income_s < 0

gen w_`p'_income_s = w_`p'_income
replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
}
egen w_total_income_s = rowtotal(w_crop_income_s w_livestock_income_s w_self_employment_income_s w_nonagwage_income_s w_agwage_income_s  w_transfers_income_s w_all_other_income_s)
foreach p of global income_vars {
gen w_share_`p' = w_`p'_income_s / w_total_income_s
lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}

egen w_nonfarm_income_s = rowtotal(w_self_employment_income_s w_nonagwage_income_s w_transfers_income_s w_all_other_income_s)
gen w_share_nonfarm = w_nonfarm_income_s / w_total_income_s
lab var w_share_nonfarm "Share of household income (winsorized) from nonfarm sources"
foreach p of global income_vars {
drop `p'_income_s  w_`p'_income_s 
}
drop w_total_income_s w_nonfarm_income_s


***getting correct subpopulations 
*all rural households 
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income*/ w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock /*w_share_fishing*/ w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
*/ formal_land_rights_hh w_off_farm_hours_pc_all months_food_insec /* w_value_assets hhs_little hhs_moderate hhs_severe hhs_total*/ /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
 
*all rural households engaged in livestock production
recode vac_animal share_livestock_prod_sold livestock_expenses any_imp_herd_all (. = 0) if livestock_hh==1 
recode vac_animal share_livestock_prod_sold livestock_expenses any_imp_herd_all (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert /*w_dist_agrodealer*/ w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert /*w_dist_agrodealer*/ w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0
		
*hh engaged in crop or livestock production
gen ext_reach_unspecified=0 
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"

*all rural households growing specific crops 
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_hv_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_hv_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (nonmissing=.) if grew_`cn'==0
}

*households engaged in monocropped production of specific crops
forvalues k=1/16 {
	local cn: word `k' of $topcropname_area
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}

*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced w_value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced w_value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode w_eggs_total_year w_value_eggs_produced (.=0) if egg_hh==1
recode w_eggs_total_year w_value_eggs_produced (nonmissing=.) if egg_hh==0



*** End outliers *** 


*Convert monetary values to 2016 Purchasing Power Parity international dollars
global topcrop_monetary=""
foreach v in $topcropname_area {
	global topcrop_monetary $topcrop_monetary `v'_exp `v'_exp_ha `v'_exp_kg
	
	foreach g in $gender{
	global topcrop_monetary $topcrop_monetary `v'_exp_`g' `v'_exp_ha_`g' `v'_exp_kg_`g'
	}
}

global monetary_vars crop_income livestock_income nonagwage_income agwage_income self_employment_income transfers_income all_other_income  /*
*/ percapita_income total_income nonfarm_income farm_income land_productivity labor_productivity /*
*/ total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ wage_paid_aglabor* /*
*/ cost_total_ha cost_total_ha_female cost_total_ha_male cost_total_ha_mixed /*
*/ cost_expli_ha cost_expli_ha_female cost_expli_ha_male cost_expli_ha_mixed /*
*/ cost_expli_hh cost_expli_hh_ha /*
*/ value_crop_production value_harv* value_sold_* value_crop_sales value_milk_produced  value_eggs_produced livestock_expenses /*
*/ costs_dairy costs_dairy_percow cost_per_lit_milk* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ $topcrop_monetary 


foreach p of varlist $monetary_vars {
	gen `p'_1ppp = `p' / $ETH_LSMS_ISA_W3_cons_ppp_dollar 
	gen `p'_2ppp = `p' / $ETH_LSMS_ISA_W3_gdp_ppp_dollar 
	gen `p'_usd = `p' / $ETH_LSMS_ISA_W3_exchange_rate 
	gen `p'_loc = `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' (2016 ETB)"  
	lab var `p' "`l`p'' (ETB)"  
	gen w_`p'_1ppp = w_`p' / $ETH_LSMS_ISA_W3_cons_ppp_dollar 
	gen w_`p'_2ppp = w_`p' / $ETH_LSMS_ISA_W3_gdp_ppp_dollar 
	gen w_`p'_usd = w_`p' / $ETH_LSMS_ISA_W3_exchange_rate 
	gen w_`p'_loc = w_`p'
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2016 ETB)"
	lab var w_`p' "`lw_`p'' (ETB)"  
}


***Rural poverty headcount ratio
*First, we convert $1.91 USD to local currency using https://data.worldbank.org/indicator/PA.NUS.PPP?locations=TZ
	// 1.91 * 5.439 = 10.388
*NOTE: this is using the "Private Consumption, PPP" conversion factors.
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003	
	// ((226.759 - 133.25)/133.25) + 1 = 
	// 10.388 * 1.702 = 17.678 ETB
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out

gen poverty_under_1_9 = (daily_percap_cons<17.678)
la var poverty_under_1_9 "Household has a percapita conumption of under $1.90 in 2011 $ PPP)"

*getting rid of some intermediate variables so that the file is smaller and usable on basic Stata
drop *_inter_* 
recode fishing_income costs_dairy_percow ext_reach_unspecified (0=.)

//////////Identifier Variables ////////
*Add variables and rename household id so dta file can be appended with dta files from other instruments
rename household_id2 hhid 
gen geography = "Ethiopia"
gen survey = "LSMS-ISA"
gen year = "2015-16"
gen instrument = 7
label define instrument 1 "TZA NPS Wave 1" 2 "TZA NPS Wave 2" 3 "TZA NPS Wave 3" 4 "TZA NPS Wave 4" /*
	*/ 5 "ETH ESS Wave 1" 6 "ETH ESS Wave 2" 7 "ETH ESS Wave 3" /*
	*/ 8 "NGA GHSP Wave 1" 9 "NGA GHSP Wave 2" 10 "NGA GHSP Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "ETH ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	

save "$ETH_W3_final_data/Ethiopia_ESS_LSMS_ISA_W3_household_variables.dta", replace


///////////////////
//               //
//     FIELD     //
//     LEVEL     //
//               //
///////////////////

use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_field.dta", clear
merge 1:1 household_id2 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area.dta", nogen keep(1 3)
merge 1:1 household_id2 holder_id parcel_id field_id using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen keep(1 3)
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", nogen keep(1 3)		
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen

merge 1:1 household_id2 holder_id parcel_id field_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_plot_farmlabor_postplanting.dta", keep (1 3) nogen
merge 1:1 household_id2 holder_id parcel_id field_id using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_plot_farmlabor_postharvest.dta", keep (1 3) nogen
drop household_id ea_id- obs local_unit area_sqmeters_gps conversion_merge sqmeters_per_unit_zone obs_zone sqmeters_per_unit_region obs_region obs_country sqmeters_per_unit_country
egen  labor_total =rowtotal(days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest)
ren value_crop_production plot_value_harvest


*Winsorize area_meas_hectares and labor_total at top and bottom 1%
keep if cultivated==1
global winsorize_vars area_meas_hectares  labor_total  
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight] if w_`p'!=0 , p(1 99)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}
 
*Winsorize plot_value_harvest at top  1% only 
_pctile plot_value_harvest  [aw=weight] , p(99) 
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top 1%"

*Generate land and labor productivity using winsorized values
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"
gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"

*Winsorize both land and labor productivity at top 1% only
gen plot_weight=w_area_meas_hectares*weight
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p(99) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	
	
*Convert monetary values into USD and PPP
global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_usd= `p' / $ETH_LSMS_ISA_W3_exchange_rate
	gen `p'_1ppp= `p' / $ETH_LSMS_ISA_W3_cons_ppp_dollar
	gen `p'_2ppp= `p' / $ETH_LSMS_ISA_W3_gdp_ppp_dollar
	gen `p'_loc = `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' (2016 ETB)" 
	lab var `p' "`l`p'' (ETB)" 
	
	gen w_`p'_usd= w_`p' / $ETH_LSMS_ISA_W3_exchange_rate
	gen w_`p'_1ppp= w_`p' / $ETH_LSMS_ISA_W3_cons_ppp_dollar
	gen w_`p'_2ppp= w_`p' / $ETH_LSMS_ISA_W3_gdp_ppp_dollar
	gen w_`p'_loc = w_`p' 
	local lw_`p' : var lab w_`p' 
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption  PPP)"
	lab var w_`p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2016 ETB)"
	lab var w_`p' "`lw_`p'' (ETB)" 
}

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) 		// get standard errors of the mean

*SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only

*Gender-gap 1a 
gen lplot_productivity_usd=ln(w_plot_productivity_usd) //use winsorize value for to report gender gap
gen larea_meas_hectares=ln(w_area_meas_hectares)
svy, subpop(  if rural==1 ): reg  lplot_productivity_usd male_dummy 
matrix b1a=e(b)
gen gender_prod_gap1a=100*el(b1a,1,1)
sum gender_prod_gap1a
lab var gender_prod_gap1a "Gender productivity gap (%) - regression in logs with no controls"
matrix V1a=e(V)
gen segender_prod_gap1a= 100*sqrt(el(V1a,1,1)) 
sum segender_prod_gap1a
lab var segender_prod_gap1a "SE Gender productivity gap (%) - regression in logs with no controls"

*Gender-gap 1b
svy, subpop(  if rural==1 ): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region
matrix b1b=e(b)
gen gender_prod_gap1b=100*el(b1b,1,1)
sum gender_prod_gap1b
lab var gender_prod_gap1b "Gender productivity gap (%) - regression in logs with controls"
matrix V1b=e(V)
gen segender_prod_gap1b= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b
lab var segender_prod_gap1b "SE Gender productivity gap (%) - regression in logs with controls"
lab var lplot_productivity_usd "Log Value of crop production per hectare"


//////////Identifier Variables ////////
*Add variables and rename household id so dta file can be appended with dta files from other instruments
rename household_id2 hhid
rename field_id plot_id
gen geography = "Ethiopia"
gen survey = "LSMS-ISA"
gen year = "2015-16"
gen instrument = 7
label define instrument 1 "TZA NPS Wave 1" 2 "TZA NPS Wave 2" 3 "TZA NPS Wave 3" 4 "TZA NPS Wave 4" /*
	*/ 5 "ETH ESS Wave 1" 6 "ETH ESS Wave 2" 7 "ETH ESS Wave 3" /*
	*/ 8 "NGA GHSP Wave 1" 9 "NGA GHSP Wave 2" 10 "NGA GHSP Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "ETH ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	

save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_productivity_gap.dta", replace



**************
*INDIVIDUAL-LEVEL VARIABLES
**************
use "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_control_income.dta", clear
merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_ag_decision.dta", nogen keep(1 3)
merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_women_asset.dta", nogen keep(1 3)
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", nogen keep(1 3)
merge 1:1 household_id2 personid using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 household_id2 personid using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 household_id2 personid using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_household_diet.dta", nogen
merge m:1 household_id2 using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen
merge 1:1 household_id2 personid using "${ETH_W3_created_data}/Ethiopia_ESS_LSMS_ISA_W3_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1				// this line will set to zero for all women for whom it is missing (i.e. regardless of ownerhsip status)
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*Adding individual economic activities
merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_agworker.dta", nogen
merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_W3_business_owners_ind.dta", nogen
merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_wage_worker.dta", nogen
replace business_owner=0 if business_owner==.

preserve
	gen farm_manager_female = farm_manager if mem_gender==2
	gen farm_manager_female_adult = farm_manager_female if age>14 & age<65
	gen livestock_keeper_female = livestock_keeper if mem_gender==2
	gen livestock_keeper_female_adult = livestock_keeper_female if age>14 & age<65
	gen agworker_female = agworker if mem_gender==2
	gen agworker_female_adult = agworker_female if age>14 & age<65
	gen business_owner_female = business_owner if mem_gender==2
	gen business_owner_female_adult = business_owner_female if age>14 & age<65
	gen wage_worker_female = wage_worker if mem_gender==2
	gen wage_worker_female_adult = wage_worker_female if age>14 & age<65
	ren household_id2 hhid
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_female_manager_individual.dta", replace
	ren hhid household_id2
	collapse (sum) num_farm_manager_female=farm_manager_female num_livestock_keeper_female=livestock_keeper_female num_business_owner_female=business_owner_female num_agworker_female=agworker_female /*
	*/ num_wage_worker_female=wage_worker_female num_farm_manager_female_ad=farm_manager_female_adult num_livestock_keeper_female_ad=livestock_keeper_female_adult num_business_owner_female_ad=business_owner_female_adult /*
	*/ num_agworker_female_ad=agworker_female_adult num_wage_worker_female_ad= wage_worker_female_adult, by(household_id2)
	save "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_female_manager.dta", replace
restore

*Adding improved seed use by crop 
foreach cn in $topcropname_area {
	merge 1:1 household_id2 personid using "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_farmer_improvedseed_use_`cn'.dta", nogen
}

lab var personid "Person ID"
lab var household_id2 "Household ID"
lab var region "Region"
lab var zone "Zone"
lab var woreda "Woreda"
lab var town "Town"
lab var subcity "Subcity"
lab var kebele "Kebele"
lab var ea "Enumeration area"
lab var rural "1= Rural"
lab var pw_w3 "Household weight"
lab var women_control_all_income "Invidual has control over at least one type of income"
lab var women_decision_ag "Invidual makes decision about livestock production activities"
lab var women_asset "Invidual owns an assets (land or livestock)"

replace all_imprv_seed_use=0 if all_imprv_seed_use==. & farm_manager==1
replace female_imprv_seed_use=0 if female_imprv_seed_use==. & farm_manager==1 & mem_gender==2
replace male_imprv_seed_use=0 if male_imprv_seed_use==. & farm_manager==1 & mem_gender==1
replace all_use_inorg_fert=0 if all_use_inorg_fert==. & farm_manager==1
replace female_use_inorg_fert=0 if female_use_inorg_fert==. & farm_manager==1 & mem_gender==2
replace male_use_inorg_fert=0 if male_use_inorg_fert==. & farm_manager==1 & mem_gender==1
replace all_vac_animal=0 if all_vac_animal==. & livestock_keeper==1
replace female_vac_animal=0 if female_vac_animal==. & livestock_keeper==1 & mem_gender==2
replace male_vac_animal=0 if male_vac_animal==. & livestock_keeper==1 & mem_gender==1

*Generating rural codes for individuals
bysort household_id2: egen rural_temp= mean(rural)
replace rural= rural_temp if rural==.
drop rural_temp

*Merge in hh variable to determine ag household
preserve
use "${ETH_W3_final_data}/Ethiopia_ESS_LSMS_ISA_W3_household_variables.dta", clear
rename hhid household_id2
keep household_id2 ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 household_id2 using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

//////////Identifier Variables ////////
*Add variables and rename household id so dta file can be appended with dta files from other instruments
rename household_id2 hhid
rename personid indid
gen geography = "Ethiopia"
gen survey = "LSMS-ISA"
gen year = "2015-16"
gen instrument = 7
label define instrument 1 "TZA NPS Wave 1" 2 "TZA NPS Wave 2" 3 "TZA NPS Wave 3" 4 "TZA NPS Wave 4" /*
	*/ 5 "ETH ESS Wave 1" 6 "ETH ESS Wave 2" 7 "ETH ESS Wave 3" /*
	*/ 8 "NGA GHSP Wave 1" 9 "NGA GHSP Wave 2" 10 "NGA GHSP Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "ETH ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	
save "$ETH_W3_final_data/Ethiopia_ESS_LSMS_ISA_W3_individual_variables.dta", replace


*End of dta creation. Below is output of summary statistics




**************
*SUMMARY STATISTICS
************** 

/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
To consider a different sup_population or the entire sample, you have to modify the condition "if rural==1".
*/ 

set  matsize 10000

*Setting directories for summary statistics
global final_data_household  "${ETH_W3_final_data}/Ethiopia_ESS_LSMS_ISA_W3_household_variables.dta"  
global final_data_individual "${ETH_W3_final_data}/Ethiopia_ESS_LSMS_ISA_W3_individual_variables.dta"
global final_data_plot       "$ETH_W3_created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_productivity_gap.dta"
global final_outputfile      "$ETH_W3_final_data/Ethiopia_ESS_LSMS_ISA_W3_summary_stats_100918.xlsx"

global topcropname_area_full "maize rice wheat sorgum millet cowpea grdnt bean yam swtptt cassav banana teff barley coffee sesame hsbean nueg"  	


use "$final_data_household", replace
*Group 1 : All variables that uses household weights
*Generating empty variables to keep code the same across instruments
gen w_share_fishing=0
gen fishing_hh=0
gen w_fishing_income_1ppp=0
gen w_fishing_income_2ppp=0
gen w_fishing_income_loc=0
gen use_fin_serv_others=0

foreach v of varlist /*
*/ w_share_crop w_total_income_1ppp w_percapita_income_1ppp w_crop_income_1ppp w_cost_expli_hh_1ppp w_daily_percap_cons_1ppp w_daily_peraeq_cons_1ppp /*		
*/ w_total_income_2ppp w_percapita_income_2ppp w_crop_income_2ppp w_cost_expli_hh_2ppp w_daily_percap_cons_2ppp w_daily_peraeq_cons_2ppp /*
*/ w_total_income_loc w_percapita_income_loc w_crop_income_loc w_cost_expli_hh_loc w_daily_percap_cons_loc w_daily_peraeq_cons_loc {
	gen `v'0Ha=`v' if farm_size_0_0==1
	gen `v'01Ha=`v' if farm_size_0_1==1
	gen `v'12Ha=`v' if farm_size_1_2==1
	gen `v'24Ha=`v' if farm_size_2_4==1
	gen `v'4Ha_=`v' if farm_size_4_more==1
	local l`v' : var lab `v'
	lab var `v'0Ha "`l`v'' - HH with no farm"
	lab var `v'01Ha "`l`v'' - HH with farm size [0-1 Ha]"
	lab var `v'12Ha "`l`v'' - HH with farm size [1-2 Ha]"
	lab var `v'24Ha "`l`v'' - HH with farm size ]2-h Ha]"
	lab var `v'4Ha_ "`l`v'' - HH with farm size ]4 ha and more"
}

*Adding more empty variables
gen grew_cowpea=0
gen grew_yam=0
gen imprv_seed_cowpea=0
gen imprv_seed_yam=0
gen hybrid_seed_cowpea=0
gen hybrid_seed_yam=0
 
foreach v in $topcropname_area_full {		
	gen grew_`v'01Ha=grew_`v' if farm_size_0_1==1
	gen grew_`v'12Ha=grew_`v' if farm_size_1_2==1
	gen grew_`v'24Ha=grew_`v' if farm_size_2_4==1
	gen grew_`v'4Ha=grew_`v' if farm_size_4_more==1
}

*renaming variables with names that are too long
foreach i in 1ppp 2ppp loc{
	rename w_livestock_income_`i' w_lvstck_income_`i'
	rename w_fishing_income_`i' w_fish_income_`i'
	rename w_self_employment_income_`i' w_self_emp_income_`i'
}

*Crop income, livestock income, fishing income, livestock_holding, are reported for 2 different subpopulation : all rural HH and rural HH engaged in the specific activities
foreach v of varlist w_crop_income*ppp* w_crop_income*loc* w_share_crop* {
	local l`v' : var lab `v' 
	gen `v'4crop1=`v' if crop_hh==1
	lab var `v'4crop1 "`l`v'' - only for crop producing household"
}
foreach v of varlist w_lvstck_income_1ppp w_lvstck_income_2ppp w_lvstck_income_loc w_share_livestock lvstck_holding* {
	local l`v' : var lab `v' 
	gen `v'4ls_hh=`v' if livestock_hh==1
	lab var `v'4ls_hh "`l`v'' - only for livestock producing household"
}
foreach v of varlist  w_fish_income_1ppp w_fish_income_2ppp w_fish_income_loc w_share_fishing {
	local l`v' : var lab `v' 
	gen `v'4fish_hh=`v' if fishing_hh==1
	lab var `v'4fish_hh "`l`v'' - only for household with fishing income"
}

*Set crop improved seed adoption to missing if household is not growing crop
foreach cn in $topcropname_area_full {
	replace imprv_seed_`cn' =. if grew_`cn'==0 | grew_`cn'==.
	recode imprv_seed_`cn' (.=0) if grew_`cn'==1
	replace hybrid_seed_`cn' =. if grew_`cn'==0 | grew_`cn'==.
	recode hybrid_seed_`cn' (.=0) if grew_`cn'==1
}
gen share_imp_dairy=0
gen w_value_assets_1ppp=0 
gen w_value_assets_2ppp=0 
gen w_value_assets_loc=0 
gen hhs_little = 0 
gen hhs_moderate = 0
gen hhs_severe = 0
gen hhs_total=0
gen w_dist_agrodealer=0

global household_vars1 /*
*/ w_total_income_1ppp w_total_income_1ppp0Ha w_total_income_1ppp01Ha w_total_income_1ppp12Ha w_total_income_1ppp24Ha w_total_income_1ppp4Ha_  /*
*/ w_total_income_2ppp w_total_income_2ppp0Ha w_total_income_2ppp01Ha w_total_income_2ppp12Ha w_total_income_2ppp24Ha w_total_income_2ppp4Ha_  /*
*/ w_total_income_loc w_total_income_loc0Ha w_total_income_loc01Ha w_total_income_loc12Ha w_total_income_loc24Ha w_total_income_loc4Ha_  /*
*/ w_percapita_income_1ppp w_percapita_income_1ppp0Ha w_percapita_income_1ppp01Ha w_percapita_income_1ppp12Ha w_percapita_income_1ppp24Ha w_percapita_income_1ppp4Ha_ /*
*/ w_percapita_income_2ppp w_percapita_income_2ppp0Ha w_percapita_income_2ppp01Ha w_percapita_income_2ppp12Ha w_percapita_income_2ppp24Ha w_percapita_income_2ppp4Ha_ /*
*/ w_percapita_income_loc w_percapita_income_loc0Ha w_percapita_income_loc01Ha w_percapita_income_loc12Ha w_percapita_income_loc24Ha w_percapita_income_loc4Ha_ /*
*/ w_percapita_cons_1ppp w_percapita_cons_2ppp w_percapita_cons_loc /* 
*/ w_daily_percap_cons_1ppp w_daily_percap_cons_1ppp0Ha w_daily_percap_cons_1ppp01Ha w_daily_percap_cons_1ppp12Ha w_daily_percap_cons_1ppp24Ha w_daily_percap_cons_1ppp4Ha_ /*
*/ w_daily_percap_cons_2ppp w_daily_percap_cons_2ppp0Ha w_daily_percap_cons_2ppp01Ha w_daily_percap_cons_2ppp12Ha w_daily_percap_cons_2ppp24Ha w_daily_percap_cons_2ppp4Ha_ /*
*/ w_daily_percap_cons_loc w_daily_percap_cons_loc0Ha w_daily_percap_cons_loc01Ha w_daily_percap_cons_loc12Ha w_daily_percap_cons_loc24Ha w_daily_percap_cons_loc4Ha_ /*
*/ w_peraeq_cons_1ppp w_peraeq_cons_2ppp w_peraeq_cons_loc /*
*/ w_daily_peraeq_cons_1ppp w_daily_peraeq_cons_1ppp0Ha w_daily_peraeq_cons_1ppp01Ha w_daily_peraeq_cons_1ppp12Ha w_daily_peraeq_cons_1ppp24Ha w_daily_peraeq_cons_1ppp4Ha_ /*
*/ w_daily_peraeq_cons_2ppp w_daily_peraeq_cons_2ppp0Ha w_daily_peraeq_cons_2ppp01Ha w_daily_peraeq_cons_2ppp12Ha w_daily_peraeq_cons_2ppp24Ha w_daily_peraeq_cons_2ppp4Ha_ /*
*/ w_daily_peraeq_cons_loc w_daily_peraeq_cons_loc0Ha w_daily_peraeq_cons_loc01Ha w_daily_peraeq_cons_loc12Ha w_daily_peraeq_cons_loc24Ha w_daily_peraeq_cons_loc4Ha_ /*
*/ w_crop_income_1ppp w_crop_income_1ppp01Ha w_crop_income_1ppp12Ha w_crop_income_1ppp24Ha w_crop_income_1ppp4Ha_ /*
*/ w_crop_income_1ppp4crop1 w_crop_income_1ppp01Ha4crop1 w_crop_income_1ppp12Ha4crop1 w_crop_income_1ppp24Ha4crop1 w_crop_income_1ppp4Ha_4crop1 /*
*/ w_crop_income_2ppp w_crop_income_2ppp01Ha w_crop_income_2ppp12Ha w_crop_income_2ppp24Ha w_crop_income_2ppp4Ha_ /*
*/ w_crop_income_2ppp4crop1 w_crop_income_2ppp01Ha4crop1 w_crop_income_2ppp12Ha4crop1 w_crop_income_2ppp24Ha4crop1 w_crop_income_2ppp4Ha_4crop1 /*
*/ w_crop_income_loc w_crop_income_loc01Ha w_crop_income_loc12Ha w_crop_income_loc24Ha w_crop_income_loc4Ha_ /*
*/ w_crop_income_loc4crop1 w_crop_income_loc01Ha4crop1 w_crop_income_loc12Ha4crop1 w_crop_income_loc24Ha4crop1 w_crop_income_loc4Ha_4crop1 /*
*/ w_lvstck_income_1ppp w_lvstck_income_1ppp4ls_hh /*
*/ w_lvstck_income_2ppp w_lvstck_income_2ppp4ls_hh /*
*/ w_lvstck_income_loc w_lvstck_income_loc4ls_hh /*
*/ w_fish_income_1ppp w_fish_income_1ppp4fish_hh /*
*/ w_fish_income_2ppp w_fish_income_2ppp4fish_hh /*
*/ w_fish_income_loc w_fish_income_loc4fish_hh /*
*/ w_nonagwage_income_1ppp w_nonagwage_income_2ppp w_nonagwage_income_loc w_agwage_income_1ppp w_agwage_income_2ppp w_agwage_income_loc /*
*/ w_self_emp_income_1ppp w_self_emp_income_2ppp w_self_emp_income_loc/*
*/ w_transfers_income_1ppp w_transfers_income_2ppp w_transfers_income_loc /*
*/ w_all_other_income_1ppp  w_all_other_income_2ppp w_all_other_income_loc /*
*/ w_nonfarm_income_1ppp w_nonfarm_income_2ppp w_nonfarm_income_loc/*
*/ w_share_crop w_share_crop01Ha w_share_crop12Ha w_share_crop24Ha w_share_crop4Ha_ /*
*/ w_share_crop4crop1 w_share_crop01Ha4crop1 w_share_crop12Ha4crop1 w_share_crop24Ha4crop1 w_share_crop4Ha_4crop1 /*
*/ w_share_livestock w_share_livestock4ls_hh w_share_fishing w_share_fishing4fish_hh w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ w_proportion_cropvalue_sold w_farm_size_agland hh_members adulteq w_labor_family w_labor_hired /*
*/ use_inorg_fert vac_animal vac_animal_lrum vac_animal_srum vac_animal_poultry /*
*/ ext_reach_all ext_reach_public ext_reach_private ext_reach_unspecified ext_reach_ict /*
*/ use_fin_serv_bank use_fin_serv_credit use_fin_serv_insur use_fin_serv_digital use_fin_serv_others use_fin_serv_all /* 
*/ lvstck_holding_tlu lvstck_holding_tlu4ls_hh lvstck_holding_all lvstck_holding_all4ls_hh   /*
*/ lvstck_holding_lrum lvstck_holding_lrum4ls_hh lvstck_holding_srum lvstck_holding_srum4ls_hh  lvstck_holding_poultry lvstck_holding_poultry4ls_hh /*
*/ w_mortality_rate_lrum w_mortality_rate_srum w_mortality_rate_poultry /*
*/ any_imp_herd_all any_imp_herd_lrum any_imp_herd_srum any_imp_herd_poultry share_imp_dairy /*
*/ share_livestock_prod_sold formal_land_rights_hh w_livestock_expenses_1ppp w_livestock_expenses_2ppp w_livestock_expenses_loc w_off_farm_hours_pc_all w_off_farm_hours_pc_any /*
*/ months_food_insec w_value_assets_1ppp w_value_assets_2ppp w_value_assets_loc hhs_little hhs_moderate hhs_severe hhs_total w_dist_agrodealer imprv_seed_use	

foreach cn in $topcropname_area_full {
	global household_vars1 $household_vars1 imprv_seed_`cn' hybrid_seed_`cn' 
}

global final_indicator1 ""
*first disaggregate by gender of the head of household
foreach v of global household_vars1 {
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1
	lab var `v'_fhh "`l`v'' - FHH"
	gen `v'_mhh=`v' if fhh==0
	lab var `v'_mhh "`l`v'' - MHH"
	global final_indicator1 $final_indicator1 `v'  `v'_fhh  `v'_mhh
}
*recoding variables with no observations to 0
recode w_fish_income_1ppp (.=0)
recode w_fish_income_1ppp_fhh (.=0)
recode w_fish_income_1ppp_mhh (.=0)
recode w_fish_income_1ppp4fish_hh (.=0)
recode w_fish_income_1ppp4fish_hh_fhh (.=0)
recode w_fish_income_1ppp4fish_hh_mhh (.=0)
recode w_fish_income_2ppp (.=0)
recode w_fish_income_2ppp_fhh (.=0)
recode w_fish_income_2ppp_mhh (.=0)
recode w_fish_income_2ppp4fish_hh (.=0)
recode w_fish_income_2ppp4fish_hh_fhh (.=0)
recode w_fish_income_2ppp4fish_hh_mhh (.=0)
recode w_fish_income_loc (.=0)
recode w_fish_income_loc_fhh (.=0)
recode w_fish_income_loc_mhh (.=0)
recode w_fish_income_loc4fish_hh (.=0)
recode w_fish_income_loc4fish_hh_fhh (.=0)
recode w_fish_income_loc4fish_hh_mhh (.=0)
recode w_share_fishing4fish_hh (.=0)
recode w_share_fishing4fish_hh_fhh (.=0)
recode w_share_fishing4fish_hh_mhh (.=0)
recode imprv_seed_rice_fhh (.=0)
recode hybrid_seed_rice_fhh (.=0)
foreach v in cowpea yam {
	recode imprv_seed_`v' (.=0)
	recode hybrid_seed_`v' (.=0)
	recode imprv_seed_`v'_fhh (.=0)
	recode hybrid_seed_`v'_fhh (.=0)
	recode imprv_seed_`v'_mhh (.=0)
	recode hybrid_seed_`v'_mhh (.=0)
}

tabstat ${final_indicator1} [aw=weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix final_indicator1=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) 	// get standard errors of the mean
matrix semean1=(.)
matrix colnames semean1=semean_wei
foreach v of global final_indicator1 {
	qui svy, subpop(if rural==1): mean `v'		
	matrix semean1=semean1\(el(r(table),2,1))
}
matrix final_indicator1=final_indicator1,semean1[2..rowsof(semean1),.]
matrix list final_indicator1


*Group 2: labor_productivity_ppp and land_productivity_ppp at the household level
gen w_labor_weight=weight*w_labor_total
gen w_land_weight=weight*w_farm_area

matrix final_indicator2=(.,.,.,.,.,.,.,.,.)
matrix final_indicator2a=(.,.,.,.,.,.,.,.,.)
global household_indicators2a  w_labor_productivity_1ppp w_labor_productivity_2ppp w_labor_productivity_loc

foreach v of global household_indicators2a {
	global final_indicator2a ""	
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1
	lab var `v'_fhh "`l`v'' - FHH"
	gen `v'_mhh= `v' if fhh==0
	lab var `v'_mhh "`l`v'' - MHH"
	global final_indicator2a $final_indicator2a `v' `v'_fhh  `v'_mhh
	tabstat $final_indicator2a [aw=w_labor_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp2=r(StatTotal)'	
	qui svyset clusterid [pweight=w_labor_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean2=(.)
	matrix colnames semean2=semean_wei
	foreach v of global final_indicator2a {
		qui svy, subpop(if rural==1): mean `v' 
		matrix semean2=semean2\(el(r(table),2,1))
	}
	matrix temp2=temp2,semean2[2..rowsof(semean2),.]
	matrix final_indicator2a=final_indicator2a\temp2
}	

matrix final_indicator2b=(.,.,.,.,.,.,.,.,.)
global household_indicators2b w_land_productivity_1ppp w_land_productivity_2ppp w_land_productivity_loc
foreach v of global household_indicators2b {
	global final_indicator2b ""	
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1
	lab var `v'_fhh "`l`v'' - FHH"
	gen `v'_mhh= `v' if fhh==0
	lab var `v'_mhh "`l`v'' - MHH"
	global final_indicator2b $final_indicator2b `v' `v'_fhh  `v'_mhh
	tabstat $final_indicator2b [aw=w_land_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp2=r(StatTotal)'	
	qui svyset clusterid [pweight=w_land_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean2=(.)
	matrix colnames semean2=semean_wei
	foreach v of global final_indicator2b {
		qui svy, subpop(if rural==1): mean `v' 
		matrix semean2=semean2\(el(r(table),2,1))
	}
	matrix temp2=temp2,semean2[2..rowsof(semean2),.]
	matrix final_indicator2b=final_indicator2b\temp2
}	


matrix final_indicator2a =final_indicator2a[2..rowsof(final_indicator2a), .]
matrix final_indicator2b =final_indicator2b[2..rowsof(final_indicator2b), .]
matrix final_indicator2  = final_indicator2a\final_indicator2b 

matrix list final_indicator2 


*Group 3 : daily wage in  agriculture
ren w_wage_paid_aglabor_1ppp w_wage_paid_aglabor_all_1ppp
ren w_wage_paid_aglabor_2ppp w_wage_paid_aglabor_all_2ppp
ren w_wage_paid_aglabor_loc w_wage_paid_aglabor_all_loc

recode w_wage_paid_aglabor_male_1ppp w_wage_paid_aglabor_female_1ppp w_wage_paid_aglabor_male_2ppp w_wage_paid_aglabor_female_2ppp w_wage_paid_aglabor_male_loc w_wage_paid_aglabor_female_loc(.=0) 
gen w_aglabor_weight_all=w_labor_hired*weight
lab var w_aglabor_weight_all "Hired labor-adjusted household weights"
gen w_aglabor_weight_female=1  
lab var w_aglabor_weight_female "Hired labor-adjusted household weights -female workers"
gen w_aglabor_weight_male=1 
lab var w_aglabor_weight_male "Hired labor-adjusted household weights -male workers"

global final_indicator3a "all female male"
matrix final_indicator3a=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator3a {
	tabstat w_wage_paid_aglabor_`v'_1ppp [aw=w_aglabor_weight_`v'] if rural==1, stat(mean  sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	svyset clusterid [pweight=w_aglabor_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean w_wage_paid_aglabor_`v'_1ppp
	matrix final_indicator3a=final_indicator3a\(temp4,el(r(table),2,1))
}
matrix final_indicator3a =final_indicator3a[2..rowsof(final_indicator3a), .]


global final_indicator3a "all female male"
matrix final_indicator3b=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator3a {
	tabstat w_wage_paid_aglabor_`v'_2ppp [aw=w_aglabor_weight_`v'] if rural==1, stat(mean  sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	svyset clusterid [pweight=w_aglabor_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean w_wage_paid_aglabor_`v'_2ppp
	matrix final_indicator3b=final_indicator3b\(temp4,el(r(table),2,1))
}
matrix final_indicator3b =final_indicator3b[2..rowsof(final_indicator3b), .]

global final_indicator3a "all female male"
matrix final_indicator3c=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator3a {
	tabstat w_wage_paid_aglabor_`v'_loc [aw=w_aglabor_weight_`v'] if rural==1, stat(mean  sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	svyset clusterid [pweight=w_aglabor_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean w_wage_paid_aglabor_`v'_loc
	matrix final_indicator3c=final_indicator3c\(temp4,el(r(table),2,1))
}
matrix final_indicator3c =final_indicator3c[2..rowsof(final_indicator3c), .]

matrix final_indicator3 = final_indicator3a\final_indicator3b\final_indicator3c
matrix list final_indicator3  
 

 
 ** Group 4  - yields 
*set yield to missing when the crop is not availlable in a given instrument so that this code will work and most importantly the output will have the same structure accross instruments
 
global final_indicator4=""
foreach v in $topcropname_area_full {
	global final_indicator4 $final_indicator4 `v' female_`v' male_`v' mixed_`v'
}

*adding in purestand yields
foreach v in $topcropname_area_full {
	global final_indicator4 $final_indicator4 pure_`v' pure_female_`v' pure_male_`v' pure_mixed_`v' 
}

*Generating missing variables (yam and cowpea are not in this instrument)
foreach v in cowpea yam {
	gen w_yield_hv_`v' = 0
	gen w_yield_pl_`v' = 0
	gen w_yield_hv_pure_`v' = 0
	gen w_yield_pl_pure_`v' = 0
	gen ar_h_wgt_`v' =1
	gen ar_pl_wgt_`v' =1
	gen ar_h_wgt_pure_`v' =1
	gen ar_pl_wgt_pure_`v' =1
	foreach x in female male mixed {
		gen w_yield_hv_`x'_`v' =0
		gen w_yield_pl_`x'_`v' = 0
		gen w_yield_hv_pure_`x'_`v' = 0
		gen w_yield_pl_pure_`x'_`v' = 0
		gen ar_h_wgt_`x'_`v' =1
		gen ar_pl_wgt_`x'_`v' =1
		gen ar_h_wgt_pure_`x'_`v' =1
		gen ar_pl_wgt_pure_`x'_`v' =1
	}		
}

matrix final_indicator4a=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator4 {
	tabstat w_yield_hv_`v' [aw=ar_h_wgt_`v'] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	qui svyset clusterid [pweight=ar_h_wgt_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean w_yield_hv_`v'
	matrix final_indicator4a=final_indicator4a\(temp4,el(r(table),2,1))	
}

matrix final_indicator4b=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator4 {
	tabstat w_yield_pl_`v' [aw=ar_pl_wgt_`v'] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	qui svyset clusterid [pweight=ar_pl_wgt_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean w_yield_pl_`v'
	matrix final_indicator4b=final_indicator4b\(temp4,el(r(table),2,1))	
}

matrix final_indicator4a =final_indicator4a[2..rowsof(final_indicator4a), .]
matrix final_indicator4b =final_indicator4b[2..rowsof(final_indicator4b), .]

matrix final_indicator4  = final_indicator4a\final_indicator4b 
matrix list final_indicator4


* Group 5  - milk and egg productivity
gen liters_per_all=0
gen w_liters_per_all=0
gen liters_per_buffalo=0 	/*not possible for ETH so all is missing*/
gen w_liters_per_buffalo=0
gen liters_per_largeruminant=0
gen w_liters_per_largeruminant=0
gen weight_milk=milk_animals*weight
gen weight_egg=poultry_owned*weight
replace w_liters_per_all=. if weight_milk==0  | weight_milk==.
replace w_liters_per_cow=. if weight_milk==0 | weight_milk==.
replace w_value_milk_produced_1ppp=. if weight_milk==0  | weight_milk==.
replace w_egg_poultry_year=. if weight_egg==0  |  weight_egg==.
replace w_egg_poultry_year=. if weight_egg==0  |  weight_egg==.
replace w_value_eggs_produced_1ppp=. if weight_egg==0  |  weight_egg==.

global household_indicators5 liters_per_all liters_per_cow liters_per_buffalo costs_dairy_1ppp costs_dairy_2ppp costs_dairy_loc /*
*/ cost_per_lit_milk_1ppp cost_per_lit_milk_2ppp cost_per_lit_milk_loc /*
*/ costs_dairy_percow_1ppp  costs_dairy_percow_2ppp  costs_dairy_percow_loc egg_poultry_year
global final_indicator5  
foreach v of global household_indicators5 {
	local l`v' : var lab w_`v' 
	gen w_`v'_fhh=w_`v' if fhh==1
	lab var w_`v'_fhh "`l`v'' - FHH"
	gen w_`v'_mhh=w_`v' if fhh==0
	lab var w_`v'_mhh "`l`v'' - MHH"
}

*Add condition that household must be engaged in livestock production
global milkvar w_liters_per_all w_liters_per_all_fhh w_liters_per_all_mhh w_liters_per_cow w_liters_per_cow_fhh w_liters_per_cow_mhh /*
*/ w_liters_per_buffalo w_liters_per_buffalo_fhh w_liters_per_buffalo_mhh /*
*/ w_costs_dairy_1ppp w_costs_dairy_1ppp_fhh w_costs_dairy_1ppp_mhh /*
*/ w_costs_dairy_2ppp w_costs_dairy_2ppp_fhh w_costs_dairy_2ppp_mhh /*
*/ w_costs_dairy_loc w_costs_dairy_loc_fhh w_costs_dairy_loc_mhh /*
*/w_costs_dairy_percow_1ppp w_costs_dairy_percow_1ppp_fhh w_costs_dairy_percow_1ppp_mhh /*
*/w_costs_dairy_percow_2ppp w_costs_dairy_percow_2ppp_fhh w_costs_dairy_percow_2ppp_mhh /*
*/w_costs_dairy_percow_loc w_costs_dairy_percow_loc_fhh w_costs_dairy_percow_loc_mhh /*
*/ w_cost_per_lit_milk_1ppp w_cost_per_lit_milk_1ppp_fhh w_cost_per_lit_milk_1ppp_mhh /*
*/ w_cost_per_lit_milk_2ppp w_cost_per_lit_milk_2ppp_fhh w_cost_per_lit_milk_2ppp_mhh /*
*/ w_cost_per_lit_milk_loc w_cost_per_lit_milk_loc_fhh w_cost_per_lit_milk_loc_mhh

tabstat $milkvar  [aw=weight_milk] if rural==1 , stat(mean sd p25 p50 p75  min max N) col(stat) save 
matrix final_indicator5=r(StatTotal)' 
qui svyset clusterid [pweight=weight_milk], strata(strataid) singleunit(centered) // get standard errors of the mean	
matrix semean5=(.)
matrix colnames semean5=semean_wei
foreach v of global milkvar {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean5=semean5\(el(r(table),2,1))
}
matrix final_indicator5=final_indicator5,semean5[2..rowsof(semean5),.]

global eggvar w_egg_poultry_year w_egg_poultry_year_fhh w_egg_poultry_year_mhh
tabstat $eggvar [aw=weight_egg] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix temp5=r(StatTotal)' 
matrix semean5=(.)
matrix colnames semean5=semean_wei
foreach v of global eggvar {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean5=semean5\(el(r(table),2,1))
}
matrix temp5=temp5,semean5[2..rowsof(semean5),.]
matrix final_indicator5=final_indicator5\temp5
matrix list final_indicator5 


* Group 6  - inorg_fert_rate_all
ren w_inorg_fert_rate w_inorg_fert_rate_all
ren w_ha_planted w_ha_planted_all
*We are reporting inorg_fert_rate for 2 sub-population
*All rural housholds engaged in crop production
*All rural households engaged in crop production using inorganic fertilizer
recode w_inorg_fert_rate* (.=0) if crop_hh==1
global final_indicator6 ""
global fert_vars all female male mixed

foreach  v of global fert_vars {
	gen area_weight_`v'=weight*w_ha_planted_`v'
	local l`v' : var lab w_inorg_fert_rate_`v' 
	gen w_inorg_fert_rate_`v'use_fert=w_inorg_fert_rate_`v'  if  w_inorg_fert_rate_`v'!=0
	lab var w_inorg_fert_rate_`v'use_fert "`l`v'' - only household using ferttilizer"
}
*All hh engaged in crop production
global final_indicator6 all female male mixed
matrix final_indicator6=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator6 {
	tabstat w_inorg_fert_rate_`v' [aw=area_weight_`v'] if rural==1,  stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp6=r(StatTotal)'
	qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean w_inorg_fert_rate_`v'
	matrix final_indicator6=final_indicator6\(temp6,el(r(table),2,1))
}
*Only hh engaged in crop production and using fertilizer
foreach v of global final_indicator6 {
	tabstat  w_inorg_fert_rate_`v'use_fert [aw=area_weight_`v'] if rural==1  & ag_hh==1  & w_inorg_fert_rate_`v'!=. & w_inorg_fert_rate_`v'!=0,  stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp6=r(StatTotal)'
	qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean  w_inorg_fert_rate_`v'use_fert
	matrix final_indicator6=final_indicator6\(temp6,el(r(table),2,1))
}

matrix final_indicator6 =final_indicator6[2..rowsof(final_indicator6), .]
matrix list final_indicator6 


* Group 7  - total explicit cost at the household level, also by farm type and gender of HoH
global household_indicators7a cost_expli_hh_1ppp cost_expli_hh_1ppp01Ha cost_expli_hh_1ppp12Ha cost_expli_hh_1ppp24Ha cost_expli_hh_1ppp4Ha_  /*
*/ cost_expli_hh_2ppp cost_expli_hh_2ppp01Ha cost_expli_hh_2ppp12Ha cost_expli_hh_2ppp24Ha cost_expli_hh_2ppp4Ha_  /*
*/ cost_expli_hh_loc cost_expli_hh_loc01Ha cost_expli_hh_loc12Ha cost_expli_hh_loc24Ha cost_expli_hh_loc4Ha_ 

matrix final_indicator7a=(.,.,.,.,.,.,.,.,.)
foreach v of global household_indicators7a {
	global final_indicator7a ""	
	local l`v' : var lab w_`v' 
	gen w_`v'_fhh=w_`v' if fhh==1
	lab var w_`v'_fhh "`l`v'' - FHH"
	gen w_`v'_mhh=w_`v' if fhh==0
	lab var w_`v'_mhh "`l`v'' - MHH"
	global final_indicator7a $final_indicator7a w_`v'  w_`v'_fhh  w_`v'_mhh
	tabstat $final_indicator7a [aw=weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp7a=r(StatTotal)'	
	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean7a=(.)
	matrix colnames semean7a=semean_wei
	foreach v of global final_indicator7a {
		qui svy, subpop(if rural==1): mean `v' 
		matrix semean7a=semean7a\(el(r(table),2,1))
	}
	matrix temp7a=temp7a,semean7a[2..rowsof(semean7a),.]
	matrix final_indicator7a=final_indicator7a\temp7a
}	
matrix final_indicator7a =final_indicator7a[2..rowsof(final_indicator7a), .]


global household_indicators7b cost_expli_hh_ha_1ppp cost_expli_hh_ha_2ppp cost_expli_hh_ha_loc

gen w_ha_planted_weight=w_ha_planted_all*weight
matrix final_indicator7b=(.,.,.,.,.,.,.,.,.)
foreach v of global household_indicators7b {
	global final_indicator7b ""	
	local l`v' : var lab w_`v' 
	gen w_`v'_fhh=w_`v' if fhh==1
	lab var w_`v'_fhh "`l`v'' - FHH"
	gen w_`v'_mhh=w_`v' if fhh==0
	lab var w_`v'_mhh "`l`v'' - MHH"
	global final_indicator7b $final_indicator7b w_`v'  w_`v'_fhh  w_`v'_mhh
	tabstat $final_indicator7b [aw=w_ha_planted_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp7b=r(StatTotal)'	
	qui svyset clusterid [pweight=w_ha_planted_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean7b=(.)
	matrix colnames semean7b=semean_wei
	foreach v of global final_indicator7b {
		qui svy, subpop(if rural==1): mean `v' 
		matrix semean7b=semean7b\(el(r(table),2,1))
	}
	matrix temp7b=temp7b,semean7b[2..rowsof(semean7b),.]
	matrix final_indicator7b=final_indicator7b\temp7b
}	


matrix final_indicator7b =final_indicator7b[2..rowsof(final_indicator7b), .]

matrix final_indicator7 =final_indicator7a\final_indicator7b
matrix list final_indicator7


* Group 8  - total explicit cost per ha by gender of plot manager, also by farm type
*Explicit cost by farm type
ren w_cost_expli_ha_1ppp w_cost_expli_ha_all_1ppp		
ren w_cost_expli_ha_2ppp w_cost_expli_ha_all_2ppp
ren w_cost_expli_ha_loc w_cost_expli_ha_all_loc

global final_indicator8 all female male  mixed
foreach v of global final_indicator8 {
	foreach i in 1ppp 2ppp loc {
		gen w_cost_expli_ha_`v'01Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_0_1==1
		gen w_cost_expli_ha_`v'12Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_1_2==1
		gen w_cost_expli_ha_`v'24Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_2_4==1
		gen w_cost_expli_ha_`v'4Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_4_more==1	
		local l`v' : var label w_cost_expli_ha_`v'_`i'
		lab var w_cost_expli_ha_`v'01Ha_`i' "`l`v'' - farm size [0-1 Ha]"
		lab var w_cost_expli_ha_`v'12Ha_`i' "`l`v'' - farm size [1-2 Ha]"
		lab var w_cost_expli_ha_`v'24Ha_`i' "`l`v'' - farm size ]2-h Ha]"
		lab var w_cost_expli_ha_`v'4Ha_`i' "`l`v'' - farm size ]4 ha and more"
	}
}

matrix final_indicator8=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator8 {
	foreach i in 1ppp 2ppp loc {
		tabstat w_cost_expli_ha_`v'_`i' w_cost_expli_ha_`v'01Ha_`i' w_cost_expli_ha_`v'12Ha_`i' w_cost_expli_ha_`v'24Ha_`i' w_cost_expli_ha_`v'4Ha_`i'  [aw=w_ha_planted_weight]   if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp8=r(StatTotal)'
		qui svyset clusterid [pweight=w_ha_planted_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'_`i'
		scalar se`v'= el(r(table),2,1)
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'01Ha_`i' 
		scalar se`v'01Ha= el(r(table),2,1)
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'12Ha_`i' 
		scalar se`v'12Ha= el(r(table),2,1)		
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'24Ha_`i' 
		scalar se`v'24Ha= el(r(table),2,1)	
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'4Ha_`i' 
		scalar se`v'4Ha_= el(r(table),2,1)	
	
		matrix temp8=temp8,(se`v'\se`v'01Ha\se`v'12Ha\se`v'24Ha\se`v'4Ha_)
		matrix final_indicator8=final_indicator8\temp8	
	}
}

matrix final_indicator8 =final_indicator8[2..rowsof(final_indicator8), .]
matrix list final_indicator8  


** Group 9 - costs_total_hh_1ppp  (explicit and implicit)
*Adding empty variables (no cowpea or yam in this instrument)
foreach v in cowpea yam {
	gen w_`v'_monocrop_ha=0		
	gen w_kgs_harv_mono_`v'=0
	foreach x in male female mixed {
		gen w_`v'_monocrop_ha_`x'=0
		gen w_kgs_harv_mono_`v'_`x'=0
	}
}

*generate area weights for monocropped plots
foreach cn in $topcropname_area_full {
	gen ar_pl_mono_wgt_`cn'_all = weight*w_`cn'_monocrop_ha	
	gen kgs_harv_wgt_`cn'_all = weight*w_kgs_harv_mono_`cn'
	foreach g in male female mixed {
		gen ar_pl_mono_wgt_`cn'_`g' = weight*w_`cn'_monocrop_ha_`g'
		gen kgs_harv_wgt_`cn'_`g' = weight*w_kgs_harv_mono_`cn'_`g'
	}
}

*Adding empty variables (no cowpea or yam in this instrument)
foreach v in cowpea yam {
	recode ar_pl_mono_wgt_`v'_all (0=1)
	recode kgs_harv_wgt_`v'_all (0=1)
	foreach i in 1ppp 2ppp loc {
		gen w_`v'_exp_`i' = 0
		gen w_`v'_exp_ha_`i' = 0
		gen w_`v'_exp_kg_`i' = 0
		foreach x in male female mixed {
			recode ar_pl_mono_wgt_`v'_`x' (0=1)
			recode kgs_harv_wgt_`v'_`x' (0=1)
			gen w_`v'_exp_`x'_`i' = 0
			gen w_`v'_exp_ha_`x'_`i' = 0
			gen w_`v'_exp_kg_`x'_`i' = 0
		}
	}
}

foreach i in 1ppp 2ppp loc {		
	ren w_cost_total_ha_`i' w_cost_total_ha_all_`i'		
	foreach v in $topcropname_area_full {
		ren w_`v'_exp_`i' w_`v'_exp_all_`i' 
		ren w_`v'_exp_ha_`i' w_`v'_exp_ha_all_`i'
		ren w_`v'_exp_kg_`i' w_`v'_exp_kg_all_`i'
	}
}

global final_indicator9 all female male  mixed
matrix final_indicator9=(.,.,.,.,.,.,.,.,.)
foreach i in 1ppp 2ppp loc {
	foreach v of global final_indicator9 {		
		tabstat w_cost_total_ha_`v'_`i'  [aw=area_weight_`v']  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp9=r(StatTotal)'
		qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
		capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_total_ha_`v'_`i'
		matrix final_indicator9=final_indicator9\(temp9,el(r(table),2,1))
	}
}
matrix final_indicator9 =final_indicator9[2..rowsof(final_indicator9), .]

matrix temp9b = (.,.,.,.,.,.,.,.,.)
foreach i in 1ppp 2ppp loc {
	foreach v of global final_indicator9 {
		foreach x in $topcropname_area_full {		
			tabstat w_`x'_exp_`v'_`i'  [aw=weight]  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp9c=r(StatTotal)'
			qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
			capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean w_`x'_exp_`v'_`i'
			matrix temp9b=temp9b\(temp9c,el(r(table),2,1))
		}
	}
}
matrix temp9b =temp9b[2..rowsof(temp9b), .]

matrix temp9d = (.,.,.,.,.,.,.,.,.)
foreach i in 1ppp 2ppp loc {
	foreach v of global final_indicator9 {
		foreach x in $topcropname_area_full {		
			tabstat w_`x'_exp_ha_`v'_`i'  [aw=ar_pl_mono_wgt_`x'_`v']  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp9e=r(StatTotal)'
			qui svyset clusterid [pw=ar_pl_mono_wgt_`x'_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
			capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean w_`x'_exp_ha_`v'_`i'
			matrix temp9d=temp9d\(temp9e,el(r(table),2,1))
		}
	}
}
matrix temp9d =temp9d[2..rowsof(temp9d), .]

matrix temp9f = (.,.,.,.,.,.,.,.,.)
foreach i in 1ppp 2ppp loc {
	foreach v of global final_indicator9 {
		foreach x in $topcropname_area_full {		
			tabstat w_`x'_exp_kg_`v'_`i'  [aw=kgs_harv_wgt_`x'_`v']  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp9g=r(StatTotal)'
			qui svyset clusterid [pw=kgs_harv_wgt_`x'_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
			capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean w_`x'_exp_kg_`v'_`i'
			matrix temp9f=temp9f\(temp9g,el(r(table),2,1))
		}
	}
}
matrix temp9f =temp9f[2..rowsof(temp9f), .]

matrix final_indicator9 =final_indicator9\temp9b\temp9d\temp9f
matrix list final_indicator9


** Group 10 - per_capita income using individual weight
global final_indicator10a ""

foreach  v of varlist w_percapita_income_1ppp w_percapita_income_2ppp w_percapita_income_loc w_daily_percap_cons_1ppp w_daily_percap_cons_2ppp w_daily_percap_cons_loc {
	local l`v' : var lab `v' 
	gen `v'_nat= `v'  
	lab var `v'_nat "`l`v'' - using individual weight"
	gen `v'_nat_fhh=`v' if fhh==1	
	lab var `v'_nat_fhh "`l`v'' - FHH- using individual weight"
	gen `v'_nat_mhh=`v' if fhh==0	
	lab var `v'_nat_mhh "`l`v'' - MHH- using individual weight"
	global final_indicator10a $final_indicator10a `v'_nat  `v'_nat_fhh `v'_nat_mhh
}


global final_indicator10b ""
foreach i in 1ppp 2ppp loc {
	foreach  v of varlist w_daily_peraeq_cons_`i' {
		local l`v' : var lab `v' 
		gen `v'_nat= `v'  
		lab var `v'_nat "`l`v'' - using adult equivalent weight"
		gen `v'_nat_fhh=`v' if fhh==1	
		lab var `v'_nat_fhh "`l`v'' - FHH- using adult equivalent weight"
		gen `v'_nat_mhh=`v' if fhh==0	
		lab var `v'_nat_mhh "`l`v'' - MHH- using adult equivalent weight"
		global final_indicator10b $final_indicator10b `v'_nat  `v'_nat_fhh `v'_nat_mhh
	}
}
gen individual_weight=hh_members*weight
gen adulteq_weight=adulteq*weight

*Average consumption expenditure of the bottom 40% of the rural consumption expenditure distribution
*First, generating variable that reports the individuals in the bottom 40% of rural consumption expenditures
_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40 = 0
replace bottom_40 = 1 if r(r1) > w_daily_percap_cons & rural==1

*By peraeq consumption
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1

*percapita consumption
global final_indicator10c ""
foreach i in 1ppp 2ppp loc {
	foreach v of varlist w_daily_percap_cons_`i' {
		local l`v' : var lab `v' 
		gen `v'_b40= `v' if bottom_40==1  
		lab var `v'_b40 "`l`v'' - limited to bottom 40% of consumption for rural population - using adult equivalent weight"
		gen `v'_b40_fhh=`v' if fhh==1	
		lab var `v'_b40_fhh "`l`v'' - limited to bottom 40% of consumption for rural population - FHH - using adult equivalent weight"
		gen `v'_b40_mhh=`v' if fhh==0	
		lab var `v'_b40_mhh "`l`v'' - limited to bottom 40% of consumption for rural population - MHH - using adult equivalent weight"
		global final_indicator10c $final_indicator10c `v'_b40  `v'_b40_fhh `v'_b40_mhh
	}
}

*adult equivalent consumption
global final_indicator10d ""
foreach i in 1ppp 2ppp loc {
	foreach v of varlist w_daily_peraeq_cons_`i' {
		local l`v' : var lab `v' 
		gen `v'_b40= `v' if bottom_40_peraeq==1  
		lab var `v'_b40 "`l`v'' - limited to bottom 40% of consumption for rural population - using adult equivalent weight"
		gen `v'_b40_fhh=`v' if fhh==1	
		lab var `v'_b40_fhh "`l`v'' - limited to bottom 40% of consumption for rural population - FHH - using adult equivalent weight"
		gen `v'_b40_mhh=`v' if fhh==0	
		lab var `v'_b40_mhh "`l`v'' - limited to bottom 40% of consumption for rural population - MHH - using adult equivalent weight"
		global final_indicator10d $final_indicator10d `v'_b40 `v'_b40_fhh `v'_b40_mhh
	}
}

*Rural poverty headcount
global final_indicator10e ""
foreach v of varlist poverty_under_1_9 {
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1	
	lab var `v'_fhh "`l`v'' - FHH"
	gen `v'_mhh=`v' if fhh==0	
	lab var `v'_mhh "`l`v'' - MHH"
	global final_indicator10e $final_indicator10e `v'  `v'_fhh `v'_mhh
}	

matrix final_indicator10a=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10a {
	tabstat `v' [aw=individual_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean  `v'
	matrix final_indicator10a=final_indicator10a\(temp10,el(r(table),2,1))	
}
matrix final_indicator10a =final_indicator10a[2..rowsof(final_indicator10a), .]

matrix final_indicator10b=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10b {
	tabstat `v' [aw=adulteq_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean  `v'
	matrix final_indicator10b=final_indicator10b\(temp10,el(r(table),2,1))	
}

matrix final_indicator10b =final_indicator10b[2..rowsof(final_indicator10b), .]

matrix final_indicator10c=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10c {
	tabstat `v' [aw=adulteq_weight] if rural==1 & bottom_40==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=adulteq_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1 & bottom_40==1): mean  `v'
	matrix final_indicator10c=final_indicator10c\(temp10,el(r(table),2,1))	
}

matrix final_indicator10c =final_indicator10c[2..rowsof(final_indicator10c), .]

matrix final_indicator10d=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10d {
	tabstat `v' [aw=adulteq_weight] if rural==1 & bottom_40_peraeq==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=adulteq_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1 & bottom_40_peraeq==1): mean  `v'
	matrix final_indicator10d=final_indicator10d\(temp10,el(r(table),2,1))	
}

matrix final_indicator10d =final_indicator10d[2..rowsof(final_indicator10d), .]

matrix final_indicator10e=(.,.,.,.,.,.,.,.,.)
global poverty_count ""
qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
foreach v of global final_indicator10e {
    gen tot_`v'=`v'
	local l`v' : var lab `v' 
	lab var tot_`v' " Total : `l`v''"
	svy, subpop(if rural==1): total  `v'
	matrix b=e(b)
	matrix V=e(V)
	matrix N=e(N)
	matrix final_indicator10e=final_indicator10e\(el(b,1,1),. ,. ,. ,. ,. ,. ,el(N,1,1),sqrt(el(V,1,1)))
	global poverty_count $poverty_count "tot_`v'"
}

matrix final_indicator10e = final_indicator10e[2..rowsof(final_indicator10e),.]
matrix rownames final_indicator10e = $poverty_count

*poverty ratio
matrix final_indicator10f=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10e {
	tabstat `v' [aw=individual_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean  `v'
	matrix final_indicator10f=final_indicator10f\(temp10,el(r(table),2,1))	
}
matrix final_indicator10f =final_indicator10f[2..rowsof(final_indicator10f), .]


matrix final_indicator10 =final_indicator10a\final_indicator10b\final_indicator10c\final_indicator10d\final_indicator10e\final_indicator10f
matrix list final_indicator10 


* Group 11: Variables that are reported as both as average and also as total at the country level
*Starting with value of crop production
global final_indicator11 "w_value_crop_production_1ppp w_value_crop_production_2ppp w_value_crop_production_loc"
foreach v in $topcropname_area_full {
	foreach x in 1ppp 2ppp loc {
		global final_indicator11 $final_indicator11 w_value_harv_`v'_`x'
	}
}
*adding in value of crop sales
global final_indicator11 $final_indicator11 w_value_crop_sales_1ppp w_value_crop_sales_2ppp w_value_crop_sales_loc
foreach v in $topcropname_area_full {
	foreach x in 1ppp 2ppp loc {
		global final_indicator11 $final_indicator11 w_value_sold_`v'_`x'
	}
}
*adding in other non-monetary variables by crop
foreach v in $topcropname_area_full {
	global final_indicator11 $final_indicator11 w_kgs_harvest_`v' 
}
foreach v in $topcropname_area_full {
	global final_indicator11 $final_indicator11 w_total_planted_area_`v' 
}
foreach v in $topcropname_area_full {
	global final_indicator11 $final_indicator11 w_total_harv_area_`v' 
}
global final_indicator11 $final_indicator11 w_all_area_planted w_all_area_harvested
foreach v in $topcropname_area_full {
	global final_indicator11 $final_indicator11 grew_`v' grew_`v'01Ha grew_`v'12Ha grew_`v'24Ha grew_`v'4Ha		
}
*Adding in final (non-crop) variables
global final_indicator11 $final_indicator11 /*
*/agactivities_hh ag_hh crop_hh livestock_hh fishing_hh /*
*/w_liters_milk_produced w_value_milk_produced_1ppp w_value_milk_produced_2ppp w_value_milk_produced_loc /*
*/ w_eggs_total_year w_value_eggs_produced_1ppp w_value_eggs_produced_2ppp w_value_eggs_produced_loc

*Adding in empty variables (no yam or cowpea in this instrument) 
foreach v in cowpea yam {
	gen w_kgs_harvest_`v'=0
	gen w_total_planted_area_`v'=0
	gen w_total_harv_area_`v'=0
	foreach x in 1ppp 2ppp loc {
		gen w_value_harv_`v'_`x'=0
		gen w_value_sold_`v'_`x'=0
	}
}

* first report summary statistitc
matrix final_indicator11=(.,.,.,.,.,.,.,.,.)
global final_indicator11bis ""
foreach v of global final_indicator11 {
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1	
	lab var `v'_fhh "`l`v'' - FHH- using individual weight"
	gen `v'_mhh=`v' if fhh==0	
	lab var `v'_mhh "`l`v'' - MHH- using individual weight"
	global final_indicator11bis $final_indicator11bis `v'  `v'_fhh `v'_mhh
}

*Recoding missing variables
foreach v in 1ppp 2ppp loc {
	recode w_value_harv_rice_`v'_fhh (.=0)
	recode w_value_sold_rice_`v'_fhh (.=0)
}
recode w_kgs_harvest_rice_fhh (.=0)
recode w_total_planted_area_rice_fhh (.=0)
recode w_total_harv_area_rice_fhh (.=0)


foreach v of global final_indicator11bis {
	tabstat `v' [aw=weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp11=r(StatTotal)'
	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean  `v'
	matrix final_indicator11=final_indicator11\(temp11,el(r(table),2,1))	
}	
matrix final_indicator11 =final_indicator11[2..rowsof(final_indicator11), .]
matrix list final_indicator11 


* Group 12
*Now get rural total at the country level 
*since these are total, we are just keeping the estimated total and its standard errors
*there are no other meanigful statisitics
matrix final_indicator12a=J(1,9,.)
global total_vars ""
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
foreach v of global final_indicator11 {
    gen rur_`v'=`v'	
	recode rur_`v' (.=0)
	local l`v' : var lab `v' 
	lab var rur_`v' " Total : `l`v''"		
	svy, subpop(if rural==1): total  rur_`v'
	matrix b=e(b)
	matrix V=e(V)
	matrix N=e(N)
	matrix final_indicator12a=final_indicator12a\(el(b,1,1),. ,. ,. ,. ,. ,. ,el(N,1,1),sqrt(el(V,1,1)))
	global total_vars $total_vars "rur_`v'"		
}

matrix final_indicator12a=final_indicator12a[2..rowsof(final_indicator12a),.]		
matrix rownames final_indicator12a =$total_vars
matrix colnames final_indicator12a =total semean c3 c4 c5 c6 c7 c8 c9
matrix list final_indicator12a 


*Getting the total at the country level including rural and urban
matrix final_indicator12b=J(1,9,.)
global total_vars ""
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
foreach v of global final_indicator11 {
    gen tot_`v'=`v'
	recode tot_`v' (.=0)
	local l`v' : var lab `v' 
	lab var tot_`v' " Total : `l`v''"
	svy: total  tot_`v'	
	matrix b=e(b)
	matrix V=e(V)
	matrix N=e(N)
	matrix final_indicator12b=final_indicator12b\(el(b,1,1),. ,. ,. ,. ,. ,. ,el(N,1,1),sqrt(el(V,1,1)))
	global total_vars $total_vars "tot_`v'"
}

matrix final_indicator12b=final_indicator12b[2..rowsof(final_indicator12b),.]
matrix rownames final_indicator12b =$total_vars
matrix colnames final_indicator12b =total semean c3 c4 c5 c6 c7 c8 c9
matrix list final_indicator12b

matrix final_indicator12 =final_indicator12a\final_indicator12b
matrix list final_indicator12

 
*Group 13 :  plot level indicators : labor productivity, plot productivity, gender-base productivity gap
use  "$final_data_plot",  clear

foreach i in 1ppp 2ppp loc{
gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

foreach i in 1ppp 2ppp loc{
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
tabstat w_plot_productivity_`i'  [aw=plot_weight]  if rural==1 & dm_gender!=.    , stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix temp_all=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender!=. ): mean w_plot_productivity_`i'
matrix w_plot_productivity_all_`i'=temp_all,el(r(table),2,1)
 
tabstat w_plot_productivity_female_`i'  [aw=plot_weight]   if rural==1 & dm_gender==2 , stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix temp_female=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==2): mean w_plot_productivity_female_`i'
matrix w_plot_productivity_female_`i'=temp_female,el(r(table),2,1)
 
tabstat w_plot_productivity_male_`i'  [aw=plot_weight]   if rural==1 & dm_gender==1 , stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix temp_male=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==1): mean w_plot_productivity_male_`i'
matrix w_plot_productivity_male_`i'=temp_male,el(r(table),2,1)
 
tabstat w_plot_productivity_mixed_`i'  [aw=plot_weight]   if rural==1 & dm_gender==3 , stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix temp_mixed=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==3): mean w_plot_productivity_mixed_`i'
matrix w_plot_productivity_mixed_`i'=temp_mixed,el(r(table),2,1)
 }
 
matrix final_indicator13=(w_plot_productivity_all_1ppp\w_plot_productivity_female_1ppp\w_plot_productivity_male_1ppp\w_plot_productivity_mixed_1ppp\ /*
*/w_plot_productivity_all_2ppp\w_plot_productivity_female_2ppp\w_plot_productivity_male_2ppp\w_plot_productivity_mixed_2ppp\ /*
*/w_plot_productivity_all_loc\w_plot_productivity_female_loc\w_plot_productivity_male_loc\w_plot_productivity_mixed_loc)

gen plot_labor_weight= w_labor_total*weight
foreach i in 1ppp 2ppp loc{
gen w_plot_labor_prod_all_`i'=w_plot_labor_prod_`i'
gen w_plot_labor_prod_female_`i'=w_plot_labor_prod_`i' if dm_gender==2
gen w_plot_labor_prod_male_`i'=w_plot_labor_prod_`i' if dm_gender==1
gen w_plot_labor_prod_mixed_`i'=w_plot_labor_prod_`i' if dm_gender==3
}

foreach i in 1ppp 2ppp loc{
qui svyset clusterid [pweight=plot_labor_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
tabstat w_plot_labor_prod_all_`i'  [aw=plot_labor_weight]   if rural==1  & dm_gender!=. , stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix temp_all=r(StatTotal)'
qui svy, subpop(if rural==1): mean w_plot_labor_prod_all_`i'
matrix w_plot_labor_prod_all_`i'=temp_all,el(r(table),2,1)
 
tabstat w_plot_labor_prod_male_`i'  [aw=plot_labor_weight]   if rural==1  & dm_gender==1  , stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix temp_male=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==1): mean w_plot_labor_prod_male_`i'
matrix w_plot_labor_prod_male_`i'=temp_male,el(r(table),2,1)

tabstat w_plot_labor_prod_female_`i'  [aw=plot_labor_weight]   if rural==1 & dm_gender==2   , stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix temp_female=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==2): mean w_plot_labor_prod_female_`i'
matrix w_plot_labor_prod_female_`i'=temp_female,el(r(table),2,1)

tabstat w_plot_labor_prod_mixed_`i'  [aw=plot_labor_weight]   if rural==1 & dm_gender==3   , stat(mean sd p25 p50 p75  min max N) col(stat) save
matrix temp_mixed=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==3): mean w_plot_labor_prod_mixed_`i'
matrix w_plot_labor_prod_mixed_`i'=temp_mixed,el(r(table),2,1)
}

matrix final_indicator13=final_indicator13\(w_plot_labor_prod_all_1ppp\w_plot_labor_prod_female_1ppp\w_plot_labor_prod_male_1ppp\w_plot_labor_prod_mixed_1ppp\ /*
*/ w_plot_labor_prod_all_2ppp\w_plot_labor_prod_female_2ppp\w_plot_labor_prod_male_2ppp\w_plot_labor_prod_mixed_2ppp\ /*
*/w_plot_labor_prod_all_loc\w_plot_labor_prod_female_loc\w_plot_labor_prod_male_loc\w_plot_labor_prod_mixed_loc)

** gender_prod_gap
tabstat gender_prod_gap1a gender_prod_gap1b, save
matrix temp13= r(StatTotal)', J(2,7,.)
tabstat segender_prod_gap1a segender_prod_gap1b, save
matrix final_indicator13=final_indicator13\(temp13, r(StatTotal)')
matrix list final_indicator13 


*Group 14 : individual level variables - women controle over income, asset, and participation in ag
use "$final_data_individual", clear
*Keep only adult women
keep if female==1
keep if age>=18
*count the number of female adult per household to be used in the weight
bysort hhid : egen number_female_hhmember =count (female==1 & age>=18)
global household_indicators15 control_all_income make_decision_ag own_asset formal_land_rights_f 
global final_indicator14 ""
foreach v of global household_indicators15 {
	gen `v'_female_hh=`v' if  fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator14 $final_indicator14 `v'  `v'_female_hh  `v'_male_hh 
}
tabstat ${final_indicator14} [aw=weight] if rural==1 , stat(mean sd  p25 p50 p75  min max N) col(stat) save
matrix final_indicator14=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean14=(.)
matrix colnames semean14=semean_wei
foreach v of global final_indicator14 {
	svy, subpop(if rural==1): mean `v'
	matrix semean14=semean14\(el(r(table),2,1))
}
matrix final_indicator14=final_indicator14,semean14[2..rowsof(semean14),.]
matrix list final_indicator14 

*Group 15 : individual level variables - women diet
use "$final_data_individual", clear
*only women of reproductive age
keep if female==1
drop if age>49
drop if age<15
gen women_diet=0
replace number_foodgroup=0			
*count the number of female adult per household to be used in the weight
bysort hhid : egen number_female_hhmember =count (female==1 & age<15 & age>49)

global household_indicators15  number_foodgroup women_diet
global final_indicator15""
foreach v of global household_indicators15 {
	gen `v'_female_hh=`v' if  fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator15 $final_indicator15 `v'  `v'_female_hh  `v'_male_hh 
}
tabstat ${final_indicator15} [aw=weight], stat(mean sd min p25 p50 p75 max N) col(stat) save
matrix final_indicator15=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean15=(.)
matrix colnames semean15=semean_wei
foreach v of global final_indicator15 {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean15=semean15\(el(r(table),2,1))
}

matrix final_indicator15=final_indicator15,semean15[2..rowsof(semean15),.]
matrix list final_indicator15

** Group 16 - Use of fertilizer, imporved seeds, and vaccing by individual farmers (plot managers or livestock keepers)
use "$final_data_individual", clear

*Adding empty variables (no cowpea or yam in this instrument)
foreach v in cowpea yam {
	gen `v'_farmer=0
	gen all_hybrid_seed_`v'=0
	foreach g in all female male {
		gen `g'_imprv_seed_`v' =0
	}
}

*Set improved seed adoption to missing if household is not growing crop 
foreach v in $topcropname_area_full {
	gen female_hybrid_seed_`v' = 0
	gen male_hybrid_seed_`v' = 0 

	foreach g in all male female {
		replace `g'_imprv_seed_`v' =. if `v'_farmer==0 | `v'_farmer==.
		recode `g'_imprv_seed_`v' (.=0) if `v'_farmer==1
		replace `g'_hybrid_seed_`v' =. if  `v'_farmer==0 | `v'_farmer==.
		recode `g'_hybrid_seed_`v' (.=0) if `v'_farmer==1
		replace `g'_use_inorg_fert =. if farmerid==.

	}	
		
	replace female_imprv_seed_`v'=. if female==0
	replace male_imprv_seed_`v'=. if female==1
	replace female_hybrid_seed_`v'=. if female==0
	replace male_hybrid_seed_`v'=. if female==1

	}

	
global household_indicator16 all_use_inorg_fert female_use_inorg_fert male_use_inorg_fert all_imprv_seed_use female_imprv_seed_use male_imprv_seed_use
foreach v in $topcropname_area_full {
	global household_indicator16 $household_indicator16 all_imprv_seed_`v' female_imprv_seed_`v' male_imprv_seed_`v' all_hybrid_seed_`v' female_hybrid_seed_`v' male_hybrid_seed_`v'
}
global household_indicator16 $household_indicator16 all_vac_animal female_vac_animal male_vac_animal
tabstat ${household_indicator16} [aw=weight] if rural==1 , stat(mean sd  p25 p50 p75  min max N) col(stat) save		
matrix final_indicator16=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean16=(.)
matrix colnames semean16=semean_wei
foreach v of global household_indicator16 {
local missing_var ""
	findname `v',  all(@==.) local (missing_var)
	if "`missing_var'"!="" { 
		qui replace `v'=0
	}	
	qui svy, subpop(if rural==1): mean `v'
	matrix semean16=semean16\(el(r(table),2,1))
}

matrix final_indicator16=final_indicator16,semean16[2..rowsof(semean16),.]
matrix list final_indicator16 


* All together
matrix final_indicator_all =(.,.,.,.,.,.,.,.,.)
forvalue i=1/16 {
	matrix final_indicator_all=final_indicator_all\final_indicator`i'
}
matrix final_indicator_all =final_indicator_all[2..rowsof(final_indicator_all), .] 
matrix list final_indicator_all 
matrix colname final_indicator_all =  mean sd p25 p50 p75 min max N semean_strata
*Reordering columns to put semean first
matrix final_indicator_exported=final_indicator_all[.,1..1],final_indicator_all[.,9..9],final_indicator_all[.,2..8]
*Export to Excel
putexcel set "$final_outputfile", replace
putexcel A1=matrix(final_indicator_exported)  , names 



 
