;; read a file with this format as input,
;; and return a compatible 16/24 color scheme.
;; 
;; format:
;;   COLOR0 anything else
;;   COLOR1 can be typed
;;   COLOR2 after the
;;   COLOR3 colors are
;;   COLOR4 declared
;;   COLOR5
;;   COLOR6 lorem ipsum
;;   COLOR7 dolor sit
;;   COLOR8 amet
;;   COLOR9 consectetur
;;   COLORA adipisci velit
;;   COLORB
;;   COLORC as you already
;;   COLORD noticed, there
;;   COLORE wasn't enough
;;   COLORF space for it...
;;   
;;   but now i have space for anything else down there >:)

(fn [scheme]
  (io.input (.. :assets/themes/homemade-schemes/ scheme))
  (var colors {})
  (let [text (io.read :*all)]
    (each [line (text:gmatch "[^\n]+")]
      (local words {})
      (each [word (line:gmatch "%S+")] (table.insert words word))
      (table.insert colors (. words 1))))
  {  0 (. colors 1)   1 (. colors 2)   2 (. colors 3)   3 (. colors 4)
     4 (. colors 5)   5 (. colors 6)   6 (. colors 7)   7 (. colors 8)
     8 (. colors 9)   9 (. colors 10) 10 (. colors 11) 11 (. colors 12)
    12 (. colors 13) 13 (. colors 14) 14 (. colors 15) 15 (. colors 16)
    :name scheme })
