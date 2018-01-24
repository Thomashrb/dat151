{-# LANGUAGE OverloadedStrings #-}
module Main where

import Turtle (shell, empty)
import System.Directory (getCurrentDirectory)
import Data.Char (isDigit, isAlpha)
import Data.Text (Text, pack)

main :: IO ()
main = do
  load "data.txt"

data TD =
  Td String
  | TRow TD TD TD TD TD TD TD
  deriving (Eq, Show)

-- | expects a 'dbuser' to be set up for mariadb with all rights
load :: String -> IO()
load file = do
  shell "mysql -u dbuser pendantdelete < task5.sql" empty >>= print -- Create/Reset db
  path <- getCurrentDirectory
  tabsraw <- readFile $ path ++ "/" ++ file
  let rows = parse tabsraw
--  print rows
  runInserts rows

runInserts :: [TD] -> IO ()
runInserts td = do
  shell (participantInsert td "pID" "pFname" "pLname") empty >>= print
  shell (arrangementInsert td "arrID" "arrName" "arrTime" "arrSpaces" ) empty >>= print
  shell (ticketsInsert td "pID" "arrID") empty >>= print

-- | wrapper for using parseExpr and pfold to parse a file
parse :: String -> [TD]
parse ss = init $ fst $ pfold $ ([],ss)

pfold :: ([TD],String) -> ([TD],String)
pfold  (a,"") = (a ++ [],"")
pfold  (a,ss) = let (e1,r1) = parseExpr ss
                in pfold (a ++ [e1], r1)

parseExpr :: String -> (TD,String)
parseExpr       []  = (Td "","")
parseExpr  (';':xs) = parseExpr xs
parseExpr ('\n':xs) = let (e1,r1) = parseExpr xs;
                          (e2,r2) = parseExpr r1;
                          (e3,r3) = parseExpr r2;
                          (e4,r4) = parseExpr r3;
                          (e5,r5) = parseExpr r4;
                          (e6,r6) = parseExpr r5;
                          (e7,r7) = parseExpr r6 in (TRow e1 e2 e3 e4 e5 e6 e7, r7)
parseExpr    (x:xs) | isDigit x   = parseExprStr (x:xs)
                    | isAlpha x   = parseExprStr (x:xs)
                    | otherwise   = error $ "Unexpected input " ++ [x]

parseExprStr :: String -> (TD, String)
parseExprStr ss = let (td,remainder) = span notIsDelimiter ss
                  in (Td td, tail $ remainder)

notIsDelimiter :: Char -> Bool
notIsDelimiter (';') = False
notIsDelimiter  _    = True

-----------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------
wrap element = "'" ++ element ++ "'"

end = " | mysql -u dbuser task5"

--participantInsert :: String -> String -> String -> Text
participantInsert td a b c = pack $
    "echo "
    ++ "\"insert into task5.participant(pID,pFname,pLname) values"
    ++ participant td a b c
    ++ ";\""
    ++ end

arrangementInsert td a b c d = pack $
    "echo "
    ++ "\"insert into task5.arrangement(arrID,arrName,arrTime,arrSpaces) values"
    ++ arrangement td (remDups' td "arrID" []) a b c d
    ++ ";\""
    ++ end

ticketsInsert td a b = pack $
    "echo "
    ++ "\"insert into task5.tickets(pID,arrID) values"
    ++ tickets td a b
    ++ ";\""
    ++ end

participant :: [TD] -> String  -> String -> String -> String
participant  [ ]  _ _ _  = ""
participant  [r]  a b c  =
  "("
  ++ selectFrom a r ++ ","
  ++ (wrap $ selectFrom b r) ++ ","
  ++ (wrap $ selectFrom c r) ++ ")"
participant (r:rs) a b c = participant rs a b c ++
  ",("
  ++ selectFrom a r ++ ","
  ++ (wrap $ selectFrom b r) ++ ","
  ++ (wrap $ selectFrom c r) ++ ")"

-- memory
arrangement :: [TD] -> [String] -> String -> String -> String -> String -> String
arrangement  [ ] _   _ _ _ _  = ""
arrangement  [r] mem a b c d  =
  "("
  ++ selectFrom a r ++ ","
  ++ (wrap $ selectFrom b r) ++ ","
  ++ (wrap $ selectFrom c r) ++ ","
  ++ selectFrom d r ++ ")"
arrangement (r:rs) mem a b c d =
  if (elem  (selectFrom a r) mem) then
    arrangement rs mem a b c d ++
    ",("
    ++ selectFrom a r ++ ","
    ++ (wrap $ selectFrom b r) ++ ","
    ++ (wrap $ selectFrom c r) ++ ","
    ++ selectFrom d r ++ ")"
  else arrangement rs mem a b c d ++ ""

tickets :: [TD] -> String -> String -> String
tickets  [ ]  _ _  = ""
tickets  [r]  a b  =
  "("
  ++ selectFrom a r ++ ","
  ++ selectFrom b r ++ ")"
tickets (r:rs) a b = tickets rs a b ++
  ",("
  ++ selectFrom a r ++ ","
  ++ selectFrom b r ++ ")"

selectFrom "arrID"     (TRow a _ _ _ _ _ _) = peek a
selectFrom "arrName"   (TRow _ b _ _ _ _ _) = peek b
selectFrom "arrTime"   (TRow _ _ c _ _ _ _) = peek c
selectFrom "arrSpaces" (TRow _ _ _ d _ _ _) = peek d
selectFrom "pID"       (TRow _ _ _ _ e _ _) = peek e
selectFrom "pFname"    (TRow _ _ _ _ _ f _) = peek f
selectFrom "pLname"    (TRow _ _ _ _ _ _ g) = peek g
selectFrom "" _ = ""

remDups' [ ]    _ mem = mem
remDups' [r]    i mem =
  if (elem (selectFrom i r) mem) then remDups' [] i mem
  else remDups' [] i (mem ++ [selectFrom i r])
remDups' (r:rs) i mem =
  if (elem (selectFrom i r) mem) then remDups' rs i mem
  else  remDups' rs i (mem ++ [selectFrom i r])

peek :: TD -> String
peek (Td element) = element
