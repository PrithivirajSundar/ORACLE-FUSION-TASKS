SELECT DISTINCT
DHA.ORDER_NUMBER AS "ORDER NUMBER",
TO_CHAR(DHA.ORDERED_DATE,'YYYY-MM-DD') AS "ORDERED DATE",
DHA.TRANSACTIONAL_CURRENCY_CODE AS "TRANSACTION CURR",
DLA.ORDERED_QTY	AS "ORDERED QTY",
DLA.UNIT_SELLING_PRICE AS "UNIT SELLING PRICE",
ESI.ITEM_NUMBER AS "ITEM NUMBER",
HP.PARTY_NAME AS "CUSTOMER NAME",
HL.CITY ||' '||HL.STATE||' '||HL.COUNTRY AS "CUSTOMER ADDRESS" ,
HCA.ACCOUNT_NUMBER AS "ACCOUNT NUMBER" 

FROM 
HR_ALL_ORGANIZATION_UNITS HAOU,
DOO_HEADERS_ALL DHA,
DOO_LINES_ALL DLA,
EGP_SYSTEM_ITEMS ESI,
HZ_PARTIES HP,
HZ_CUST_ACCOUNTS HCA,
HZ_PARTY_SITES HPS,
HZ_LOCATIONS HL

WHERE 1=1
AND HAOU.ORGANIZATION_ID = DHA.ORG_ID
AND DHA.HEADER_ID = DLA.HEADER_ID
AND DLA.INVENTORY_ITEM_ID = ESI.INVENTORY_ITEM_ID
AND DHA.SOLD_TO_PARTY_ID = HP.PARTY_ID
AND DHA.SOLD_TO_CUSTOMER_ID = HCA.CUST_ACCOUNT_ID
AND DHA.SOLD_TO_PARTY_ID = HPS.PARTY_ID
AND HPS.LOCATION_ID = HL.LOCATION_ID
AND HAOU.NAME = NVL( :ORG_NAME,HAOU.NAME)
AND DHA.ORDER_TYPE_CODE = NVL( :ORDER_TYPE,DHA.ORDER_TYPE_CODE)
AND DLA.STATUS_CODE = NVL( :LINE_STATUS,DLA.STATUS_CODE)

=========================================================================================================================
LINE_STATUS:
SELECT DISTINCT STATUS_CODE FROM DOO_LINES_ALL

ORDER_TYPE:
SELECT DISTINCT ORDER_TYPE_CODE FROM DOO_HEADERS_ALL

ORG_NAME:
SELECT DISTINCT NAME FROM HR_ALL_ORGANIZATION_UNITS
WHERE NAME IN ('France Business Unit','US1 Business Unit','China Business Unit','UK Business Unit')

=========================================================================================================================================