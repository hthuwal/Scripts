alias youtube="youtube-dl -c -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mkv"
alias subs="subliminal download -l en"
#python
alias pie="python3.6"

alias r='ranger'

#Github
alias gst="git status"
alias ga="git add"
alias gc='git commit'
alias gp='git push origin master'
alias gpl='git pull origin master'
alias gl='git log --branches --remotes --tags --graph --oneline --decorate'
alias gcm='git checkout master'

alias gapdf='wget -A pdf -m -p -E -k -K -np -nd'

#Aria parallel download
alias pd='aria2c --file-allocation=none -c -x 16 -s 16' 
alias ptpy='ptpython'

xsv-head() {
    lines=${2:-100}
    xsv cat -n rows -- $1 | head -n $lines | xsv table | less -S
}

function gio() { 
	curl -L -s https://www.gitignore.io/api/$@ ;
}

function x265tox264() {

	file_name=$(basename "$@")
	root_dir=$(dirname "$@")
	dest_dir="$root_dir""/x264"
	
	if [ ! -d "$dest_dir" ]; then
		mkdir "$dest_dir"
	fi

	dest_file="$dest_dir""/""$file_name"
	
	echo "Trying to convert to x264.."
	ffmpeg -i "$@" -map 0 -c:a copy -c:s copy -c:v libx264 "$dest_file"
}