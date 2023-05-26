# Go to a place directly
echo "Where to go ?"
declare -A addr

h=$HOME

addr["l"]="$h/Templates/lrn/"
# addr["t"]="$h/Templates/lrn/h5/threejs/try-sky/"
# addr["w"]="$h/wspace/submarine/"
addr["r"]="$h/repo/rock-chain-origin/"
addr["n"]="$h/repo/notes/test-dia/"
addr["h"]="$h/repo/hi/"
addr["E"]="$h/repo/expr/"
addr["R"]="$h/repo/"
addr["p"]="$h/repo/notes/supply-chain-report/"
addr["e"]="$h/repo/notes/test-evmone-mockedHost/"
addr["t"]="$h/repo/try-rock-chain"
# addr["c"]="$h/Downloads/cmake-3.26.0-rc4/Help/guide/tutorial/"

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
