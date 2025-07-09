(local Widget (require :astal.gtk3.widget))
(local Anchor (. (require :astal.gtk3) :Astal :WindowAnchor))
(local Variable (. (require :astal) :Variable))

(local json (require :json))

(var overview-open? (: (Variable false) :watch
                       "niri msg -j event-stream" 
                       (fn [out prev]
                         (let [decoded  (json.decode out)
                               open-fn? #(?. $ :OverviewOpenedOrClosed :is_open)
                               is-open? (open-fn? decoded)]
                           (if (= is-open? nil)
                               prev
                               is-open?)))))

(fn pp [...]
  (print "dbg" ...)
  ...)

(fn string.trunc [self num ellipsis?]
  (if (< num (length self))
      (.. (self:sub 1 num) (if ellipsis? "..."))
      self))

(var date (Variable.poll   (Variable "null") 10000 "date +\"%e de %B (%a)\"" #$1))
(var time (Variable.poll   (Variable "null") 10000 "date +\"%H:%M\"" #$1))
(var music (Variable.watch (Variable "null") ; 1st = Title, 2nd = Artist, 3rd = Cover Art
                           "playerctl metadata -F -f '{{title}}#{{artist}}#{{mpris:artUrl}}'"
                           (fn [out]
                             (pp (icollect [s (string.gmatch out "(.-)#")] s)))))

(fn Panel [...]
  (Widget.Box { :vertical true
                ;:vexpand true
                :class_name "panel"
                1 [...] }))

(fn Panels []
  (Widget.Box { :vertical true
                1 (Panel
                   (Widget.Label { :label (time #$) :class_name "size-4" })
                   (Widget.Label { :label (date string.upper) :class_name "bold" }))
                2 (Panel
                   (Widget.Box { :class_name "cover-art"
                                 :css (string.format "background-image: url('%s');"
                                                     (music #(. $ 3))) })
                   (Widget.Label { :label (music (fn [vals]
                                                   (if (. vals 1)
                                                       (let [name    (?. vals 1)
                                                             artist  (?. vals 2)
                                                             tname   (name:trunc 10 true)
                                                             tartist (artist:trunct 10 true)]
                                                             (string.format "%s • %s"
                                                                            tname tartist))
                                                       "nothing playing"))) })) }))

(fn [monitor]
  (Widget.Window { :name "Sidepanel"
                   :application (require :astal.gtk3.app)
                   :anchor (+ Anchor.TOP Anchor.BOTTOM Anchor.LEFT)
                   :monitor monitor
                   :class_name "sidepanel"
                   :margin_top    20
                   :margin_bottom 20
                   :margin_left   20
                                    
                   1 (Widget.Revealer { :reveal_child (overview-open? #$)
                                        :transition_type 2 ; https://docs.gtk.org/gtk3/enum.RevealerTransitionType.html
                                        1 (Panels) }) }))
