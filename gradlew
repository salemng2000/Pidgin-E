#!/bin/sh
set -eu
GRADLE_VERSION="8.9"
GRADLE_HOME="${GRADLE_HOME:-}"
if [ -n "$GRADLE_HOME" ] && [ -x "$GRADLE_HOME/bin/gradle" ]; then
  exec "$GRADLE_HOME/bin/gradle" "$@"
fi
if command -v gradle >/dev/null 2>&1; then
  exec gradle "$@"
fi
CACHE="${HOME:-.}/.gradle/pidgin-wrapper/gradle-${GRADLE_VERSION}"
if [ ! -x "$CACHE/bin/gradle" ]; then
  TMP="${TMPDIR:-/tmp}/pidgin-gradle-${GRADLE_VERSION}.zip"
  if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 3 -o "$TMP" "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$TMP" "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
  else
    echo "Gradle 8.9 is required. Install Gradle or enable network access." >&2
    exit 1
  fi
  mkdir -p "$(dirname "$CACHE")"
  rm -rf "${CACHE}.tmp"
  mkdir -p "${CACHE}.tmp"
  unzip -q "$TMP" -d "${CACHE}.tmp"
  mv "${CACHE}.tmp/gradle-${GRADLE_VERSION}" "$CACHE"
  rm -rf "${CACHE}.tmp" "$TMP"
fi
exec "$CACHE/bin/gradle" "$@"
