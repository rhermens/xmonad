{-# LANGUAGE OverloadedStrings #-}

import Lib (XResources (..), getXResources)
import Xmobar
import Data.Word (Word32)
import DBus (MemberName, MethodError, MethodCall (methodCallDestination), methodCall)
import DBus.Client (connectSession, getPropertyValue, Client, disconnect)

main :: IO ()
main = do
  res <- getXResources
  configFromArgs config >>= xmobar . applyXResources res

config :: Config
config =
  defaultConfig
    { font = "monospace 11",
      additionalFonts = [],
      borderWidth = 0,
      border = FullB,
      alpha = 255,
      position = TopH 25,
      textOffset = -1,
      iconOffset = -1,
      lowerOnStart = True,
      pickBroadest = False,
      persistent = False,
      hideOnStart = False,
      iconRoot = ".",
      allDesktops = True,
      overrideRedirect = True,
      textOutputFormat = Ansi,
      commands =
        [ Run $
            Network
              "eth0"
              [ "-L",
                "0",
                "-H",
                "32",
                "--normal",
                "green",
                "--high",
                "red"
              ]
              10,
          Run $
            Network
              "eth1"
              [ "-L",
                "0",
                "-H",
                "32",
                "--normal",
                "green",
                "--high",
                "red"
              ]
              10,
          Run $
            Cpu
              [ "-L",
                "3",
                "-H",
                "50",
                "--normal",
                "green",
                "--high",
                "red"
              ]
              10,
          Run $ Memory ["-t", "Mem: <usedratio>%"] 10,
          Run $ Swap [] 10,
          Run $ Date "%a %b %_d %Y %H:%M:%S" "date" 10,
          Run $ Volume "default" "Master" [] 10,
          Run $ Dunst "dunst" 1000,
          Run XMonadLog
        ],
      sepChar = "%",
      alignSep = "}{",
      template = "%XMonadLog% }{ %default:Master% | %cpu% | %memory% * %swap% | %date% | %dunst%"
    }

applyXResources :: XResources -> Config -> Config
applyXResources res cfg =
  cfg
    {
      borderColor = "black",
      bgColor = background res,
      fgColor = foreground res
    }

data Dunst = Dunst String Int
  deriving (Show, Read)

instance Exec Dunst where
  alias (Dunst a _) = a
  rate (Dunst _ r) = r
  run _ = do
    dbus <- connectSession
    history <- getPropertyHistoryLength dbus
    disp <- getPropertyDisplayedLength dbus
    disconnect dbus

    return $ case (history, disp) of
      (Right h, Right d) -> show d ++ "/" ++ show h
      (_, _) -> ""

getPropertyValueWord32 :: MemberName -> Client -> IO (Either MethodError Word32)
getPropertyValueWord32 member dbus = do
  getPropertyValue dbus (methodCall "/org/freedesktop/Notifications" "org.dunstproject.cmd0" member) { methodCallDestination = Just "org.freedesktop.Notifications" }

getPropertyHistoryLength :: Client -> IO (Either MethodError Word32)
getPropertyHistoryLength = getPropertyValueWord32 "historyLength"

getPropertyDisplayedLength :: Client -> IO (Either MethodError Word32)
getPropertyDisplayedLength = getPropertyValueWord32 "displayedLength"


