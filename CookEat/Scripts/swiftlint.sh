#!/bin/bash

if [ "$CONFIGURATION" = "Debug" ]; then
    cd "$PROJECT_DIR/.." && $PODS_ROOT/SwiftLint/swiftlint autocorrect
    cd "$PROJECT_DIR/.." && $PODS_ROOT/SwiftLint/swiftlint
fi
