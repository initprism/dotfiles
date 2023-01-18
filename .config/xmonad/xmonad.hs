import System.Exit
import System.IO
import Data.Maybe
import XMonad
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Actions.MouseResize
import XMonad.Layout.ThreeColumns
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spiral
import XMonad.Layout.Accordion
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.ShowWName
import XMonad.Layout.Renamed
import XMonad.Layout.WindowNavigation
import XMonad.Layout.NoBorders
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import qualified XMonad.StackSet                    as W
import qualified Data.Map                           as M

import Colors.SolarizedDark

------------------------------------------------------------------------
-- Terminimport XMonad.Hooks.EwmhDesktopsal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.

myFont :: String
-- myFont = "xft:Noto Sans CJK:size=10:antialias=true"
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true, xft:Noto Sans CJK:size=10:antialias=true"

myTerminal :: String
myTerminal = "alacritty"

myLauncher :: String
myLauncher = "rofi -show drun"

myBrowser :: String
myBrowser = "firefox"

myLocker :: String
myLocker = "light-locker-command -l"

myFileManager :: String
myFileManager = "nautilus"

------------------------------------------------------------------------
-- WorkSpace

myWorkspaces :: [String]
myWorkspaces = [ " dev ", " www ", " term ", " study " , " sys " , " doc ", " tube ",  " netflix ",  " etc " ]

------------------------------------------------------------------------
-- Colors and borders

myBorderWidth :: Dimension
myBorderWidth = 3

myNormalBorderColor :: String
myNormalBorderColor = colorBack
 
myFocusedBorderColor :: String
myFocusedBorderColor = color14

myClickJustFocuses :: Bool
myClickJustFocuses = False

------------------------------------------------------------------------
-- Key bindings

myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
  , ((modm,               xK_p       ), spawn myLauncher)
  , ((modm,               xK_f       ), spawn myBrowser)
  , ((modm,               xK_u       ), spawn myFileManager)
  , ((modm,               xK_space   ), sendMessage NextLayout)
  , ((modm,               xK_n       ), refresh)
  , ((modm,               xK_j       ), windows W.focusDown)
  , ((modm,               xK_k       ), windows W.focusUp  )
  , ((modm,               xK_m       ), windows W.focusMaster  )
  , ((modm,               xK_Return  ), windows W.swapMaster)
  , ((modm,               xK_h       ), sendMessage Shrink)
  , ((modm,               xK_l       ), sendMessage Expand)
  , ((modm,               xK_t       ), withFocused $ windows . W.sink)
  , ((modm,               xK_comma   ), sendMessage (IncMasterN 1))
  , ((modm,               xK_period  ), sendMessage (IncMasterN (-1)))
  , ((modm,               xK_q       ), restart "xmonad" True)

  , ((modm .|. shiftMask, xK_u       ), spawn myLocker)
  , ((modm .|. shiftMask, xK_c       ), kill)
  , ((modm .|. shiftMask, xK_space   ), setLayout $ XMonad.layoutHook conf)
  , ((modm .|. shiftMask, xK_j       ), windows W.swapDown  )
  , ((modm .|. shiftMask, xK_k       ), windows W.swapUp    )
  , ((modm .|. shiftMask, xK_q       ), io (exitWith ExitSuccess))
  ]
  ++
  [((m .|. modm, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++
  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

  ++
  -- audio control, xev
  [ ((0,                  0x1008ff12), spawn "amixer set Master toggle")
  , ((0,                  0x1008ff11), spawn "amixer set Master 5%- unmute")
  , ((0,                  0x1008ff13), spawn "amixer set Master 5%+ unmute")
  ]


------------------------------------------------------------------------
-- Mouse bindings

myFocusFollowsMouse = False

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))
  ]

------------------------------------------------------------------------
-- Xmobar

myXmobarrc :: String
myXmobarrc = "$HOME/.config/xmobar/xmobarrc"

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..]

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myXmobarPP :: Handle -> PP
myXmobarPP out = def
  { 
    ppOutput          = hPutStrLn out
  , ppCurrent         = xmobarColor color06 "" . wrap 
                        ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>"
  , ppVisible         = xmobarColor color06 "" . clickable
  , ppHidden          = xmobarColor color05 "" . wrap
                        ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>" . clickable
  , ppHiddenNoWindows = xmobarColor color05 ""  . clickable
  , ppTitle           = xmobarColor color16 "" . shorten 60
  , ppSep             =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
  , ppUrgent          = xmobarColor color02 "" . wrap "!" "!"
  , ppExtras          = [windowCount]
  , ppOrder           = \(ws:l:t:ex) -> [ws,l]++ex++[t]
  }

------------------------------------------------------------------------
-- Layouts

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw True (Border i i i i) True (Border i i i i) True

myTabTheme     = def { fontName            = myFont
                     , activeColor         = color15
                     , inactiveColor       = color08
                     , activeBorderColor   = color15
                     , inactiveBorderColor = colorBack
                     , activeTextColor     = colorBack
                     , inactiveTextColor   = color16 
                     }

tall           = renamed [Replace "tall"]
                 $ limitWindows 5
                 $ smartBorders
                 $ windowNavigation
                 $ addTabs shrinkText myTabTheme
                 $ subLayout [] (smartBorders Simplest)
                 $ mySpacing 8
                 $ ResizableTall 1 (3/100) (1/2) []

full           = renamed [Replace "full"]
                 $ smartBorders
                 $ windowNavigation
                 $ addTabs shrinkText myTabTheme
                 $ subLayout [] (smartBorders Simplest)
                 $ Full

grid           = renamed [Replace "grid"]
                 $ limitWindows 9
                 $ withBorder myBorderWidth
                 -- $ smartBorders
                 $ windowNavigation
                 $ addTabs shrinkText myTabTheme
                 $ subLayout [] (smartBorders Simplest)
                 $ mySpacing 8
                 $ mkToggle (single MIRROR)
                 $ Grid (16/10)

threeCol       = renamed [Replace "threeCol"]
                 $ limitWindows 7
                 $ withBorder myBorderWidth
                 -- $ smartBorders
                 $ windowNavigation
                 $ addTabs shrinkText myTabTheme
                 $ subLayout [] (smartBorders Simplest)
                 $ ThreeCol 1 (3/100) (1/2)


--floats         = renamed [Replace "floats"]
--                 $ smartBorders
--                 $ simplestFloat

--spirals        = renamed [Replace "spirals"]
--                 $ limitWindows 9
--                 $ smartBorders
--                 $ windowNavigation
--                 $ addTabs shrinkText myTabTheme
--                 $ subLayout [] (smartBorders Simplest)
--                 $ mySpacing 8
--                 $ spiral (6/7)

--threeRow       = renamed [Replace "threeRow"]
--                 $ limitWindows 7
--                 $ smartBorders
--                 $ windowNavigation
--                 $ addTabs shrinkText myTabTheme
--                 $ subLayout [] (smartBorders Simplest)
--                 $ Mirror
--                 $ ThreeCol 1 (3/100) (1/2)

--tabs           = renamed [Replace "tabs"] $ tabbed shrinkText myTabTheme

--tallAccordion  = renamed [Replace "tallAccordion"] $ Accordion

--wideAccordion  = renamed [Replace "wideAccordion"] $ Mirror Accordion

myLayoutHook = avoidStruts
               $ mouseResize
               $ windowArrange
               -- $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) layout
  where
    layout = withBorder myBorderWidth tall
                                       ||| noBorders full
                                       ||| grid
                                       ||| threeCol
                                       -- ||| floats
                                       -- ||| noBorders tabs
                                       -- ||| spirals
                                       -- ||| threeRow
                                       -- ||| tallAccordion
                                       -- ||| wideAccordion

------------------------------------------------------------------------
-- StartupHook
myStartupHook :: X ()
myStartupHook = do
  spawn "light-locker"
  spawn "killall trayer" 
  spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --iconspacing 10 --expand true --transparent true --alpha 0 " ++ colorTrayer ++ " --height 56")


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.

main :: IO ()
main = do 
     xmproc <- spawnPipe $ "xmobar " <> myXmobarrc
     xmonad 
       . ewmhFullscreen 
       . ewmh 
       . docks
       $ def
       { modMask            = myModMask
       , terminal           = myTerminal
       , startupHook        = myStartupHook
       , workspaces         = myWorkspaces
       , borderWidth        = myBorderWidth
       , normalBorderColor  = myNormalBorderColor
       , focusedBorderColor = myFocusedBorderColor
       , focusFollowsMouse  = myFocusFollowsMouse
       , keys               = myKeys
       , mouseBindings      = myMouseBindings
       , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
       , logHook            = dynamicLogWithPP $ myXmobarPP xmproc
       }
       where 
         myShowWNameTheme :: SWNConfig
         myShowWNameTheme = def { swn_font     = "xft:Ubuntu:bold:size=60"
                                , swn_fade     = 1.0
                                , swn_bgcolor  = "#1c1f24"
                                , swn_color    = "#ffffff" 
                                }
