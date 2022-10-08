# Go to a place directly
echo "Where to go ?"
declare -A addr

h=$HOME

addr["l"]="$h/Templates/lrn/"
addr["c"]="/home/me/Templates/lrn/c/"
addr["cpp"]="/home/me/Templates/lrn/cpp/"
addr["w"]="/home/me/work/lcode/"
addr["t"]="/home/me/work/ses/cw2r/"
addr["i"]="/home/me/work/ide/gsa/r/"
addr["o"]="/home/me/Templates/lrn/org/"
addr["v"]="/home/me/Downloads/Intro-to-Vue-3"
addr["f"]="/home/me/Downloads/learning-area/css/styling-boxes"

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
