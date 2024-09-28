#! /bin/bash

 find . -type f -name '*.tf*' -not -path '*/.*' | sed -r 's|/[^/]+$||' | sort | uniq | sed 's/$/\/*/' | sed 's/^..//' | while read -r line ; do
 echo "Processing directory: $line"
 pre-commit run --files $line
 done

 find . -type f -name '*.yaml' -not -path '*/.*' | sed -r 's|/[^/]+$||' | sort | uniq | sed 's/$/\/*/' | sed 's/^..//' | while read -r line ; do
  echo "Processing directory: $line"
   pre-commit run --files $line
    done
 find . -type f -name '*.hcl' -not -path '*/.*' | sed -r 's|/[^/]+$||' | sort | uniq | sed 's/$/\/*/' | sed 's/^..//' | while read -r line ; do
  echo "Processing directory: $line"
   pre-commit run --files $line
    done
pre-commit run --all-files
