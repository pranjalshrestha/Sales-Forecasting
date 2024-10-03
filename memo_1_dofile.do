/*
Memo 1
10/02/2024
Pranjal Shrestha
*/

*set directory
cd "/Users/pranjal/Library/CloudStorage/OneDrive-CentreCollegeofKentucky/ECO 392/Memo_1/"


*******************************************************************************
*******************************************************************************
*******************************************************************************

*open AlchSales data
import excel "AlchSales.xls", sheet("data") firstrow 

*set unit of time
tsset obsdate

*reconstruct date
gen year = year(obsdate)
gen month = month(obsdate)

*combine year and month into a monthly date format
gen date = ym(year,month)

*format the date variable for monthly data
format date %tm 

tsset date

*drop variables
drop obsdate 
drop year
drop month 

*reorder the columns
order date sales

*save the data
save alcsales.dta, replace

*graph it
tsline sales

*******************************************************************************
*******************************************************************************
*******************************************************************************

//***Exponential Forecast***

tssmooth exp f_exp = sales, forecast(4)

*graph
tsline sales f_exp  

*Pseudo
tssmooth exp pf_exp = sales if date < m(2024m4), forecast(4)

*In-Sample RMSE
gen e_exp = (sales - f_exp)
gen e_exp_sq = e_exp * e_exp
egen mse_exp = mean(e_exp_sq)
gen rmse_exp = sqrt(mse_exp)


*Pseudo RMSE
gen pe_exp = (sales - pf_exp) if date > m(2024m3)
gen pe_exp_sq = pe_exp * pe_exp
egen pMSE_exp = mean(pe_exp_sq)
gen pRMSE_exp = sqrt(pMSE_exp) 


*In-Sample MAPE
gen abspcter_exp = abs(sales-f_exp)/sales
egen MAPE_exp = mean(abspcter_exp)

*Pseudo MAPE
gen p_abspcter_exp = abs(sales - pf_exp)/sales if date > m(2024m3)
egen pMAPE_exp = mean(p_abspcter_exp)


*drop unnecessary variables
drop e_exp
drop e_exp_sq
drop mse_exp
drop pe_exp
drop pe_exp_sq
drop pMSE_exp
drop abspcter_exp
drop p_abspcter_exp

*******************************************************************************
*******************************************************************************
*******************************************************************************

// ***Holts Forecast***

tssmooth hwinters f_holts = sales, forecast(4)

*graph it
tsline f_holts sales

*Pseudo
tssmooth hwinters pf_holts = sales if date< m(2024m4), forecast(4)


*In-Sample RMSE
gen e_h = (sales-f_holts)
gen e_h_sq = e_h * e_h
egen mse_h = mean(e_h_sq)
gen rmse_h = sqrt(mse_h)


*Pseudo RMSE
gen pe_h = (sales-pf_holts) if date > m(2024m3)
gen pe_hsq = pe_h*pe_h
egen pMSE_h = mean(pe_hsq)
gen pRMSE_h = sqrt(pMSE_h)


*In-Sample MAPE
gen abspcter_h = abs(sales-f_holts)/sales
egen MAPE_h = mean(abspcter_h)


*Pseudo MAPE
gen p_abspcter_h = abs(sales - pf_holts)/sales if date > m(2024m3)
egen pMAPE_h = mean(p_abspcter_h)

*drop unnecessary Variables
drop e_h
drop e_h_sq
drop mse_h
drop pe_h
drop pe_hsq
drop pMSE_h
drop abspcter_h
drop p_abspcter_h


*******************************************************************************
*******************************************************************************
*******************************************************************************


// ***Winters Forecast***

tssmooth shwinters f_winters = sales, forecast(4)

*graph it
tsline sales f_winters
tsline sales f_winters f_holts


*Pseudo
tssmooth shwinters pf_winters = sales if date< m(2024m4), forecast(4)


*In-Sample RMSE
gen e_w = (sales-f_winters)
gen e_w_sq = e_w * e_w
egen mse_w = mean(e_w_sq)
gen rmse_w = sqrt(mse_w)


*Pseudo RMSE
gen pe_w = (sales-pf_winters) if date > m(2024m3)
gen pe_wsq = pe_w*pe_w
egen pMSE_w = mean(pe_wsq)
gen pRMSE_w = sqrt(pMSE_w)


*In-Sample MAPE
gen abspcter_w = abs(sales-f_winters)/sales
egen MAPE_w = mean(abspcter_w)


*Pseudo MAPE
gen p_abspcter_w = abs(sales - pf_winters)/sales if date > m(2024m3)
egen pMAPE_w = mean(p_abspcter_w)


*drop unnecessary variables
drop e_w
drop e_w_sq
drop mse_w
drop pe_w
drop pe_wsq
drop pMSE_w
drop abspcter_w
drop p_abspcter_w


*list the final forecast values from the Holt-Winters model
list f_winters


*summary statistics
sum f_exp rmse_exp pRMSE_exp MAPE_exp rmse_h pRMSE_h MAPE_h pMAPE_h rmse_w pRMSE_w MAPE_w pMAPE_w

*******************************************************************************
*******************************************************************************
*******************************************************************************























