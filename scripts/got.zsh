# Go to a place directly
echo "Where to go ?"
typeset -A addr

h=$HOME

addr["l"]="$h/Templates/lrn/"
# addr["t"]="$h/Templates/lrn/h5/threejs/try-sky/"
# addr["w"]="$h/wspace/submarine/"
addr["w"]="$h/repo/wrack-chain/weak"
addr["n"]="$h/repo/notes/test-dia/"
addr["h"]="$h/repo/hi/"
addr["E"]="$h/repo/expr/"
addr["R"]="$h/repo/"
addr["p"]="$h/repo/notes/supply-chain-report/"
addr["e"]="$h/repo/notes/test-evmone-mockedHost/"
addr["t"]="$h/repo/try-rock-chain"
# addr["c"]="$h/Downloads/cmake-3.26.0-rc4/Help/guide/tutorial/"

{
    for s in ${(k)addr}; do
        printf "\t%-10s: %10s\n" "$s" "${addr[$s]}"
    done | sort
    echo
}

print -n "Enter your choice >>>"
read r
# print "Got r=$r"

{
    for s in ${(k)addr}; do
        # printf "checking >>%s<< >>%s<<\n" $s \"$r\"
        # 🦜: string in the list kinda need quote.
        if [ \"$r\" = $s ] ; then
            echo "Address found"
            a=${addr[$s]}
            cd $a
            return
        fi
    done
    echo "Address not found for $r 🐸"
}
