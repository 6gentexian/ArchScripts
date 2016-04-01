# Summary

  This suite of scripts provides a basic configuration for emacs v24 on
  Arch linux.  The root emacs file, `~/.emacs` calls additional files that
  provide themes, formatting, hotkeys, the repository info for installs
  and upgrades, various hooks for different editing modes and a file that
  provides nice modeline formatting, based on:
  [http://amitp.blogspot.sg/2011/08/emacs-custom-mode-line.html]

# Files

*    .emacs
**        custom.el
**        my-packages.el
**        my-modes.el
**        my-modeline.el

# Dependencies

Arch - emacs 24.5-2

# Use

Place .emacs in your home directory (~/)
Place dependencies in separate folder `~/.emacs.d/`


# NB   

In order to test changes in the various emacs scripts, place them in
a dev folder and run the following command, e.g. when working on
the modeline script:
```
 $ emacs -q -l path/to/test/init/script scriptname.el
```		
    where
```
      -q            				// runs emacs with no init script
      -l path/to/test/init/script 	// links emacs to the testing init script
      scriptname.el 				// the test file you're editing
```
For example,
```
 $ emacs -q -l ~/DEV/EMACS/.emacs my-modeline.el
```
will edit my new modeline script using the .emacs file in my DEV folder


If something goes wonky with one of the files or future customizations,
 use the debug mode to debug the (e.g. .emacs) file
```
 $ emacs ~/.emacs --debug-init
```

# TODO


# License

