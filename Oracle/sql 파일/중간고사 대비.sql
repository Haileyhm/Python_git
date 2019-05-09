--[데이터베이스 4/23]
--- DB 접속 / 계정생성
--- 테이블의 관계를 이해하기 위한 기본키/외래키 관련 테이블 생성 및 데이터 넣기


--0.테이블스페이스 생성하기 
CREATE TABLESPACE TS_USER03
    DATAFILE 'C:\Users\SMART-01\midtermDatabase\TS_USER03.dbf' SIZE 1024M -----------------> 경로명에 생성할 테이블스페이스명도 포함시켜줘야해 
    AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED
    SEGMENT SPACE MANAGEMENT AUTO;
    
--0.1 테이블스페이스 삭제 
DROP TABLESPACE TS_USER03
    INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;
    
--1.사용자 생성
CREATE USER MIDTERM --사용자이름
    IDENTIFIED BY MIDTERM --비밀번호 --우리는 여기까지만 신경쓰면 돼. 이후는 관리자 레벨
    
    DEFAULT TABLESPACE TS_USER03 --테이블스페이스명 ---------------------------------------> 왜 에러나와...? 해결! 왜냐면 한 문장인데 두번째 줄에서 ; 으로 끊었기 때문
    TEMPORARY TABLESPACE TEMP; --TEMP 테이블스페이스명 / 디폴트로 설정이 되기 때문에 신경쓰지 않아도 돼
    
--1.1 모든 사용자 정보 확인
SELECT * FROM DBA_USERS;

--1.2 사용자 비밀번호 변경 및 사용자 삭제 
--비밀번호 변경
ALTER USER MIDTERM 
    IDENTIFIED BY MIDTERM; --새로운 비밀번호
--사용자 삭제    
DROP USER MIDTERM CASCADE;

--1.3 사용자 비밀번호 오류나서 LOCK 되면 MANAGER 계정으로 접근하여 UNLOCK  
ALTER USER SYSTEM
    IDENTIFIED BY MANAGER;
    
ALTER USER MIDTERM
    ACCOUNT UNLOCK;       -----------------------------------------------------------------> 이게 뭐람? 해결! 계정 잠겼을 때 풀기
    
--------------------------------------------
--2.사용자 권한주기
GRANT CONNECT, RESOURCE, DBA TO MIDTERM; --접속, 리소스, 테이블생성 권한 부여 

--------------------------------------------
--3.테이블 생성하기
CREATE TABLE MIDTERM_PRODUCT_VOLUME(
REGIONID VARCHAR2(20BYTE), --콤마 주의!!!
PRODUCTGROUP VARCHAR2(20), ------------------------------------------------------------------> 숫자만 써도 20BYTE 인가? 신우오빠가 맞대.
YEARWEEK VARCHAR2(6),
VOLUME NUMBER );

--3.1 테이블 조회하기 (여기서는 데이터를 안 넣었으니, 컬럼명만 조회됨)
SELECT REGIONID, YEARWEEK
FROM MIDTERM_PRODUCT_VOLUME;

SELECT * FROM MIDTERM_PRODUCT_VOLUME;

--3.2 데이터 입력하기 : 상단 메뉴 Database - Import Table Data .. one commit after all records 선택 // CSV 파일은 .txt 에 , 로 구분

--3.3 데이터 삽입
INSERT INTO MIDTERM_PRODUCT_VOLUME
VALUES('A00','ST0001','199303','10000');

--3.3.1 특정 컬럼 데이터 삽입
INSERT INTO MIDTERM_PRODUCT_VOLUME
(REGIONID,PRODUCTGROUP)
VALUES('A00','ST0001');

--3.4 데이터 업데이트
UPDATE MIDTERM_PRODUCT_VOLUME ----------------------------------------------------------------> UPDATE 가 왜 안 될까....?
SET YEARWEEK = '201513'
WHERE 1=1
AND YEARWEEK = '201512'
AND PRODUCTGROUP = 'ST0001';
---------------------------------------------
--4.입력한 데이터 조회
--특정 컬럼 조회
SELECT REGIONID, PRODUCTGROUP
FROM MIDTERM_PRODUCT_VOLUME;

--전체 조회
SELECT * FROM MIDTERM_PRODUCT_VOLUME;

----------------------------------------------
--5.무결성제약조건 확인 
--5.1 도메인무결성 컬럼생성시에 NOT NULL 이라고 정의했는데, NULL 값을 넣으면 에러 발생
--5.2 개체무결성
--5.2.1 테이블 구조 변경하여 기본키 생성
ALTER TABLE MIDTERM_PRODUCT_VOLUME
    ADD CONSTRAINTS MIDTERM_PRODUCT_VOLUME_PK --삭제는 DROP CONSTRAINTS MIDTERM_PRODUCT_VOLUME_PK
    PRIMARY KEY(REGIONID, PRODUCTGROUP, YEARWEEK); -----------------------------------------> 기본키 3개 설정의 의미 : 행으로 속성 봤을 때, 겹치는 것이 없어야 하는 것?

--5.3 참조무결성
--5.3.1 부모테이블 생성
CREATE TABLE MIDTERM_EVENT_INFO_FOREIGN(
EVENTID VARCHAR2(20),
EVENTPERIOD VARCHAR2(20),
PROMOTION_RATIO NUMBER,
CONSTRAINT MIDTERM_EVENT_INFO_FOREIGN_PK PRIMARY KEY(EVENTID));

--5.3.2 자식테이블 생성
CREATE TABLE MIDTERM_PRODUCT_VOLUME_FOREIGN(
REGIONID VARCHAR2(20),
PRODUCTGROUP VARCHAR2(20),
YEARWEEK VARCHAR2(20),
VOLUME NUMBER NOT NULL,
EVENTID VARCHAR2(20),
CONSTRAINTS PKMIDTERM_PRODUCT_FOREIGN_PK PRIMARY KEY(REGIONID, PRODUCTGROUP, YEARWEEK),
CONSTRAINTS MIDTERM_PRODUCT_FOREIGN_FK FOREIGN KEY(EVENTID)REFERENCES MIDTERM_EVENT_INFO_FOREIGN(EVENTID));    

--5.3.3 부모테이블에 자료가 없는데, 자식테이블에 넣으면 오류가 남 
INSERT INTO MIDTERM_PRODUCT_VOLUME_FOREIGN
VALUES('A01','ST00002','201501',50,'EVTEST');
--5.3.4 자식테이블에 자료가 있는데, 부모테이블에서 지우려고 하면 오류남
INSERT INTO MIDTERM_EVENT_INFO_FOREIGN  --부모테이블과 
VALUES ('EV00001','20',50);

INSERT INTO MIDTERM_PRODUCT_VOLUME_FOREIGN --자식테이블에  
VALUES ('A01','APPLE','201401',50,'EV00001'); --같은 EVENTID 입력

DELETE FROM MIDTERM_EVENT_INFO_FOREIGN --부모테이블에서 지우려고 하면 integrity constraint violated - child record found
WHERE EVENTID = 'EV00001';



