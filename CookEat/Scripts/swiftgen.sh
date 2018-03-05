#!/bin/sh

SRC_TARGET_DIR="$PROJECT_DIR/$TARGET_NAME"

#strings
$PODS_ROOT/SwiftGen/bin/swiftgen strings $SRC_TARGET_DIR/Resources/Base.lproj/Localizable.strings --output $SRC_TARGET_DIR/Code/Constants/Strings.swift -t flat-swift4

#storyboards
$PODS_ROOT/SwiftGen/bin/swiftgen storyboards $SRC_TARGET_DIR/ --output $SRC_TARGET_DIR/Code/Constants/Storyboards.swift -t swift4

#assets
find $SRC_TARGET_DIR -name '*.xcassets' -print0 | xargs -0 $PODS_ROOT/SwiftGen/bin/swiftgen xcassets -t swift4 --output $SRC_TARGET_DIR/Code/Constants/Assets.swift
