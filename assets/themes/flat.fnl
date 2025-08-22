;; Loaded modules
(local module (. package :loaded))

;; Ghostty
(require :ghostty.gen)
(local ghostty (. module :ghostty.gen :cfg))
(set ghostty.window-padding-x 10)
(set ghostty.window-padding-y 10)
(set ghostty.adjust-cell-height "20%")
