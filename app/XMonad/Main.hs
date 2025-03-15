import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Util.EZConfig (additionalKeys)
import Text.Printf (printf)
import XMonad.Hooks.StatusBar.PP (PP (ppSep))
import XMonad.Hooks.StatusBar (StatusBarConfig, statusBarProp, dynamicEasySBs)
import Lib (getXResources, XResources (foreground, background))

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
                        ((kMask, xK_F11), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
                        ((kMask, xK_F12), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
                      ]

barCfg :: PP
barCfg = def {
        ppSep = "|"
    }

barSpawn :: ScreenId -> StatusBarConfig
barSpawn sid = statusBarProp (printf "xmobar -x %d" (toInteger sid)) (pure barCfg)

applyXResources :: XResources -> XConfig l -> XConfig l
applyXResources res conf = conf {
    focusedBorderColor = background res,
    normalBorderColor = foreground res
}

