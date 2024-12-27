#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/unisonweb/unison"
TOOL_NAME="unison"
TOOL_TEST="ucm --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if unison is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -n -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/release/.*' | cut -d/ -f4
}

list_all_versions() {
	list_github_tags
}

platform() {
	case "$OSTYPE" in
	darwin*) echo "macos" ;;
	linux*) echo "linux" ;;
	*) fail "Unsupported platform" ;;
	esac
}

arch() {
	local arch_check=${ASDF_UNISON_OVERWRITE_ARCH:-"$(uname -m)"}
	case "${arch_check}" in
	x86_64 | amd64) echo "x64" ;;
	aarch64 | arm64) echo "arm64" ;;
	*) fail "Arch '${arch_check}' not supported!" ;;
	esac
}

download_release() {
	local version filename url major minor patch
	version="$1"
	filename="$2"

	major=$(echo "$version" | cut -d. -f1)
	minor=$(echo "$version" | cut -d. -f2)
	patch=$(echo "$version" | cut -d. -f3)

	if [ $(echo "$version" | head -c 1) = "M" ] || [ $major -eq 0 -a $minor -le 5 -a $patch -le 27 ]; then
		url="$GH_REPO/releases/download/release/${version}/ucm-$(platform).tar.gz"
	else
		url="$GH_REPO/releases/download/release/${version}/ucm-$(platform)-$(arch).tar.gz"
	fi

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
