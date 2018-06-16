#!/bin/bash
Dir=/media/sf_MINT
Month=30
find $Dir -type f -mtime +$Month -exec rm -f {} \;
