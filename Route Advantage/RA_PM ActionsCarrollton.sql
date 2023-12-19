 
select distinct 
 AC.CUSTOMER_NO, CONCAT(AC.CUSTOMER_NO,'-',RIGHT(CP.ROUTE_ID,2)) LOCATION_NO, CP.route_id, CP.prod_id, CP.dpd_price, PL.PROD_DESC , CM.ROU_ROUTE_A, cm.rou_day,
--concat('W',left(cm.rou_day,1)) Action_PM
case 
	when cm.rou_day like '%T' then 'W1'
	when cm.rou_day like '%R2' then 'W8'
	when cm.rou_day like '%S2' then 'W8'
	when cm.rou_day like '%S' then 'W2'
	else 'W4' END Action_PM
, '74023' Site_PM
,CONCAT('DP-',AC.CUSTOMER_NO,'-',(Format(Row_Number() Over (Order By AC.CUSTOMER_NO, CP.ROUTE_ID),'00'))) ObjectId_PM
,  CONVERT(NVARCHAR,SYSDATETIME(),101)  ValidFrom_PM
, concat('CWG-R',substring(cm.rou_day,2,1)) Calendar_PM
, '2000' MaintOrg_PM
, case	when CM.cust_type_a = 'B' THEN '400' 
		WHEN CM.cust_type_a IN ('A','C','D') THEN '900' 
		 END	  WorkType
, '.15' ExecutionTime_PM
, 'TNORGREN' PlannedBy_PM
, AC.CUSTOMER_NO Customer_PM
, ''ContractID_SC
, '1' LineNo_PMSC
, 'DAY' StartUnit_PM
, ''  StartValue_PM
, 'WEEK' IntervalUnit_PM
, CM.DELFREQ  Interval_pm
, 'YES' PerformedDateBased_PM
, PL.prod_desc  WorkDescription_pm
, '1' WorkDuration_PM
, 'Person' ResourceDemandType_PM
, 'EDG_PP_DEL' ResourceGroup_PM
,	'PP_TRUCK_XXX'  Resource_PM
, '1' ResourcePlannedQty_PM
, X.IFS_PART_NO  MaterialPartNo_PM
, CP.dpd_price SalesPriceUnit_PM
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

from dbo.RouteAdv_SUPMTWA_Custprods CP
INNER JOIN [dbo].[RouteAdv_SUPMTWA_CustomerMaster] CM ON CM.route_id = CP.route_id
INNER JOIN DBO.customer_active_scope AC ON CM.acctno = AC.legacy_number AND AC.legacy_migration_source = 'RA_SUP'
INNER JOIN dbo.RouteAdv_SUPMTWA_ProductList PL ON CP.PROD_ID = PL.PROD_ID
INNER JOIN DBO.RA_Product_XREF X ON CP.prod_id = X.Prod_id and x.branch = '23 - Superior Mountain'
where CP.prod_id not in ( '9999','305')
--and cm.rou_day like '836%'

ORDER BY AC.CUSTOMER_NO
