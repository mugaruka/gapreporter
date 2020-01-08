* opening the household members datafile.
GET
  FILE='C:\files\data-analysis\rstats\work\pse\urban-poverty\data\CDPR60FL.SAV'
  /KEEP HV005
             HV104
             HV105
             HV024. 

* saving a copy of the datafile in order to not jeopardise the original datafile.
SAVE OUTFILE
  'C:\Users\pmugaruka\Desktop\on-going-oct-17\NMODA\CDPR60FL-NMODA-AGERANGES.SAV'. 

* creating age categories (HV105: Age of household members).
IF (HV105 < 5) age_band = 1.
IF (HV105 >= 5 & HV105 <= 19) age_band = 2.
IF (HV105 >= 10 & HV105 <= 14) age_band = 3.
IF (HV105 >= 15 & HV105 <= 19) age_band = 4.
IF (HV105 >= 20 & HV105 <= 24) age_band = 5.
IF (HV105 >= 25 & HV105 <= 29) age_band = 6.
IF (HV105 >= 30 & HV105 <= 34) age_band = 7.
IF (HV105 >= 35 & HV105 <= 39) age_band = 8.
IF (HV105 >= 40 & HV105 <= 44) age_band = 9.
IF (HV105 >= 45 & HV105 <= 49) age_band = 10.
IF (HV105 >= 50 & HV105 <= 54) age_band = 11.
IF (HV105 >= 55 & HV105 <= 59) age_band = 12.
IF (HV105 >= 60 & HV105 <= 64) age_band = 13.
IF (HV105 >= 65 & HV105 <= 69) age_band = 14.
IF (HV105 >= 70 & HV105 <= 74) age_band = 15.
IF (HV105 >= 75 & HV105 <= 79) age_band = 16.
IF (HV105 > 80) age_band = 17.
EXECUTE.

* label the codes.
VARIABLE LABELS age_band 'Age category'.
VALUE LABELS age_band
  1 '0-4'
  2 '5-9'
  3 '10-14'
  4 '15-19'
  5 '20-24'
  6 '25-29'
  7 '30-34'
  8 '35-39'
  9 '40-44'
  10 '45-49'
  11 '50-54'
  12 '55-59'
  13 '60-64'
  14 '65-69'
  15 '70-74'
  16 '75-79'
  17 '80+'.
  
* applying weights.
COMPUTE WGT = HV005/1000000.
WEIGHT by WGT.

* contingency table age category by sex of household member (HV104).
CROSSTABS
  /TABLES = age_band BY HV104
  /CELLS COUNT COLUMN.

