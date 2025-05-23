#!/usr/bin/env python3
import os
import re

def fix_toast_calls(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Fix cases with too many arguments
    content = re.sub(r'showToast\(context,\s*context,\s*(".*?")\)', r'showToast(context, \1)', content)
    
    # Fix cases with too few arguments
    content = re.sub(r'showToast\((".*?")\)', r'showToast(context, \1)', content)
    
    # Fix string interpolation cases
    content = re.sub(r'showToast\(([^)]+)\)', lambda m: fix_interpolation(m.group(1)), content)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def fix_interpolation(match):
    # If it's already properly formatted with context, return as is
    if match.strip().startswith('context,'):
        return f'showToast({match})'
    # If it's a string interpolation or other expression, add context
    return f'showToast(context, {match})'

def main():
    base_dir = 'frontend/lib'
    for root, _, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.dart') and file != 'toast.dart':
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    if 'showToast(' in f.read():
                        print(f'Fixing {file_path}')
                        fix_toast_calls(file_path)

if __name__ == '__main__':
    main() 