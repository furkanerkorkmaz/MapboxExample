#!/bin/sh

RSROOT=$SRCROOT/MapboxExample/Resources

"$PODS_ROOT/SwiftGen/bin/swiftgen" \
xcassets -t swift3 "$RSROOT/Assets.xcassets" \
--output "$RSROOT/SwiftGen/Assets.swift"

"$PODS_ROOT/SwiftGen/bin/swiftgen" \
strings -t structured-swift4 "$RSROOT/en.lproj/Localization.strings" \
--output "$RSROOT/SwiftGen/L10n.swift"
