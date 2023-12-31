#!/usr/bin/env bash

# Check if the version is supplied
if [ -z "$1" ]; then
	echo "Error: No version supplied"
	exit 1
fi

latest=$1

# find any cases of "walteh/actions/*@v*" and replace with "walteh/actions/*@latest"
formulas=$(find . \( -path "./**/action.yml" \) -name "*.y*ml")

# Check if any action.yml files were found
if [ -z "$formulas" ]; then
	echo "Error: No action.yml files were found"
	exit 1
fi

echo "Found formulas: $formulas"

for formula in $formulas; do

	echo "Checking $formula"

	found=$(grep -oE "walteh/actions/.*@v[0-9\.]+" "$formula")

	echo "found= $found"

	for f in $found; do
		action_name=$(echo "$f" | grep -oE "walteh/actions/[a-zA-Z_-]+")
		echo "modifying $f to $action_name@$latest"

		if [[ "$OSTYPE" == "linux"* ]]; then
			echo "using linux sed to modify $formula"
			# Linux
			sed -i "s#${f}#${action_name}@${latest}#" "$formula"
		elif [[ "$OSTYPE" == "darwin"* ]]; then
			# Mac OSX
			echo "using mac sed to modify $formula"
			sed -i "" "s#${f}#${action_name}@${latest}#" "$formula"
		else
			echo "unknown OSTYPE='$OSTYPE'"
			exit 1
		fi
	done
done
