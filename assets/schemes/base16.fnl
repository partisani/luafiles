;; Stolen from StackOverflow
(fn os.capture [cmd raw]
  (let [f (assert (io.popen cmd :r))]
    (var s (assert (f:read :*a)))
    (f:close)
    (when raw (lua "return s"))
    (set s (string.gsub s "^%s+" ""))
    (set s (string.gsub s "%s+$" ""))
    (set s (string.gsub s "[\n\r]+" " "))
    s))

(fn [scheme use24]
  (var scheme scheme) ; Shadowed
  (let [command (.. "yq -o=lua eval '... comments=\"\"' assets/schemes/base16-schemes/base"
                    (if use24 "24/" "16/") scheme :.yaml)]
    (set scheme ((load (os.capture command))))
    (local palette scheme.palette)
    { 0  palette.base00 1  palette.base01 2  palette.base02 3  palette.base03
      4  palette.base04 5  palette.base05 6  palette.base06 7  palette.base07
      8  palette.base08 9  palette.base09 10 palette.base0A 11 palette.base0B
      12 palette.base0C 13 palette.base0D 14 palette.base0E 15 palette.base0F
      16 palette.base11 17 palette.base12 18 palette.base13 19 palette.base14
      20 palette.base15 21 palette.base16 22 palette.base17
      :name scheme.name }))	
