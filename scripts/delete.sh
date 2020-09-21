#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    -p | --pattern)
        PATTERN="$2"
        shift
        shift
        ;;
    esac
done

POD_NAMES=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{";"}}{{end}}')
IFS=';' read -ra POD_NAMES_ARRAY <<<"$POD_NAMES"

echo "Searching for pods by the pattern: $PATTERN with container: $CONTAINER"

TARGET_PODS=()

for name in "${POD_NAMES_ARRAY[@]}"; do
    if [[ -z "$PATTERN" || $name =~ "$PATTERN" ]]; then
        TARGET_PODS+=("$name")
    fi
done

if [ -z "$TARGET_PODS" ]; then
    echo "Could not found pods which mach pattern: $PATTERN"
else
    echo "Target pods: "
    echo "${TARGET_PODS[@]}" | tr ' ' '\n'
    read -r -p "Do you want to delete those pods [Y/n]: " REPLY
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for name in "${TARGET_PODS[@]}"; do
            kubectl delete pods "$name"
        done
    else
        exit 1
    fi

fi
