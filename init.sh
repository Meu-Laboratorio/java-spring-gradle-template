#!/usr/bin/env bash

set -e

echo "Spring Boot project initializer"
echo

read -p "Application name (ex: payment-service): " APP_NAME
read -p "Base package (ex: com.gusrubin.payment): " BASE_PACKAGE

if [ -z "$APP_NAME" ] || [ -z "$BASE_PACKAGE" ]; then
  echo "Application name and base package are required."
  exit 1
fi

echo
echo "Detecting template package..."

# detect template package from first java file
TEMPLATE_PACKAGE=$(grep -R "^package " src/main/java | head -n1 | sed 's/package //' | sed 's/;//')

if [ -z "$TEMPLATE_PACKAGE" ]; then
  echo "Could not detect template package."
  exit 1
fi

echo "Template package detected: $TEMPLATE_PACKAGE"

TEMPLATE_PATH=$(echo "$TEMPLATE_PACKAGE" | tr '.' '/')
PACKAGE_PATH=$(echo "$BASE_PACKAGE" | tr '.' '/')

echo
echo "Configuring project..."

# update project name
if [ -f settings.gradle ]; then
  sed -i "s/java-spring-gradle-template-app/$APP_NAME/g" settings.gradle
fi

# update README
if [ -f README.md ]; then
  sed -i "s/java-spring-gradle-template-app/$APP_NAME/g" README.md
fi

# replace package in java files
find src -type f -name "*.java" -exec sed -i "s/$TEMPLATE_PACKAGE/$BASE_PACKAGE/g" {} +

# create new directories
mkdir -p src/main/java/$PACKAGE_PATH
mkdir -p src/test/java/$PACKAGE_PATH

# move source files
if [ -d src/main/java/$TEMPLATE_PATH ]; then
  mv src/main/java/$TEMPLATE_PATH/* src/main/java/$PACKAGE_PATH
fi

if [ -d src/test/java/$TEMPLATE_PATH ]; then
  mv src/test/java/$TEMPLATE_PATH/* src/test/java/$PACKAGE_PATH
fi

# remove old directories
rm -rf src/main/java/$TEMPLATE_PATH
rm -rf src/test/java/$TEMPLATE_PATH

echo
echo "Project configured successfully!"
echo
echo "Application name: $APP_NAME"
echo "Base package: $BASE_PACKAGE"