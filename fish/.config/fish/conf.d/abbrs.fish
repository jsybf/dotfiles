# clean all abbreviations
abbr --erase (abbr --list)

abbr --add ga git add --all
abbr --add gs git status
abbr --add gc git commit

abbr --add iimages incus image list images: -f compact
abbr --add ilist incus list -c ns4tS --format compact
abbr --add ifish --set-cursor -- 'incus exec % -- fish'
abbr --add gdog git log --all --decorate --oneline --graph
