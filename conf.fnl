(local config-path :/home/partisani/config/conf.fnl)
(local config-dir :/home/partisani/config/)

(local conf
       { :distro "I USE ARCH BTW"
         :apps { :editor "kak" :term "ghostty" }
         :config_dir config-dir
         :config_path config-path
         :font { :mono "Iosevka Manet" :serif "Iosevka Manet" :sans-serif "Iosevka Manet" }
         :scheme ((require :assets.schemes.base16) :black-metal-bathory nil)
                  ;; If #2 is non-nil, use base24. As a convention,
                  ;; set it to :base24 for ease of understanding.
                ;((require :assets.schemes.homemade) :backlight-amber)
        })

;; Allows scheme to be indexed by:
;; tbl.{method}N where N is a number between 0..F
(local methods
       { :hex (fn [c] c)
         :nhx (fn [c] (c:sub 2))
         :raw (fn [c]
                (let [[r g b]
                      [
                       (/ (tonumber (c:sub 2 3) 16) 256)
                       (/ (tonumber (c:sub 4 5) 16) 256)
                       (/ (tonumber (c:sub 6 7) 16) 256)
                      ]]
                   [r g b]))})
;; tbl(N) or (tbl N) where N is a number
;; methods.{method}(tbl(N)) or (methods.{method} (tbl N)) that allows usage of
;; these previously defined methods in other contexts and for numbers > 0xF

(setmetatable conf.scheme
  { :__index (fn [tbl k]
               "tbl.hexN should return #RRGGBB.
                tbl.nhxN should return RRGGBB.
                tbl.rawN should return {float R, float G, float B}.
                tbl.rgbN should return rgb(R, G, B)."
               (when (tonumber k) (lua "return "))
               (local method
                      (.. (k:sub 1 1) (k:sub 2 2) (k:sub 3 3)))
               (local num (tonumber (k:sub 4 4) 16))
               (local color (. tbl num))
               ((. methods method) color))
    :__call #(. $1 $2) })

conf
