module Lib.Media (mediaKeys) where

import Graphics.X11.ExtraTypes.XF86
import XMonad

mediaKeys :: KeyMask -> [((KeyMask, KeySym), X ())]
mediaKeys kMask =
  [ ((noModMask, xF86XK_AudioPlay), spawn "playerctl play-pause"),
    ((noModMask, xF86XK_AudioPause), spawn "playerctl play-pause"),
    ((noModMask, xF86XK_AudioNext), spawn "playerctl next"),
    ((noModMask, xF86XK_AudioPrev), spawn "playerctl previous"),
    ((kMask, xK_F11), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
    ((kMask, xK_F12), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"),
    ((noModMask, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1%"),
    ((noModMask, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1%"),
    ((noModMask, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"),
    ((noModMask, xF86XK_AudioMicMute), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
  ]
