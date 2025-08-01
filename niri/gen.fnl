(local fennel (require :fennel))
(fn pp [...] (print (fennel.view [...])) ...)

(fn node [name a ...]
  (let [props    (if (not (?. a :node?)) a {}) ;; if a is not node, a is props
        children (if (?. a :node?) [a ...] [...])]
    (accumulate [acc { :node? true : name : props }
                 i child (ipairs children)]
        (doto acc
            (tset i child)))))

(fn flag [name]
  (node name))

(fn option [name props]
  (node name props))

(local cfg
    [
     (node :input
           (node :keyboard
                 (node :xkb
                       (option :layout [ :br ])
                       (option :options [
                                         "lv3:caps_switch_capslock_with_ctrl,ctrl:nocaps" ])))
            
            (node :touchpad
                  (flag :tap)
                  (flag :natural-scroll)
                  (option :scroll-method [ "two-finger" ]))
            
            (flag :warp-mouse-to-focus)
            (flag :focus-follows-mouse))
     
     (node :output [ :eDP-1 ]
           (option :mode [ "1366x768@60.00" ])
           (option :scale [ 1 ])
           (option :transform [ :normal ])
           (option :position { :x 0 :y 0 }))
     
     (node :output [ :VGA-1 ]
           (option :mode [ "1366x768@60.00" ])
           (option :scale [ 1 ])
           (option :transform [ :normal ])
           (option :position { :x -1366 :y 0 }))
     
     (node :layout
           (option :background-color [ :transparent ])
           (option :gaps [ 30 ])
           (option :center-focused-column [ :never ]))
    ])

(fn value->string [val]
  (case (type val)
    :nil    "#null"
    :number (tostring val)
    :string (fennel.view val { :escape-newlines? true
                               :one-line? true })
    t       (.. "#invalid: " t)))

(fn node->string [n]
  (table.concat
    [
     n.name

     (if n.props
         (..
           ;; Properties (§3.4)
           (table.concat
             (icollect [key val (pairs n.props)]
               (if (not= (type key) :number)
                   (.. " " key "=" (value->string val)))) "")
           " "
           ;; Arguments (§3.5)
           (table.concat
             (icollect [_ val (ipairs n.props)]
               (.. (value->string val) " ")) ""))
         " ")

     ;; Children Block (§3.6)
     (if (. n 1)
         (..
           "{\n"
           (table.concat 
             (icollect [_ ch (ipairs n)]
               (node->string ch))
             "\n")
           "\n}")
         "")
    ]
   ""))

{ :gen (fn [self]
         (table.concat
           (icollect [_ v (pairs cfg)]
             (node->string v)) "\n"))
  : cfg
  : node
  : flag
  : option
  : match-selector
  : node->string
  : value->string }
