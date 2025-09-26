(local usr (or _G.conf (require :conf)))

(local fennel (require :fennel))

(fn lines [str]
  (icollect [line (str:gmatch "[^\n]+")] line))

(local commands
    {
     :term { :run usr.apps.term }
     :niri { :exec (fn [act ...]
                      (os.execute
                        (.. "niri msg action "
                            act
                            (if ...
                                (table.concat [" --" ...] " ")
                                "")))) }
     :volume { :run "~/scripts/volume"
               :exec (fn [vol]
                       (os.execute
                         (.. "wpctl set-volume @DEFAULT_AUDIO_SINK@ " vol))) }
     
     :power { :run "~/scripts/power"
              :exec (fn [opt]
                      (os.execute (.. "~/scripts/power " opt)))}
    })

;; Provides the launcher with items
(local providers
    {
     ;; Apps and .desktop files
     :desktop { :show #(.. "󰌧  :: " $)
                :results (lines (_G.sh "dot-desktop" true))
                :exec (fn [self n]
                        (-> (assert (. self.results n))
                            (#(.. "dot-desktop \"" $1 "\""))
                            (_G.sh)
                            (os.execute))) }
     ;; Commands to run with `/cmd`
     :commands { :show #(.. "/" $)
                 :results (icollect [k _ (pairs commands)] k)
                 :exec (fn [self n]
                         (let [selected (. self.results n)
                               cmd (. commands selected)]
                           (if cmd.run  (os.execute cmd.run)
                               cmd.exec (cmd.exec)))) }
    })

;; For when no provided item is selected
(local handlers
    { :commands { :match #(= "/" (: $ :sub 1 1))
                  :exec (fn [self text]
                          (let [wrds (icollect [word (text:gmatch "%S+")]
                                       (word:gsub "%^" " "))
                                frst (: (. wrds 1) :sub 2)
                                cmd   (. commands frst)]
                            (if (not cmd)
                                (log _G.ERROR frst "doesn't exist")
                             
                                cmd.exec
                                (cmd.exec
                                  (table.unpack wrds 2))))) } })


{ :launcher usr.apps.launcher
  : providers 
  : handlers }
