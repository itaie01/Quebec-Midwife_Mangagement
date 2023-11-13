-- Include your INSERT SQL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the INSERT statements for the tables with foreign key references
--    ONLY AFTER the parent tables!

-- This is only an example of how you add INSERT statements to this file.
--   You may remove it


-- BACKUP MIDWIFE FROM SAME INSTITUION

INSERT INTO parent (hCardID, pname, birthDate, addr, email, phoneNum, profession, btype) VALUES
(339, 'Mary Bobsin', '1994-05-01', '123 Fake Street', 'bob.bobsin@gmail.com', '4230477240', 'Courier', 'AB+'),
(514, 'Victoria Gutierrez', '2001-01-01', '425 Rue Henri-Julien', 'vgutierrez@yahoo.com', '8404136948', 'Bricklayer', 'O-'),
(519, 'Jemma Fisher', '1998-11-05', '5814 Augue, Street', 'jfisher@gmail.com', '6931847608', 'Nurse', 'O+'),
(863, 'Sierra Donovan', '1999-04-12', '456 Rue Sherbrooke O', 'sierra.don@outlook.com', '1337044749', 'Solicitor', 'A-'),
(448, 'Elaine Lowery','2001-06-13','Ap #458-7855 Vestibulum. St.', 'elowery@fastmail.net', '1234567899', 'Homemaker','B+'),
(800, 'Ava Holmes', '1987-02-16', '6347 Semper Ave', 'ava.holmes@fastmail.net', '5264039807', 'Typist', 'AB-'),
(757, 'Rob Boeing', '1923-12-23', '243-5976 Varius Av', 'rboeing@boeing.com', '1284096728', 'Pilot', 'O+'),
(481, 'Guy Little', '1967-02-14', '248-8960 Donec Av', 'littleguy@bighouse.net', '4139135413', 'Cook', 'B-'),
(457, 'Guy Fiery', '1976-04-21', '43 Las Vegas Blvd', 'guy.fiery@fire.net', '4826671634', 'Chef', 'A+'),
(635, 'Stewart Little', '1967-03-04', '1532 Aliquam Av.', 'little.stewarts@big.com', '8658370863', 'Animal Trainer', 'AB+'),
(983, 'Jerry Seinfeld', '1954-04-29', '5A-34 5th Avenue', 'jerry@seinfeld.com', '3822474225', 'Comedian', 'B-'),
(801, 'Louis Hendrix', '1945-04-05', '9035 Magna. Av.', 'hendrix.louis@freemail.net', '1758235943', 'Author', 'A+')
;

INSERT INTO mother (hCardID) VALUES
(339),
(514),
(519),
(863),
(448),
(800)
;

INSERT INTO father (fid, hCardID) VALUES
(1, 757),
(2, 481),
(3, 457),
(4, 635),
(5, 983),
(6, 801)
;

INSERT INTO couples (coupleID, hCardID, fid) VALUES
(1, 339, 1),
(2, 514, 2),
(3, 519, 3),
(4, 863, 4),
(5, 448, 5),
(6, 800, 6),
(7, 339, 1)
;

INSERT INTO healthcareInstitution (phoneNum, hciname, addr, email, website) VALUES
('4760577225', 'Toronto Medical Group', '4826 Adipiscing Ave', 'tmg@toronto.ca','tmg.toronto.ca'),
('3471476059', 'Montreal General', '256 Ave Doctor Penfield', 'hopitale@mtlgenerale.ca', 'mtl-generale.ca'),
('1827809241', 'Laval Medicine Inc.', '1 Avenue Laval', 'inquire@laval-hospital.ca', 'laval-hospital.ca'),
('1525657859', 'Vancouver Island General', '71 Vancouver Island Rd.', 'help@vcislandh.ca', 'vcislandh.ca'),
('3642842533', 'Halipal', '4 Halifax Main St.', 'save@halifaxgen.ca', 'halifaxgen.ca'),
('2984169441', 'Toronto CC', '67 Union Square Drive', 'care@torontoclinic.ca', 'torontoclinic.ca'),
('1439134758', 'Montreal Com. Clinic', '90 Boulevard St. Laurent', 'save@mtlclinic.ca', 'mtlclinic.ca'),
('7493579288', 'Laval Community Clinic', '23 Rue Laval', 'save@lavalclinic.ca', 'lavalclinic.ca'),
('5883089902', 'VC Island CC', '101 Island Way', 'help@vcislandc.ca', 'vcislandc.ca'),
('8758426349', 'Halifax Community Clinic', '43 Nova Scotia Drive', 'save@halifaxclinic.ca', 'halifaxclinic.ca'),
('7737329562', 'Lac-Saint-Louis', '72 Rue St. Louis', 'care@lacstlouis.ca', 'lacstlouis.ca')
;

INSERT INTO birthingCenter (phoneNum) VALUES
('4760577225'), -- Toronto Medical Group
('3471476059'), -- Montreal General
('1827809241'), -- Laval Medicine Inc
('1525657859'), -- Vancouver Island General
('3642842533'), -- Halipal
('7737329562') -- Lac-Saint-Louis
;

INSERT INTO communityClinic (phoneNum) VALUES
('2984169441'), -- Toronto CC
('1439134758'), -- Montreal Com. Clinic
('7493579288'), -- Laval Community Clinic
('5883089902'), -- VC Island CC
('8758426349') -- Halifax Community Clinic
;

INSERT INTO midwives (practID, mwname, email, phoneNum, workplace) VALUES
(1, 'Marion Girard', 'mgirard@lacstlouis.ca', '8489169950', '7737329562'),
(11, 'Sanya Arellano', 'sarellano@lacstlouis.ca', '7412833425', '7737329562'),
(2, 'May Marbles', 'marbles@lavalclinic.ca', '1090880026', '7493579288'),
(22, 'Matilda Rubio', 'mrubio@lavalclinic.ca', '5449883366', '7493579288'),
(3, 'Marta Thornton', 'thorns@mtl-generale.ca', '2339011689', '3471476059'),
(33, 'Emme Pham', 'emma.pham@mtl-generale.ca', '7923210987', '3471476059'),
(4, 'Lianne Hussain' ,'lhussain@tmg.toronto.ca', '8927859678', '4760577225'),
(44, 'Daniele Galloway' ,'dgalloway@tmg.toronto.ca', '4168338137', '4760577225'),
(5, 'Dhiane Lowell' ,'dlowell@lacstlouis.ca', '2018338173', '7737329562'),
(55, 'Lily Allen' ,'lily.alen@lacstlouis.ca', '4194099835', '7737329562'),
(6, 'Suzannah Rowe', 'suz.rowe@mtlclinic.ca', '5286094311', '1439134758'),
(7, 'Allegra Ewing', 'allgeraewing@mtlclinic.ca', '4389018867', '1439134758')
;

INSERT INTO labTechnician (ltID, ltname, phoneNum) VALUES
(1, 'Teddy Bowes', '8166101503'),
(2, 'Nikola Richards', '7902478883'),
(3, 'Dylon Patel', '6879556226'),
(4, 'Dylan Perry', '8009231453'),
(5, 'Zavier Xiong', '9642849947')
;

INSERT INTO pregnancy (pregID, pregNum, origDueDate, menstrDate, ultrasdDate, fnlDueDate, numBabies, coupleID, ppractID, bpractID, birthLocation) VALUES
(33911, 1, '2019-04-14', '2019-04-17', '2019-04-27', '2019-04-17', 4, 7, 4, 44, '4760577225'),
(5141, 1, '2022-02-22', '2022-02-25', '2022-02-27', '2022-02-25', 1, 2, 1, 11, '7737329562'),
(5191, 1, '2022-07-24', '2022-06-13', '2022-07-30',  '2022-07-30', 1, 3, 11 ,1, NULL),
(3391, 1, '2022-07-01', '2022-07-02', '2022-07-03', '2022-07-03', 1, 1, 3, 33, NULL),
(4481, 1, '2022-07-10', '2022-07-11', '2022-07-12', '2022-07-12', 1, 5, 1, 11, NULL),
(8631, 1, '2022-03-01', '2022-03-05', '2022-03-11', '2022-03-05', 1, 4, 2, 22, NULL),
(5142, 2, '2022-05-13', '2022-05-20', '2022-05-17', '2022-05-17', 2, 2, 1, 11, NULL),
(8632, 2, '2022-12-01', '2022-12-03', '2022-12-10', '2022-12-10', 2, 4, 5, 55, NULL),
(8001, 1, '2022-01-01', NULL, NULL, NULL, 1, 6, 6, 7, NULL)
;

INSERT INTO babies (pregID, birthTime, birthDate, gender, bname, btype, homeBirth) VALUES
(5141, '00.00.00', '2022-02-25', 'male', 'Leonard Bobsin', 'A-', FALSE),
(33911, '17.45.00', '2019-04-17', 'female', NULL, 'O+', FALSE),
(33911, '17.47.00', '2019-04-17', 'female', NULL, 'B+', FALSE),
(33911, '17.49.00', '2019-04-17', 'male', NULL, 'O-', FALSE),
(33911, '17.51.00', '2019-04-17', 'female', NULL, 'AB-', FALSE)
;

INSERT INTO tests (testID, ttype, prescribedDate, sampleDate, labWorkDate, result) VALUES
(101, 'blood iron', '2022-01-31', '2022-02-03', '2022-02-04', 'high'),
(104, 'blood iron', '2022-02-06', '2022-02-07', '2022-03-08', 'low'),
(106, 'ultrasound', '2022-01-01', '2022-01-02', '2022-01-03', 'healthy'),
(109, 'blood iron', '2022-02-17', '2022-02-23', '2022-02-24', 'low'),
(110, 'blood iron', '2022-01-04', '2022-01-10', '2022-01-11', 'high')
;

INSERT INTO updatesTests (testID, ltID) VALUES
(101, 2),
(104, 3),
(106, 1),
(109, 1),
(110, 5)
;

INSERT INTO testsTakenDuring (testID, pregID, birthTime) VALUES
(101, 5142, NULL),
(104, 5142, NULL),
(106, 5141, NULL),
(109, 4481, NULL),
(110, 3391, NULL)
;

INSERT INTO motherTests (testID, practID, mother) VALUES
(101, 1, 514),
(104, 5, 514),
(106, 1, 514),
(109, 1, 448),
(110, 3, 339)
;

INSERT INTO informationSession (sessID, scheldDate, scheldTime, lang) VALUES
(230, '2021-09-01', '17.05.00', 'English'),
(231, '2021-07-09', '14.30.00', 'French'),
(232, '2021-08-14', '19.55.00', 'English'),
(233, '2021-10-21', '14.10.00', 'English'),
(234, '2021-09-18', '16.00.00', 'French'),
(235, '2021-03-10', '23.00.00', 'English')
;

-- make sure the sessions & couples match up with the midwives eventually assigned
INSERT INTO informationSessionHosts (sessID, practID) VALUES
(230, 1),
(231, 2),
(232, 3),
(233, 4),
(234, 5),
(235, 6)
;

INSERT INTO attends (sessID, coupleID) VALUES
(230, 2),
(230, 1),
(230, 4),
(231, 4),
(232, 3),
(232, 1),
(233, 4),
(234, 5),
(235, 4),
(235, 6)
;

INSERT INTO appointments (apptID, heldDate, heldTime, practID, pregID) VALUES
(20, '2022-03-21', '16.00.00', 1, 5141),
(21, '2022-03-22', '15.00.00', 1, 4481),
(22, '2022-03-23', '13.00.00', 1, 5142),
(23, '2022-03-24', '12.00.00', 1, 5141),
(24, '2022-03-25', '11.00.00', 1, 5142),
(25, '2022-03-23', '10.00.00', 1, 5191),
(54, '2022-01-31', '09.00.00', 2, 8631),
(56, '2022-02-20', '09:20:00', 6, 8001)
;

INSERT INTO notes (apptID, takenDate, takenTime, observation) VALUES
(20, '2022-03-21', '16.00.00', NULL),
(20, '2022-03-21', '16.01.00', NULL),
(22, '2022-03-23', '13.15.00', NULL),
(23, '2022-03-24', '12.05.00', NULL),
(24, '2022-03-25', '11.06.00', NULL),
(54, '2022-01-31', '09.30.00', NULL),
(56, '2022-02-20', '09:35:00', NULL)
;