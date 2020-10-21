use linkdbase;
DELETE FROM tracking_bak;
INSERT INTO tracking_bak SELECT * FROM tracking;
DELETE FROM sfbak;
INSERT INTO sfbak SELECT * FROM sf;

