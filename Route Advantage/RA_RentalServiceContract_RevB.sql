---Rental Contracts
--- Route Advantage Data

/*  REVISION HISTORY      
20230711  - Initial Query
2023-10-18 BN	REV B	ADDED COUNTER TO CONTRACT ID FOR CUSTOMER WILL MULTIPLE RENTALS

*/  

/*




*/
select distinct 
 --CS.SERVICE_C,C.CUSTOMER_TYPE_F,
 --a.*

'74021'Site_PM
,convert(nvarchar, eq_custin, 101) ValidFrom_PM
,case
	when cust_type_a = '85' then '300'
	WHEN cust_type_a IN ('89','90') THEN '800' END WorkType
 , ac.customer_no CustomerNo
 , cONCAT('21-',a.eqcustid,'-',ROW_NUMBER() OVER(PARTITION BY a.eqcustid ORDER BY a.eqcustid ASC))ContractID_SC 
 , a.type_desc ContractName
, 'USD' CurrencyCode
, '200' ContractType
, concat(a.eq_type,'-',a.eq_id)  ObjectId
, '1' PriceUnitLength
,'MONTH' PriceUnit
, 'TRUE' CreatePeriodAllocation
, 'PRIOR' InvoiceRule
, convert(nvarchar, sysdatetime(), 101)  PlanStartDate
, '12/31/2099' PlanEndDate
, '1' InvoicingInterval
,'MONTH' InvoicingIntervalUnit
, xr.ifs_part_number SalesPart
, a.per_rate	PriceCurr
, 'FALSE' IncludeObjectsaddedtoStructure

FROM [dbo].[RouteAdv_PARMERW_Equipment] a
inner join [dbo].[RouteAdv_PARMERW_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_Parmerw_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '21 - Parmer' and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_PARM'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_PARM'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'

UNION ALL 
select distinct 
 --CS.SERVICE_C,C.CUSTOMER_TYPE_F,
 --a.*

'74023'Site_PM
,convert(nvarchar, eq_custin, 101) ValidFrom_PM
,case
	when cust_type_a = 'B' then '300'
	WHEN cust_type_a IN ('A','C','D') THEN '800' END WorkType
 , ac.customer_no CustomerNo
 , cONCAT('23-',a.eqcustid)ContractID_SC 
 , a.type_desc ContractName
, 'USD' CurrencyCode
, '200' ContractType
, concat(a.eq_type,'-',a.eq_id)  ObjectId
, '1' PriceUnitLength
,'MONTH' PriceUnit
, 'TRUE' CreatePeriodAllocation
, 'PRIOR' InvoiceRule
, convert(nvarchar, sysdatetime(), 101)  PlanStartDate
, '12/31/2099' PlanEndDate
, '1' InvoicingInterval
,'MONTH' InvoicingIntervalUnit
, xr.ifs_part_number SalesPart
, a.per_rate	PriceCurr
, 'FALSE' IncludeObjectsaddedtoStructure

FROM [dbo].[RouteAdv_SUPMTWA_Equipment] a
inner join [dbo].[RouteAdv_SUPMTWA_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_SUPMTWA_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '23 - Superior Mountain' and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_SUP'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_SUP'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'

UNION ALL 
select distinct 
 --CS.SERVICE_C,C.CUSTOMER_TYPE_F,
 --a.*

'74022'Site_PM
,convert(nvarchar, eq_custin, 101) ValidFrom_PM
,case
	when cust_type_a = 'B' then '300'
	WHEN cust_type_a IN ('A','C') THEN '800' END WorkType
 , ac.customer_no CustomerNo
 , cONCAT('22-',a.eqcustid)ContractID_SC 
 , a.type_desc ContractName
, 'USD' CurrencyCode
, '200' ContractType
, concat(a.eq_type,'-',a.eq_id)  ObjectId
, '1' PriceUnitLength
,'MONTH' PriceUnit
, 'TRUE' CreatePeriodAllocation
, 'PRIOR' InvoiceRule
, convert(nvarchar, sysdatetime(), 101)  PlanStartDate
, '12/31/2099' PlanEndDate
, '1' InvoicingInterval
,'MONTH' InvoicingIntervalUnit
, xr.ifs_part_number SalesPart
, a.per_rate	PriceCurr
, 'FALSE' IncludeObjectsaddedtoStructure

FROM [dbo].[RouteAdv_CCNDIST_Equipment] a
inner join [dbo].[RouteAdv_CCNDIST_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_CCNDIST_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '22 - CCN Distributors' and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_CCN'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_CCN'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'

UNION ALL 
select distinct 
 --CS.SERVICE_C,C.CUSTOMER_TYPE_F,
 --a.*

'74025'Site_PM
,convert(nvarchar, eq_custin, 101) ValidFrom_PM
,case
	when cust_type_a = 'R' then '300'
	WHEN cust_type_a IN ('C') THEN '800' END WorkType
 , ac.customer_no CustomerNo
 , cONCAT('25-',a.eqcustid)ContractID_SC 
 , a.type_desc ContractName
, 'USD' CurrencyCode
, '200' ContractType
, concat(a.eq_type,'-',a.eq_id)  ObjectId
, '1' PriceUnitLength
,'MONTH' PriceUnit
, 'TRUE' CreatePeriodAllocation
, 'PRIOR' InvoiceRule
, convert(nvarchar, sysdatetime(), 101)  PlanStartDate
, '12/31/2099' PlanEndDate
, '1' InvoicingInterval
,'MONTH' InvoicingIntervalUnit
, xr.ifs_part_number SalesPart
, a.per_rate	PriceCurr
, 'FALSE' IncludeObjectsaddedtoStructure

FROM [dbo].[RouteAdv_AFRDWTR_Equipment] a
inner join [dbo].[RouteAdv_AFRDWTR_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_AFRDWTR_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '25 - Affordable Water' and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_AFRD'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_AFRD'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'

order by 5