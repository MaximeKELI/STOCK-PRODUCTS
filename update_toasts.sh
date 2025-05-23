#!/bin/bash
files=$(grep -l "showToast(" frontend/lib/**/*.dart)
for file in $files; do if [[ "$file" != *"toast.dart" ]]; then sed -i 's/showToast("\([^"]*\)")/showToast(context, "\1")/g' "$file"; sed -i 's/showToast(\([^)]*\))/showToast(context, \1)/g' "$file"; fi; done
