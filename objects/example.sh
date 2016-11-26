#!/bin/bash

# include class header
. obj.h
. system.h

# create class object
obj myobject

# use object methods
myobject.sayHello

myobject.fileName = "file1"

system.stdout.printString "value is"
system.stdout.printValue myobject.fileName
