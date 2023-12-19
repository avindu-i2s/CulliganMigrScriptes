--Fixed Asset (FA01)

/*
------REVISION NOTES ------
20230829	REV A  BN  Initial Query
*/


/*
--------Open - Query Validation/Questions----
1.  Review Missign Site's;  Sites are based on Service Location for the values of the CustomerID +Customer Location 
*/



select distinct
'DMS_OH' datasource
, 'US73000' Company
, FA.IFS_FA_ID Object
, CASE 
	WHEN FA.EQUIPMENT_C = '???' AND B.DESCRIPTION IS NULL THEN 'Unknown Description for Model ???'
	WHEN FA.EQUIPMENT_C IS NULL AND B.DESCRIPTION IS NULL THEN 'Unknown Description for Blank Model'
	WHEN FA.EQUIPMENT_C = 'TOWER' AND B.DESCRIPTION IS NULL THEN 'Unknown Description for Model TOWER'
	else B.DESCRIPTION end Description
, 'Normal' ObjectType
, '170595' ObjectGroup
, 'DEFAULT' AcquisitionReason
, CASE WHEN D.SVCLOC = '2' THEN '73016'
WHEN D.SVCLOC = 'A' THEN '73046'
WHEN D.SVCLOC = 'C' THEN '73017'
WHEN D.SVCLOC = 'D' THEN '73016'
WHEN D.SVCLOC = 'F' THEN '73038'
WHEN D.SVCLOC = 'H' THEN '73016'
WHEN D.SVCLOC = 'I' THEN '73038'
WHEN D.SVCLOC = 'J' THEN '73043'
WHEN D.SVCLOC = 'N' THEN '73045'
WHEN D.SVCLOC = 'R' THEN '73015'
WHEN D.SVCLOC = 'U' THEN 'NA' 
ELSE '' END  Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  '' INSTALL_DATE
FROM IFS_FA_ID FA
LEFT JOIN  [dbo].[WaterCo_DMS_OH_Inv] A ON
	A.CUSTID = FA.ACCOUNT_NUMBER 	AND ISNULL(FA.SERIAL_NUMBER,'') = ISNULL(A.SERIALNO,'')
	AND A.CODE = FA.DEALER_OWNED_C AND isnull(A.MODELNO,'') = isnull(FA.EQUIPMENT_C,'')
left join [dbo].[WaterCo_DMS_OH_Model] b on B.MODELNO = FA.EQUIPMENT_C
left join [dbo].[WaterCo_DMS_OH_Cust] d on A.CUSTID = D.CUSTID AND ISNULL(A.CUSTLOC,'') = ISNULL(D.CUSTLOC,'') 
		AND  FA.ACCOUNT_NUMBER = D.CUSTID
WHERE FA.branch_datasource = 'DMS_OH'
 UNION 
select distinct
'DMS_CS' datasource
, 'US73000' Company
, FA.IFS_FA_ID Object
, CASE 
	WHEN FA.EQUIPMENT_C = '???' AND B.DESCRIPTION IS NULL THEN 'Unknown Description for Model ???'
	WHEN FA.EQUIPMENT_C IS NULL AND B.DESCRIPTION IS NULL THEN 'Unknown Description for Blank Model'
	else B.DESCRIPTION end Description
, 'Normal' ObjectType
, '170595' ObjectGroup
, 'DEFAULT' AcquisitionReason
, CASE WHEN SVCLOC = 'C' THEN '73036'
WHEN SVCLOC = 'D' THEN '73047'
WHEN SVCLOC = 'E' THEN '73036'
WHEN SVCLOC = 'F' THEN '73042'
WHEN SVCLOC = 'H' THEN '73042'
WHEN SVCLOC = 'K' THEN '73041'
WHEN SVCLOC = 'P' THEN '73040'
WHEN SVCLOC = 'V' THEN '73039'
WHEN SVCLOC = 'W' THEN '73036'
ELSE '' END  Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  '' INSTALL_DATE
FROM IFS_FA_ID FA
LEFT JOIN  [dbo].[WaterCo_DMS_CS_Inv] A ON
	A.CUSTID = FA.ACCOUNT_NUMBER 	AND ISNULL(FA.SERIAL_NUMBER,'') = ISNULL(A.SERIALNO,'')
	AND A.CODE = FA.DEALER_OWNED_C AND isnull(A.MODELNO,'') = isnull(FA.EQUIPMENT_C,'')
left join [dbo].[WaterCo_DMS_CS_Model] b on B.MODELNO = FA.EQUIPMENT_C
left join [dbo].[WaterCo_DMS_CS_Cust] d on A.CUSTID = D.CUSTID AND ISNULL(A.CUSTLOC,'') = ISNULL(D.CUSTLOC,'') 
		AND  FA.ACCOUNT_NUMBER = D.CUSTID
WHERE FA.branch_datasource = 'DMS_CS'
UNION
select distinct
'DMS_HV' datasource
, 'US73000' Company
, FA.IFS_FA_ID Object
, B.DESCRIPTION  Description
, 'Normal' ObjectType
, '170595' ObjectGroup
, 'DEFAULT' AcquisitionReason
, CASE WHEN SVCLOC = 'L' THEN '73013'
WHEN SVCLOC = 'N' THEN '73013'
WHEN SVCLOC = 'S' THEN '73073'
WHEN SVCLOC = 'T' THEN '73014'
WHEN SVCLOC = 'W' THEN '73071'
WHEN SVCLOC = 'X' THEN '73070' 
ELSE '' END  Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  '' INSTALL_DATE
FROM IFS_FA_ID FA
LEFT JOIN  [dbo].[WaterCo_DMS_HV_Inv] A ON
	A.CUSTID = FA.ACCOUNT_NUMBER 	AND ISNULL(FA.SERIAL_NUMBER,'') = ISNULL(A.SERIALNO,'')
	AND A.CODE = FA.DEALER_OWNED_C AND isnull(A.MODELNO,'') = isnull(FA.EQUIPMENT_C,'')
left join [dbo].[WaterCo_DMS_HV_Model] b on B.MODELNO = FA.EQUIPMENT_C
left join [dbo].[WaterCo_DMS_HV_Cust] d on A.CUSTID = D.CUSTID AND ISNULL(A.CUSTLOC,'') = ISNULL(D.CUSTLOC,'') 
		AND  FA.ACCOUNT_NUMBER = D.CUSTID
WHERE FA.branch_datasource = 'DMS_HV'
UNION 

select distinct
'DMS_NCA' datasource
, 'US73000' Company
, FA.IFS_FA_ID Object
, B.DESCRIPTION  Description
, 'Normal' ObjectType
, '170595' ObjectGroup
, 'DEFAULT' AcquisitionReason
, CASE 
WHEN SVCLOC = 'A' THEN '73022'
WHEN SVCLOC = 'B' THEN '73024'
WHEN SVCLOC = 'E' THEN '73022'
WHEN SVCLOC = 'G' THEN '73024'
WHEN SVCLOC = 'M' THEN '73024'
WHEN SVCLOC = 'N' THEN '73023'
WHEN SVCLOC = 'Q' THEN '73022'
WHEN SVCLOC = 'S' THEN '73022'
WHEN SVCLOC = 'V' THEN '73023'
ELSE '' END  Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  '' INSTALL_DATE
FROM IFS_FA_ID FA
LEFT JOIN  [dbo].[WaterCo_DMS_NCA_Inv] A ON
	A.CUSTID = FA.ACCOUNT_NUMBER 	AND ISNULL(FA.SERIAL_NUMBER,'') = ISNULL(A.SERIALNO,'')
	AND A.CODE = FA.DEALER_OWNED_C AND isnull(A.MODELNO,'') = isnull(FA.EQUIPMENT_C,'')
left join [dbo].[WaterCo_DMS_NCA_Model] b on B.MODELNO = FA.EQUIPMENT_C
left join [dbo].[WaterCo_DMS_NCA_Cust] d on A.CUSTID = D.CUSTID AND ISNULL(A.CUSTLOC,'') = ISNULL(D.CUSTLOC,'') 
		AND  FA.ACCOUNT_NUMBER = D.CUSTID
WHERE FA.branch_datasource = 'DMS_NCA'
UNION

select distinct
'DMS_NE' datasource
, 'US73000' Company
, FA.IFS_FA_ID Object
, B.DESCRIPTION  Description
, 'Normal' ObjectType
, '170595' ObjectGroup
, 'DEFAULT' AcquisitionReason
, CASE 
WHEN SVCLOC = '3' THEN '73012'
WHEN SVCLOC = '4' THEN '73012'
WHEN SVCLOC = 'A' THEN '73008'
WHEN SVCLOC = 'B' THEN '73012'
WHEN SVCLOC = 'C' THEN '73009'
WHEN SVCLOC = 'K' THEN '73009'
WHEN SVCLOC = 'L' THEN '73009'
WHEN SVCLOC = 'M' THEN '73011'
WHEN SVCLOC = 'S' THEN '73011'
WHEN SVCLOC = 'W' THEN '73010'
ELSE '' END  Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  '' INSTALL_DATE
FROM IFS_FA_ID FA
LEFT JOIN  [dbo].[WaterCo_DMS_NE_Inv] A ON
	A.CUSTID = FA.ACCOUNT_NUMBER 	AND ISNULL(FA.SERIAL_NUMBER,'') = ISNULL(A.SERIALNO,'')
	AND A.CODE = FA.DEALER_OWNED_C AND isnull(A.MODELNO,'') = isnull(FA.EQUIPMENT_C,'')
left join [dbo].[WaterCo_DMS_NE_Model] b on B.MODELNO = FA.EQUIPMENT_C
left join [dbo].[WaterCo_DMS_NE_Cust] d on A.CUSTID = D.CUSTID AND ISNULL(A.CUSTLOC,'') = ISNULL(D.CUSTLOC,'') 
		AND  FA.ACCOUNT_NUMBER = D.CUSTID
WHERE FA.branch_datasource = 'DMS_NE'
UNION 
select distinct
'DMS_PNW' datasource
, 'US73000' Company
, FA.IFS_FA_ID Object
, B.DESCRIPTION  Description
, 'Normal' ObjectType
, '170595' ObjectGroup
, 'DEFAULT' AcquisitionReason
, CASE 
WHEN SVCLOC = 'B' THEN '73032'
WHEN SVCLOC = 'C' THEN '73020'
WHEN SVCLOC = 'I' THEN '73021'
WHEN SVCLOC = 'K' THEN '73020'
WHEN SVCLOC = 'O' THEN '73021'
WHEN SVCLOC = 'P' THEN '73018'
WHEN SVCLOC = 'Q' THEN '73020'
WHEN SVCLOC = 'S' THEN '73031'
WHEN SVCLOC = 'T' THEN '73020'
WHEN SVCLOC = 'W' THEN '73033'
WHEN SVCLOC = 'Y' THEN '73019'
ELSE '' END  Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  '' INSTALL_DATE
FROM IFS_FA_ID FA
LEFT JOIN  [dbo].[WaterCo_DMS_PNW_Inv] A ON
	A.CUSTID = FA.ACCOUNT_NUMBER 	AND ISNULL(FA.SERIAL_NUMBER,'') = ISNULL(A.SERIALNO,'')
	AND A.CODE = FA.DEALER_OWNED_C AND isnull(A.MODELNO,'') = isnull(FA.EQUIPMENT_C,'')
left join [dbo].[WaterCo_DMS_PNW_Model] b on B.MODELNO = FA.EQUIPMENT_C
left join [dbo].[WaterCo_DMS_PNW_Cust] d on A.CUSTID = D.CUSTID AND ISNULL(A.CUSTLOC,'') = ISNULL(D.CUSTLOC,'') 
		AND  FA.ACCOUNT_NUMBER = D.CUSTID
WHERE FA.branch_datasource = 'DMS_PNW'




order by 3