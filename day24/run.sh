#!/bin/sh
OUTPUT=day24a.jar
MAINCLASS=Day24a

kotlinc -verbose -include-runtime -d $OUTPUT src_kotlin/*.kt
if [ $? -ne 0 ] ; then
  echo "ERROR: $?"
  exit 1
fi

#kotlin -classpath $OUTPUT $MAINCLASS
#java -jar $OUTPUT
java -cp $OUTPUT $MAINCLASS
