# Go to a place directly
echo "Where to go ?"
declare -A addr

h=$HOME

addr["l"]="$h/Templates/lrn/"
addr["p"]="$h/Templates/lrn/tex/prog/"
addr["r"]="$h/Templates/lrn/h5/react/menu-app/"

addr["n"]="$h/Templates/lrn/h5/react/react-native/"
addr["w"]="$h/work/lcode/"
addr["c"]="$h/Downloads/cmake-3.26.0-rc4/Help/guide/tutorial/"

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
