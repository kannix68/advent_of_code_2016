#!/bin/sh
OUTPUT=day24a.jar
MAINCLASS=Day24a

##
# Get default java heapsize:
#    java -XX:+PrintFlagsFinal -version | grep HeapSize

kotlinc -verbose -include-runtime -d $OUTPUT src_kotlin/*.kt
if [ $? -ne 0 ] ; then
  echo "ERROR: $?"
  exit 1
fi

#kotlin -classpath $OUTPUT $MAINCLASS
#java -jar $OUTPUT
#java -Xmx8192m -cp $OUTPUT $MAINCLASS
java -Xmx12288m -cp $OUTPUT $MAINCLASS
