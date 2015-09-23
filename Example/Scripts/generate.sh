#!/bin/bash
DIR=$1
TMP=/tmp/Fluency

echo $DIR

java -jar $DIR/Scripts/plantuml.jar -o $DIR/PlantUML/ -tpng $TMP/*.plantuml

for f in $DIR/PlantUML/*.svg
do
    xmllint --format --output "$f" "$f"
done
