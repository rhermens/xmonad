import Lib
import Lib.Media
import Lib.Workspaces (followTo)
import Text.Printf (printf)
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.StatusBar (StatusBarConfig, dynamicEasySBs, statusBarProp)
import XMonad.Hooks.StatusBar.PP (PP (..), shorten)
import XMonad.Util.EZConfig (additionalKeys)
import System.Exit (exitSuccess)
import XMonad.Hooks.Rescreen (addRandrChangeHook)

main :: IO ()
main = do
  resources <- getXResources
  xmonad . ewmhFullscreen . addRandrChangeHook randrChangeHook . ewmh . dynamicEasySBs (pure . barSpawn) $ cfg resources

kMask :: KeyMask
kMask = mod4Mask

dmenuCmd :: XResources -> String
dmenuCmd xrm =
  "dmenu -i -fn \"monospace\" -nb \"" ++ background xrm ++ "\" -nf \"" ++ foreground xrm ++ "\" -sb \"" ++ accent xrm ++ "\" -sf \"" ++ accentForeground xrm ++ "\""

cfg :: XResources -> XConfig (Choose Tall (Choose (Mirror Tall) Full))
cfg xrm =
  def
    { modMask = kMask,
      terminal = "kitty",
      focusedBorderColor = background xrm,
      normalBorderColor = background xrm
    }
    `additionalKeys` [ ((kMask, xK_d), spawn ("j4-dmenu-desktop --dmenu='" ++ dmenuCmd xrm ++ "'")),
                       ((kMask, xK_grave), moveTo Next emptyWS),
                       ((kMask .|. shiftMask, xK_grave), followTo Next emptyWS),
                       ((kMask .|. shiftMask, xK_F11), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"),
                       ((kMask .|. shiftMask, xK_F12), io exitSuccess),
                       ((kMask, xK_q), kill),
                       ((kMask .|. shiftMask, xK_q), kill),
                       ((kMask .|. mod1Mask, xK_l), spawn "slock")
                     ]
    ++ mediaKeys kMask

barCfg :: PP
barCfg =
  def
    { ppSep = " | "
    , ppLayout = const ""
    , ppUrgent = (++ "!!")
    , ppTitle  = shorten 160
    }

barSpawn :: ScreenId -> StatusBarConfig
barSpawn sid = statusBarProp (printf "xmobar -x %d" (toInteger sid)) (pure barCfg)

randrChangeHook :: X ()
randrChangeHook = spawn "autorandr --change"
