(local usr (or _G.conf (require :conf)))

(local cfg {
            ;; Theming
            :font-family usr.font.mono
            :font-size 11
            
            :adjust-cell-height "20%"

            :background-opacity 1

            :cursor-color (usr.scheme 5)
            :cursor-text (usr.scheme 0)
            :cursor-style :block

            :background (usr.scheme 1)
            :foreground (usr.scheme 5)

            :selection-background (usr.scheme 2)
            :selection-foreground (usr.scheme 0)

            :palette { 0 (usr.scheme 0)
                       1 (usr.scheme 8)
                       2 (usr.scheme 11)
                       3 (usr.scheme 10)
                       4 (usr.scheme 13)
                       5 (usr.scheme 14)
                       6 (usr.scheme 12)
                       7 (usr.scheme 5)
                       8 (usr.scheme 2)
                       9  (or (usr.scheme 18) (usr.scheme 8))
                       10 (or (usr.scheme 20) (usr.scheme 11))
                       11 (or (usr.scheme 19) (usr.scheme 10))
                       12 (or (usr.scheme 22) (usr.scheme 13))
                       13 (or (usr.scheme 23) (usr.scheme 14))
                       14 (or (usr.scheme 21) (usr.scheme 12))
                       15 (or (usr.scheme 7)  (usr.scheme 7))
                       16 (or (usr.scheme 9)  (usr.scheme 9))
                       17 (or (usr.scheme 15) (usr.scheme 15))
                       18 (or (usr.scheme 1)  (usr.scheme 1))
                       19 (or (usr.scheme 2)  (usr.scheme 2))
                       20 (or (usr.scheme 4)  (usr.scheme 4))
                       21 (or (usr.scheme 6)  (usr.scheme 6)) }

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

{ : cfg
  :gen (fn [self]
         (table.concat (gen self.cfg) "\n")) }
