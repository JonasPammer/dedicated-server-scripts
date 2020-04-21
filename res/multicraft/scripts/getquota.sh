#!/bin/sh
quota -w | tail -1 | awk '{print $2}' | sed 's/[^0-9]//g'
