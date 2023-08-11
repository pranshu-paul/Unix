# BASH divide functions.

divide () {
local x=$1
local y=$2
local value=$3

if [[ -z "$value" ]]; then
	local value=2
fi

local precision="$((20-$value))"

local output="$(bc -l <<< $x/$y)"

echo $x/$y = "${output::-$precision}"
}


divide () {
local x=$1
local y=$2
local precision=$3

if [[ -z "${precision}" ]]; then
	local precision=2
fi

local output="$(bc -l <<< "scale=${precision};($x/$y)")"

echo $x/$y = "${output}"
}


divide () {
local x=$1
local y=$2
awk "BEGIN {print $x/$y}"
}