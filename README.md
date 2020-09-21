# Bash helpers

 ### [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) log helper
Provide an easy way to run logs from multiple pods that have the same name pattern. Especially useful when load balancing introduces to cluster.

Usage: 

    bash kube-log.sh -p web-pod -c web-conainer
    
Params:
  - `-p / --pattern` (optional) - pattern by which script will choose pod name to log
  - `-c / --container` (optional) - name of the pods container 