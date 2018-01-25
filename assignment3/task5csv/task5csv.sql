CREATE TABLE IF NOT EXISTS `survey` (
`projectId` bigint(20) NOT NULL,
`surveyId` bigint(20) NOT NULL,
`views` bigint(20) NOT NULL,
`dateTime` datetime NOT NULL
);

LOAD DATA INFILE 'data.csv' 
INTO TABLE survey 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
