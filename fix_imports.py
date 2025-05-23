#!/usr/bin/env python3
import os
import re

def fix_imports(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Replace imports
    content = content.replace('package:stock_master/', 'package:stock_landy/')
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def main():
    base_dir = 'frontend/lib'
    for root, _, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    if 'package:stock_master/' in f.read():
                        print(f'Fixing imports in {file_path}')
                        fix_imports(file_path)

if __name__ == '__main__':
    main() 