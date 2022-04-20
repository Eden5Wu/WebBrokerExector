
/*
# Table structure for table dept
*/

CREATE TABLE dept (
  DEPT_ID varchar(4) NOT NULL default '',
  DEPT_NAM nvarchar(20) NOT NULL default '',
  PRIMARY KEY  (DEPT_ID),
  INDEX DEPT_NAM (DEPT_NAM)
)

/*#
# Table structure for table duty
#*/

CREATE TABLE duty (
  D_YEAR char(2) NOT NULL default '',
  D_MON char(2) NOT NULL default '',
  D_DAT char(2) NOT NULL default '',
  EMP_ID char(8) NOT NULL default '',
  TIME_S char(4) NOT NULL default '',
  TIME_E char(4) NOT NULL default '',
  TIME_HR decimal(4,2) NOT NULL default '0.00',
  LTR_HR decimal(4,2) NOT NULL default '0.00',
  EAR_HR decimal(4,2) NOT NULL default '0.00',
  SIK_HR decimal(4,2) NOT NULL default '0.00',
  ABS_HR decimal(4,2) NOT NULL default '0.00',
  PUB_HR decimal(4,2) NOT NULL default '0.00',
  MRY_HR decimal(4,2) NOT NULL default '0.00',
  DIE_HR decimal(4,2) NOT NULL default '0.00',
  OVL_HR decimal(4,2) NOT NULL default '0.00',
  PRIMARY KEY  (D_YEAR,D_MON,D_DAT,EMP_ID)
)

/*#
# Table structure for table emp
#*/

CREATE TABLE emp (
  EMP_ID char(8) NOT NULL default '',
  NAME nchar(10) NOT NULL default '',
  SEX char(1) NOT NULL default '',
  ROC_ID char(10) NOT NULL default '',
  BIR_DAT varchar(10) NOT NULL default '',
  HOME nchar(10) NOT NULL default '',
  H_ADD nchar(60) NOT NULL default '',
  C_ADD nchar(60) NOT NULL default '',
  TEL char(20) NOT NULL default '',
  EMG_NAM nchar(10) NOT NULL default '',
  REL_DES nchar(10) NOT NULL default '',
  EDU nchar(10) NOT NULL default '',
  MRY char(1) NOT NULL default '',
  ARR_DAT varchar(10) NOT NULL default '',
  LEV_DAT varchar(10) NOT NULL default '',
  SARRY decimal(7,0) NOT NULL default '0',
  DEPT_ID char(4) NOT NULL default '',
  TITLE nchar(12) NOT NULL default '',
  PRIMARY KEY  (EMP_ID),
  INDEX IX_NAME (NAME)
)

/*#
# Table structure for table emp_ansy
#*/

CREATE TABLE emp_ansy (
  SL_YEAR char(2) NOT NULL default '',
  SL_MON char(2) NOT NULL default '',
  EMP_ID char(8) NOT NULL default '',
  WRK_HR decimal(6,2) NOT NULL default '0.00',
  LTR_HR decimal(6,2) NOT NULL default '0.00',
  EAR_HR decimal(6,2) NOT NULL default '0.00',
  SIK_HR decimal(6,2) NOT NULL default '0.00',
  ABS_HR decimal(6,2) NOT NULL default '0.00',
  PUB_HR decimal(6,2) NOT NULL default '0.00',
  MRY_HR decimal(6,2) NOT NULL default '0.00',
  DIE_HR decimal(6,2) NOT NULL default '0.00',
  OVL_HR decimal(6,2) NOT NULL default '0.00',
  PRIMARY KEY  (SL_YEAR,SL_MON,EMP_ID)
)

/*#
# Table structure for table sarry
#*/

CREATE TABLE sarry (
  SL_YEAR char(2) NOT NULL default '',
  SL_MON char(2) NOT NULL default '',
  EMP_ID char(8) NOT NULL default '',
  SL_ID char(2) NOT NULL default '',
  D_AMT decimal(8,0) NOT NULL default '0',
  C_AMT decimal(8,0) NOT NULL default '0',
  PRIMARY KEY  (SL_YEAR,SL_MON,EMP_ID,SL_ID)
)

/*#
# Table structure for table sl_ansy
#*/

CREATE TABLE sl_ansy (
  SL_YEAR char(2) NOT NULL default '',
  SL_MON char(2) NOT NULL default '',
  EMP_ID char(8) NOT NULL default '',
  D_AMT decimal(8,0) NOT NULL default '0',
  C_AMT decimal(8,0) NOT NULL default '0',
  PRIMARY KEY  (SL_YEAR,SL_MON,EMP_ID)
)

/*#
# Table structure for table sl_item
#*/

CREATE TABLE sl_item (
  SL_ID char(2) NOT NULL default '',
  SL_NAM char(20) NOT NULL default '',
  D_C char(1) NOT NULL default '',
  PRIMARY KEY  (SL_ID)
)

/*#
# Table structure for table sl_parm
#*/

CREATE TABLE sl_parm (
  SL_YEAR char(2) NOT NULL default '',
  SL_MON char(2) NOT NULL default '',
  TIME_S decimal(4,0) NOT NULL default '0',
  TIME_E decimal(4,0) NOT NULL default '0',
  NOM_OVL decimal(4,2) NOT NULL default '0.00',
  VAC_OVL decimal(4,2) NOT NULL default '0.00',
  OVR_OVL decimal(4,2) NOT NULL default '0.00',
  OVR_HR decimal(1,0) NOT NULL default '0',
  LTR_HR decimal(3,2) NOT NULL default '0.00',
  DEX_HR decimal(3,2) NOT NULL default '0.00',
  PRIMARY KEY  (SL_YEAR,SL_MON)
)

/*#
# Table structure for table sy_author
#*/

CREATE TABLE sy_author (
  USR_ID char(10) NOT NULL default '',
  PRG_01 char(1) NOT NULL default '',
  PRG_02 char(1) NOT NULL default '',
  PRG_03 char(1) NOT NULL default '',
  PRG_04 char(1) NOT NULL default '',
  PRG_05 char(1) NOT NULL default '',
  PRG_06 char(1) NOT NULL default '',
  PRG_07 char(1) NOT NULL default '',
  PRG_08 char(1) NOT NULL default '',
  PRG_09 char(1) NOT NULL default '',
  PRG_10 char(1) NOT NULL default '',
  PRG_11 char(1) NOT NULL default '',
  PRG_12 char(1) NOT NULL default '',
  PRG_13 char(1) NOT NULL default '',
  PRG_14 char(1) NOT NULL default '',
  PRG_15 char(1) NOT NULL default '',
  PRG_16 char(1) NOT NULL default '',
  PRG_17 char(1) NOT NULL default '',
  PRG_18 char(1) NOT NULL default '',
  PRG_19 char(1) NOT NULL default '',
  PRG_20 char(1) NOT NULL default '',
  PRIMARY KEY  (USR_ID)
)

/*#
# Table structure for table sy_ctrl
#*/

CREATE TABLE sy_ctrl (
  COMP_NAM char(40) NOT NULL default '',
  SL_YEAR char(2) NOT NULL default '',
  SL_MON char(2) NOT NULL default '',
  PRIMARY KEY  (COMP_NAM)
)

/*#
# Table structure for table sy_usr
#*/

CREATE TABLE sy_usr (
  USR_ID char(10) NOT NULL default '',
  USR_NAM char(10) NOT NULL default '',
  PASS_CODE char(10) NOT NULL default '',
  PRIMARY KEY  (USR_ID)
)

