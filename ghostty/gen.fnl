;; Returns a table of files that should be generated
(local usr (require :conf))

(local cfg {
            ;; Theming
            :font-family usr.font.mono
            :font-size 11
            
            :adjust-cell-height "20%"

            :background-opacity 0.0

            :cursor-color (usr.theme 5)
            :cursor-text (usr.theme 0)
            :cursor-style :block

            :background (usr.theme 1)
            :foreground (usr.theme 5)

            :selection-background (usr.theme 2)
            :selection-foreground (usr.theme 0)

            :palette { 0 (usr.theme 0)
                       1 (usr.theme 8)
                       2 (usr.theme 11)
                       3 (usr.theme 10)
                       4 (usr.theme 13)
                       5 (usr.theme 14)
                       6 (usr.theme 12)
                       7 (usr.theme 5)
                       8 (usr.theme 2)
                       9  (or (usr.theme 18) (usr.theme 8))
                       10 (or (usr.theme 20) (usr.theme 11))
                       11 (or (usr.theme 19) (usr.theme 10))
                       12 (or (usr.theme 22) (usr.theme 13))
                       13 (or (usr.theme 23) (usr.theme 14))
                       14 (or (usr.theme 21) (usr.theme 12))
                       15 (or (usr.theme 7)  (usr.theme 7))
                       16 (or (usr.theme 9)  (usr.theme 9))
                       17 (or (usr.theme 15) (usr.theme 15))
                       18 (or (usr.theme 1)  (usr.theme 1))
                       19 (or (usr.theme 2)  (usr.theme 2))
                       20 (or (usr.theme 4)  (usr.theme 4))
                       21 (or (usr.theme 6)  (usr.theme 6)) }

            :bold-is-bright :true

            :window-padding-x 20
            :window-padding-y 20

            ;; Keybinds
            :keybind { :ctrl+a :toggle_quick_terminal }
           })

(fn gen [tbl]
   (icollect [k v (pairs tbl) &into ["# Auto-generated"]]
     (if (not= (type v) :table)                                ; Simple key=val
         (.. k " = " v)
         (table.concat (icollect [ik iv (pairs v)]
           (.. k " = " ik "=" iv)) "\n"))))  ; (key=vk=vv)*

(table.concat (gen cfg) "\n")
