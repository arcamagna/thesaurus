#!/bin/bash
# args: word [compare] [length]
re='^[0-9]+$'

makelist(){
	arr=()
	input="$1"
	length=$2
	list=$(sed 's/See also:/,/' <<< $(moby "$1") | sed '/No match found/d' | tr -d "[:cntrl:]\040")
	list+=",$1"
	readarray -td, res <<< $list
	for i in ${res[@]}; do
		[[ ${#i} == $length || -z $length ]] && arr+=(${i^^})
	done
	arr=($(for i in "${arr[@]}"; do echo "${i}"; done | sort -u))
	echo ${arr[@]}
}

[[ ! $2 =~ $re ]] && { compare=$2; length=$3; } || length=$2
arr1=($(makelist $1 $length))

if [[ -n $compare ]]; then
	arr2=($(makelist $compare $length))
	echo "${arr1[@]} ${arr2[@]}" | sed 's/ /\n/g' | sort | uniq -d
else
	printf "%s\n" "${arr1[@]}"
fi
