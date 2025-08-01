;; Loaded modules
(local module (. package :loaded))

;; Ghostty
(require :ghostty.gen)
(local ghostty (. module :ghostty.gen :cfg))
(set ghostty.background-opacity 0)
