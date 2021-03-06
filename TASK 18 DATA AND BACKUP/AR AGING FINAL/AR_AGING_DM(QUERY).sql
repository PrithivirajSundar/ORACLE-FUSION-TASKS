SELECT 
HAOU.NAME AS "ORGANIZATION",
HZP.PARTY_NAME AS "CUSTOMER NAME",
HZP.PARTY_NUMBER AS "CUSTOMER NUMBER",
RACTA.TRX_NUMBER AS "INVOICE NUMBER",
TO_CHAR(RACTA.TRX_DATE,'DD-MM-YYYY') AS "INVOICE DATE",
ARPSA.INVOICE_CURRENCY_CODE AS "INVOICE CURRENCY",
TO_CHAR(ARPSA.GL_DATE,'DD-MM-YYYY') AS "LEDGER DATE",
TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY') AS "DUE DATE",
ARPSA.AMOUNT_DUE_ORIGINAL AS "INVOICE AMOUNT",
ARPSA.AMOUNT_DUE_REMAINING AS "AMOUNT REMAINING",
CEIL(ARPSA.AMOUNT_DUE_ORIGINAL - ARPSA.AMOUNT_DUE_REMAINING) AS "AMOUNT PAID",
TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') AS "PAST DUE DAYS",
CASE WHEN 
TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') >= -999 AND TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') < 0 
THEN ARPSA.AMOUNT_DUE_REMAINING ELSE 0
END "CURRENT BUCKET",
CASE WHEN 
TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') >= 0 AND TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') < 30 
THEN ARPSA.AMOUNT_DUE_REMAINING ELSE 0
END "0 T0 30 DAYS",
CASE WHEN 
TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') >= 31 AND TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') < 60 
THEN ARPSA.AMOUNT_DUE_REMAINING ELSE 0
END "31 TO 60 DAYS",
CASE WHEN 
TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') >= 61 AND TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') < 90
THEN ARPSA.AMOUNT_DUE_REMAINING ELSE 0
END "61 TO 90 DAYS",
CASE WHEN 
TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') >= 91 AND TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') <  120
THEN ARPSA.AMOUNT_DUE_REMAINING ELSE 0
END "91 TO 120 DAYS",
CASE WHEN 
TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') >= 121 AND TO_DATE(TO_CHAR(:AS_OF_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') - TO_DATE(TO_CHAR(ARPSA.DUE_DATE,'DD-MM-YYYY'),'DD-MM-YYYY') < 999999
THEN ARPSA.AMOUNT_DUE_REMAINING ELSE 0
END "MORE THAN 120 DAYS"

FROM
HR_ALL_ORGANIZATION_UNITS HAOU,
HZ_PARTIES HZP,
RA_CUSTOMER_TRX_ALL RACTA,
AR_PAYMENT_SCHEDULES_ALL ARPSA

WHERE 1=1
AND RACTA.ORG_ID = HAOU.ORGANIZATION_ID(+)
AND RACTA.CUSTOMER_TRX_ID = ARPSA.CUSTOMER_TRX_ID(+)
AND RACTA.SOLD_TO_PARTY_ID = HZP.PARTY_ID(+)

AND HAOU.NAME = NVL( :ORG_NAME, HAOU.NAME)
AND HAOU.NAME IN ('France Business Unit','US1 Business Unit','China Business Unit','Progress US Business Unit')

AND ARPSA.GL_DATE <= :AS_OF_DATE
AND ARPSA.AMOUNT_DUE_ORIGINAL >= NVL( :MIN_AMT,0)
AND ARPSA.AMOUNT_DUE_ORIGINAL <= NVL( :MAX_AMT,999999)


AND ARPSA.AMOUNT_DUE_REMAINING > 0
AND ARPSA.AMOUNT_DUE_ORIGINAL - ARPSA.AMOUNT_DUE_REMAINING != 0

====================================================================================================================================

ORG_NAME:
SELECT DISTINCT NAME FROM HR_ALL_ORGANIZATION_UNITS
WHERE NAME IN ('France Business Unit','US1 Business Unit','China Business Unit','Progress US Business Unit')

================================================================================================================================================