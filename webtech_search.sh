#!/bin/bash
# wladiolo (https://github.com/wladiolo)
# This script parses the json output of webtech tool (https://github.com/ShielderSec/webtech) to find a specific technology or a specific header
# It requires jq (https://stedolan.github.io/jq/) to function properly
# usage:
# webtech_search.sh <file to parse> <options> <string>
# Options:
# --tech: search for string in the tech array
# --head: search for string in the headers array

# colors, for a better world
BLUE='\e[0;34m'
YELLOW='\e[0;33m'
PURPLE='\e[0;35m'

if [[ $# -le 2 ]]; then
	echo -e "usage: webtech_search.sh <file to parse> <options> <string>"
	echo -e "Options:"
	echo -e "--tech: search for string in the tech array"
	echo -e "--head: search for string in the headers array"
	exit
fi

# arguments parsing
input_file=$1
option=$2
string_to_search=$3

# sites are the keys in the json file
for url in $( cat $input_file | jq -r '.|keys|.[]' ); do
	# do a tech searh
	if [[ "$option" == "--tech" ]]; then
		# tech is an array
		for t in $( cat $input_file | jq -r --arg sito "$url" '.[$sito].tech|keys|.[]' ); do
			# tech and version extraction
			tech=$( cat $input_file | jq -r --arg sito "$url" --argjson id "$t" '.[$sito]|.tech[$id].name' )
			vers=$( cat $input_file | jq -r --arg sito "$url" --argjson id "$t" '.[$sito]|.tech[$id].version' )
			# match the string "string_to_search" (uppercase forced to do a case independent match)
			if [[ "${tech^^}" =~ "${string_to_search^^}" ]]; then
				echo -e "${BLUE}Site: $url ${YELLOW}Technology: $tech ${PURPLE}Version: $vers"
			fi
		done
	fi
	# do a header search
	if [[ "$option" == "--head" ]]; then
		#headers is an array
		for t in $( cat $input_file | jq -r --arg sito "$url" '.[$sito].headers|keys|.[]' ); do
                        # header and value extraction
                        head=$( cat $input_file | jq -r --arg sito "$url" --argjson id "$t" '.[$sito]|.headers[$id].name' )
                        value=$( cat $input_file | jq -r --arg sito "$url" --argjson id "$t" '.[$sito]|.headers[$id].value' )
                        # match the string "string_to_search" (uppercase forced to do a case independent match)
                        if [[ "${head^^}" =~ "${string_to_search^^}" ]]; then
                                echo -e "${BLUE}Site: $url ${YELLOW}Header: $head ${PURPLE}Value: $value"
                        fi
                done
	fi
done
															
