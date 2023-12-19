select distinct 

case
when cs.DELV_ROUTE_1 <> 'NO'  and cs.service_c in ('SLT','PCC','PCR','PCS','PRR','PRS','PRU') 
	THEN CONCAT('S',cs.DELV_FREQUENCY)  ELSE  CONCAT('W',cs.DELV_FREQUENCY)end  Action_PM
,74011 Site_PM
,fo.objectid ObjectId_PM
,case when cs.serv_start_date = '1920-01-01' 
then CAST(GETDATE() AS DATE) else convert(nvarchar,cs.SERV_START_DATE,101) end ValidFrom_PM
, CONCAT('CWG_R',CS.DELV_ROUTE_1) Calendar_PM
, '2000' MaintOrg_PM
,CASE
WHEN cs.SERVICE_C in ('BIL','COF','CPM','CSR','EQC','HMM','HOM','HPM','OVC','SCC','SCH','SCO','SVC','SVH','UNK') and CS.TRANSACTION_C is not null THEN
          CASE
            WHEN CS.TRANSACTION_C IN ('96RC','CAR','FILR','LCAR') THEN
             CASE
               WHEN C.CUSTOMER_TYPE_F in ('C','I') THEN
                '800'
               WHEN C.CUSTOMER_TYPE_F = 'R' THEN
                '300'
             END
            WHEN CS.TRANSACTION_C IN ('BW10','BW5S','BWD1','BWF3','BWF4','BWP3','BWPR','BWS4','BWS5','CFL7','CONE','FUEL','L681','L688','L696','PKRO','QFSD','T40P','T40R','T40S','T4SF') THEN
             CASE
               WHEN C.CUSTOMER_TYPE_F in ('C','I') THEN
                '900'
               WHEN C.CUSTOMER_TYPE_F = 'R' THEN
                '400'
             END
           WHEN CS.TRANSACTION_C IN ('PECB','PEIT','PESV') AND C.CUSTOMER_TYPE_F in ('R','C','I') THEN
                 '301'
           WHEN CS.TRANSACTION_C = 'SCON' AND C.CUSTOMER_TYPE_F in ('R','C','I') THEN
                         '500'
          END
         WHEN C.CUSTOMER_TYPE_F = 'R' AND CS.SERVICE_c = ST.SERVICE_Code THEN
          isnull(ST.Residential_Work_Type, '')
       
         WHEN C.CUSTOMER_TYPE_F in ('C','I') AND
              CS.SERVICE_C = ST.SERVICE_Code THEN
          isnull(ST.Commerical_Work_Type, '')
       
       end WorkType
	   , '.15' ExecutionTime_PM
, 'TNORGREN' PlannedBy_PM
, AC.CUSTOMER_NO Customer_PM
, cONCAT('11', '-',CS.ACCOUNT_NUMBER,'-',CS.SERVICE_NUMBER) ContractID_SC
, 1 LineNo_PMSC
, 'DAY' StartUnit_PM
, convert(nvarchar,(CASE 
   	WHEN cs.DELV_FREQUENCY > 0 AND cs.NEXT_DELV_DATE  <= CAST(GETDATE() AS DATE) 
			THEN (DATEADD(DAY,(ROUND(((DATEDIFF(DAY, cs.NEXT_DELV_DATE,CAST(GETDATE() AS DATE)))/(cs.DELV_FREQUENCY*7)),0))*(cs.DELV_FREQUENCY*7) , cs.NEXT_DELV_DATE)) 
			WHEN cs.NEXT_DELV_DATE  IS NULL THEN CAST(GETDATE() AS DATE) 
				ELSE  cs.NEXT_DELV_DATE END),101)  StartValue_PM
, 'WEEK' IntervalUnit_PM
, CS.DELV_FREQUENCY  Interval_pm
, 'YES' PerformedDateBased_PM
, SC.SERV_LONG_DESC  WorkDescription_pm
, 1 WorkDuration_PM
, 'Person' ResourceDemandType_PM
, 'EDG_OC_DEL' ResourceGroup_PM
,CASE 
WHEN cs.delv_truck_1 IS NOT NULL THEN CONCAT('CH_TRUCK_',cs.delv_truck_1)
		ELSE '' END  Resource_PM
, 1 ResourcePlannedQty_PM
, case	
	when cs.TRANSACTION_C =  x1.CWG_Part_Number then x1.ifs_number2 
	when cs.TRANSACTION_C = x.New_MAS_Item_Code then x1.ifs_number2
	else Concat('I70000',CS.service_c)  
		end   MaterialPartNo_PM,
 case	when cs.PUR_AMT_PER_TOT <> 0 then round((cs.PUR_AMT_PER_TOT/cs.SUPPLY_PER_TOT ),2) 
		when cs.PUR_AMT_PER_TOT = 0 AND CS.SERVICE_RATE = 0 AND O.UNIT_PRICE IS NOT NULL then round(o.unit_price, 2) 
		WHEN cs.PUR_AMT_PER_TOT = 0 AND  o.unit_price IS NULL THEN '0.00'
		WHEN CS.PUR_AMT_PER_TOT = 0 AND CS.SUPPLY_PER_TOT = 0 AND CS.SERVICE_RATE = 0 AND O.UNIT_PRICE IS NULL THEN '0.00'	
		else '0.00' end SalesPriceUnit_PM
, case 
		when (CONVERT(DECIMAL,cs.bottle_delv_1)+CONVERT(DECIMAL,cs.bottle_delv_2)+CONVERT(DECIMAL,cs.bottle_delv_3)) = 0 then '0' 
		else CONVERT(INT, round(((CONVERT(DECIMAL,cs.bottle_delv_1)+CONVERT(DECIMAL,cs.bottle_delv_2)+CONVERT(DECIMAL,cs.bottle_delv_3))/3),0)) end  MaterialPlannedQty_PM
, 'USD' CurrencyCode_SC
, sc.SERV_LONG_DESC ContractName_SC
, case	
	when st.service_code = cs.SERVICE_C then isnull(st.contract_type,'') end  ContractType_SC
 , '1' PriceUnitLength_PMSC
, case 
	WHEN cs.bill_override_c = 'N ' THEN 'MONTH'
	WHEN cs.bill_override_c = 'A' THEN 'YEAR' END  PriceUnit_PMSC
, 'TRUE' CreatePeriodAllocation_SC
, 'PRIOR' InvoiceRule_SC
, convert(nvarchar,(CASE 
					when cs.NEXT_DELV_DATE is null then SYSDATETIME()
					WHEN cs.DELV_FREQUENCY > 0  AND cs.NEXT_DELV_DATE < CAST(GETDATE() AS DATE) and cs.next_delv_date is not null
							THEN (DATEADD(DAY,(ROUND(((DATEDIFF(WEEK, cs.NEXT_DELV_DATE,CAST(GETDATE() AS DATE)))/(cs.DELV_FREQUENCY*7)),0))*(cs.DELV_FREQUENCY*7) , cs.NEXT_DELV_DATE)) 
					ELSE  cs.NEXT_DELV_DATE  END),101)  PlanStartDate_SC
, '12/31/2099' PlanEndDate_SC
, '1' InvoicingInterval_SC
, case 
	WHEN cs.bill_override_c = 'N' THEN 'MONTH'
	WHEN cs.bill_override_c = 'A' THEN 'YEAR' END InvoicingIntervalUnit_SC
,   CONCAT('700000',CS.SERVICE_C)
		SalesPart_SC
, case	
		when CS.SERV_TYPE_C = 'RN' AND (CS.SERVICE_RATE IS NOT NULL OR CS.SERVICE_RATE > 0) THEN CS.SERVICE_RATE
		when  CS.SERV_TYPE_C = 'RN' AND CS.SERVICE_RATE IS NULL THEN '0.00'
		when  CS.SERV_TYPE_C = 'RN' AND CS.SERVICE_RATE = 0 THEN o.UNIT_PRICE
		else '0.00' 
		end PriceCurr_SC
, 'FALSE' IncludeObjectsaddedtoStructure_SC 
FROM 
dbo.WF_CH_CustServ cs
INNER JOIN [dbo].[WF_CH_CUSTOMER] C ON cs.ACCOUNT_NUMBER = C.ACCOUNT_NUMBER
inner join dbo.customer_active_scope ac on ac.legacy_number = cs.account_number and ac.legacy_number = c.account_number and ac.legacy_migration_source = '11 - Charleston, SC'inner join dbo.WF_CH_ServiceCodes sc on cs.service_c = sc.SERVICE_C
left join [dbo].[z_transcodepart] X ON isnull(CS.TRANSACTION_C,'') = isnull(X.WATERFLEX_TRANS_CODE,'')
left join (select CWG_Part_Number,ifs_number2, IFS_Description from dbo.EDG_NonCullParts_CWG where CWG_Part_Number is not null) X1
			on  (cs.TRANSACTION_C = x1.CWG_Part_Number) or (x.New_MAS_Item_Code = x1.CWG_Part_Number)
 left join [dbo].[WF_CH_CustOverride] O on cs.ACCOUNT_NUMBER = o.ACCOUNT_NUMBER and cs.TRANSACTION_C = o.TRANSACTION_C
 left join dbo.z_WF_FuncObj_Serv fo on 
		cs.ACCOUNT_NUMBER = fo.account_number and cs.SERVICE_NUMBER = fo.service_number  and ac.legacy_number = fo.account_number
		and ac.customer_no = fo.customer_NO
left join [dbo].[WF_All_ContractServiceTranslation_P1] ST ON ST.BRANCH = '11 - Charleston, SC' AND CS.SERVICE_C = ST.service_code
where ((cs.SERV_TERM_DATE is null or cs.SERV_TERM_DATE = '') and (cs.TERM_REASON_C is null or cs.TERM_REASON_C = '')) and 
CS.SERV_TYPE_C = 'RN' and cs.DELV_ROUTE_1 <> 'NO' 
and (cs.DELV_FREQUENCY <>0 or ( cs.DELV_FREQUENCY = 0 and cs.TRANSACTION_C <> '')) order by 1
