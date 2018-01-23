{-# LANGUAGE OverloadedStrings #-}
module Main where

import Turtle
import System.Directory (getCurrentDirectory)
import Data.Char (isDigit, isAlpha)
import Data.Text (pack)

main :: IO ()
main = putStrLn "Hello, Haskell!"

data TD =
      Td String
    | TRow TD TD TD TD TD TD TD
  deriving (Eq, Show)

load :: String -> IO ()
load file = do
  path <- getCurrentDirectory
  tabsraw <- readFile $ path ++ "/" ++ file
  let a = parse tabsraw
  print a

-- | expects a 'dbuser' to be set up for mariadb with all rights
insertArr :: String -> IO()
insertArr file = do
  shell "mysql -u dbuser pendantdelete < task5.sql" empty >>= print -- Create/Reset db
  path <- getCurrentDirectory
  tabsraw <- readFile $ path ++ "/" ++ file
  let rows = parse tabsraw
  print rows

runInserts :: [TD] -> IO ()
runInserts rows = do
  putStrLn "TODO"


insertRow :: TD -> IO ()
insertRow (TRow a b c d e f g) = do
  shell (participantInsert (peek f) (peek g)) empty >>= print
  shell (arrangementInsert (peek a) (peek b) (peek c)) empty >>= print
  shell (ticketsInsert (peek e) (peek a) (peek d)) empty >>= print

peek :: TD -> String
peek (Td element) = element

participantInsert :: String -> String -> Text
participantInsert a b = pack $
    "echo mysql | "
    ++ "insert into task5.participant(pFname,pLname) values("
    ++ a
    ++ ","
    ++ b
    ++ ");"

arrangementInsert a b c = pack $
    "echo mysql | "
    ++ "insert into task5.arrangement(arrName,arrTime,arrSpaces) values("
    ++ a
    ++ ","
    ++ b
    ++ ","
    ++ c
    ++ ");"

ticketsInsert a b c = pack $
    "echo mysql | "
    ++ "insert into task5.tickets(pId,arrID,numTickets) values("
    ++ a
    ++ ","
    ++ b
    ++ ","
    ++ c
    ++ ");"

-- | wrapper for using parseExpr and pfold to parse a file
parse :: String -> [TD]
parse ss = fst $ pfold $ ([],ss)

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
