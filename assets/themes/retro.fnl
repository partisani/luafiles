;; Loaded modules
(local module (. package :loaded))

;; Ghostty
(require :ghostty.gen)
(local ghostty (. module :ghostty.gen :cfg))
(set ghostty.window-padding-x 15)
(set ghostty.window-padding-y 15)
;(set ghostty.adjust-cell-height "0%")

;; Tofi
(require :tofi.gen)
(local tofi (. module :tofi.gen :cfg))

;; Niri
(require :niri.gen)
(local niri (. module :niri.gen))

;(tset (niri:query-selector "layout border active-color")
;      :props 1 conf.scheme.hex7)
(tset (niri:query-selector "layout border active-color")
      :props 1 conf.scheme.hex0)
;(table.insert (niri:query-selector "layout border")
;              (niri.option* :width 3))

(tset (niri:query-selector "window-rule opacity")
      :props 1 1.01)
(tset (niri:query-selector "window-rule geometry-corner-radius")
      :props 1 0)
