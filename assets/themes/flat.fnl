;; Loaded modules
(local module (. package :loaded))

;; Ghostty
(require :ghostty.gen)
(local ghostty (. module :ghostty.gen :cfg))
(set ghostty.window-padding-x 30)
(set ghostty.window-padding-y 30)
(set ghostty.adjust-cell-height "20%")

;; Niri
(require :niri.gen)
(local niri (. module :niri.gen))

(tset (niri:query-selector "layout border active-color")
      :props 1 (conf.scheme 0))
(tset (niri:query-selector "layout border inactive-color")
      :props 1 (conf.scheme 0))

(tset (niri:query-selector "window-rule opacity")
      :props 1 1.01)
(tset (niri:query-selector "window-rule geometry-corner-radius")
      :props 1 0)
