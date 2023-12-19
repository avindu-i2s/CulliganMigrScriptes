--Fixed Asset (FA01)

/*
------REVISION NOTES ------
20230727	REV A  BN  REWORK OF QUERY;  Jax Only; FUNCTIONAL OBJECTS WILL BE CREATED FOR EVERY INDIVIDUAL PIECE OF EQUIPMENT AND EVERY SERVICE THAT IS ACTIVE FOR ACTIVE CUSTOMERS
20230731	REV B	BN	Updated Query Based on Initial Review and Query Validation Questions;  
						Created Active Fixed Asset Column for Fixed Assets that are less than 7 years old due to depreciation
						Added All WaterFlex Branch Data for Fixed Assets
20230802	REV C	BN	Status: Remove Status Column. The uploader creates this when Tor loads the data.
						Object type: This needs to be the spelled out and not the number. In this case Rented. Is “Rented” confirmed? We used “Normal” for Pass 1
						Updated Description from Notes for Jax  Equipment = 'SEE'
20230804	REV D	BN	Updated to Object Type From 'Rented' to 'Normal'
						Updated Estimated Life from 7 to 7y 00m
*/


/*

Query Updates in Rev B
5.  Object ID??  How do we want to name them?  These are have the same ID as functional Objects. 
	 Rentals are 10 digit numbers starting with 2
3.  How do we determine wich Depreciation Method to Apply to Fixed Assets?  DB 150 BP is the tentative value for migration; 
	No Updated Needed all fixed assets are using DB 150 BP depreciation method
1.  Object Type '3' = Rented, '1' = Normal, '5' = Expense, '6' =  Planned
	No Update - everyting is set to '3' for rentals
2.  Object Group - 170510 - Rented Equipment.  Why are other in PPR under other codes???  
		No Update - Evething is set to 170510 - Rented Equipment
4.  Review the Objects starting with 'SEE NOTES'
	RAIDD Item #247 - Task for Tor, Tom, Bethany
		With the new object IDS - this doens't apply in this file but will affect functional objects
3.  Should Estimated Life be 7 years across All or 7 years less the lapsed time since rental start date?   
		Always 7 years
      We only want to include equipment that is installed in the last 7 years in Fixed Assets
	  RAIDD Item #248 - Question to Alena


--------Open - Query Validation/Questions----



	  

6.  RAIDD #254 -  '03 - Ocala Culligan' and '06 - West Palm Beach' does not use the Installed Date Field - Need Data


*/

----Rented Customer Equipment Jax
select distinct
'09 - Jacksonville' datasource
, 'US74000' Company
, FA.IFS_FA_ID
/*,  case when ce.DEALER_OWNED_C = 'D' then  ( case 
	when UPPER(ce.SERIAL_NUMBER) LIKE 'ZZ%'  THEN Concat(Concat(z.PartNoObject,'-'),upper(REPLACE(ce.INSTALLED_DATE,'-','')))
	when UPPER(ce.SERIAL_NUMBER) LIKE 'xxzz%'  THEN Concat(Concat(z.PartNoObject,'-'),upper(REPLACE(ce.INSTALLED_DATE,'-','')))
	ELSE Concat(Concat(z.PartNoObject,'-'),upper(ce.SERIAL_NUMBER)) 
	END)
		when ce.DEALER_OWNED_C = 'C' THEN '' 
		ELSE CE.DEALER_OWNED_C END*/  Object
, case when ce.equipment_c = 'SEE' then trim(substring(cn.Note,28,11))+'-'+REPLACE(TRIM(substring(cn.Note,162,30)),'Style: ','')
		else EC.EQUIPMENT_DESC end Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74009' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE

FROM 
dbo.WF_JV_CustEquip ce 
inner join  dbo.WF_JV_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '09 - Jacksonville'
LEFT JOIN WF_JV_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
left join dbo.WF_JV_CustNote  cn on ce.ACCOUNT_NUMBER = cn.ACCOUNT_NUMBER and tRIM(REPLACE(CE.SERIAL_NUMBER,'RM:',''))= TRIM(REPLACE(SUBSTRING(CN.NOTE,1,21),'ID: ',''))

WHERE CE.DEALER_OWNED_C = 'D'

UNION ALL
select distinct
'18 - Daytona Beach' datasource
, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74018' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE

FROM 
dbo.WF_DA_CustEquip ce 
inner join  dbo.WF_DA_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '18 - Daytona Beach'
LEFT JOIN WF_DA_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'

UNION ALL
select distinct
'03 - Ocala Culligan' datasource

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74003' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE
FROM 
dbo.WF_OC_CustEquip ce 
inner join  dbo.WF_OC_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '03 - Ocala Culligan'
LEFT JOIN WF_OC_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'

UNION ALL
select distinct
'04 - Orlando' datasource

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74004' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE
FROM 
dbo.WF_OR_CustEquip ce 
inner join  dbo.WF_OR_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '04 - Orlando'
LEFT JOIN WF_OR_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'

UNION ALL
select distinct
'11 - Charleston, SC' datasource

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74016' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE

FROM 
dbo.WF_CH_CustEquip ce 
inner join  dbo.WF_CH_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '11 - Charleston, SC'
LEFT JOIN WF_CH_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'

UNION ALL
select distinct
'16 - Kingsland' datasource

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74011' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE
FROM 
dbo.WF_KL_CustEquip ce 
inner join  dbo.WF_KL_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '16 - Kingsland'
LEFT JOIN WF_KL_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'

UNION ALL
select distinct
'13 - Myrtle Beach, SC'datasource 

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74013' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE

FROM 
dbo.WF_MB_CustEquip ce 
inner join  dbo.WF_MB_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '13 - Myrtle Beach, SC'
LEFT JOIN WF_MB_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'

UNION ALL
select distinct
'07 - Miami' datasource 

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74007' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE

FROM 
dbo.WF_MI_CustEquip ce 
inner join  dbo.WF_MI_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '07 - Miami'
LEFT JOIN WF_MI_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'

UNION ALL
select distinct
'15 - Melbourne' datasource 

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74015' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE
FROM 
dbo.WF_ML_CustEquip ce 
inner join  dbo.WF_ML_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '15 - Melbourne'
LEFT JOIN WF_ML_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'

UNION ALL
select distinct
'08 - Port St. Lucie' datasource 

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74008' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE
FROM 
dbo.WF_SL_CustEquip ce 
inner join  dbo.WF_SL_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '08 - Port St. Lucie'
LEFT JOIN WF_SL_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'
UNION ALL
select distinct
'05 - Starke' datasource 

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74005' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE

FROM 
dbo.WF_ST_CustEquip ce 
inner join  dbo.WF_ST_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '05 - Starke'
LEFT JOIN WF_ST_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'
UNION ALL
select distinct
'10 - Tallahassee' datasource 

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74010' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE
FROM 
dbo.WF_TA_CustEquip ce 
inner join  dbo.WF_TA_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '10 - Tallahassee'
LEFT JOIN WF_TA_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'
UNION ALL
select distinct
'17 - Vero Beach' datasource 

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74017' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE

FROM 
dbo.WF_VB_CustEquip ce 
inner join  dbo.WF_VB_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '17 - Vero Beach'
LEFT JOIN WF_VB_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'
UNION ALL
select distinct
'06 - West Palm Beach' datasource 

, 'US74000' Company
, FA.IFS_FA_ID Object
, EC.EQUIPMENT_DESC Description
, 'Normal' ObjectType
, '170510' ObjectGroup
, 'DEFAULT' AcquisitionReason
, '74017' Site
, 'INTERNAL' BookID
, 'DB 150 BP' DepreciationMethod
, '7y 00m' EstimatedLife
,  CONVERT(NVARCHAR,ce.Installed_date,101) INSTALL_DATE

FROM 
dbo.WF_WP_CustEquip ce 
inner join  dbo.WF_WP_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = '06 - West Palm Beach'
LEFT JOIN WF_WP_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join zEquipmentTranslation z on ce.equipment_c = z.objectid 
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
WHERE CE.DEALER_OWNED_C = 'D'

order by 4
