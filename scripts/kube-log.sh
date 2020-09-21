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
    if [[ $name =~ "$PATTERN" ]]; then
        echo "Logging from the pod: $name"

        osascript -e "tell app \"Terminal\"
            do script \"kubectl logs -f $name -c $CONTAINER\"
        end tell"
    fi
done