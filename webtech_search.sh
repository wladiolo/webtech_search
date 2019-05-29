#!/bin/bash
# wladiolo (https://github.com/wladiolo)
# This script parses the json output of webtech tool (https://github.com/ShielderSec/webtech) to find a specific technology
# It requires jq (https://stedolan.github.io/jq/) to function properly
# usage:
# webtech_search.sh <file to parse> <tecnology to search>

# colors, for a better world
BLUE='\e[0;34m'
YELLOW='\e[0;33m'
PURPLE='\e[0;35m'

if [[ $# -eq 0 || $# -eq 1 ]]; then
	echo -e "usage: webtech_search.sh <file to parse> <tecnology to search>"
	exit
fi

# arguments parsing
input_file=$1
tech_to_search=$2

# sites are the keys in the json file
for url in $( cat $input_file | jq -r '.|keys|.[]' ); do
	# tech is an array
	for t in $( cat $input_file | jq -r --arg sito "$url" '.[$sito].tech|keys|.[]' ); do
		# tech and version extraction
		tech=$( cat $input_file | jq -r --arg sito "$url" --argjson id "$t" '.[$sito]|.tech[$id].name' )
		vers=$( cat $input_file | jq -r --arg sito "$url" --argjson id "$t" '.[$sito]|.tech[$id].version' )
		# match the string "tech_to_search" (uppercase forced to do a case independent match)
		if [[ "${tech^^}" =~ "${tech_to_search^^}" ]]; then
			echo -e "${BLUE}Site: $url ${YELLOW}Technology: $tech ${PURPLE}Version: $vers"
		fi
	done
done
															
