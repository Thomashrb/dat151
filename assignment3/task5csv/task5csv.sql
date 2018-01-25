LOAD DATA LOCAL INFILE '/home/bbsl/development/dat151/assignment3/task5csv/data.csv'
INTO TABLE allrow
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\n'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
 (arrID, arrName, arrTime, arrSpaces, pID, pFname, pLname);
