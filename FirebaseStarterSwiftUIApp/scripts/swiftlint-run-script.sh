#!/bin/sh

if [[ -f "${PODS_ROOT}/SwiftLint/swiftlint" ]]; then
  "${PODS_ROOT}/SwiftLint/swiftlint"
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
