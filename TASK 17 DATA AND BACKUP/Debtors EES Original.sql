select * from (select 
customer_num
,customer_name
          ,customer_address
          ,country
          ,customer_location
          ,location_name
          ,proj_name
          ,sales_person
          ,bg_name
          ,bal_due_30
          ,bal_due_30_60
          ,bal_due_60_90
          ,bal_due_90_180
          ,bal_due_180_365
          ,bal_due_365_730
          ,bal_due_731
          ,outstanding
          ,open_credit
          ,pdc_amount
          ,doc_no
          ,TYPE
          ,trx_date
          ,od_no
          ,doc_amount
          ,due_date
          ,cust_ref
          ,(outstanding + open_credit) Balance

from
(SELECT   hca.customer_num customer_num
          ,hca.customer_name customer_name
          ,hca.customer_address customer_address
          ,hca.country
          ,hca.location customer_location
          ,phl.location_name
          ,phl.proj_name
          ,pps.sales_person
          ,hou.name bg_name
          ,NVL (SUM (art.bal_due_30), 0) bal_due_30
          ,NVL (SUM (art.bal_due_30_60), 0) bal_due_30_60
          ,NVL (SUM (art.bal_due_60_90), 0) bal_due_60_90
          ,NVL (SUM (art.bal_due_90_180), 0) bal_due_90_180
          ,NVL (SUM (art.bal_due_180_365), 0) bal_due_180_365
          ,NVL (SUM (art.bal_due_365_730), 0) bal_due_365_730
          ,NVL (SUM (art.bal_due_731), 0) bal_due_731
          ,NVL (SUM (art.unapp_amount), 0) outstanding
          ,NVL (SUM (art.open_credit), 0) open_credit
          ,NVL (SUM (art.pdc_amount), 0) pdc_amount
          ,art.doc_no
          ,art.TYPE
          ,art.trx_date
          ,art.od_no
          ,art.bal_amount doc_amount
          ,art.due_date
          ,art.cust_ref
    FROM   (SELECT   rcp.org_id org_id
                    ,rcp.customer_id
                    ,rcp.customer_site_use_id
                    ,CASE
                        WHEN (TRUNC (TO_DATE (TO_CHAR (:p_date_on
                                                      ,'DDMMYYYY')
                                             ,'DDMMYYYY'))
                              - TRUNC (rcp.trx_date)) <= 30 THEN
                           (NVL (rcp.bal_amount, 0) - NVL (ara.amount_applied, 0))
                        ELSE
                           0
                     END
                        bal_due_30
                    ,CASE
                        WHEN (TRUNC (TO_DATE (TO_CHAR (:p_date_on
                                                      ,'DDMMYYYY')
                                             ,'DDMMYYYY'))
                              - TRUNC (rcp.trx_date)) BETWEEN 31
                                                          AND  60 THEN
                           (NVL (rcp.bal_amount, 0) - NVL (ara.amount_applied, 0))
                        ELSE
                           0
                     END
                        bal_due_30_60
                    ,CASE
                        WHEN (TRUNC (TO_DATE (TO_CHAR (:p_date_on
                                                      ,'DDMMYYYY')
                                             ,'DDMMYYYY'))
                              - TRUNC (rcp.trx_date)) BETWEEN 61
                                                          AND  90 THEN
                           (NVL (rcp.bal_amount, 0) - NVL (ara.amount_applied, 0))
                        ELSE
                           0
                     END
                        bal_due_60_90
                    ,CASE
                        WHEN (TRUNC (TO_DATE (TO_CHAR (:p_date_on
                                                      ,'DDMMYYYY')
                                             ,'DDMMYYYY'))
                              - TRUNC (rcp.trx_date)) BETWEEN 91
                                                          AND  180 THEN
                           (NVL (rcp.bal_amount, 0) - NVL (ara.amount_applied, 0))
                        ELSE
                           0
                     END
                        bal_due_90_180
                    ,CASE
                        WHEN (TRUNC (TO_DATE (TO_CHAR (:p_date_on
                                                      ,'DDMMYYYY')
                                             ,'DDMMYYYY'))
                              - TRUNC (rcp.trx_date)) BETWEEN 181
                                                          AND  365 THEN
                           (NVL (rcp.bal_amount, 0) - NVL (ara.amount_applied, 0))
                        ELSE
                           0
                     END
                        bal_due_180_365
                    ,CASE
                        WHEN (TRUNC (TO_DATE (TO_CHAR (:p_date_on
                                                      ,'DDMMYYYY')
                                             ,'DDMMYYYY'))
                              - TRUNC (rcp.trx_date)) BETWEEN 366
                                                          AND  730 THEN
                           (NVL (rcp.bal_amount, 0) - NVL (ara.amount_applied, 0))
                        ELSE
                           0
                     END
                        bal_due_365_730
                    ,CASE
                        WHEN (TRUNC (TO_DATE (TO_CHAR (:p_date_on
                                                      ,'DDMMYYYY')
                                             ,'DDMMYYYY'))
                              - TRUNC (rcp.trx_date)) >= 731 THEN
                           (NVL (rcp.bal_amount, 0) - NVL (ara.amount_applied, 0))
                        ELSE
                           0
                     END
                        bal_due_731
                    , (NVL (rcp.bal_amount, 0) - NVL (ara.amount_applied, 0)) unapp_amount
                    ,rcp.open_credit open_credit
                    ,0 pdc_amount
                    ,rcp.doc_no
                    ,rcp.TYPE
                    ,rcp.trx_date
                    ,rcp.od_no
                    , pid.project_id
                   -- ,rcp.pa_contract_id
                     --           ,rcp.pa_inv_num
                       --         ,rcp.pa_inv_line_id
                   
                    ,rcp.bal_amount
                    ,rcp.due_date
                    ,rcp.cust_ref
              FROM   (  SELECT   rct.org_id org_id
                                ,rct.bill_to_customer_id customer_id
                                ,rct.bill_to_site_use_id customer_site_use_id
                                ,rct.customer_trx_id
                                ,rct.trx_date
                                ,rct.trx_number doc_no
                                ,rct.purchase_order cust_ref
                                ,SUM (CASE WHEN rctt.TYPE = 'CM' THEN NVL (aps.amount_due_original, 0) * NVL (aps.exchange_rate, 1) ELSE NULL END)
                                    open_credit
                                ,aps.payment_schedule_id
                                ,aps.due_date
                                ,SUM (CASE WHEN rctt.TYPE = 'CM' THEN NULL ELSE NVL (aps.amount_due_original, 0) * NVL (aps.exchange_rate, 1) END)
                                    bal_amount
                                ,rctt.TYPE TYPE
                                ,rct.interface_header_attribute1 od_no
                                ,rct.interface_header_attribute2 pa_contract_id
                                ,rct.interface_header_attribute3 pa_inv_num
                                ,rct.interface_header_attribute5 pa_inv_line_id
                                
                          FROM   ra_customer_trx_all rct
                                ,ar_payment_schedules_all aps
                                ,ra_cust_trx_types_all rctt
                                ,ra_batch_sources_all rbs
                         WHERE   rct.customer_trx_id = aps.customer_trx_id
                             AND rct.cust_trx_type_seq_id = rctt.cust_trx_type_seq_id(+)
                             AND rct.batch_source_seq_id = rbs.batch_source_seq_id
                             AND RCT.trx_number NOT LIKE '200%'
              --               AND rbs.name <> 'OPEN_PA_INV'
                             AND aps.class <> 'PMT'
                             
                      GROUP BY   rct.org_id
                                ,rct.bill_to_customer_id
                                ,rct.bill_to_site_use_id
                                ,rct.customer_trx_id
                                ,rct.trx_date
                                ,rct.trx_number
                                ,rct.purchase_order
                                ,aps.payment_schedule_id
                                ,aps.due_date
                                ,rctt.TYPE
                                ,rct.interface_header_attribute1
                                ,rct.interface_header_attribute2
                                ,rct.interface_header_attribute3
                                ,rct.interface_header_attribute5) rcp
                    , (  SELECT   payment_schedule_id
                                 ,customer_trx_id
                                 ,SUM (amount_applied) amount_applied
                           FROM   (SELECT   ara.applied_payment_schedule_id payment_schedule_id
                                           ,ara.applied_customer_trx_id customer_trx_id
                                           ,ara.acctd_amount_applied_to amount_applied
                                     FROM   ar_receivable_applications_all ara
                                    WHERE   ara.status IN ('APP', 'ACTIVITY')
                                        AND ara.gl_date <= :p_date_on
                                        AND (ara.cash_receipt_id IS NULL
                                          OR EXISTS
                                                (SELECT   1
                                                   FROM   ar_cash_receipt_history_all acrh
                                                  WHERE   acrh.cash_receipt_id = ara.cash_receipt_id
                                                      AND acrh.status = 'CLEARED'
                                                      AND acrh.cash_receipt_history_id =
                                                             (SELECT   MAX (cash_receipt_history_id)
                                                                          KEEP (DENSE_RANK LAST ORDER BY creation_date)
                                                                FROM   ar_cash_receipt_history_all
                                                               WHERE   cash_receipt_id = acrh.cash_receipt_id
                                                                   AND gl_date <= :p_date_on)))
                                   UNION ALL
                                   SELECT   ara.payment_schedule_id
                                           ,ara.customer_trx_id
                                           , (ara.acctd_amount_applied_from * -1) amount_applied
                                     FROM   ar_receivable_applications_all ara
                                    WHERE   ara.status IN ('APP', 'ACTIVITY')
                                        AND ara.gl_date <= :p_date_on
                                   UNION ALL
                                   SELECT   aad.payment_schedule_id
                                           ,aad.customer_trx_id
                                           , (aad.acctd_amount * -1) amount_applied
                                     FROM   ar_adjustments_all aad
                                    WHERE   aad.status = 'A'
                                        AND aad.gl_date <= :p_date_on)
                       GROUP BY   payment_schedule_id
                                 ,customer_trx_id) ara,
               (
        SELECT 
          pil.transaction_project_id project_id, 
          --pil.transaction_task_id task_id, 
          pil.invoice_line_id pa_inv_line_id, 
          pih.invoice_id pa_invoice_id, 
          pih.invoice_num pa_invoice_num, 
          pih.ra_invoice_number ra_invoice_number, 
          SUM (pil.project_curr_billed_amt*nvl(pil.INVOICE_CURR_EXCHG_RATE,1)) pa_invoice_amount 
        FROM 
          pjb_inv_line_dists pil, 
          pjb_invoice_headers pih 
        WHERE 
          pil.invoice_id = pih.invoice_id 
        GROUP BY 
          pil.transaction_project_id, 
          --pil.transaction_task_id, 
          pil.invoice_line_id, 
          pih.invoice_id, 
          pih.invoice_num, 
          pih.ra_invoice_number
      ) pid                   
             WHERE   rcp.customer_trx_id = ara.customer_trx_id(+)
             and  rcp.pa_inv_num = pid.pa_invoice_num(+) 
      AND  rcp.pa_inv_line_id = pid.pa_inv_line_id(+) 
                 AND rcp.payment_schedule_id = ara.payment_schedule_id(+)
                 AND rcp.org_id = NVL (:p_org_id, rcp.org_id)
                 AND TRUNC (rcp.trx_date) <= :p_date_on
				 
				 
            UNION ALL
			
			
			
              SELECT   acr.org_id
                      ,acr.pay_from_customer customer_id
                      ,acr.customer_site_use_id customer_site_use_id
                      ,0 bal_due_30
                      ,0 bal_due_30_60
                      ,0 bal_due_60_90
                      ,0 bal_due_90_180
                      ,0 bal_due_180_365
                      ,0 bal_due_365_730
                      ,0 bal_due_731
                      ,0 unapp_amount
                      ,SUM (CASE WHEN acrh.status ='CLEARED'  THEN ( ( (NVL (acrh.acctd_amount, 0) + NVL (acrh.acctd_factor_discount_amount, 0))* -1) - NVL (ara.app_amount, 0)) ELSE 0 END)
                          open_credit
                      ,SUM (CASE WHEN acrh.status <> 'CLEARED' THEN (NVL (acrh.acctd_amount, 0) + NVL (acrh.acctd_factor_discount_amount, 0)) ELSE 0 END)
                          pdc_amount
                      ,acr.receipt_number doc_no
                      ,'Rct' TYPE
                      ,acr.receipt_date trx_date
                      ,NULL od_no
                      ,null project_id
                      ,NULL bal_amount
                      ,NULL due_date
                      ,NULL cust_ref
                FROM   ar_cash_receipts_all acr
                      ,ar_payment_schedules_all aps
                      ,ar_cash_receipt_history_all acrh
                      , (  SELECT   app.cash_receipt_id
                                   ,SUM (NVL (app.acctd_amount_applied_from, app.acctd_amount_applied_to)) * -1 app_amount
                                   ,SUM (CASE WHEN (app.status = 'ACC') THEN (NVL (app.acctd_amount_applied_from, app.acctd_amount_applied_to)) ELSE 0 END)
                                       onacc_amount
                             FROM   ar_receivable_applications_all app
                            WHERE   app.status IN ('APP', 'ACC', 'ACTIVITY')
                                AND app.gl_date <= :p_date_on
                         GROUP BY   app.cash_receipt_id) ara
               WHERE   acr.cash_receipt_id = aps.cash_receipt_id
                   AND acr.cash_receipt_id = acrh.cash_receipt_id
                   AND acr.cash_receipt_id = ara.cash_receipt_id(+)
                   AND acrh.status <> 'REVERSED'
                   AND acr.org_id = :p_org_id
                   AND acrh.cash_receipt_history_id =
                          (SELECT   MAX (cash_receipt_history_id) KEEP (DENSE_RANK LAST ORDER BY creation_date)
                             FROM   ar_cash_receipt_history_all
                            WHERE   cash_receipt_id = acr.cash_receipt_id
                                AND gl_date <= :p_date_on
                                and CURRENT_RECORD_FLAG='Y'
----Updated by manoj for the T20180315.0026 --------
--AND CURRENT_RECORD_FLAG = 'Y'
----------------------------------------------------------
)
                   AND TRUNC (acrh.gl_date) <= :p_date_on
				   				   
            GROUP BY   acr.org_id
                      ,acr.pay_from_customer
                      ,acr.customer_site_use_id
                      ,acr.receipt_number
                      ,acr.TYPE
                      ,acr.receipt_date
					  
UNION ALL

SELECT   acr.org_id
                      ,acr.pay_from_customer customer_id
                      ,acr.customer_site_use_id customer_site_use_id
                      ,0 bal_due_30
                      ,0 bal_due_30_60
                      ,0 bal_due_60_90
                      ,0 bal_due_90_180
                      ,0 bal_due_180_365
                      ,0 bal_due_365_730
                      ,0 bal_due_731
                      ,0 unapp_amount
                      ,SUM (CASE WHEN acrh.status <> 'CLEARED' THEN ( ( (NVL (acrh.acctd_amount, 0) + NVL (acrh.acctd_factor_discount_amount, 0))* -1) - NVL (ara.app_amount, 0)) ELSE 0 END)
                          open_credit
                      ,SUM (CASE WHEN acrh.status = 'CLEARED' THEN (NVL (acrh.acctd_amount, 0) + NVL (acrh.acctd_factor_discount_amount, 0)) ELSE 0 END)
                          pdc_amount
                      ,acr.receipt_number doc_no
                      ,'Rct' TYPE
                      ,acr.receipt_date trx_date
                      ,NULL od_no
                      ,null project_id
                      ,NULL bal_amount
                      ,NULL due_date
                      ,NULL cust_ref
                FROM   ar_cash_receipts_all acr
                      ,ar_payment_schedules_all aps
                      ,ar_cash_receipt_history_all acrh
                      , (  SELECT   app.cash_receipt_id
                                   ,SUM (NVL (app.acctd_amount_applied_from, app.acctd_amount_applied_to)) * -1 app_amount
                                   ,SUM (CASE WHEN (app.status = 'ACC') THEN (NVL (app.acctd_amount_applied_from, app.acctd_amount_applied_to)) ELSE 0 END)
                                       onacc_amount
                             FROM   ar_receivable_applications_all app,
                                    AR_CASH_RECEIPTS_ALl acr
                            WHERE  app.CASH_RECEIPT_ID = acr.CASH_RECEIPT_ID 
                              and app.status IN ('APP', 'ACC', 'ACTIVITY')
                                AND acr.reversal_date >= :p_date_on
                         GROUP BY   app.cash_receipt_id) ara
               WHERE   acr.cash_receipt_id = aps.cash_receipt_id
                   AND acr.cash_receipt_id = acrh.cash_receipt_id
                   AND acr.cash_receipt_id = ara.cash_receipt_id(+)
                   AND acrh.status = 'REVERSED'
                   AND acr.org_id = :p_org_id

                  
                   AND acrh.cash_receipt_history_id =
                          (SELECT   MAX (cash_receipt_history_id) KEEP (DENSE_RANK LAST ORDER BY creation_date)
                             FROM   ar_cash_receipt_history_all 
                            WHERE   cash_receipt_id = acr.cash_receipt_id
                                AND acr.creation_date < :p_date_on
                                and CURRENT_RECORD_FLAG='Y'
----Updated by manoj for the T20180315.0026 --------
--AND CURRENT_RECORD_FLAG = 'Y'
----------------------------------------------------------
)
                   AND nvl(acr.reversal_date, :p_date_on) > :p_date_on
            GROUP BY   acr.org_id
                      ,acr.pay_from_customer
                      ,acr.customer_site_use_id
                      ,acr.receipt_number
                      ,acr.TYPE
                      ,acr.receipt_date
					  ) art
          , (SELECT   hca.cust_account_id customer_id
                     ,hp.party_id
                     ,hca.account_number customer_num
                     ,hcsu.site_use_id customer_site_use_id
                     ,hp.party_name customer_name
                     ,hlc.address1 || ' - ' || hlc.address2 customer_address
                     ,ftv.territory_short_name country
                     ,hcsu.location
                     ,ras.resource_salesrep_id resource_salesrep_id
                     ,ras.name sales_rep_name
               FROM   hz_cust_accounts hca
                     ,hz_parties hp
                     ,hz_cust_acct_sites_all hcas
                     ,hz_cust_site_uses_all hcsu
                     ,hz_party_sites pss
                     ,hz_locations hlc
                     ,ra_salesreps ras
                     ,fnd_territories_vl ftv
              WHERE   1 = 1
                  AND hca.party_id = hp.party_id(+)
                  AND hca.cust_account_id = hcas.cust_account_id(+)
                  AND hcas.cust_acct_site_id = hcsu.cust_acct_site_id(+)
                  AND hcas.party_site_id = pss.party_site_id(+)
                  AND pss.location_id = hlc.location_id(+)
                  AND hcas.attribute_number2 = ras.party_id(+)
                  AND hlc.country = ftv.territory_code(+)) hca
          , (SELECT   ppmv.project_id
                     , (SELECT   segment1
                          FROM   pjf_projects_all_b
                         WHERE   project_id = ppmv.project_id)
                         proj_number
                     ,ppn.list_name sales_person
                     ,ppn.person_name_id sales_person_id
               FROM   pjf_project_members_v ppmv
                     ,per_person_names_f_v ppn
              WHERE   ppmv.person_id = ppn.person_id(+)
			  and ppmv.END_DATE_ACTIVE is null
                  AND TRUNC (SYSDATE) BETWEEN ppn.effective_start_date(+) AND ppn.effective_end_date(+)
                  AND ppmv.project_role_id = (SELECT   project_role_id
                                                FROM   pjf_proj_role_types_v
                                               WHERE   project_role_name = 'Sales Person')) pps
          , (SELECT   ppc.project_id
                     ,ppa.segment1 proj_number
                     ,ppa.name proj_name
                     ,pcod.class_code location_name

               FROM   pjf_project_classes ppc
                     ,pjf_class_categories_vl pcc
                     ,pjf_class_codes_vl pcod
                     ,pjf_projects_all_vl ppa

              WHERE   ppc.class_category_id = pcc.class_category_id
                  AND ppc.class_code_id = pcod.class_code_id
                  AND ppa.project_id = ppc.project_id(+)
                  AND pcc.class_category = 'Location') phl
          ,hr_operating_units hou
          ,gl_ledgers gll
   WHERE   art.customer_id = hca.customer_id(+)
       AND art.customer_site_use_id = hca.customer_site_use_id(+)
       AND art.org_id = hou.organization_id
       AND hou.set_of_books_id = gll.ledger_id
       AND NVL (hca.party_id, -99) BETWEEN NVL (:p_cust_from, NVL (hca.party_id, -99))
                                       AND  NVL (:p_cust_to, NVL (hca.party_id, -99))
       AND (:p_sales_person IS NULL
         OR pps.sales_person = pps.sales_person)
       AND (:p_location_name IS NULL
         OR phl.location_name = :p_location_name)
       AND art.project_id = pps.project_id(+)
       AND art.project_id = phl.project_id(+)
	   --and art.doc_no = 'UBL-110319'
GROUP BY   art.customer_site_use_id
          ,hca.customer_num
          ,hca.customer_name
          ,hca.customer_address
          ,hca.country
          ,hca.location
          ,hca.sales_rep_name
          ,hou.name
          ,gll.currency_code
          ,art.doc_no
          ,art.TYPE
          ,art.trx_date
          ,art.od_no
          ,art.bal_amount
          ,art.due_date
          ,art.cust_ref
          ,phl.location_name
          ,phl.proj_name
          ,pps.sales_person 
)
          
          
ORDER BY   customer_num
          ,doc_no
)
    
 where
 pdc_amount <> '0'
or Balance<> '0'