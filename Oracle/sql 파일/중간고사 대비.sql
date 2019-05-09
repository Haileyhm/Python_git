--[�����ͺ��̽� 4/23]
--- DB ���� / ��������
--- ���̺��� ���踦 �����ϱ� ���� �⺻Ű/�ܷ�Ű ���� ���̺� ���� �� ������ �ֱ�


--0.���̺����̽� �����ϱ� 
CREATE TABLESPACE TS_USER03
    DATAFILE 'C:\Users\SMART-01\midtermDatabase\TS_USER03.dbf' SIZE 1024M -----------------> ��θ� ������ ���̺����̽��� ���Խ�������� 
    AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED
    SEGMENT SPACE MANAGEMENT AUTO;
    
--0.1 ���̺����̽� ���� 
DROP TABLESPACE TS_USER03
    INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;
    
--1.����� ����
CREATE USER MIDTERM --������̸�
    IDENTIFIED BY MIDTERM --��й�ȣ --�츮�� ��������� �Ű澲�� ��. ���Ĵ� ������ ����
    
    DEFAULT TABLESPACE TS_USER03 --���̺����̽��� ---------------------------------------> �� ��������...? �ذ�! �ֳĸ� �� �����ε� �ι�° �ٿ��� ; ���� ������ ����
    TEMPORARY TABLESPACE TEMP; --TEMP ���̺����̽��� / ����Ʈ�� ������ �Ǳ� ������ �Ű澲�� �ʾƵ� ��
    
--1.1 ��� ����� ���� Ȯ��
SELECT * FROM DBA_USERS;

--1.2 ����� ��й�ȣ ���� �� ����� ���� 
--��й�ȣ ����
ALTER USER MIDTERM 
    IDENTIFIED BY MIDTERM; --���ο� ��й�ȣ
--����� ����    
DROP USER MIDTERM CASCADE;

--1.3 ����� ��й�ȣ �������� LOCK �Ǹ� MANAGER �������� �����Ͽ� UNLOCK  
ALTER USER SYSTEM
    IDENTIFIED BY MANAGER;
    
ALTER USER MIDTERM
    ACCOUNT UNLOCK;       -----------------------------------------------------------------> �̰� ����? �ذ�! ���� ����� �� Ǯ��
    
--------------------------------------------
--2.����� �����ֱ�
GRANT CONNECT, RESOURCE, DBA TO MIDTERM; --����, ���ҽ�, ���̺���� ���� �ο� 

--------------------------------------------
--3.���̺� �����ϱ�
CREATE TABLE MIDTERM_PRODUCT_VOLUME(
REGIONID VARCHAR2(20BYTE), --�޸� ����!!!
PRODUCTGROUP VARCHAR2(20), ------------------------------------------------------------------> ���ڸ� �ᵵ 20BYTE �ΰ�? �ſ������ �´�.
YEARWEEK VARCHAR2(6),
VOLUME NUMBER );

--3.1 ���̺� ��ȸ�ϱ� (���⼭�� �����͸� �� �־�����, �÷��� ��ȸ��)
SELECT REGIONID, YEARWEEK
FROM MIDTERM_PRODUCT_VOLUME;

SELECT * FROM MIDTERM_PRODUCT_VOLUME;

--3.2 ������ �Է��ϱ� : ��� �޴� Database - Import Table Data .. one commit after all records ���� // CSV ������ .txt �� , �� ����

--3.3 ������ ����
INSERT INTO MIDTERM_PRODUCT_VOLUME
VALUES('A00','ST0001','199303','10000');

--3.3.1 Ư�� �÷� ������ ����
INSERT INTO MIDTERM_PRODUCT_VOLUME
(REGIONID,PRODUCTGROUP)
VALUES('A00','ST0001');

--3.4 ������ ������Ʈ
UPDATE MIDTERM_PRODUCT_VOLUME ----------------------------------------------------------------> UPDATE �� �� �� �ɱ�....?
SET YEARWEEK = '201513'
WHERE 1=1
AND YEARWEEK = '201512'
AND PRODUCTGROUP = 'ST0001';
---------------------------------------------
--4.�Է��� ������ ��ȸ
--Ư�� �÷� ��ȸ
SELECT REGIONID, PRODUCTGROUP
FROM MIDTERM_PRODUCT_VOLUME;

--��ü ��ȸ
SELECT * FROM MIDTERM_PRODUCT_VOLUME;

----------------------------------------------
--5.���Ἲ�������� Ȯ�� 
--5.1 �����ι��Ἲ �÷������ÿ� NOT NULL �̶�� �����ߴµ�, NULL ���� ������ ���� �߻�
--5.2 ��ü���Ἲ
--5.2.1 ���̺� ���� �����Ͽ� �⺻Ű ����
ALTER TABLE MIDTERM_PRODUCT_VOLUME
    ADD CONSTRAINTS MIDTERM_PRODUCT_VOLUME_PK --������ DROP CONSTRAINTS MIDTERM_PRODUCT_VOLUME_PK
    PRIMARY KEY(REGIONID, PRODUCTGROUP, YEARWEEK); -----------------------------------------> �⺻Ű 3�� ������ �ǹ� : ������ �Ӽ� ���� ��, ��ġ�� ���� ����� �ϴ� ��?

--5.3 �������Ἲ
--5.3.1 �θ����̺� ����
CREATE TABLE MIDTERM_EVENT_INFO_FOREIGN(
EVENTID VARCHAR2(20),
EVENTPERIOD VARCHAR2(20),
PROMOTION_RATIO NUMBER,
CONSTRAINT MIDTERM_EVENT_INFO_FOREIGN_PK PRIMARY KEY(EVENTID));

--5.3.2 �ڽ����̺� ����
CREATE TABLE MIDTERM_PRODUCT_VOLUME_FOREIGN(
REGIONID VARCHAR2(20),
PRODUCTGROUP VARCHAR2(20),
YEARWEEK VARCHAR2(20),
VOLUME NUMBER NOT NULL,
EVENTID VARCHAR2(20),
CONSTRAINTS PKMIDTERM_PRODUCT_FOREIGN_PK PRIMARY KEY(REGIONID, PRODUCTGROUP, YEARWEEK),
CONSTRAINTS MIDTERM_PRODUCT_FOREIGN_FK FOREIGN KEY(EVENTID)REFERENCES MIDTERM_EVENT_INFO_FOREIGN(EVENTID));    

--5.3.3 �θ����̺� �ڷᰡ ���µ�, �ڽ����̺� ������ ������ �� 
INSERT INTO MIDTERM_PRODUCT_VOLUME_FOREIGN
VALUES('A01','ST00002','201501',50,'EVTEST');
--5.3.4 �ڽ����̺� �ڷᰡ �ִµ�, �θ����̺��� ������� �ϸ� ������
INSERT INTO MIDTERM_EVENT_INFO_FOREIGN  --�θ����̺�� 
VALUES ('EV00001','20',50);

INSERT INTO MIDTERM_PRODUCT_VOLUME_FOREIGN --�ڽ����̺�  
VALUES ('A01','APPLE','201401',50,'EV00001'); --���� EVENTID �Է�

DELETE FROM MIDTERM_EVENT_INFO_FOREIGN --�θ����̺��� ������� �ϸ� integrity constraint violated - child record found
WHERE EVENTID = 'EV00001';



