--RouteAdvantage
--Fixed Assett

/*  REVISION HISTORY      
20230711  - Initial Query 

*/  


/*
Action:   

*/

select 
 'US74000' Company
, fa.IFS_FA_ID Object
, e.type_desc  Description
, 'Normal' ObjectType
, '170510' ObjectGroup  -- Bottle Water Coolers
, 'DEFAULT' AcquisitionReason
, '74021' Site -- LaGrange
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife


FROM [dbo].[RouteAdv_PARMERW_Equipment] a
inner join [dbo].[RouteAdv_PARMERW_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_Parmerw_equiptype e on a.eq_type = e.eq_type
INNER JOIN DBO.customer_active_scope c ON b.acctno = c.legacy_number and c.legacy_migration_source = 'RA_PARM'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_PARM'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'



union 
select 
 'US74000' Company
, fa.IFS_FA_ID   Object
, e.TYPE_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup  -- Bottle Water Coolers
, 'DEFAULT' AcquisitionReason
, '74023' Site -- Superior Water
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife


FROM [dbo].[RouteAdv_SUPMTWA_Equipment] a
inner join [dbo].[RouteAdv_SUPMTWA_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_SUPMTWA_equiptype e on a.eq_type = e.eq_type
INNER JOIN DBO.customer_active_scope c ON b.acctno = c.legacy_number and c.legacy_migration_source = 'RA_SUP'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_SUP'
where b.stat_code = 'A'and a.per_rate <> '0' and a.rentfreq = 'M'



union 
select 
'US74000' Company
,  fa.IFS_FA_ID   Object
, e.TYPE_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup  -- Bottle Water Coolers
, 'DEFAULT' AcquisitionReason
, '74022' Site --CCN
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife

FROM [dbo].[RouteAdv_CCNDIST_Equipment] a
inner join [dbo].[RouteAdv_CCNDIST_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_CCNDIST_equiptype e on a.eq_type = e.eq_type
INNER JOIN DBO.customer_active_scope c ON b.acctno = c.legacy_number and c.legacy_migration_source = 'RA_CCN'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_CCN'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'

union
select 
'US74000' Company
, fa.IFS_FA_ID   Object
, e.TYPE_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup  -- Bottle Water Coolers
, 'DEFAULT' AcquisitionReason
, '74025' Site --Affordable Water
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife


FROM [dbo].[RouteAdv_AFRDWTR_Equipment] a
inner join [dbo].[RouteAdv_AFRDWTR_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_AFRDWTR_equiptype e on a.eq_type = e.eq_type
INNER JOIN DBO.customer_active_scope c ON b.acctno = c.legacy_number and c.legacy_migration_source = 'RA_AFRD'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource ='RA_AFRD'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'
