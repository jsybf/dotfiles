function add-user-font
    if test (count $argv) -ne 2
        echo "[1] Usage: install_font <source_dir_path> <dest_dir_name>"
        return 1
    end

    set -l src $argv[1]
    set -l name $argv[2]
    set -l dest ~/.local/share/fonts/$name

    if not test -d $src
        echo "Error: source dir '$src' not found"
        return 1
    end

    mkdir -p $dest

    set -l fonts $src/*.ttf $src/*.ttc $src/*.otf
    if test (count $fonts) -eq 0
        echo "Error: no font files (.ttf/.ttc/.otf) in '$src'"
        return 1
    end

    cp $fonts $dest/
    echo "[2] Copied "(count $fonts)" font file(s) to $dest"

    fc-cache -fv $dest
    echo "[3] indexed new fonts"
end
