import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.StatusBar (defToggleStrutsKey, statusBarProp, withEasySB)
import XMonad.Hooks.StatusBar.PP (PP (ppSep))
import XMonad.Util.EZConfig (additionalKeys)

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . withEasySB (statusBarProp "xmobar" (pure barCfg)) defToggleStrutsKey $ cfg

kMask :: KeyMask
kMask = mod4Mask

cfg :: XConfig (Choose Tall (Choose (Mirror Tall) Full))
cfg =
  def
    { modMask = kMask,
      terminal = "kitty"
    }
    `additionalKeys` [ ((kMask, xK_d), spawn "dmenu_run"),
                        ((kMask, xK_F11), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
                        ((kMask, xK_F12), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
                      ]

barCfg :: PP
barCfg = def {ppSep = "|"}

