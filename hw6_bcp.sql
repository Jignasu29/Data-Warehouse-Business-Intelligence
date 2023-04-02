create table c19(
			wk varchar(255) NULL,
			Federal_pvd_no varchar(255) NULL,
			pvd_Name varchar(255) NULL,
			pvd_ct varchar(255) NULL,
			pvd_st varchar(255) NULL,
			pvd_ph_no varchar(255) NULL,
			county varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_comp_c19_vac varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_Partial_c19_vac varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_with_med_contraindication_to_c19_vac varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_decline_c19_vac varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_with_an_ukwn_c19_vac_Status varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_the_pfz_bnt_c19_vac_d1 varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_the_pfz_bnt_c19_vac_d1_2 varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_the_modernc19_vac_d1 varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_the_modernc19_vac_d1_2 varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_the_jsn_c19_vac_d1 varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_comp_unsp_c19_vac varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_comp_c19_vac varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_Partial_c19_vac varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_with_med_contraindication_to_c19_vac varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_decline_c19_vac varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_with_an_ukwn_c19_vac_Status varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_the_pfz_bnt_c19_vac_d1 varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_the_pfz_bnt_c19_vac_d1_2 varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_the_moderna_c19_vac_d1 varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_the_moderna_c19_vac_d1_2 varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_the_jsn_c19_vac_d1 varchar(255) NULL,
			no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_comp_unsp_c19_vac varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_pfz_bnt_c19_vac_bst varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_moderna_c19_vac_bst varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_jsn_c19_vac_bst varchar(255) NULL,
			no_of_res_stay_min_1d_of_wk_rcv_an_unsp_c19_vac_bst varchar(255) NULL,
			no_of_hc_per_stay_min_1d_of_wk_rcv_pfz_bnt_c19_vac_bst varchar(255) NULL,
			no_of_hc_per_stay_min_1d_of_wk_rcv_moderna_c19_vac_bst varchar(255) NULL,
			no_of_hc_per_stay_min_1d_of_wk_rcv_jsn_c19_vac_bst varchar(255) NULL,
			no_of_hc_per_stay_min_1d_of_wk_rcv_an_unsp_c19_vac_bst varchar(255) NULL
)

select * from c19

drop table c19

select top(5000) * from ssis_c19

ALTER TABLE ssis_c19
ALTER COLUMN wk date;

ALTER TABLE ssis_c19
ALTER COLUMN no_of_hc_per_Eligible_to_Work__min_1d_of_wk_decline_c19_vac INT;


/*
Analysis 1
Find the County name where percentage of fully vaccinated resident is less than 70% 
*/

Select county, SUM(no_of_res_stay_min_1d_of_wk) as total_stayed_resident_for_this_week, SUM(no_of_res_stay_min_1d_of_wk_rcv_comp_c19_vac) as vaccinated_resident_for_this_week
from ssis_c19
group by county

select county, (vaccinated_resident_for_this_week * 100)/total_stayed_resident_for_this_week as percentage_of_vaccinated_resident
from analysis1
where vaccinated_resident_for_this_week != 0 AND ((vaccinated_resident_for_this_week * 100)/total_stayed_resident_for_this_week)<70

/* for above query, we have to put where condition because in caribou country 0 residents stayed over the time. */


/*
Analysis 2
Find the top 5 provider's state names where maximum healthcare personnal receieved unspecified booster shot
*/

Select top(5) pvd_st as State_of_Provider, SUM(no_of_hc_per_stay_min_1d_of_wk_rcv_an_unsp_c19_vac_bst) as Unspecified_booster_received_healthcare_workers
from ssis_c19
group by pvd_st
order by SUM(no_of_hc_per_stay_min_1d_of_wk_rcv_an_unsp_c19_vac_bst) desc

/* Analysis 3 
Number of residents who received moderna vaccine booster from each city
*/

select SUM(no_of_res_stay_min_1d_of_wk_rcv_moderna_c19_vac_bst) as total_moderna_booster,pvd_ct
from ssis_c19
group by pvd_ct
order by pvd_ct

/* Analysis 4 
Retrive the total number of vaccinated residents and with unknown vaccination status
*/

select SUM(no_of_res_stay_min_1d_of_wk) as res_stay_minimum_1day,
(SUM(no_of_res_stay_min_1d_of_wk)-SUM(no_of_res_stay_min_1d_of_wk_with_an_ukwn_c19_vac_Status)) as vaccinated_resident,
SUM(no_of_res_stay_min_1d_of_wk_with_an_ukwn_c19_vac_Status) as Unknown_vaccination_status
from ssis_c19

/* Analysis 5 
retrive the number of health workers who are fully or partial vaccinated and/or having medicale contradiction or decline to take vaccine
*/

select SUM(no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_comp_c19_vac) as fully_vaccinated_healthcare_workers,
SUM(no_of_hc_per_Eligible_to_Work__min_1d_of_wk_rcv_Partial_c19_vac) as partial_vaccinated_healthcare_workers,
SUM(no_of_hc_per_Eligible_to_Work__min_1d_of_wk_with_med_contraindication_to_c19_vac) as healthcare_workers_have_medical_contradiction,
SUM(no_of_hc_per_Eligible_to_Work__min_1d_of_wk_decline_c19_vac) as healthcare_workers_who_decline_vaccination,
pvd_st as States
from ssis_c19
group by pvd_st
order by pvd_st

/* Analysis 6 
Retrive the provider name where more than 50% residents are decline to take vaccines
*/

select pvd_Name as provider_name
from ssis_c19
where no_of_res_stay_min_1d_of_wk_decline_c19_vac != 0 AND ((no_of_res_stay_min_1d_of_wk_decline_c19_vac * 100)/no_of_res_stay_min_1d_of_wk)>50
group by pvd_Name