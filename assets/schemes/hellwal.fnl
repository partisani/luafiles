;; swww query | parse --regex '.*image: (?<wall>.+)' | $in.0.wall | hellwal --skip-term-colors -i $in --json | yq ".colors" -o=lua
