SELECT
          rct.payment_trxn_extension_id
         ,rctl.description                    AS "Transaction Line Description"
         , rct.trx_number                      AS "Transaction Number"
	  , rct.CT_REFERENCE                    AS CROSS_REFERENCE
          , rbs.name "Transaction Source"
          , HO.name                             AS "Business Unit Name"
          , To_char(rct.trx_date, 'YYYY/MM/DD') Transaction_Date
        , (
                SELECT DISTINCT
                       To_char(gl_date, 'YYYY/MM/DD')
                FROM
                       ra_cust_trx_line_gl_dist_all
                WHERE
                       customer_trx_line_id = rctl.customer_trx_line_id
          )
          AS Accounting_Date
         , (
                SELECT
                       name
                FROM
                       ra_terms
                WHERE
                       term_id = rct.term_id
         )
         AS "Payment Terms Name"
           , (
                SELECT DISTINCT
                       account_number
                FROM
                       hz_cust_accounts
                WHERE
                       cust_account_id = rct.bill_to_customer_id
         )
         AS "Bill_To_Customer_Account"
          , (
                SELECT DISTINCT
                       account_number
                FROM
                       hz_cust_accounts
                WHERE
                       Party_id  = rct.Ship_to_party_id
         )
         AS "Ship_To_Customer_Account"		
        ,rct.invoice_currency_code                                   AS "Currency"
       , rctl.line_type                                              AS "Transaction Line Type"
       , Decode (rctl.line_type, 'LINE', rctl.extended_amount, NULL) AS "Line Amount"
       , Decode (rctl.line_type, 'TAX', rctl.extended_amount, NULL)  AS "Tax Amount"
        , rctl.line_number AS "Transaction Line Number"
       , rctl.UOM_CODE "Transaction UOM CODE"
        , rctta.Name "Transaction Type"
       , amlat.Name "Standard Memo"
       , rct.attribute1
       , rct.attribute3
       , rct.attribute5
       , rct.attribute6
       , rct.attribute7
         , (
                SELECT
                       tax_rate_code
                FROM
                       zx_lines
                WHERE
                       tax_line_id = rctl.tax_line_id
         )
         AS "Tax Rate Code"
          
          ,RCTL.CUSTOMER_TRX_LINE_ID
          ,rctl.interface_line_context
       , rctl.interface_line_attribute1
       , rctl.interface_line_attribute2
        , baa.bank_name
       , baa.bank_branch_name
       , Nvl(BAA.bank_account_name, BAA.primary_acct_owner_name) bank_account_name
       , baa.bank_account_number
          , rm.name receipt_method_name
           ,rctl.source_document_line_number
          ,rct.created_by AS "Created By"
FROM
         ra_customer_trx_all       rct
       , ra_customer_trx_lines_all rctl
       , ra_batch_sources_all      rbs
       , hr_operating_units        HO
       , RA_CUST_TRX_TYPES_ALL     rctta
       , ar_memo_lines_all_b       amlab
        , ar_memo_lines_all_tl      amlat
            , iby_ext_bank_accounts_v   BAA
         , iby_pmt_instr_uses_all    BAUA
          , ar_receipt_methods        rm
           , iby_fndcpt_tx_extensions  fte
WHERE
      rct.customer_trx_id         = rctl.customer_trx_id
         AND rct.batch_source_seq_id = rbs.batch_source_seq_id
         AND RCT.org_id              = RCTL.org_id
         AND rct.org_id              = HO.organization_id
         AND HO.name = NVL( :BU,HO.name)
         AND rct.payment_trxn_extension_id = fte.trxn_extension_id (+)
         AND rct.receipt_method_id         = rm.receipt_method_id(+)
         AND fte.instr_assignment_id       = BAUA.instrument_payment_use_id (+)
         AND rct.CUST_TRX_TYPE_SEQ_ID      = rctta.CUST_TRX_TYPE_SEQ_ID
         AND amlab.memo_line_id            = amlat.memo_line_id (+)
         and rctl.memo_line_seq_id         =amlab.memo_line_seq_id (+)
         and amlat.LANGUAGE (+)            = 'US'
         AND baua.payment_function (+)     = 'CUSTOMER_PAYMENT'
         AND Trunc(SYSDATE) BETWEEN Nvl(BAUA.start_date, SYSDATE - 1) AND Nvl(BAUA.end_date, SYSDATE + 1)
         AND baa.ext_bank_account_id (+) = baua.instrument_id
==================================================
select distinct NAME from HR_OPERATING_UNITS 
Where name in ('UK Business Unit','US1 Business Unit', 'Supremo US Business Unit', 'China Business Unit1')
order by 1