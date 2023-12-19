---FUNCTIONAL OBJECT (OU01)
--- Route Advantage Data

/*  REVISION HISTORY      
20231019  REV A  -Products Initial Query
20231030  Rev B - Updated Object ID from having a counter to using the route and  product id.  

*/  

/*


*/

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
--,CONCAT('DP-',AC.CUSTOMER_NO,'-',(Format(Row_Number() Over (Order By AC.CUSTOMER_NO, CP.ROUTE_ID),'00'))) ObjectId
,CONCAT('DP-',AC.CUSTOMER_NO,'-',REPLACE(CP.ROUTE_ID, ACCTNO, ''),CP.prod_id) ObjectId
, PL.prod_desc Description
, '74021' Site  --LaGrange
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, X.IFS_PART_NO PartNo
,  CONVERT(NVARCHAR,SYSDATETIME(),101)  InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(CP.ROUTE_ID, ACCTNO, '')) LocationId
, '' SerialNo
, '' FixedAssests
, '' FreeNotes
, 'CUSTOMER' PartyType
, ac.customer_no  CustomerNo


from dbo.RouteAdv_PARMERW_Custprods CP
INNER JOIN [dbo].[RouteAdv_PARMERW_CustomerMaster] CM ON CM.route_id = CP.route_id
INNER JOIN DBO.customer_active_scope AC ON CM.acctno = AC.legacy_number AND AC.legacy_migration_source = 'RA_PARM'
INNER JOIN dbo.RouteAdv_PARMERW_ProductList PL ON CP.PROD_ID = PL.PROD_ID
INNER JOIN DBO.RA_Product_XREF X ON CP.prod_id = X.Prod_id and x.branch = '21 - Parmer'
where CP.prod_id <> '9999'

union all 

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
--,CONCAT('DP-',AC.CUSTOMER_NO,'-',(Format(Row_Number() Over (Order By AC.CUSTOMER_NO, CP.ROUTE_ID),'00')))ObjectId
,CONCAT('DP-',AC.CUSTOMER_NO,'-',REPLACE(CP.ROUTE_ID, ACCTNO, ''),CP.prod_id) ObjectId
, PL.prod_desc Description
, '74025' Site  --LaGrange
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, X.IFS_PART_NO PartNo
,  CONVERT(NVARCHAR,SYSDATETIME(),101)  InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(CP.ROUTE_ID, ACCTNO, '')) LocationId
, '' SerialNo
, '' FixedAssests
, '' FreeNotes
, 'CUSTOMER' PartyType
, ac.customer_no  CustomerNo


from dbo.RouteAdv_AFRDWTR_Custprods CP
INNER JOIN [dbo].[RouteAdv_AFRDWTR_CustomerMaster] CM ON CM.route_id = CP.route_id
INNER JOIN DBO.customer_active_scope AC ON CM.acctno = AC.legacy_number AND AC.legacy_migration_source = 'RA_AFRD'
INNER JOIN dbo.RouteAdv_AFRDWTR_ProductList PL ON CP.PROD_ID = PL.PROD_ID
INNER JOIN DBO.RA_Product_XREF X ON CP.prod_id = X.Prod_id and x.branch = '25 - Affordable Water'
where CP.prod_id <> '9999'

union all 

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
--,CONCAT('DP-',AC.CUSTOMER_NO,'-',(Format(Row_Number() Over (Order By AC.CUSTOMER_NO, CP.ROUTE_ID),'00'))) ObjectId
,CONCAT('DP-',AC.CUSTOMER_NO,'-',REPLACE(CP.ROUTE_ID, ACCTNO, ''),CP.prod_id) ObjectId
, PL.prod_desc Description
, '74022' Site  --LaGrange
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, X.IFS_PART_NO PartNo
,  CONVERT(NVARCHAR,SYSDATETIME(),101)  InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(CP.ROUTE_ID, ACCTNO, '')) LocationId
, '' SerialNo
, '' FixedAssests
, '' FreeNotes
, 'CUSTOMER' PartyType
, ac.customer_no  CustomerNo


from dbo.RouteAdv_CCNDIST_Custprods CP
INNER JOIN [dbo].[RouteAdv_CCNDIST_CustomerMaster] CM ON CM.route_id = CP.route_id
INNER JOIN DBO.customer_active_scope AC ON CM.acctno = AC.legacy_number AND AC.legacy_migration_source = 'RA_CCN'
INNER JOIN dbo.RouteAdv_CCNDIST_ProductList PL ON CP.PROD_ID = PL.PROD_ID
INNER JOIN DBO.RA_Product_XREF X ON CP.prod_id = X.Prod_id and x.branch = '22 - CCN Distributors'
where CP.prod_id <> '001'



union all 

SELECT DISTINCT
--a.*,
'IN_OPERATION' Status
--,CONCAT('DP-',AC.CUSTOMER_NO,'-',(Format(Row_Number() Over (Order By AC.CUSTOMER_NO, CP.ROUTE_ID),'00'))) ObjectId
,CONCAT('DP-',AC.CUSTOMER_NO,'-',REPLACE(CP.ROUTE_ID, ACCTNO, ''),CP.prod_id) ObjectId
, PL.prod_desc Description
, '74023' Site  --LaGrange
, 'Equipment' ObjectLevel  --600 = Equipment
, '' ItemClass -- 300 = Drinking Water
, X.IFS_PART_NO PartNo
,  CONVERT(NVARCHAR,SYSDATETIME(),101)  InstallationDate
,  concat(ac.customer_no,'-','1',REPLACE(CP.ROUTE_ID, ACCTNO, '')) LocationId
, '' SerialNo
, '' FixedAssests
, '' FreeNotes
, 'CUSTOMER' PartyType
, ac.customer_no  CustomerNo


from dbo.RouteAdv_SUPMTWA_Custprods CP
INNER JOIN [dbo].[RouteAdv_SUPMTWA_CustomerMaster] CM ON CM.route_id = CP.route_id
INNER JOIN DBO.customer_active_scope AC ON CM.acctno = AC.legacy_number AND AC.legacy_migration_source = 'RA_SUP'
INNER JOIN dbo.RouteAdv_SUPMTWA_ProductList PL ON CP.PROD_ID = PL.PROD_ID
INNER JOIN DBO.RA_Product_XREF X ON CP.prod_id = X.Prod_id and x.branch = '23 - Superior Mountain'
where CP.prod_id <> '9999'

ORDER BY 2






