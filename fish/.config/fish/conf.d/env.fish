# fcitx
set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS @im=fcitx

# editor
set -gx EDITOR ~/.local/bin/nvim

#LS_COLORS
# set -gx LS_COLORS (dircolors -b ~/.config/dir_colors/my_dir_colors | string match -rg "LS_COLORS='(.*)'")
