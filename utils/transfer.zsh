transfer() { 
    # check arguments
    if [ $# -eq 0 ]; then 
        echo "No arguments specified." >&2
        echo "Usage:" >&2
        echo "  transfer <file|directory>" >&2
        echo "  ... | transfer <file_name>" >&2
        return 1
    fi
    
    if tty -s; then # transfer file or directory
        file="$1"
        file_name=$(basename "$file")
        if [ ! -e "$file" ]; then
            echo "$file: No such file or directory" >&2
            return 1
        fi
      
        if [ -d "$file" ]; then  # transfer directory
            file_name="$file_name.zip" 
            (cd "$file" && zip -r -q - .) | curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" | tee /dev/null
        else # transfer file
            cat "$file" | curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" | tee /dev/null
        fi
    else # transfer pipe
        file_name=$1
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" | tee /dev/null
    fi
}
