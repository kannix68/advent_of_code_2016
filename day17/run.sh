#!/bin/sh
OUTPUT=day17a.jar
MAINCLASS=Day17a

#kotlinc -verbose -include-runtime -d $OUTPUT *.kt
kotlinc -verbose -include-runtime -d $OUTPUT src_kotlin/*.kt
if [ $? -ne 0 ] ; then
  echo "ERROR: $?"
  exit 1
fi

#java -jar $OUTPUT
java -cp $OUTPUT $MAINCLASS $1
