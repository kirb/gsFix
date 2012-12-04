#!/bin/bash

#  fixer.sh
#  gsFix
#
#  Created by Adam D on 20/11/12.
#  Copyright (c) 2012 HASHBANG Productions. All rights reserved.

/bin/cp /etc/hosts /tmp/hosts

[[ $? != 0 ]] && exit 1

/usr/bin/grep -vE "gs.apple.com$" /etc/hosts > /tmp/newhosts && cat /tmp/newhosts > /etc/hosts && rm /tmp/newhosts