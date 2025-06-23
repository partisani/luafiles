(local data (require :conf))

;; Stolen from stack overflow: https://stackoverflow.com/questions/1283388/how-to-merge-two-tables-overwriting-the-elements-which-are-in-both
(fn merge [a b]
  "Merges a and b using a simple recursive call to itself
   whenever both values are tables, or returns the value in a."
  (when (and (= (type a) :table) (= (type b) :table))
    (each [k v (pairs b)]
      (if (and (= (type v) :table) (= (type (or (. a k) false)) :table))
          (merge (. a k) v) (tset a k v))))
  a)

{ :targets { 0       { :target "~/.config/" }
             :home   { :target "~/" }
             :misc   { :target "~/.config/" }
             :assets { :skip true }
           }
  :process (fn [text filename]
            (var [text filename] [text filename]) ; Shadowed
            (var (_ match-end directives) (text:find "^@ (.-) @\n"))
            (when directives
              (set text (text:sub (+ match-end 1)))
              (set directives ((load (.. "return " directives))))
              (set filename directives.filename))
            (local res (text:gsub "@%|(.-)%|@"
                                  (fn [s]
                                    (let [compiled (load s nil nil (merge _G data))
                                          func (assert compiled)]
                                        (func)))))
            (values res filename)) }
