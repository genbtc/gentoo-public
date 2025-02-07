#! /bin/sh
# the next line restarts using wish \
exec /usr/bin/wish "$0" ${1+"$@"}

set myName [info script]
set myGorilla /opt/gorilla-1.5.3.7/gorilla.tcl

if {![catch {
    set linkName [file readlink $myName]
}]} {
    set myName $linkName
}
source [file join [file dirname $myName] $myGorilla]
