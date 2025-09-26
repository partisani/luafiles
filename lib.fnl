(fn _G.sh [cmd raw]
  (let [f (assert (io.popen cmd :r))]
    (var s (assert (f:read :*a)))
    (f:close)
    (when raw (lua "return s"))
    (set s (string.gsub s "^%s+" ""))
    (set s (string.gsub s "%s+$" ""))
    (set s (string.gsub s "[\n\r]+" " "))
    s))

(fn string.split [self delimiter]
  (let [result {}]
    (var from 1)
    (var (delim-from delim-to) (string.find self delimiter from true))
    (while delim-from
      (when (not= delim-from 1)
        (table.insert result (string.sub self from (- delim-from 1))))
      (set from (+ delim-to 1))
      (set (delim-from delim-to) (string.find self delimiter from true)))
    (when (<= from (length self))
        (table.insert result (string.sub self from)))
    result))

(set _G.HIDE 0)
(set _G.TEXT 1)
(set _G.INFO 2)
(set _G.ERROR 3)
(fn _G.log [level ...]
  (let [formatting {0 "\027[2m"
                    1 "\027[2m:::"
                    2 "\027[32;1m[#] "
                    3 "\027[31;1m[!] "}]
    (print (. formatting level) (.. (table.concat [...] " ") "\027[0m"))))
