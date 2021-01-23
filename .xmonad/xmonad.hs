--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad

import Data.Monoid

import System.Exit


import XMonad.Actions.CycleWS
import XMonad.Actions.MouseResize

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ServerMode

import XMonad.Util.EZConfig -- optional, but helpful
import XMonad.Util.SpawnOnce
import XMonad.Util.Scratchpad
import XMonad.Util.Run
import XMonad.Util.WorkspaceCompare

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Simplest
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

    -- Layouts modifiers
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))


import XMonad.Hooks.ManageDocks

import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W
import qualified Data.Map        as M



-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
-- Other terminals can be used, such as alacritty and xcfe4-terminal
-- When changing the default terminal, make sure to also change it in 
-- .picom.conf and .config/rofi/edit-configs.sh
myTerminal      = "alacritty"

-- Font
myFont :: String
myFont = "xft:Mononoki Nerd Font:bold:size=11:antialias=true:hinting=true"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myEditor :: String
myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor for tree select

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["dev","www","files","mus","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#ffffff"
myFocusedBorderColor = "#C0C0C0"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch rofi
    --, ((modm,               xK_p     ), spawn "rofi -show run")
    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch firefox
    , ((modm .|. shiftMask, xK_f     ), spawn "firefox")

    -- screenshot to clipboard
    , ((modm .|. shiftMask, xK_s     ), spawn "maim --hidecursor -s | xclip -selection clipboard -t image/png")

    -- screenshot to file
    , ((modm,               xK_s     ), spawn "maim --hidecursor -s ~/$(date +%s).png")

    -- toggle picom
    , ((modm,               xK_c     ), spawn "killall picom || picom --config /home/mal/.config/picom.conf --experimental-backends")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- launch edit-configs
    , ((modm,               xK_d     ), spawn "~/.config/rofi/edit-configs.sh")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    -- Toggle focus in fullscreen
    , ((modm .|. shiftMask, xK_space ), sendMessage $ XMonad.Layout.MultiToggle.Toggle FULL)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,           xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    
    -- Floating windows
    --, ((modm,               xK_f     ), sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)  -- Push floating window back to tile
    --, ((modm .|. shiftMask, xK_t     ), sinkAll)                       -- Push ALL floating windows to tile

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))

    -- Enable use of volume and mute keys
    , ((0 , xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
    , ((0 , xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1.5%")
    , ((0 , xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

    , ((modm, xK_eacute), spawn "playerctl play-pause")    
    , ((modm, xK_ampersand), spawn "playerctl previous")    
    , ((modm, xK_quotedbl), spawn "playerctl next") 

    -- Enable use of brightness keys
    , ((0, xF86XK_MonBrightnessUp), spawn "lux -a 1%")
    , ((0, xF86XK_MonBrightnessDown), spawn "lux -s 1%")  
    ]
    ++

    -- focus /any/ workspace except scratchpad, even visible
    [ ((modm,               xK_Right ), moveTo Next (WSIs notSP))
    , ((modm,               xK_Left  ), moveTo Prev (WSIs notSP))

    -- move window to /any/ workspace except scratchpad
    , ((modm .|. shiftMask, xK_Right ), shiftTo Next (WSIs notSP))
    , ((modm .|. shiftMask, xK_Left  ), shiftTo Prev (WSIs notSP))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

  -- Make sure to put any where clause after your last list of key bindings*
  where notSP = (return $ ("SP" /=) . W.tag) :: X (WindowSpace -> Bool)
        -- | any workspace but scratchpad
        shiftAndView dir = findWorkspace getSortByIndex dir (WSIs notSP) 1
                >>= \t -> (windows . W.shift $ t) >> (windows . W.greedyView $ t)
        -- | hidden, non-empty workspaces less scratchpad
        shiftAndView' dir = findWorkspace getSortByIndexNoSP dir HiddenNonEmptyWS 1
                >>= \t -> (windows . W.shift $ t) >> (windows . W.greedyView $ t)
        getSortByIndexNoSP =
                fmap (.scratchpadFilterOutWorkspace) getSortByIndex
        -- | toggle any workspace but scratchpad
        myToggle = windows $ W.view =<< W.tag . head . filter 
                ((\x -> x /= "NSP" && x /= "SP") . W.tag) . W.hidden 

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm .|. shiftMask, button1), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True
mySpacing2 :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing2 i = spacingRaw False (Border 40 350 40 600) True (Border i i i i) True
mySpacing' :: Integer -> Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i j = spacingRaw False (Border i i i i) True (Border j j j j) True

--layouts
tall_small = renamed [Replace "small"]
           $ limitWindows 12
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing2 20
           $ ResizableTall 1 (3/100) (1/2) []
tall       = renamed [Replace "tall"]
           $ limitWindows 12
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing 20
           $ ResizableTall 1 (3/100) (1/2) []
tall_nosp = renamed [Replace "nosp"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 0
           $ ResizableTall 1 (3/100) (1/2) []
grid     = renamed [Replace "grid"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mkToggle (single MIRROR)
           $ mySpacing' 20 70
           $ Grid (16/10)
floats   = renamed [Replace "floats"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 simplestFloat
spirals  = renamed [Replace "spirals"]
           $ mySpacing 0
           -- $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           -- $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 4
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           -- $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 4
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
--tabs     = renamed [Replace "tabs"]
--           -- I cannot add spacing to this layout because it will
--           -- add spacing between window and tabs which looks bad.
--           $ tabbed shrinkText myTabTheme

myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

myLayout = tall_small 
       ||| tall 
       ||| tall_nosp 
--       ||| floats
--       ||| grid 
--       ||| threeCol 
--       ||| spirals 

-- The layout hook
myLayoutHook = mkToggle (NOBORDERS ?? FULL ?? EOT) $ (avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myLayout)

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- Start nitrogen once on boot, restart picom every time
myStartupHook = do 
    spawnOnce "nitrogen --restore &"
    spawnOnce "redshift -l 50.51:4.20 &"
    spawnOnce "picom --config /home/mal/.config/picom.conf --experimental-backends &"
    spawnOnce "~/bin/conky_launch &"
    spawnOnce "/usr/lib/notification-daemon-1.0/notification-daemon &"
    spawnOnce "batsignal -f 100 -b"
    setWMName "LG3D"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do 
    xmproc <- spawnPipe "xmobar -x 0 /home/mal/.config/xmobar/xmobarrc"
    xmonad $ docks $ ewmh $ ewmh defaults {
        logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
            , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
            --, ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
            , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
            --, ppHiddenNoWindows = xmobarColor "#c792ea" ""        -- Hidden workspaces (no windows)
            , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
            , ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"                     -- Separators in xmobar
            , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
            --, ppExtras  = [windowCount]                           -- # of windows current workspace
            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
        }
        , manageHook = manageDocks <+> manageHook def
        -- , handleEventHook = handleEventHook def <+> fullscreenEventHook
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook
    }


-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayoutHook,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
 
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
