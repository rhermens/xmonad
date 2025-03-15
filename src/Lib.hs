module Lib (getXResources, XResources(..), getColor) where

import Graphics.X11.XRM (rmGetResource, rmGetFileDatabase, rmValue)
import System.IO (hPutStr, openFile, IOMode (WriteMode))
import XMonad (rmInitialize)

data XResources = XResources {
    background :: String,
    foreground :: String
} deriving (Show)

getColor :: String -> IO String
getColor color = do
    db <- rmGetFileDatabase "/home/roy/.Xresources"
    case db of
        Just db' -> do
            res <- rmGetResource db' color "color"
            print res
            case res of
                Just (_, v) -> rmValue v
                Nothing -> return "black"
        Nothing -> return "black"

getXResources :: IO XResources
getXResources = do
    _ <- rmInitialize
    bg <- getColor "background"
    fg <- getColor "foreground"
    return $ XResources bg fg

writeStdout :: String -> IO ()
writeStdout s = do
    stdout' <- openFile "/home/roy/.xmonad/stdout" WriteMode
    hPutStr stdout' s
