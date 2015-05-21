-- MODULE  XTS729

-- SQL Test Suite, V6.0, Interactive SQL, xts729.sql
-- 59-byte ID
-- TEd Version #

-- AUTHORIZATION CTS1              

   SELECT USER FROM HU.ECCO;
-- RERUN if USER value does not match preceding AUTHORIZATION comment

-- date_time print

   ROLLBACK WORK;

-- TEST:7029 Column name with 19, 72 and 128 characters!
-- NOTE:  If long lines are not supported by the ISQL interfac, an
--        implementation defined line continuation format may be used
-- Begin 19 character column names

   CREATE TABLE TESTA6439
        (COLUMNOFCHARACTERSA CHARACTER(10),
         columnofcharactersb CHARACTER(10),
         cOlUmNoFNUMERICss_0 NUMERIC(5),
         cOlUmNoFNUMERICss_1 NUMERIC(5));
-- PASS:7029 If table created successfully?

   COMMIT WORK;

   INSERT INTO CTS1.TESTA6439
         VALUES('ABCD','DCBA',1,9999);
-- PASS:7029 If 1 row inserted successfully?

   COMMIT WORK;

   SELECT COLUMNOFCHARACTERSA, columnofcharactersb,
                cOlUmNoFNUMERICss_0, cOlUmNoFNUMERICss_1
                FROM CTS1.TESTA6439;
-- PASS:7029 If COLUMNOFCHARACTERSA = ABCD?
-- PASS:7029 If columnofcharactersb = DCBA?
-- PASS:7029 If cOlUmNoFNUMERICss_0 = 1?
-- PASS:7029 If cOlUmNoFNUMERICss_1 = 9999?
   
   COMMIT WORK;

   DROP TABLE TESTA6439 CASCADE;
-- PASS:7029 If table dropped successfully?

   COMMIT WORK;

-- End 19 character column names

-- Begin 128 character column names
   CREATE TABLE TESTB6439
(COLUMNOFCHARACTERDATATYPE1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123 CHARACTER(3),
columnofcharacterdatatype123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012b CHARACTER(3),
cOlUmNoFNUMERIC123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901_0 NUMERIC(5),
CoLuMnOfNUMERIC123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901_1 NUMERIC(5));
-- PASS:7029 If table created successfully?

   COMMIT WORK;

   INSERT INTO CTS1.TESTB6439
         VALUES('AA','BB',1,2);
-- PASS:7029 If 1 row inserted successfully?

   INSERT INTO CTS1.TESTB6439
         VALUES('CC','DD',3,4);
-- PASS:7029 If 1 row inserted successfully?

   INSERT INTO CTS1.TESTB6439
         VALUES('EE','FF',5,6);
-- PASS:7029 If 1 row inserted successfully?

   INSERT INTO CTS1.TESTB6439
         VALUES('GG','HH',7,8);
-- PASS:7029 If 1 row inserted successfully?

   INSERT INTO CTS1.TESTB6439
         VALUES('II','KK',9,0);
-- PASS:7029 If 1 row inserted successfully?

   SELECT * FROM CTS1.TESTB6439
          ORDER BY cOlUmNoFNUMERIC123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901_0;
-- PASS:7029 If 5 rows selected in the following order?
--                    ===  ===  === ===
-- PASS:7029   If      AA   BB   1   2?
-- PASS:7029   If      CC   DD   3   4?
-- PASS:7029   If      EE   FF   5   6?
-- PASS:7029   If      GG   HH   7   8?
-- PASS:7029   If      II   KK   9   0?

   SELECT  COLUMN_NAME, ORDINAL_POSITION
         FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_SCHEMA = 'CTS1' AND TABLE_NAME = 'TESTB6439'
         ORDER BY ORDINAL_POSITION;
-- PASS:7029 If 4 rows are selected in the following order?
--
-- PASS:7029 If r1,c1 = COLUMNOFCHARACTERDATATYPE12345678901234567890
--                         1234567890123456789012345678901234567890
--                         1234567890123456789012345678901234567890123?
-- PASS:7029 If row1,col2 = 1?

-- PASS:7029 If r2,c1 = COLUMNOFCHARACTERDATATYPE12345678901234567890
--                      1234567890123456789012345678901234567890
--                      123456789012345678901234567890123456789012B?
-- PASS:7029 If row2,col2 = 2?

-- PASS:7029 If r3,c1 = COLUMNOFNUMERIC123456789012345678901234567890
--                      1234567890123456789012345678901234567890
--                      12345678901234567890123456789012345678901_0?
-- PASS:7029 If row3,col2 = 3?

-- PASS:7029 If r4,c1 = COLUMNOFNUMERIC123456789012345678901234567890
--                      1234567890123456789012345678901234567890
--                      12345678901234567890123456789012345678901_1?
-- PASS:7029 If row4,col2 = 4?

   COMMIT WORK;

   ALTER TABLE CTS1.TESTB6439
         ADD COLUMN 
COLUMNOFCHARACTERDATATYPE123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012C CHAR(3);
-- PASS:7029 If table altered successfully?

   COMMIT WORK;

   INSERT INTO CTS1.TESTB6439
         VALUES('TTT','TTT',100,100,'ADD');
-- PASS:7029 If 1 row inserted successfully?

   SELECT * FROM CTS1.TESTB6439
         WHERE COLUMNOFCHARACTERDATATYPE123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012C = 'ADD';
-- PASS:7029 If 5 values =  TTT  TTT  100  100  ADD?

   ROLLBACK WORK;

   DROP TABLE TESTB6439 CASCADE;
-- PASS:7029 If table dropped successfully?

   COMMIT WORK;

-- End 128 character column names

-- Begin 72 character column names

   CREATE TABLE TESTC6439 (COLUMNOFCHARACTERSA CHAR(3),
COLUMNOFCHARACTERDATATYPE12345678901234567890123456789012345678901234567
CHAR(3));
-- PASS:7029 If table created successfully?

   COMMIT WORK;

   INSERT INTO CTS1.TESTC6439
         VALUES('aaa','bbb');
-- PASS:7029 If 1 row inserted successfully?

   INSERT INTO CTS1.TESTC6439
         VALUES  ('ccc','ddd');
-- PASS:7029 If 1 row inserted successfully?

   INSERT INTO CTS1.TESTC6439
         VALUES('eee','fff');
-- PASS:7029 If 1 row inserted successfully?

   SELECT * FROM CTS1.TESTC6439
         ORDER BY COLUMNOFCHARACTERSA;
-- PASS:7029 If 3 rows selected in the following order?
--                 ===    ===
-- PASS:7029 If    aaa    bbb?
-- PASS:7029 If    ccc    ddd?
-- PASS:7029 If    eee    fff? 

   COMMIT WORK;

   DROP TABLE TESTC6439 CASCADE;
-- PASS:7029 If table dropped successfully?

   COMMIT WORK;

-- End 72 character column names

-- END TEST >>> 7029 <<< END TEST
-- *********************************************
-- *************************************************////END-OF-MODULE