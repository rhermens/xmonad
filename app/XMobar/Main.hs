import Lib (XResources (..), getXResources)
import Xmobar

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
          Run XMonadLog
        ],
      sepChar = "%",
      alignSep = "}{",
      template = "%XMonadLog% }{ %default:Master% | %cpu% | %memory% * %swap% | %date%"
    }

applyXResources :: XResources -> Config -> Config
applyXResources res cfg =
  cfg
    { -- borderColor = background res
      borderColor = "black",
      bgColor = background res,
      fgColor = foreground res
    }
