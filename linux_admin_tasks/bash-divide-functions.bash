# bash divide functions.

divide () {
local x=$1
local y=$2
local VAL=$3

if [[ -z "$VAL" ]]; then
	local VAL=2
fi

local PRECISION="$((20-$VAL))"

local OUTPUT="$(bc -l <<< $x/$y)"

echo $x/$y = "${OUTPUT::-$PRECISION}"
}


divide () {
local x=$1
local y=$2
local PRECISION=$3

if [[ -z "${PRECISION}" ]]; then
	localPRECISION=2
fi

local OUTPUT="$(bc -l <<< "scale=${PRECISION};($x/$y)")"

echo $x/$y = "${OUTPUT}"
}


divide () {
local x=$1
local y=$2
awk "BEGIN {print $x/$y}"
}