#!/bin/bash
MYFONTS=$(pdffonts -l 5 "$1" | tail -n +3 | cut -d' ' -f1 | sort | uniq)
if [ "$MYFONTS" = '' ] || [ "$MYFONTS" = '[none]' ]; then
    echo "NAO_OCR: $1"
else 
    echo "SIM_OCR: $1"
fi 
