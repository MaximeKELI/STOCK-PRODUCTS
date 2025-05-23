#!/bin/bash

# Mettre à jour tous les imports dans les fichiers Dart
find . -name "*.dart" -type f -exec sed -i 's/stock_master/stock_landy/g' {} +

# Mettre à jour le package name dans pubspec.yaml
sed -i 's/stock_master/stock_landy/g' pubspec.yaml

echo "Imports mis à jour avec succès !" 