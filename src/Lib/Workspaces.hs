module Lib.Workspaces (followTo) where

import XMonad
import XMonad.Actions.CycleWS (Direction1D, WSType, doTo)
import XMonad.Util.WorkspaceCompare (getSortByIndex)
import XMonad.StackSet (shift, greedyView)

followTo :: Direction1D -> WSType -> X ()
followTo dir wsType = doTo dir wsType getSortByIndex (\ws -> windows (shift ws) >> windows (greedyView ws))

