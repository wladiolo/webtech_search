# webtech_search

This script parses the json output of **webtech** tool by ShielderSec (https://github.com/ShielderSec) to find a specific technology.

It requires **jq** (https://stedolan.github.io/jq/).

It can be useful when you need to found a specific technology in a massive scan did with **webtech**.

## How to use webtech_search
```
webtech_search.sh file-to-parse options string-to-search
```
Where *options* are:

--tech: search in the *tech* array

--head: search in the *headers* array

## Example
First do a scan with **webtech**
```
webtech --urls-file=urls_to_scan.list --json > output.json
```
Then search for a specific technology with **webtech_search** 
```
webtech_search.sh output.json -tech woRDpr
Site: https://www.example.com Technology: Wordpress Version: 5.1.2
Site: https://www.other.com Technology: WordPress Version: 3.1.1
```
Or search for a specific header:
```
webtech_search.sh output.json -head tRAc
Site: https://www.example.com Header: X-Cloud-Trace-Context Value: 7be84e882a77baabdd9d9f7e49781fee
```

## Thanks to
* [webtech](https://github.com/ShielderSec/webtech)
* [jq](https://stedolan.github.io/jq/)

