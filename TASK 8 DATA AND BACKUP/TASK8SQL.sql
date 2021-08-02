CREATE TABLE TASK8_2596
(
LE_NAME VARCHAR2(10),
BUSINESS_UNIT VARCHAR2(10),
COMPANY_ID NUMBER,
CUSTOMER_NAME VARCHAR2(10),
PARTY_NUMBER VARCHAR(10)
)
DROP TABLE TASK8_2596;

INSERT INTO TASK8_2596 VALUES('LE1','BU1',200400,'C1','P1');
INSERT INTO TASK8_2596 VALUES('LE1','BU1',200402,'C2','P2');
INSERT INTO TASK8_2596 VALUES('LE1','BU1',200402,'C1','P1');
INSERT INTO TASK8_2596 VALUES('LE1','BU1',200403,'C3','P3');
INSERT INTO TASK8_2596 VALUES('LE1','BU1',200404,'C3','P3');
INSERT INTO TASK8_2596 VALUES('LE1','BU1',200405,'C3','P3');
COMMIT;
SELECT * FROM TASK8_2596;
============================================================================
SELECT TASK8_2596.*, ROW_NUMBER() OVER (PARTITION BY CUSTOMER_NAME ORDER BY COMPANY_ID) AS REF 
FROM TASK8_2596;

