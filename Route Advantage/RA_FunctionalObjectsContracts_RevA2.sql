---FUNCTIONAL OBJECT (OU01)
--- Route Advantage Data

/*  REVISION HISTORY      
20230711  - Initial Query

*/  

/*




*/

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
,concat(a.eq_type,'-',a.eq_id) ObjectId
, e.type_desc Description
, '74021' Site  --LaGrange
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, xr.ifs_part_number PartNo
, (CONVERT(NVARCHAR,a.eq_custin,101)) InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(ROUTE_ID, ACCTNO, '')) LocationId
, a.eq_id SerialNo
, CASE WHEN  a.per_rate <> '0' and a.rentfreq = 'M'  THEN FA.IFS_FA_ID ELSE '' END FixedAssests
, '' FreeNotes
, 'CUSTOMER' PartyType
, ac.customer_no  CustomerNo


FROM [dbo].[RouteAdv_PARMERW_Equipment] a
inner join [dbo].[RouteAdv_PARMERW_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_Parmerw_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '21 - Parmer' and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_PARM'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_PARM'
where b.stat_code = 'A'

UNION ALL 

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
,concat(a.eq_type,'-',a.eq_id) ObjectId
, e.type_desc Description
, '74021' Site  --LaGrange
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, xr.ifs_part_number PartNo
, (CONVERT(NVARCHAR,a.eq_custin,101)) InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(ROUTE_ID, ACCTNO, '')) LocationId
, a.eq_id SerialNo
, CASE WHEN  a.per_rate <> '0' and a.rentfreq = 'M'  THEN FA.IFS_FA_ID ELSE '' END FixedAssests
, '' FreeNotes
, 'OWNER' PartyType
, 'US74021' CustomerNo


FROM [dbo].[RouteAdv_PARMERW_Equipment] a
inner join [dbo].[RouteAdv_PARMERW_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_Parmerw_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '21 - Parmer' and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_PARM'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_PARM'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'

union ALL 

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
,concat(a.eq_type,'-',a.eq_id) ObjectId
,  e.type_desc Description
, '74023' Site  --Superior Mountain Water
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, xr.ifs_part_number PartNo
, (CONVERT(NVARCHAR,a.eq_custin,101)) InstallationDate
,   concat(ac.customer_no,'-','1',REPLACE(ROUTE_ID, ACCTNO, '')) LocationId
, a.eq_id SerialNo
, CASE WHEN  a.per_rate <> '0' and a.rentfreq = 'M'  THEN FA.IFS_FA_ID ELSE '' END FixedAssests
, '' FreeNotes
, 'CUSTOMER' PartyType
, AC.customer_no CustomerNo



FROM [dbo].[RouteAdv_SUPMTWA_Equipment] a
inner join [dbo].[RouteAdv_SUPMTWA_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_SUPMTWA_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '23 - Superior Mountain'  and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_SUP'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_SUP'
where b.stat_code = 'A'

UNION ALL 
SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
,concat(a.eq_type,'-',a.eq_id) ObjectId
,  e.type_desc Description
, '74023' Site  --Superior Mountain Water
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, xr.ifs_part_number PartNo
, (CONVERT(NVARCHAR,a.eq_custin,101)) InstallationDate
,   concat(ac.customer_no,'-','1',REPLACE(ROUTE_ID, ACCTNO, '')) LocationId
, a.eq_id SerialNo
, CASE WHEN  a.per_rate <> '0' and a.rentfreq = 'M'  THEN FA.IFS_FA_ID ELSE '' END FixedAssests
, '' FreeNotes
, 'OWNDER' PartyType
, 'US74023' CustomerNo



FROM [dbo].[RouteAdv_SUPMTWA_Equipment] a
inner join [dbo].[RouteAdv_SUPMTWA_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_SUPMTWA_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '23 - Superior Mountain'  and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_SUP'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_SUP'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'


union all 

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
,concat(a.eq_type,'-',a.eq_id) ObjectId
, e.type_desc Description
, '74022' Site  --CCN Dist
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, xr.ifs_part_number PartNo
, (CONVERT(NVARCHAR,a.eq_custin,101)) InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(ROUTE_ID, ACCTNO, '')) LocationId
, a.eq_id SerialNo
, CASE WHEN  a.per_rate <> '0' and a.rentfreq = 'M'  THEN FA.IFS_FA_ID ELSE '' END FixedAssests
, '' FreeNotes
, 'CUSTOMER' PartyType
, AC.CUSTOMER_NO CustomerNo 

FROM [dbo].[RouteAdv_CCNDIST_Equipment] a
inner join [dbo].[RouteAdv_CCNDIST_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_CCNDIST_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '22 - CCN Distributors'  and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_CCN'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_CCN'

where b.stat_code = 'A' 

UNION ALL 

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
,concat(a.eq_type,'-',a.eq_id) ObjectId
, e.type_desc Description
, '74022' Site  --CCN Dist
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, xr.ifs_part_number PartNo
, (CONVERT(NVARCHAR,a.eq_custin,101)) InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(ROUTE_ID, ACCTNO, '')) LocationId
, a.eq_id SerialNo
, CASE WHEN  a.per_rate <> '0' and a.rentfreq = 'M'  THEN FA.IFS_FA_ID ELSE '' END FixedAssests
, '' FreeNotes
, 'OWNER' PartyType
, 'US74022' CustomerNo 

FROM [dbo].[RouteAdv_CCNDIST_Equipment] a
inner join [dbo].[RouteAdv_CCNDIST_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_CCNDIST_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '22 - CCN Distributors'  and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_CCN'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_CCN'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'

union ALL 

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
,concat(a.eq_type,'-',a.eq_id) ObjectId
,e.type_desc Description
, '74025' Site  --Affordable Water
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, xr.ifs_part_number PartNo
, (CONVERT(NVARCHAR,a.eq_custin,101)) InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(ROUTE_ID, ACCTNO, ''))LocationId
, a.eq_id SerialNo
, CASE WHEN  a.per_rate <> '0' and a.rentfreq = 'M'  THEN FA.IFS_FA_ID ELSE '' END FixedAssests
, '' FreeNotes
, 'CUSTOMER' PartyType
, AC.customer_no CustomerNO


FROM [dbo].[RouteAdv_AFRDWTR_Equipment] a
inner join [dbo].[RouteAdv_AFRDWTR_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_AFRDWTR_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '25 - Affordable Water'  and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_AFRD'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_AFRD'
where b.stat_code = 'A'

union all 

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
,concat(a.eq_type,'-',a.eq_id) ObjectId
,e.type_desc Description
, '74025' Site  --Affordable Water
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, xr.ifs_part_number PartNo
, (CONVERT(NVARCHAR,a.eq_custin,101)) InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(ROUTE_ID, ACCTNO, ''))LocationId
, a.eq_id SerialNo
, CASE WHEN  a.per_rate <> '0' and a.rentfreq = 'M'  THEN FA.IFS_FA_ID ELSE '' END FixedAssests
, '' FreeNotes
, 'OWNER' PartyType
, 'US74025' CustomerNO


FROM [dbo].[RouteAdv_AFRDWTR_Equipment] a
inner join [dbo].[RouteAdv_AFRDWTR_CustomerMaster] b on a.eqcustid = b.route_id
left join dbo.RouteAdv_AFRDWTR_equiptype e on a.eq_type = e.eq_type
left join dbo.RA_EQUIP_XREF XR ON a.eq_type = xr.eq_type and xr.branch = '25 - Affordable Water'  and e.eq_type = xr.eq_type
inner join dbo.customer_active_scope ac on b.acctno = ac.legacy_number and legacy_migration_source = 'RA_AFRD'
left join dbo.IFS_FA_ID fa on a.eqcustid = fa.ACCOUNT_NUMBER and a.eq_id = fa.SERIAL_NUMBER and fa.EQUIPMENT_C = a.eq_type and a.rentfreq = fa.DEALER_OWNED_C and fa.branch_datasource = 'RA_AFRD'
where b.stat_code = 'A' and a.per_rate <> '0' and a.rentfreq = 'M'

ORDER BY 8, 2






