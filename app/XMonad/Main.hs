import Lib
import Lib.Media
import Lib.Workspaces (followTo)
import Text.Printf (printf)
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.StatusBar (StatusBarConfig, dynamicEasySBs, statusBarProp)
import XMonad.Hooks.StatusBar.PP (PP (ppSep))
import XMonad.Util.EZConfig (additionalKeys)

main :: IO ()
main = do
  resources <- getXResources
  xmonad . ewmhFullscreen . ewmh . dynamicEasySBs (pure . barSpawn) . applyXResources resources $ cfg

kMask :: KeyMask
kMask = mod4Mask

cfg :: XConfig (Choose Tall (Choose (Mirror Tall) Full))
cfg =
  def
    { modMask = kMask,
      terminal = "kitty"
    }
    `additionalKeys` [ ((kMask, xK_d), spawn "j4-dmenu-desktop --dmenu='dmenu -i -fn \"monospace\" -nb \"#24283b\" -nf \"#c0caf5\" -sb \"#414868\" -sf \"#7aa2f7\"'"),
                       ((kMask, xK_grave), moveTo Next emptyWS),
                       ((kMask .|. shiftMask, xK_grave), followTo Next emptyWS)
                     ]
    ++ mediaKeys kMask

barCfg :: PP
barCfg =
  def
    { ppSep = "|"
    }

barSpawn :: ScreenId -> StatusBarConfig
barSpawn sid = statusBarProp (printf "xmobar -x %d" (toInteger sid)) (pure barCfg)

applyXResources :: XResources -> XConfig l -> XConfig l
applyXResources res conf =
  conf
    { focusedBorderColor = background res,
      normalBorderColor = background res
    }
