#!/bin/bash

# Find all Dart files that contain showToast calls
files=$(grep -l "showToast(" frontend/lib/**/*.dart)

# For each file
for file in $files; do
  # Skip the toast.dart file itself
  if [[ "$file" == *"toast.dart" ]]; then
    continue
  fi
  
  # First fix the cases where we have too many arguments
  sed -i 's/showToast(context, context, \(".*"\))/showToast(context, \1)/g' "$file"
  
  # Then fix the cases where we have too few arguments
  sed -i 's/showToast(\(".*"\))/showToast(context, \1)/g' "$file"
  
  # Fix string interpolation cases
  sed -i 's/showToast(\([^)]*\))/showToast(context, \1)/g' "$file"
done

echo "Updated toast calls in all files" 