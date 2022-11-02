# Go to a place directly
echo "Where to go ?"
declare -A addr

h=$HOME

addr["l"]="$h/Templates/lrn/"
addr["r"]="$h/Templates/lrn/h5/react/my-vite-react-ts/"
addr["w"]="/home/me/work/lcode/"

{
    for s in "${!addr[@]}"; do
        printf "\t%-10s: %10s\n" "$s" "${addr["$s"]}"
    done | sort
    echo
}

read -p "Enter your choice >>>" r

{
    for s in "${!addr[@]}"; do
        if [ $r = $s ] ; then
           echo "Address found"
           a=${addr["$s"]}
           cd $a
           return
        fi
    done
    echo "Address not found for $r 🐸"
}
