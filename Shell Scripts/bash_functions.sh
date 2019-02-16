function rename_media(){
	num_params=$#
	
	if [[ $num_params -eq 1 ]]
    then

    	if [[ -d $1 ]]
    	then
	    	cur=$(pwd)
			cd "$1"
	        for filename in *
	        do
	          	tmp="$(echo "$filename" | tr '[A-Z]' '[a-z]')"
	          	case "$filename" in
	          	20*) ##name already starts with 2018 or 20** something
	        	  echo "Don't need to rename "$filename
	        	;;
	            *.MOV|*.mov) 
	              mv -iv "$filename" "$(exiftool -s -CreationDate -d "%Y_%m_%d_%H_%M_%S" "$filename" | awk -F ': ' '{print $2}')"_$tmp
	              ;;
	            *.JPG|*.jpg)
	              mv -iv "$filename" "$(exiftool -s -CreateDate -d "%Y_%m_%d_%H_%M_%S" "$filename" | awk -F ': ' '{print $2}')"_$tmp
	              ;;
	            *.MP4|*.mp4|*.AVI|*.avi)
	              mv -iv "$filename" "$(exiftool -s -FileModifyDate -d "%Y_%m_%d_%H_%M_%S" "$filename" | awk -F ': ' '{print $2}')"_$tmp
	              ;;
	            *)
	              echo 'Not a *.jpg or a *.mov!'
	              ;;
	          	esac
	        done
	        cd "$cur"
        else
        	echo $1 is not a directory
        fi
    else
        echo -e "One argmuent required: The path to the directory containing media files"
        echo -e "\nUsage:\n\n\trename_media pathtofolder\n"
    fi
}

function cpp() {
    # Function to compile and execute a cpp file
    num_params=$#
    if [[ $num_params -eq 2 ]]
    then    
        echo "g++ $1 && time ./a.out < $2"
        g++ $1 && time ./a.out < $2
    elif [[ $num_params -eq 1 ]]
    then
        echo "g++ $1 && time ./a.out"
        g++ $1 && time ./a.out
    else
        echo -e "Atleast one argmuent required"
        echo -e "\nUsage:\n\n\tcpp file.cpp input_file(optional)\n"
    fi
}

function isNum(){
    re='^[0-9]+$'
    if [[ $1 =~ $re ]]
    then
        echo 1
    else
        echo 0
    fi
}

function activate()
{
	cwd=$(pwd)
	home=$HOME

	cond=true
	while "$cond"
	do
		dir=$(pwd)
		if [ "$dir" == "$home" ]; then
			echo "env folder not found."
			cond=false
		elif [ -d "env" ]; then
			echo "Activating virtual environment located at: "$(realpath "env")
			source	"env/bin/activate"
			cond=false
		else
			cd ..
		fi
	done
	cd "$cwd"
}

function shrink-pdf()
{

	function usage(){
		echo -e "Usage: shrink-pdf <-i|--input INPUT_PDF_FILE> <OPTIONS>\n"
		echo -e "Shrink the INPUT_PDF_FILE\n\n"

		echo -e "OPTIONS\n"
		printf "%-25s\t%s\n" "-o|--output" "Specify name of the output file. Default name of the output file is INPUT_PDF_FILE-shrink.pdf"
		printf "%-25s\t%s\n" "-q|--quality" "Specify output quality [0-3]. Default is 1"
		printf "%-25s\t%s\n" "" "0: lower quality, smaller size."
		printf "%-25s\t%s\n" "" "1: for better quality, but slightly larger pdfs."
		printf "%-25s\t%s\n" "" "2: output similar to Acrobat Distiller 'Prepress Optimized' setting."
		printf "%-25s\t%s\n" "" "3: output similar to the Acrobat Distiller 'Print Optimized' setting."
	}

	# dealing with command line args
	while [ "$#" -gt 0 ]
	do
		case "$1" in

			-h|--help)
				usage
				return 0
				;;

			-i|--input)
				local infile="$2"
				if ! [ -f "$infile" ]; then
					echo -e "file '$infile' does not exist\n"
					usage
					return 1
				fi
				shift
				;;

			-o|--output)
				local outfile="$2"
				shift
				;;

			-q|--quality)
				local quality="$2"
					case "$quality" in
					        0)
								quality="/screen"			         
								;;
					        1)
								quality="/ebook"
					            ;;
					        2)
								quality="/prepress"
					            ;;
					        3)
								quality="/printer"
					            ;;
					        *)
								echo -e "Quality shoulb be between [0-3]. Use -h|--help to see the valid options"
					            return 1
					            ;;
					esac
				shift
				;;
			--)
				break
				;;
			-*)
				echo "Invalid option '$1'. Use -h|--help to see the valid options"
				return 1
				;;
		esac
		shift
	done

	# checking if variables are set or not
	if [ -z "$infile" ]; then
		echo -e "Error: No input file specified. Use -h|--help to see the valid options"
		return 1
	fi

	if [ -z "$outfile" ]; then
		if [ "${infile: -4:4}" == ".pdf" ]; then ## filename has extension .pdf
			outfile=${infile:0: -4}"-shrink.pdf"
		else
			outfile=$infile"-shrink.pdf"
		fi
	fi

	if [ -z "$quality" ]; then	
		quality="/ebook"
	fi

	## attempting to shrink
	gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS="$quality" -sOutputFile="$outfile"  "$infile"
	echo "File $infile shrinked to $outfile"
	return 0
}

# functio to pad a white background around an image
function pad()
{
	input=$1
	output=$2
	padding=$3

	if [ -z "$input" ] || [ -z "$output" ] || [ -z "$padding" ]; then
		echo -e "Usage:\t pad in_file out_file padding_size.\n\n\t E.g pad in.png out.png 200\n"
		return 1
	fi
	width=$(convert "$1" -print "%w" /dev/null)
	height=$(convert "$1" -print "%h" /dev/null)
	convert -background white -gravity center -extent $(echo $width + $padding | bc)x$(echo $height + $padding | bc) "$input" "$output"
}

# Find Files based on size
# +1G files bigger than 1Gigs
# -1G files smaller than 1Gigs
function ffbs()
{
	dir="$1"
	thresh="$2"

	find "$dir" -type f -size "$2" | xargs -d '\n' du -sh
}