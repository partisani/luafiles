(local astal (require :astal))
(local App (require :astal.gtk3.app))

(astal.exec (string.format "sass %s %s" "./style.scss" "/tmp/astal.css"))

(local Sidepanel (require :sidepanel))

(App:start {
  :main (fn []
          (Sidepanel 1)
          (Sidepanel 2))
  :css "/tmp/astal.css" })
