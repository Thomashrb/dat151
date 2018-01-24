{-# LANGUAGE OverloadedStrings #-}
module Main where

import Turtle (shell, empty)
import System.Directory (getCurrentDirectory)
import Data.Text (pack)
import Data.List.Split (splitOn)
import Data.Maybe (mapMaybe)

type TableRow = (String,String,String,String,String,String,String)

main :: IO ()
main = do
  load "data.txt"

-- | expects a 'dbuser' to be set up for mariadb with all rights
load :: String -> IO()
load file = do
  shell "mysql -u root task5 < task5.sql" empty >>= print -- Create/Reset db
  path <- getCurrentDirectory
  tabsraw <- readFile $ path ++ "/" ++ file
  let rows  = parse tabsraw
  print rows
  runInserts rows

runInserts :: [TableRow] -> IO ()
runInserts rows = do
  shell arrangementInsert empty >>= print -- insert once, small table
  mapM_ insertRow rows

insertRow :: TableRow -> IO ()
insertRow tr = do
  shell (participantInsert
          (lookup' "pID" tr)
          (lookup' "pFname" tr)
          (lookup' "pLname" tr)) empty >>= print
  shell (ticketsInsert
         (lookup' "pID" tr)
         (lookup' "arrID" tr)
         ("n")) empty >>= print

lookup' :: String -> TableRow -> String
lookup' "arrID"     (x,_,_,_,_,_,_) = x
lookup' "arrName"   (_,x,_,_,_,_,_) = x
lookup' "arrTime"   (_,_,x,_,_,_,_) = x
lookup' "arrSpaces" (_,_,_,x,_,_,_) = x
lookup' "pID"       (_,_,_,_,x,_,_) = x
lookup' "pFname"    (_,_,_,_,_,x,_) = x
lookup' "pLname"    (_,_,_,_,_,_,x) = x

parse :: String -> [TableRow]
parse rows = mapMaybe (tuplify) (parseExpr rows)

tuplify :: [String] -> Maybe TableRow
tuplify [a,b,c,d,e,f,g,_] = Just (a,b,c,d,e,f,g)
tuplify                 _ = Nothing

parseExpr :: String -> [[String]]
parseExpr rows = map cols (splitOn ("\n") rows)
  where cols x = splitOn ";" x


---------------------------------------------------------------
-- Helpers
---------------------------------------------------------------

start = "echo \""
end = ";\" | mysql -u root task5"
wrap e = "'" ++ e ++ "'"

participantInsert a b c = pack $
  start
  ++ "insert into task5.participant(pID,pFname,pLname) values("
  ++ a
  ++ ","
  ++ (wrap b)
  ++ ","
  ++ (wrap c)
  ++ ")"
  ++ end

ticketsInsert a b c = pack $
  start
  ++ "insert into task5.tickets(pId,arrID,ticketType) values("
  ++ a
  ++ ","
  ++ b
  ++ ","
  ++ (wrap c)
  ++ ")"
  ++ end

arrangementInsert = pack $
  start
  ++ "insert into task5.arrangement (arrID,arrName,arrTime,arrSpaces) values"
  ++ "(1,'Ulriken down','2017-07-01 10:00:00',15000),"
  ++ "(2,'The 7-mountain hike','2017-05-23 09:00:00',32000),"
  ++ "(3,'Pink Floyd at Koengen','2017-06-16 08:00:00',25000),"
  ++ "(4,'AHA at Koengen','2017-08-05 07:00:00',23000),"
  ++ "(5,'Stolzekleiven opp','2017-09-12 10:00:00',50000),"
  ++ "(6,'Stolzekleiven opp','2017-09-12 10:00:00',50000),"
  ++ "(7,'Led Zeppelin at Koengen','2017-07-12 07:30:00',25000),"
  ++ "(8,'Bergen City Maraton','2017-05-12 08:00:00',78000),"
  ++ "(9,'Knarvikmila','2017-06-23 08:30:00',53000),"
  ++ "(10,'Lyderhorn opp','2017-08-12 09:00:00',34000),"
  ++ "(11,'Stones at Koengen','2017-06-13 09:00:00',24000),"
  ++ "(12,'Kygo at Brann Stadion','2017-07-15 10:20:00',21000)"
  ++ end
>>>>>>> splitOnParse
