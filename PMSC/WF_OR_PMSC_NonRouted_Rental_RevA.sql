select distinct 

74004 Site_PM
,case when cs.serv_start_date = '1920-01-01' 
then CAST(GETDATE() AS DATE) else convert(nvarchar,cs.SERV_START_DATE,101) end ValidFrom_PM
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
, AC.CUSTOMER_NO
, cONCAT('04', '-',CS.ACCOUNT_NUMBER,'-',CS.SERVICE_NUMBER) ContractID_SC
, sc.SERV_LONG_DESC ContractName
, 'USD' CurrencyCode
,
 case	
	when st.service_code = cs.SERVICE_C then isnull(st.contract_type,'') end ContractType
, fo.objectid ObjectId
, '1' PriceUnitLength
, case 
	WHEN cs.bill_override_c = 'N' THEN 'MONTH'
	WHEN cs.bill_override_c = 'A' THEN 'YEAR' END PriceUnit
, 'TRUE' CreatePeriodAllocation
, 'PRIOR' InvoiceRule
, convert(nvarchar,(CASE 
					when cs.NEXT_DELV_DATE is null then SYSDATETIME()
					WHEN cs.DELV_FREQUENCY > 0  AND cs.NEXT_DELV_DATE < CAST(GETDATE() AS DATE) and cs.next_delv_date is not null
							THEN (DATEADD(DAY,(ROUND(((DATEDIFF(WEEK, cs.NEXT_DELV_DATE,CAST(GETDATE() AS DATE)))/(cs.DELV_FREQUENCY*7)),0))*(cs.DELV_FREQUENCY*7) , cs.NEXT_DELV_DATE)) 
					ELSE  cs.NEXT_DELV_DATE  END),101)  PlanStartDate
, '12/31/2099' PlanEndDate
, '1' InvoicingInterval
, case 
	WHEN cs.bill_override_c = 'N' THEN 'MONTH'
	WHEN cs.bill_override_c ='A' THEN 'YEAR' END InvoicingIntervalUnit
, CONCAT('700000',CS.SERVICE_C) SalesPart
, case when cs.SERVICE_RATE = '0' and o.UNIT_PRICE <> '0' then o.UNIT_PRICE else cs.service_rate end 	PriceCurr
, 'FALSE' IncludeObjectsaddedtoStructure_SC 
FROM 
dbo.WF_OR_CustServ cs
INNER JOIN [dbo].[WF_OR_CUSTOMER] C ON cs.ACCOUNT_NUMBER = C.ACCOUNT_NUMBER
inner join dbo.customer_active_scope ac on ac.legacy_number = cs.account_number and ac.legacy_number = c.account_number and ac.legacy_migration_source = '04 - Orlando' inner join dbo.WF_OR_ServiceCodes sc on cs.service_c = sc.SERVICE_C
left join [dbo].[z_transcodepart] X ON isnull(CS.TRANSACTION_C,'') = isnull(X.WATERFLEX_TRANS_CODE,'')
 left join [dbo].[WF_OR_CustOverride] O on cs.ACCOUNT_NUMBER = o.ACCOUNT_NUMBER and cs.TRANSACTION_C = o.TRANSACTION_C
 left join dbo.z_WF_FuncObj_Serv fo on 
		cs.ACCOUNT_NUMBER = fo.account_number and cs.SERVICE_NUMBER = fo.service_number  and ac.legacy_number = fo.account_number
		and ac.customer_no = fo.customer_NO
left join [dbo].[WF_ContractServiceTranslation] ST ON ST.BRANCH = '04 - Orlando' AND CS.SERVICE_C = ST.service_code
where ((cs.SERV_TERM_DATE is null or cs.SERV_TERM_DATE = '') and (cs.TERM_REASON_C is null or cs.TERM_REASON_C = '')) and 
CS.SERV_TYPE_C = 'RN' and cs.DELV_ROUTE_1 = 'NO' order by 1
