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
    -c | --container)
        CONTAINER="$2"
        shift
        shift
        ;;
    esac
done

echo "$PATTERN"
echo "$CONTAINER"

POD_NAMES=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{";"}}{{end}}')
IFS=';' read -ra POD_NAMES_ARRAY <<<"$POD_NAMES"

for name in "${POD_NAMES_ARRAY[@]}"; do
    if [[ $name =~ "$PATTERN" ]]; then
        osascript -e "tell app \"Terminal\"
            do script \"kubectl logs -f $name -c $CONTAINER\"
        end tell"
    fi
done
