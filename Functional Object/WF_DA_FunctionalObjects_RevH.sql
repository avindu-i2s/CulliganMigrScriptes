---FUNCTIONAL OBJECT (OU01)

/*
	------REVISION NOTES ------
	
	20230727	REV A  BN  REWORK OF QUERY;  Jax Only; FUNCTIONAL OBJECTS WILL BE CREATED FOR EVERY INDIVIDUAL PIECE OF EQUIPMENT AND EVERY SERVICE THAT IS ACTIVE FOR ACTIVE CUSTOMERS
	20230731	REV B	BN	Updated Query Based on Initial Review and Query Validation Questions;  
						Created Active Fixed Asset Column for Fixed Assets that are less than 7 years old due to depreciation	
	20230804	REV C	BN	ADDED Union statement to add a Customer Row for each functional object with a fixed asset. 
							Update Site to the correct value
	20230805	REVD	BN	Udpdated Dealer Own Customer Identity to US+SITE
							Added Site Variable
	20230808	REV E	BN	Update to Service Functional Object ID to include the ServTypeC as the prefix
							Created Master Table of Service Functional Object ID dbo.z_WF_FuncObj_Serv	
	20230824	REV F	BN	Update the Translation List parts
	20230828	REV G	BN	Renumber Functional Objects 
	20231008	REV H	BN  Added HOM service codes into the functional objects that should be in scope based on new Mapping Rules from Lauren b.
*/

/*
--------Query Validation/Questions----
Query Update Rev B
	1.  Date format for Installation Date?   mm/dd/yyyy 


2.  The Customer Location is defaulted to CustomerNo+_10, do we need to apply logic?  
	   --Add Logic to Pull the Location ID based on the Customer Master
3.  Review the Ojects starting with 'SEENOTES'
		---Pull A list of the 'SEE Notes'; Send for Review
4.  Fixed Asset ID is following the same ID as the Functional Object ID.  Do we want to change that?  
		(Updated) Fixed Asset ID will be 2######### 
		--Exclude Fixed Asset ID on Dealer Owned Equipment (Tor Getting Clarifications) 
5.  The Delivered Product Part Numbers need work.....
		--PUll this of Objects with no Part Number 
6.  Need to Add the 'Tom Translated Parts List' to Part Master before this can be run
		--Parts Listing and Parts to be Added to IFS.  

*/


DECLARE
@SITE_ VARCHAR(10) = '74018',
@MigSource_ varchar(50) = '18 - Daytona Beach'

SELECT DISTINCT


 'IN_OPERATION' Status
 ,  FO.FuncObjID /*case 
	when UPPER(ce.SERIAL_NUMBER) LIKE 'ZZ%'  THEN Concat(Concat(Z.IFS_PARTNO,'-'),upper(REPLACE(ce.INSTALLED_DATE,'-','')))
	when UPPER(ce.SERIAL_NUMBER) LIKE 'xxzz%'  THEN Concat(Concat(Z.IFS_PARTNO,'-'),upper(REPLACE(ce.INSTALLED_DATE,'-','')))
	ELSE Concat(Concat(Z.IFS_PARTNO,'-'),upper(ce.SERIAL_NUMBER)) 
	END */ObjectId 
,ec.EQUIPMENT_desc Description
, @SITE_ Site
, 'Equipment' ObjectLevel
, '' ItemClass

,  case when Z.IFS_PARTNO is null then ''
	when Z.IFS_PARTNO  = '' then '' 
		else Z.IFS_PARTNO end  PartNo
,  CONVERT(NVARCHAR,ce.Installed_date,101) InstallationDate
, concat(ac.customer_no,'_10') LocationId
,'' belongstoobject
, upper(ce.SERIAL_NUMBER) SerialNo
, CASE WHEN CE.DEALER_OWNED_C = 'D' THEN IFS_FA_ID ELSE '' END 
/*, case when ce.DEALER_OWNED_C = 'D' then  ( case 
	when UPPER(ce.SERIAL_NUMBER) LIKE 'ZZ%'  THEN Concat(Concat(z.PartNoObject,'-'),upper(REPLACE(ce.INSTALLED_DATE,'-','')))
	when UPPER(ce.SERIAL_NUMBER) LIKE 'xxzz%'  THEN Concat(Concat(z.PartNoObject,'-'),upper(REPLACE(ce.INSTALLED_DATE,'-','')))
	ELSE Concat(Concat(z.PartNoObject,'-'),upper(ce.SERIAL_NUMBER)) 
	END)
		when ce.DEALER_OWNED_C = 'C' THEN '' 
		ELSE CE.DEALER_OWNED_C END*/  FixedAsset
, '' FreeNotes
, CASE when ce.DEALER_OWNED_C = 'C' THEN 'CUSTOMER' 
	WHEN ce.DEALER_OWNED_C = 'D' THEN 'OWNER' END PartyType
, CASE when ce.DEALER_OWNED_C = 'C' THEN ac.customer_no 
	WHEN ce.DEALER_OWNED_C = 'D' THEN CONCAT('US',@SITE_) END  PartyIdentity


FROM 
dbo.WF_DA_CustEquip ce 
inner join  dbo.WF_DA_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = @MigSource_
LEFT JOIN WF_DA_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join [dbo].[WF_aComboEQTranslation] z on ce.equipment_c = z.equipment_c and z.db_source = @MigSource_
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
inner join dbo.IFS_WF_FUNCOBJ fo on fo.branch_datasource =  @MigSource_ and ce.EQUIPMENT_C = fo.equipment_c and CE.ACCOUNT_NUMBER = FO.ACCOUNT_NUMBER AND CE.SERIAL_NUMBER = FO.SERIAL_NUMBER AND AC.customer_no = FO.IFS_cust_no

--where ce.EQUIPMENT_C = 'SEE'

UNION 


SELECT DISTINCT


 'IN_OPERATION' Status
,  FO.FUNCOBJID /*case 
	when UPPER(ce.SERIAL_NUMBER) LIKE 'ZZ%'  THEN Concat(Concat(Z.IFS_PARTNO,'-'),upper(REPLACE(ce.INSTALLED_DATE,'-','')))
	when UPPER(ce.SERIAL_NUMBER) LIKE 'xxzz%'  THEN Concat(Concat(Z.IFS_PARTNO,'-'),upper(REPLACE(ce.INSTALLED_DATE,'-','')))
	ELSE Concat(Concat(Z.IFS_PARTNO,'-'),upper(ce.SERIAL_NUMBER)) 
	END */ObjectId 
,ec.EQUIPMENT_desc Description
, @SITE_ Site
, 'Equipment' ObjectLevel
, '' ItemClass
,  case when Z.IFS_PARTNO is null then ''
	when Z.IFS_PARTNO  = '' then '' 
		else Z.IFS_PARTNO end  PartNo
,  CONVERT(NVARCHAR,ce.Installed_date,101) InstallationDate
, concat(ac.customer_no,'_10') LocationId
,'' belongstoobject
, upper(ce.SERIAL_NUMBER) SerialNo
, CASE WHEN CE.DEALER_OWNED_C = 'D' THEN IFS_FA_ID ELSE '' END  FixedAsset
, '' FreeNotes
,  'CUSTOMER' PartyType
,  ac.customer_no  PartyIdentity


FROM 
dbo.WF_DA_CustEquip ce 
inner join  dbo.WF_DA_EquipmentCodes ec on ec.EQUIPMENT_C = ce.EQUIPMENT_C
inner join dbo.customer_active_scope ac on ac.legacy_number = ce.account_number  and ac.legacy_migration_source = @MigSource_
LEFT JOIN WF_DA_EquipmentMaster eq ON ce.SERIAL_NUMBER = eq.SERIAL_NUMBER AND ce.EQUIPMENT_C = eq.EQUIPMENT_C and eq.EQUIPMENT_C = ec.equipment_c and eq.CURRENT_ACCOUNT = ce.ACCOUNT_NUMBER and eq.CURRENT_ACCOUNT = ac.legacy_number
left join [dbo].[WF_aComboEQTranslation] z on ce.equipment_c = z.equipment_c and z.db_source = @MigSource_
left join dbo.IFS_FA_ID FA ON CE.EQUIPMENT_C = FA.EQUIPMENT_C AND FA.ACCOUNT_NUMBER = CE.ACCOUNT_NUMBER AND FA.SERIAL_NUMBER = CE.SERIAL_NUMBER
inner join dbo.IFS_WF_FUNCOBJ fo on fo.branch_datasource =  @MigSource_ and ce.EQUIPMENT_C = fo.equipment_c and CE.ACCOUNT_NUMBER = FO.ACCOUNT_NUMBER AND CE.SERIAL_NUMBER = FO.SERIAL_NUMBER AND AC.customer_no = FO.IFS_cust_no

where CE.DEALER_OWNED_C = 'D' and IFS_FA_ID is not null 

UNION

SELECT DISTINCT

 'IN_OPERATION' Status
, --CONCAT(cs.serv_type_c,'-',CONCAT(concat(AC.customer_no,'-'),ROW_NUMBER() OVER(PARTITION BY AC.customer_no ORDER BY CS.SERVICE_C ASC)))
 fo.objectid ObjectId
, CONCAT('Service - ', dbo.propercase(sc.SERV_LONG_DESC)) Description
, @SITE_ Site
, 'Equipment' ObjectLevel
, '' ItemClass
, CONCAT('700000',CS.SERVICE_C)PartNo
,  CONVERT(NVARCHAR,cs.SERV_START_DATE,101) InstallationDate
, concat(ac.customer_no,'_10') LocationId
,'' belongstoobject
, '' SerialNo
, '' FixedAssests
, '' FreeNotes
, 'CUSTOMER' PartyType
, ac.customer_no PartyIdentity

FROM 
dbo.WF_DA_CustServ cs
inner join dbo.customer_active_scope ac on ac.legacy_number = cs.account_number and ac.legacy_migration_source = @MigSource_
inner join dbo.WF_DA_ServiceCodes sc on cs.service_c = sc.SERVICE_C
left join [dbo].[z_transcodepart] X ON CS.TRANSACTION_C = X.WATERFLEX_TRANS_CODE
left join dbo.z_WF_FuncObj_Serv fo on 
		cs.ACCOUNT_NUMBER = fo.account_number and cs.SERVICE_NUMBER = fo.service_number  and ac.legacy_number = fo.account_number
		and ac.customer_no = fo.customer_NO
where cs.SERV_TERM_DATE is null --and CS.SERVICE_C <> 'HOM'



order by 2