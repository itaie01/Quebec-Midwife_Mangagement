-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the create table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been created.

-- This is only an example of how you add create table ddls to this file.
--   You may remove it.

CREATE TABLE parent
(
  hCardID INT NOT NULL,
  pname VARCHAR(30) NOT NULL,
  birthDate DATE NOT NULL,
  addr VARCHAR(50),
  email VARCHAR(50),
  phoneNum CHAR(10) NOT NULL,
  profession VARCHAR(20) NOT NULL,
  btype VARCHAR(3),
  PRIMARY KEY (hCardID)
);

CREATE TABLE mother
(
  hCardID INT NOT NULL,
  PRIMARY KEY (hCardID),
  FOREIGN KEY (hCardID) REFERENCES parent --ON DELETE CASCADE
);

CREATE TABLE father
(
  fid INT NOT NULL,
  hCardID INT NOT NULL,
  PRIMARY KEY (fid),
  FOREIGN KEY (hCardID) REFERENCES parent
);

CREATE TABLE couples
(
  coupleID INT NOT NULL,
  hCardID INT NOT NULL,
  fid INT NOT NULL,
  PRIMARY KEY (coupleID),
  FOREIGN KEY (hCardID) REFERENCES mother,
  FOREIGN KEY (fid) REFERENCES father
);

CREATE TABLE healthcareInstitution
(
  phoneNum CHAR(10) NOT NULL,
  hciname VARCHAR(30) NOT NULL,
  addr VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(30) UNIQUE NOT NULL,
  website VARCHAR(30) UNIQUE NOT NULL,
  PRIMARY KEY (phoneNum)
);

CREATE TABLE birthingCenter
(
  phoneNum CHAR(10) NOT NULL,
  PRIMARY KEY (phoneNum),
  FOREIGN KEY (phoneNum) REFERENCES healthcareInstitution
);

CREATE TABLE communityClinic
(
  phoneNum CHAR(10) NOT NULL,
  PRIMARY KEY (phoneNum),
  FOREIGN KEY (phoneNum) REFERENCES healthcareInstitution
);

CREATE TABLE midwives
(
  practID INT NOT NULL,
  mwname VARCHAR(30) NOT NULL,
  email VARCHAR(30) UNIQUE NOT NULL,
  phoneNum CHAR(10) UNIQUE NOT NULL,
  workplace CHAR(10) NOT NULL, --phoneNum
  PRIMARY KEY (practID),
  FOREIGN KEY (workplace) REFERENCES healthcareInstitution
);

CREATE TABLE labTechnician
(
  ltID INT NOT NULL,
  ltname VARCHAR(30) NOT NULL,
  phoneNum CHAR(10) NOT NULL,
  PRIMARY KEY (ltID)
);

CREATE TABLE pregnancy
(
  pregID INT NOT NULL,
  pregNum INT NOT NULL,
  origDueDate DATE,
  menstrDate DATE,
  ultrasdDate DATE,
  fnlDueDate DATE,
  numBabies INT,
  coupleID INT NOT NULL,
  ppractID INT NOT NULL,
  bpractID INT NOT NULL,
  birthLocation CHAR(10), --phoneNum
  PRIMARY KEY (pregID),
  FOREIGN KEY (coupleID) REFERENCES couples,
  FOREIGN KEY (ppractID) REFERENCES midwives,
  FOREIGN KEY (bpractID) REFERENCES midwives,
  FOREIGN KEY (birthLocation) REFERENCES birthingCenter
);

CREATE TABLE babies
(
  pregID INT NOT NULL,
  birthTime TIME NOT NULL,
  birthDate DATE NOT NULL,
  gender VARCHAR(6) NOT NULL,
  bname VARCHAR(30),
  btype VARCHAR(3) NOT NULL,
  homeBirth BOOLEAN,
  PRIMARY KEY (pregID, birthTime),
  FOREIGN KEY (pregID) REFERENCES pregnancy
);

CREATE TABLE tests
(
  testID INT NOT NULL,
  ttype VARCHAR(20) NOT NULL,
  prescribedDate DATE NOT NULL,
  sampleDate DATE NOT NULL,
  labWorkDate DATE,
  result VARCHAR(10) NOT NULL,
  PRIMARY KEY (testID),
  CHECK (labWorkDate >= prescribedDate)
);

CREATE TABLE updatesTests
(
  testID INT NOT NULL,
  ltID INT NOT NULL,
  PRIMARY KEY (testID),
  FOREIGN KEY (ltID) REFERENCES labTechnician,
  FOREIGN KEY (testID) REFERENCES tests
);

CREATE TABLE testsTakenDuring
(
  testID INT NOT NULL,
  pregID INT NOT NULL,
  birthTime TIME,
  PRIMARY KEY (testID),
  FOREIGN KEY (testID) REFERENCES tests,
  FOREIGN KEY (pregID) REFERENCES pregnancy,
  FOREIGN KEY (pregID, birthTime) references babies
);

CREATE TABLE motherTests
(
  testID INT NOT NULL,
  practID INT NOT NULL,
  mother INT NOT NULL,
  PRIMARY KEY (testID),
  FOREIGN KEY (testID) REFERENCES tests,
  FOREIGN KEY (practID) REFERENCES midwives,
  FOREIGN KEY (mother) REFERENCES mother
);

CREATE TABLE informationSession
(
  sessID INT NOT NULL,
  scheldDate DATE NOT NULL,
  scheldTime TIME NOT NULL,
  lang VARCHAR(10) NOT NULL,
  PRIMARY KEY (sessID)
);

CREATE TABLE informationSessionHosts
(
  sessID INT NOT NULL,
  practID INT NOT NULL,
  PRIMARY KEY (sessID),
  FOREIGN KEY (sessID) REFERENCES informationSession,
  FOREIGN KEY (practID) REFERENCES midwives
);

CREATE TABLE attends
(
  sessID INT NOT NULL,
  coupleID INT NOT NULL,
  PRIMARY KEY (sessID, coupleID),
  FOREIGN KEY (sessID) REFERENCES informationSession,
  FOREIGN KEY (coupleID) REFERENCES couples
);

CREATE TABLE appointments
(
  apptID INT NOT NULL,
  heldDate DATE NOT NULL,
  heldTime TIME NOT NULL,
  practID INT NOT NULL,
  pregID INT NOT NULL,
  PRIMARY KEY (apptID),
  FOREIGN KEY (practID) REFERENCES midwives,
  FOREIGN KEY (pregID) REFERENCES pregnancy
);

CREATE TABLE notes
(
  apptID INT NOT NULL,
  takenDate DATE NOT NULL,
  takenTime TIME NOT NULL,
  observation VARCHAR(200),
  PRIMARY KEY (apptID, takenDate, takenTime),
  FOREIGN KEY (apptID) REFERENCES appointments
);