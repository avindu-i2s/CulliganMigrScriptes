select * from (select distinct
ac.legacy_number,
 AC.CUSTOMER_NO
 , CONCAT(AC.CUSTOMER_NO,'-',RIGHT(CP.ROUTE_ID,2)) LOCATION_NO
 , CP.route_id, CP.prod_id, CP.dpd_price
 , PL.PROD_DESC 
 , CM.ROU_ROUTE_A
 , cm.rou_day
 , case 
	when cm.rou_day is null and CM.ROU_ROUTE_A = '90' then 'W99'
	else concat('W',left(cm.rou_day,1)) end Action_PM
, '74021' Site_PM
, CONCAT('DP-',AC.CUSTOMER_NO,'-',REPLACE(CP.ROUTE_ID, ACCTNO, ''),CP.prod_id) ObjectId_PM
, CONVERT(NVARCHAR,SYSDATETIME(),101)  ValidFrom_PM
, cm.cfin_lsdat
, case 
	when left(cm.rou_day,1) = '4' then
		DATEDIFF(WEEK , cm.cfin_lsdat, SYSDATETIME())
	else DATEDIFF(WEEK , cm.cfin_lsdat, SYSDATETIME()) end	week_diff
, case 
	when left(cm.rou_day,1) = '4' then
		DATEDIFF(WEEK , cm.cfin_lsdat, SYSDATETIME())/4 
	else DATEDIFF(WEEK , cm.cfin_lsdat, SYSDATETIME()) end	route_count_diff
, case 
	when left(cm.rou_day,1) = '4' then format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 4, SYSDATETIME())), 0), 'MM/dd/yyyy')
	when left(cm.rou_day,1) = '8' then
	case 
		when MONTH(cm.cfin_lsdat)%2 = 0 then
			case 
				when MONTH(GETDATE())%2 = 0 then format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 8, SYSDATETIME())), 0) , 'MM/dd/yyyy')
				else format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 4, SYSDATETIME())), 0) , 'MM/dd/yyyy')
			end
		else 
			case 
				when MONTH(GETDATE())%2 = 0 then format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 4, SYSDATETIME())), 0) , 'MM/dd/yyyy')
				else format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 8, SYSDATETIME())), 0) , 'MM/dd/yyyy')
			end
	end
	else format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 4, SYSDATETIME())), 0), 'MM/dd/yyyy') end newValidFromPM
, concat('CWG_R',RIGHT(cm.rou_day,2)) Calendar_PM
, '2000' MaintOrg_PM
, case	when CM.cust_type_a = '85' THEN '400' 
		WHEN CM.cust_type_a IN ('89','90') THEN '900' 
		 END	  WorkType
, '.15' ExecutionTime_PM
, 'TNORGREN' PlannedBy_PM
, AC.CUSTOMER_NO Customer_PM
, ''ContractID_SC
, '1' LineNo_PMSC
, 'DAY' StartUnit_PM
, ''  StartValue_PM
, 'WEEK' IntervalUnit_PM
, case 
	when concat('W',left(cm.rou_day,1)) = 'W4' then 4 
	else CM.DELFREQ  
	end Interval_pm
, 'YES' PerformedDateBased_PM
, PL.prod_desc  WorkDescription_pm
, '1' WorkDuration_PM
, 'Person' ResourceDemandType_PM
, 'EDG_PP_DEL' ResourceGroup_PM
, CASE CM.ROU_ROUTE_A
	when '01' then 'PP_TRUCK_1'
	when '02' then 'PP_TRUCK_2'
	when '04' then 'PP_TRUCK_4'
	when '05' then 'PP_TRUCK_5'
	when '90' then 'PP_TRUCK_3'
	else null
	end Resource_PM
, '1' ResourcePlannedQty_PM
, X.IFS_PART_NO  MaterialPartNo_PM
, CP.dpd_price SalesPriceUnit_PM
, '1' MaterialPlannedQty
, 'USD'  CurrencyCode_SC
, '' ContractName_SC
, ''  ContractType_SC
, '1' PriceUnitLength_PMSC
, CP.dpd_price PriceUnit_PMSC
,  'TRUE'  CreatePeriodAllocation_SC
,  'PRIOR'  InvoiceRule_SC
, ''  PlanStartDate_SC
,  '12/31/2099'  PlanEndDate_SC
,  '1'  InvoicingInterval_SC
, ''  InvoicingIntervalUnit_SC
,   '' SalesPart_SC
, '' PriceCurr_SC
,  'FALSE'  IncludeObjectsaddedtoStructure_SC

from dbo.RouteAdv_PARMERW_Custprods CP
INNER JOIN [dbo].[RouteAdv_PARMERW_CustomerMaster] CM ON CM.route_id = CP.route_id
INNER JOIN DBO.customer_active_scope AC ON CM.acctno = AC.legacy_number AND AC.legacy_migration_source = 'RA_PARM'
INNER JOIN dbo.RouteAdv_PARMERW_ProductList PL ON CP.PROD_ID = PL.PROD_ID
INNER JOIN DBO.RA_Product_XREF X ON CP.prod_id = X.Prod_id and x.branch = '21 - Parmer'
where CP.prod_id not in ( '9999','305')
--and CONCAT(AC.CUSTOMER_NO,'-',RIGHT(CP.ROUTE_ID,2)) = '7400209508-00'
--and cm.rou_day like '836%'
and ac.legacy_number not in ('000355', '001261', '002254', '002319', '002663', '003449', '005906')

union 

select distinct
ac.legacy_number,
 AC.CUSTOMER_NO
 , CONCAT(AC.CUSTOMER_NO,'-',RIGHT(CP.ROUTE_ID,2)) LOCATION_NO
 , CP.route_id, CP.prod_id, CP.dpd_price
 , PL.PROD_DESC 
 , CM.ROU_ROUTE_A
 , cm.rou_day
 , case 
	when cm.rou_day is null and CM.ROU_ROUTE_A = '90' then 'W99'
	else concat('W',left(cm.rou_day,1)) end Action_PM
, '74021' Site_PM
, CONCAT('DP-',AC.CUSTOMER_NO,'-',REPLACE(CP.ROUTE_ID, ACCTNO, ''),CP.prod_id) ObjectId_PM
, CONVERT(NVARCHAR,SYSDATETIME(),101)  ValidFrom_PM
, cm.cfin_lsdat
, case 
	when left(cm.rou_day,1) = '4' then
		DATEDIFF(WEEK , cm.cfin_lsdat, SYSDATETIME())
	else DATEDIFF(WEEK , cm.cfin_lsdat, SYSDATETIME()) end	week_diff
, case 
	when left(cm.rou_day,1) = '4' then
		DATEDIFF(WEEK , cm.cfin_lsdat, SYSDATETIME())/4 
	else DATEDIFF(WEEK , cm.cfin_lsdat, SYSDATETIME()) end	route_count_diff
, case 
	when left(cm.rou_day,1) = '4' then format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 4, SYSDATETIME())), 0), 'MM/dd/yyyy')
	when left(cm.rou_day,1) = '8' then
	case 
		when MONTH(cm.cfin_lsdat)%2 = 0 then
			case 
				when MONTH(GETDATE())%2 = 0 then format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 8, SYSDATETIME())), 0) , 'MM/dd/yyyy')
				else format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 4, SYSDATETIME())), 0) , 'MM/dd/yyyy')
			end
		else 
			case 
				when MONTH(GETDATE())%2 = 0 then format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 4, SYSDATETIME())), 0) , 'MM/dd/yyyy')
				else format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 8, SYSDATETIME())), 0) , 'MM/dd/yyyy')
			end
	end
	else format(DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(WEEK, 4, SYSDATETIME())), 0), 'MM/dd/yyyy') end newValidFromPM
, case 
	when TRY_CAST(RIGHT(cm.rou_day,2) as INT) is not null then
		case 
			when RIGHT(cm.rou_day,2) < 10 THEN
			concat('CWG_R',RIGHT(cm.rou_day,2)+10) 
			else concat('CWG_R',RIGHT(cm.rou_day,2)-10) 	
		end
	else RIGHT(cm.rou_day,2)
 end Calendar_PM
, '2000' MaintOrg_PM
, case	when CM.cust_type_a = '85' THEN '400' 
		WHEN CM.cust_type_a IN ('89','90') THEN '900' 
		 END	  WorkType
, '.15' ExecutionTime_PM
, 'TNORGREN' PlannedBy_PM
, AC.CUSTOMER_NO Customer_PM
, ''ContractID_SC
, '1' LineNo_PMSC
, 'DAY' StartUnit_PM
, ''  StartValue_PM
, 'WEEK' IntervalUnit_PM
, case 
	when concat('W',left(cm.rou_day,1)) = 'W4' then 4 
	else CM.DELFREQ  
	end Interval_pm
, 'YES' PerformedDateBased_PM
, PL.prod_desc  WorkDescription_pm
, '1' WorkDuration_PM
, 'Person' ResourceDemandType_PM
, 'EDG_PP_DEL' ResourceGroup_PM
, CASE CM.ROU_ROUTE_A
	when '01' then 'PP_TRUCK_1'
	when '02' then 'PP_TRUCK_2'
	when '04' then 'PP_TRUCK_4'
	when '05' then 'PP_TRUCK_5'
	when '90' then 'PP_TRUCK_3'
	else null
	end Resource_PM
, '1' ResourcePlannedQty_PM
, X.IFS_PART_NO  MaterialPartNo_PM
, CP.dpd_price SalesPriceUnit_PM
, '1' MaterialPlannedQty
, 'USD'  CurrencyCode_SC
, '' ContractName_SC
, ''  ContractType_SC
, '1' PriceUnitLength_PMSC
, CP.dpd_price PriceUnit_PMSC
,  'TRUE'  CreatePeriodAllocation_SC
,  'PRIOR'  InvoiceRule_SC
, ''  PlanStartDate_SC
,  '12/31/2099'  PlanEndDate_SC
,  '1'  InvoicingInterval_SC
, ''  InvoicingIntervalUnit_SC
,   '' SalesPart_SC
, '' PriceCurr_SC
,  'FALSE'  IncludeObjectsaddedtoStructure_SC

from dbo.RouteAdv_PARMERW_Custprods CP
INNER JOIN [dbo].[RouteAdv_PARMERW_CustomerMaster] CM ON CM.route_id = CP.route_id
INNER JOIN DBO.customer_active_scope AC ON CM.acctno = AC.legacy_number AND AC.legacy_migration_source = 'RA_PARM'
INNER JOIN dbo.RouteAdv_PARMERW_ProductList PL ON CP.PROD_ID = PL.PROD_ID
INNER JOIN DBO.RA_Product_XREF X ON CP.prod_id = X.Prod_id and x.branch = '21 - Parmer'
where CP.prod_id not in ( '9999','305')
--and CONCAT(AC.CUSTOMER_NO,'-',RIGHT(CP.ROUTE_ID,2)) = '7400209508-00'
--and cm.rou_day like '836%'
and ac.legacy_number not in ('000355', '001261', '002254', '002319', '002663', '003449', '005906')
and left(cm.rou_day,1) = '2') A
order by a.customer_no