export DOCKERKEY="<DOCKER-KEY>"

export NAMESPACE="oms-build"

oc create secret docker-registry docker-key --docker-server=docker.io --docker-username=codersyacht --docker-password=${DOCKERKEY} --namespace=${NAMESPACE}
