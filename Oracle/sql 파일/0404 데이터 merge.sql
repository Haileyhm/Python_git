CREATE TABLE KOPO_REGION_MASTER(
REGIONID VARCHAR2(100),
REGIONNAME VARCHAR2(100));

SELECT * FROM KOPO_REGION_MASTER;

EDIT KOPO_PRODUCT_VOLUME;

EDIT KOPO_REGION_MASTER;





TRUNCATE TABLE KOPO_PRODUCT_VOLUME;

EDIT KOPO_PRODUCT_VOLUME;

SELECT * FROM KOPO_PRODUCT_VOLUME;

SELECT * FROM KOPO_REGION_MASTER;


SELECT * FROM 
KOPO_REGION_MASTER H  --이니셜로 A 를 지정한 거야 -> H 로 바꿈:) 
INNER JOIN KOPO_PRODUCT_VOLUME R  
ON H.REGIONID = R.REGIONID;   -- INNER JOIN 을 하면 교집합인 A01 만 나와 


SELECT * FROM 
KOPO_REGION_MASTER J   
LEFT JOIN KOPO_PRODUCT_VOLUME S  
ON J.REGIONID = S.REGIONID;   -- LEFT JOIN 은 왼쪽에 있는 건 다 살려라 
