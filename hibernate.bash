#!/bin/bash
# This is intended for Gnome-like DEs

sudo dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate
