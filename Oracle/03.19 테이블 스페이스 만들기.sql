


SELECT * FROM DBA_USERS;

CREATE TABLESPACE TS_KOPO2
    DATAFILE 'E:\oracle_data\kopo2019\TS_USER_02.dbf' SIZE 1024M
    AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED
    SEGMENT SPACE MANAGEMENT AUTO; 
    
CREATE temporary tablespace KOPO2019TSTP
    TEMPFILE 'E:\oracle_data\kopo2019\TSTP_USER_01.dbf' 
    SIZE 4096M
    AUTOEXTEND ON NEXT 100M 
    MAXSIZE UNLIMITED; 
    
 ALTER USER HR
IDENTIFIED BY HR2019
DEFAULT TABLESPACE TS_KOPO2
TEMPORARY TABLESPACE KOPO2019TSTP;
    
