(local usr (or _G.conf (require :conf)))
(local scheme usr.scheme)

(local cfg {
            ;; Fixes
            :width :100%
            :height :100%

            ;; Behaviour
            :text-cursor true
            :terminal (.. usr.apps.term " -e")
                        
            ;; Theming
            :font "monospace"
            
            :prompt-text ">> "
            
            :background-color (.. scheme.hex0 "77")
            :text-color scheme.hex4
            :prompt-color scheme.hex7
            :selection-color scheme.hexA
            
            :outline-width 0
            :border-width 0
            
            :num-results 8
            :result-spacing 15

            :padding-top :15%
            :padding-bottom :15%
            :padding-left :20%
            :padding-right :20%
           })

(fn gen [tbl]
   (icollect [k v (pairs tbl) &into ["# Auto-generated"]]
     (.. k " = \"" (tostring v) "\"")))

{ : cfg
  :gen (fn [self]
         (table.concat (gen self.cfg) "\n")) }
