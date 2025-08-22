(local usr (or _G.conf (require :conf)))
(local fennel (require :fennel))
(fn log [...]
    (print (table.concat
             (icollect [_ v (ipairs [...]) &into ["\x1b[1m"]]
                       (fennel.view v))
             " ") "\x1b[0m")
    ...)

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
                        
(fn option* [name ...]
  (node name [...]))

(local cfg
    [
     (node :input
           (node :keyboard
                 (node :xkb
                       (option* :layout :br)
                       (option* :options                                          "lv3:caps_switch_capslock_with_ctrl,ctrl:nocaps")))
            
            (node :touchpad
                  (flag :tap)
                  (flag :natural-scroll)
                  (option* :scroll-method "two-finger"))
            
            (flag :warp-mouse-to-focus)
            (flag :focus-follows-mouse))
     
     (node :output [ :eDP-1 ]
           (option* :mode "1366x768@60.00")
           (option* :scale 1)
           (option* :transform :normal)
           (option :position { :x 0 :y 0 }))
     
     (node :output [ :VGA-1 ]
           (option* :mode "1366x768@60.00")
           (option* :scale 1)
           (option* :transform :normal)
           (option :position { :x -1366 :y 0 }))
     
     (node :layout
           (option* :background-color :transparent)
           (option* :gaps 30)
           (flag :always-center-single-column)
           (option* :center-focused-column :on-overflow)
     
           (node :preset-column-widths
                 (option* :proportion (/ 1 3))
                 (option* :proportion (/ 1 2))
                 (option* :proportion (/ 2 3))
                 (option* :proportion (/ 2 2)))
     
           (node :default-column-width {} {})
           
           (node :tab-indicator
                 (option :length { :total-proportion 0.75 })
                 (option* :active-color (usr.scheme 8)))
     
           (node :border
                 (option* :active-color (.. (usr.scheme 0) :77))
                 (option* :inactive-color (.. (usr.scheme 0) :77)))
     
           (node :focus-ring
                 (flag :off)))
     
     (node :animations
           (option* :slowdown 1.25)
           
           (node :window-open
                 (option* :duration-ms 250)
                 (option* :curve :linear)
                 (option* :custom-shader
                          (: (io.open "niri/window_open.glsl") :read "a")))
           
           (node :window-close
                 (option* :duration-ms 250)
                 (option* :curve :linear)
                 (option* :custom-shader
                          (: (io.open "niri/window_close.glsl") :read "a"))))
    
     ;; General 
     (node :window-rule
           (option* :geometry-corner-radius 3)
           (option* :clip-to-geometry true)
           (option* :opacity 0.9)
           (option* :draw-border-with-background true))
     
     ;; Ghostty default size
     (node :window-rule
           (option :match { :app-id "^com\\.mitchell\\.ghostty$" })
           (node :default-column-width (option* :proportion 0.5)))
    
     ;; Make `swww-daemon` stay in place while in the overview
     (node :layer-rule
           (option :match { :namespace "^swww-daemon$"})
           (option* :place-within-backdrop true))
     
     (node :overview
           (option* :zoom 0.5)
           (node :workspace-shadow (flag :off)))
     
     (node :environment
           (option* :DISPLAY ::1)
           (option* :GSK_RENDERER :gl))
     
     (node :binds
         (node :Mod+Q (option* :spawn usr.apps.term))
         (node :Mod+R (option* :spawn usr.apps.launcher))
         (node :Mod+C (flag :close-window))
         (node :Mod5+E (flag :toggle-overview))
 
         (node :XF86AudioRaiseVolume { :allow-when-locked true }
            (option* :spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"))
         (node :XF86AudioLowerVolume { :allow-when-locked true }
            (option* :spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ))
         (node :XF86AudioMute { :allow-when-locked true }
            (option* :spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"))
         (node :XF86AudioMicMute { :allow-when-locked true }
            (option* :spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"))
 
         (node :Mod+A (flag :focus-column-left))
         (node :Mod+S (flag :focus-window-or-workspace-down))
         (node :Mod+W (flag :focus-window-or-workspace-up))
         (node :Mod+D (flag :focus-column-right))
 
         (node :Mod5+A (flag :move-column-left))
         (node :Mod5+S (flag :move-window-down-or-to-workspace-down))
         (node :Mod5+W (flag :move-window-up-or-to-workspace-up))
         (node :Mod5+D (flag :move-column-right))
 
         (node :Mod+Home (flag :focus-column-first))
         (node :Mod+End  (flag :focus-column-last))
 
         (node :Mod5+Home (flag :move-column-to-first))
         (node :Mod5+End  (flag :move-column-to-last))
 
         (node :Mod+Shift+A (flag :focus-monitor-left))
         (node :Mod+Shift+S (flag :focus-monitor-down))
         (node :Mod+Shift+W (flag :focus-monitor-up))
         (node :Mod+Shift+D (flag :focus-monitor-right))
 
         (node :Mod5+Shift+A (flag :move-column-to-monitor-left))
         (node :Mod5+Shift+S (flag :move-column-to-monitor-down))
         (node :Mod5+Shift+W (flag :move-column-to-monitor-up))
         (node :Mod5+Shift+D (flag :move-column-to-monitor-right))
 
         (node :Mod+Page_Down (flag :focus-workspace-down))
         (node :Mod+Page_Up   (flag :focus-workspace-up))
 
         (node :Mod5+Page_Down (flag :move-column-to-workspace-down))
         (node :Mod5+Page_Up   (flag :move-column-to-workspace-up))
 
         (node :Mod+Shift+Page_Down (flag :move-workspace-down))
         (node :Mod+Shift+Page_Up   (flag :move-workspace-up))
 
         (node :Mod+Shift+U (flag :move-workspace-down))
         (node :Mod+Shift+I (flag :move-workspace-up))
 
         (node :Mod+WheelScrollDown { :cooldown-ms 150 }
               (flag :focus-workspace-down))
         (node :Mod+WheelScrollUp { :cooldown-ms 150 }
               (flag :focus-workspace-up))
 
         (node :Mod5+WheelScrollDown { :cooldown-ms 150 }
               (flag :move-column-to-workspace-down))
         (node :Mod5+WheelScrollUp { :cooldown-ms 150 }
               (flag :move-column-to-workspace-up))
 
         (node :Mod+Shift+WheelScrollDown (flag :focus-column-right))
         (node :Mod+Shift+WheelScrollUp   (flag :focus-column-left))
 
         (node :Mod5+Shift+WheelScrollDown (flag :move-column-right))
         (node :Mod5+Shift+WheelScrollUp   (flag :move-column-left))
 
         (node :Mod+1 (option* :focus-workspace 1))
         (node :Mod+2 (option* :focus-workspace 2))
         (node :Mod+3 (option* :focus-workspace 3))
         (node :Mod+4 (option* :focus-workspace 4))
         (node :Mod+5 (option* :focus-workspace 5))
         (node :Mod+6 (option* :focus-workspace 6))
         (node :Mod+7 (option* :focus-workspace 7))
         (node :Mod+8 (option* :focus-workspace 8))
         (node :Mod+9 (option* :focus-workspace 9))
 
         (node :Mod5+1 (option* :move-column-to-workspace 1))
         (node :Mod5+2 (option* :move-column-to-workspace 2))
         (node :Mod5+3 (option* :move-column-to-workspace 3))
         (node :Mod5+4 (option* :move-column-to-workspace 4))
         (node :Mod5+5 (option* :move-column-to-workspace 5))
         (node :Mod5+6 (option* :move-column-to-workspace 6))
         (node :Mod5+7 (option* :move-column-to-workspace 7))
         (node :Mod5+8 (option* :move-column-to-workspace 8))
         (node :Mod5+9 (option* :move-column-to-workspace 9))
 
         (node :Mod+BracketLeft  (flag :consume-or-expel-window-left))
         (node :Mod+BracketRight (flag :consume-or-expel-window-right))
 
         (node :Mod5+R       (flag :switch-preset-column-width))
         (node :Mod5+Shift+R (flag :switch-preset-window-height))
         (node :Mod5+Ctrl+R  (flag :reset-window-height))
 
         (node :Mod5+F       (flag :maximize-column))
         (node :Mod5+Shift+F (flag :fullscreen-window))
         (node :Mod5+Ctrl+F  (flag :expand-column-to-available-width))
 
         (node :Mod+Minus (option* :set-column-width "-10%"))
         (node :Mod+Equal (option* :set-column-width "+10%"))
 
         (node :Mod+Shift+Minus (option* :set-window-height "-10%"))
         (node :Mod+Shift+Equal (option* :set-window-height "+10%"))
 
         (node :Mod+V       (flag :toggle-window-floating))
         (node :Mod+Shift+V (flag :switch-focus-between-floating-and-tiling))
 
         (node :Mod+T (flag :toggle-column-tabbed-display))
 
         (node :Print      (flag :screenshot))
         (node :Ctrl+Print (flag :screenshot-screen))
         (node :Alt+Print  (flag :screenshot-window))
 
         (node :Mod+Escape { :allow-inhibiting false }
               (flag :toggle-keyboard-shortcuts-inhibit))
 
         (node :Ctrl+Alt+Delete (flag :quit))
 
         (node :Mod+Shift+P     (flag :power-off-monitors)))
     
     (option* :spawn-at-startup :xwayland-satellite)
     (option* :spawn-at-startup :swww-daemon)
     
     (flag :prefer-no-csd)
     
     (option* :screenshot-path "~/files/pictures/screenshots/screenshot-%d.%m.%Y %H:%M:%S.png")
    ])

;; Checks if two values are equal. Predicate mode makes so
;; that b acts as a predicate for a.
(fn is-equal? [a b pred?]
      ;; If both are equal.
  (if (= a b)
      true
      
      ;; If both are tables and predicate mode is enabled.
      (and pred? (= (type a) (type b) :table))
      (accumulate [matches? true
                   k v (pairs b)]
        ;; If b[k] == a[k]
        (if (and (is-equal? v (. a k) pred?) matches?)
            true
            false))
      
      ;; If both are tables
      (= (type a) (type b) :table)
      (and
        (accumulate [matches? true
                     k v (pairs a)]
          ;; If b[k] == a[k]
          (if (and (is-equal? v (. b k)) matches?)
              true
              false))
        (accumulate [matches? true
                     k v (pairs b)]
          ;; If a[k] == b[k]
          (if (and (is-equal? v (. a k)) matches?)
              true
              false)))
      
      false))

;; Checks if properties match a predicate.
(fn matches-props? [props pred]
  (if props
      (is-equal? props pred true)
      true))

;; Goes a layer deep in the configuration tree.
(fn traverse [cfg name props]
  (let [next (accumulate [curr cfg
                          _ ch (ipairs curr)]
                  (if (and (= name ch.name)
                           (matches-props? ch.props props))
                      ch
                      curr))]
    (if (= next cfg)
        nil
        next)))

;; A query is a string in the format:
;;   NAME1(:OPT)? NAME2(:OPT)? ...
(fn parse-query [str]
  (let [frags (icollect [word (str:gmatch "%S+")]
                (icollect [part (word:gmatch "[^:]+")]
                  part))]
    frags))

;; Finds a node in the configuration using a query.
(fn query-selector [self query]
    (accumulate [curr self.cfg
                 _ [name opt] (ipairs (parse-query query))]
        (if curr
            (traverse curr name [ opt ]))))

(fn value->string [val]
  (case (type val)
    :nil     "#null"
    :boolean (tostring val)
    :number  (tostring val)
    :string  (fennel.view val { :escape-newlines? true
                                :one-line? true })
    t        (.. "#invalid: " t)))

(fn node->string [n]
  (if n.node?
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
        "")
      ""))

{ :gen (fn [self]
         (table.concat
           (icollect [_ v (pairs cfg)]
             (node->string v)) "\n"))
  : cfg
  : node
  : flag
  : option
  : query-selector
  : node->string
  : value->string }
