# -------------------------- Kitty Specific Aliases -------------------------- #

if [[ $TERM == "xterm-kitty" ]]
then
	alias kcat="kitty +kitten icat"
	alias kdiff="kitty +kitten diff"
fi

# --------------------------------- Clipboard -------------------------------- #

alias xp="xclip -out -selection clipboard"
alias xpi="xp -t image/png"

# ------------------------------------ MPV ----------------------------------- #

alias play_selection='mpv "$(xclip -o)"'
alias slideshow="find . * | mpv -fs --image-display-duration=1 --playlist=-"

# ----------------------------- Downloading stuff ---------------------------- #

alias youtube-dl-aria="youtube-dl --external-downloader 'aria2c' --external-downloader-args '--file-allocation=none -c -x 16 -s 16'" 
alias youtube="youtube-dl-aria -c -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mkv"
alias youmusic="youtube-dl-aria -c -f bestaudio[ext=m4a] -x --audio-format mp3"
alias pd='aria2c --file-allocation=none -c -x 16 -s 16' 

# ---------------------------------- python ---------------------------------- #

alias pie="python3.6"
alias ptpy='ptpython'

# ------------------------------------ git ----------------------------------- #

alias gst="git status"
alias ga="git add"
alias gc='git commit'
alias gp='git push origin master'
alias gpl='git pull origin master'
alias gl='git log --branches --remotes --tags --graph --oneline --decorate'
alias gcm='git checkout master'

# ------------------------------- Arch related ------------------------------- #

alias remorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias remcache='sudo paccache -r'
alias cleanup='yay -Sc'
alias remove='yay -Rcns'

# ---------------------------------- Docker ---------------------------------- #

alias drmi='sudo docker rmi $(sudo docker images -q)'
alias drmc='sudo docker rm $(sudo docker ps -a -q)'
alias dkillall='sudo docker kill $(sudo docker ps -a -q)'
alias vpl_docker='sudo docker run --rm --privileged -p 80:80 -p 443:443 -it --user root hthuwal/vpl_docker bash -c "service vpl-jail-system start; bash"'

# ------------------------------- Miscellaneous ------------------------------ #

alias j='z'
alias subl="subl3"
alias r='ranger'
alias rc='ranger --choosedir="$HOME/.rangerdir"; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias o='xdg-open'
alias subs="subliminal download -l en"
alias bcp="rsync -ah --info=progress2"
alias gapdf='wget -A pdf -m -p -E -k -K -np -nd'
alias vi='vim'
alias img2vid='ffmpeg -r 1 -f image2 -s 1920x1080 -i %03d.png -vcodec libx264 -crf 25'
alias net_sucks='systemctl restart NetworkManager.service'
alias iitd_proxy='ssh -D 8123 -C -q -N sri'

xsv-head() {
    lines=${2:-100}
    xsv cat -n rows -- $1 | head -n $lines | xsv table | less -S
}


