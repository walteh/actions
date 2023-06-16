#!/usr/bin/env bash

override_artifact="$HOME/.buildrc-cache/buildrc-override/linux-amd64"

# Step 1: Check for buildrc-override
echo "Checking for buildrc-override... at $override_artifact"
if [[ -f "$override_artifact" ]]; then
	echo "Override artifact found. Moving..."
	mkdir -p temp
	mv "$override_artifact" ./temp/buildrc
else
	case "$RUNNER_ARCH" in
	X64) arch="amd64" ;;
	arm) arch="armv7" ;; # Modify based on your requirements
	arm64) arch="arm64" ;;
	*) echo "Unsupported architecture" && exit 1 ;;
	esac
	smp_os_arch="${RUNNER_OS,,}-$arch"
	os_arch_pattern="$smp_os_arch.tar.gz"
	echo "Override artifact not found. Downloading from GitHub releases... $os_arch_pattern $constant_version"
	# The name of the release file will be 'os-arch.tar.gz'
	gh release download $constant_version -p "$os_arch_pattern" --repo nuggxyz/buildrc --dir ./temp
	tar -xzf "./temp/$os_arch_pattern" -C ./temp/
	mv ./temp/build/$smp_os_arch ./temp/buildrc
fi

# Step 2: Setup alias
echo "Setting up alias..."
echo "loading .buildrc"
echo "$GITHUB_WORKSPACE/temp" >>$GITHUB_PATH
chmod +x ./temp/buildrc
./temp/buildrc load
echo "buildrc loaded ✅"

#   echo "adding runtime url... $ACTIONS_RUNTIME_URL"
#   echo "ACTIONS_RUNTIME_TOKEN=$ACTIONS_RUNTIME_TOKEN" >> $GITHUB_ENV
#   echo "ACTIONS_RUNTIME_URL=$ACTIONS_RUNTIME_URL" >> $GITHUB_ENV