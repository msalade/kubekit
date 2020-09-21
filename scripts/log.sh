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

POD_NAMES=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{";"}}{{end}}')
IFS=';' read -ra POD_NAMES_ARRAY <<<"$POD_NAMES"

echo "Searching for pods by the pattern: $PATTERN with container: $CONTAINER"

for name in "${POD_NAMES_ARRAY[@]}"; do
    if [[ -z "$PATTERN" || $name =~ "$PATTERN" ]]; then
        echo "Logging from the pod: $name"

        if [ -z "$CONTAINER" ]; then
            SCRIPT="kubectl logs -f $name"
        else
            SCRIPT="kubectl logs -f $name -c $CONTAINER"
        fi

        osascript -e "tell app \"Terminal\"
            do script \"$SCRIPT\"
        end tell"
    fi
done
