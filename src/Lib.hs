module Lib (getXResources, XResources (..), parseLine, getKey, loadDb) where

data XResources = XResources
  { background :: String,
    foreground :: String,
    accent :: String,
    accentForeground :: String
  }
  deriving (Show)

getKey :: [(String, String)] -> String -> String
getKey ((k, v):xs) key
  | k == key = v
  | otherwise = getKey xs key
getKey [] _ = "black"

parseLine :: String -> (String, String)
parseLine line = 
  (key, value)
  where
    (key, rest) = break (== ':') line
    value = dropWhile (== ' ') $ drop 1 rest

loadDb :: IO [(String, String)]
loadDb = do
  db <- readFile "/home/roy/.Xresources"
  let l = lines db
  return $ map parseLine l

getXResources :: IO XResources
getXResources = do
  db <- loadDb
  return $ XResources (getKey db "*.background") (getKey db "*.foreground") (getKey db "*.color8") (getKey db "*.color12")
