#!/usr/bin/env ruby

merge_base = `git merge-base HEAD master`

diff = `git diff #{merge_base}..HEAD`

