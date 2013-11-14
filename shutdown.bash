#!/bin/bash
# This is intended for Gnome-like DEs

dbus-send --system --print-reply  --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager  org.freedesktop.ConsoleKit.Manager.Stop
