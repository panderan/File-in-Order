#!/bin/bash

. ./funcs.sh

get_newfilename "microMsg-2014-08.0c3c2fff.jpg" "2014-08-10" "microMsg";
echo -e $ret_get_newfilename - $ret_get_newfilename_type;
