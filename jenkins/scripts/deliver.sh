#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository.'

set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'Extracting the project name and version from pom.xml.'
set -x
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name)
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
set +x

echo 'Running the Java application.'

if [ "$(uname)" == "Linux" ] || [ "$(uname)" == "Darwin" ]; then
    # For Unix-based systems (Linux, macOS)
    nohup java -jar target/${NAME}-${VERSION}.jar &
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    # For Windows systems
    start java -jar target/${NAME}-${VERSION}.jar
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi
