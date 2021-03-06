import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP)
import System.IO


main = do
    xmproc <- spawnPipe "xmobar ~/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ smartSpacing 5 $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "grey" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
	, terminal = "urxvtc"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -activate")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s ~/Pictures/screenshots/%Y-%m-%d_%T.png")
        , ((0, xK_Print), spawn "scrot ~/Pictures/screenshots/%Y-%m-%d_%T.png")
	, ((mod4Mask, xK_p), spawn "dmenu_run -fn 'Droid Sans Mono-9'")
        ] `additionalKeysP`
        [ ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-mute 0 false; pactl set-sink-volume 0 +5%") -- TODO: this can go over 100% (bad quality)
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-mute 0 false; pactl set-sink-volume 0 -5%")
        , ("<XF86AudioMute>"       , spawn "pactl set-sink-mute 0 toggle")
        ]
