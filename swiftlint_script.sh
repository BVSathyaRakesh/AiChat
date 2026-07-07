#!/bin/bash

# Skip SwiftLint if running in CI
if [[ -n "$CI" ]]; then
    echo "Running in Xcode Cloud. Skipping SwiftLint."
    exit 0
fi

# Skip SwiftLint for Xcode Previews
if [[ "$XCODE_RUNNING_FOR_PREVIEWS" == "1" ]]; then
    echo "Running for Xcode Previews. Skipping SwiftLint."
    exit 0
fi

# Skip SwiftLint for Index builds (helps with preview stability)
if [[ "$ACTION" == "indexbuild" ]]; then
    echo "Running index build. Skipping SwiftLint."
    exit 0
fi

# Add Homebrew to PATH for Apple Silicon
if [[ "$(uname -m)" == "arm64" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Run SwiftLint
if which swiftlint > /dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
