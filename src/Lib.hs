module Lib (getXResources, XResources (..), getColor) where

import Graphics.X11.XRM (RMDatabase, rmGetFileDatabase, rmGetResource, rmValue)
import System.IO (IOMode (WriteMode), hPutStr, openFile)
import XMonad (rmInitialize)

data XResources = XResources
  { background :: String,
    foreground :: String
  }
  deriving (Show)

getColor :: RMDatabase -> String -> IO String
getColor db color = do
  res <- rmGetResource db color "color"
  case res of
    Just (_, v) -> rmValue v
    Nothing -> return "black"

getXResources :: IO XResources
getXResources = do
  _ <- rmInitialize
  db <- rmGetFileDatabase "/home/roy/.Xresources"
  case db of
    Just db' -> do
      bg <- getColor db' "background"
      fg <- getColor db' "foreground"
      return $ XResources bg fg
    Nothing -> return $ XResources "black" "black"

writeStdout :: String -> IO ()
writeStdout s = do
  stdout' <- openFile "/home/roy/.xmonad/stdout" WriteMode
  hPutStr stdout' s
