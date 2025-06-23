(local config-path :/home/partisani/config/conf.lua)
(local config-dir :/home/partisani/config/)

(local conf
       { :apps {:editor :kak :term :ghostty}
         :config_dir config-dir
         :config_path config-path
         :font {:mono "Iosevka Ultra"}
         :theme ((require :assets.themes.base16) :rose-pine-moon nil)
                  ;; If #2 is non-nil, use base24. As a convention,
                  ;; set it to :base24 for ease of understanding.
                ; ((require :assets.themes.homemade :eink))
        })

(setmetatable conf.theme
  { :__index (fn [tbl k]
               "tbl.hexN should return #RRGGBB.
                tbl.nhxN should return RRGGBB.
                tbl.rawN should return {float R, float G, float B}.
                tbl.rgbN should return rgb(R, G, B)."
               (when (tonumber k) (lua "return "))
               (local methods
                      { :hex (fn [c] c)
                        :nhx (fn [c] (c:sub 2))
                        :raw (fn [c]
                               (let [[r g b]
                                     [
                                      (/ (tonumber (c:sub 2 3) 16)
                                         256)
                                      (/ (tonumber (c:sub 4 5) 16)
                                         256)
                                      (/ (tonumber (c:sub 6 7) 16)
                                         256)
                                     ]]
                                  [r g b]))})
               (local method
                      (.. (k:sub 1 1) (k:sub 2 2) (k:sub 3 3)))
               (local num (tonumber (k:sub 4 4) 16))
               (local color (. tbl num))
               ((. methods method) color))})

conf	
