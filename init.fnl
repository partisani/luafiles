(var env {}) ; Creating env before imports to avoid
             ; contamination inside the custom environment
(each [k v (pairs _G)]
  (tset env k v))
(tset env :conf (require :conf))
(fn env.repl [self opts] ; Simple fennel.repl wrapper
  ((coroutine.wrap #(fennel.repl { :readChunk coroutine.yield :env self ...opts }))))

(local socket (require :posix.sys.socket))
(local unistd (require :posix.unistd))
(local fennel (require :fennel))

(let [fd (assert (socket.socket socket.AF_UNIX
                                socket.SOCK_STREAM
                                0))
      _  (unistd.unlink "/tmp/conf.sock")
      _  (assert (socket.bind fd { :family socket.AF_UNIX
                                   :path "/tmp/conf.sock" }))
      _  (assert (socket.listen fd 5))]
  (var done? false)
  (while (not done?)
    (let [(conn addr) (assert (socket.accept fd))
          data        (assert (socket.recv conn 1024))
          (ok dat)    (pcall  #(fennel.eval data { : env }))
          _           (assert (socket.send conn (fennel.view dat)))]
      nil))
  
  (unistd.close fd))
