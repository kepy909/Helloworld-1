#!/bin/bash

echo -e "\nexport JD_COOKIE=\"${JD_COOKIE}\"\n"
echo "${JD_COOKIE}" | perl -pe '{s|&|\n|g}' | perl -pe '{s|^|\"|g, s|;$|;\",|g}'
echo -e ''
