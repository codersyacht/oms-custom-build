export GITKEY="<GIT-KEY>"

export NAMESPACE="oms-build"

oc create secret generic git-key --type=string --from-literal=username=codersyacht --from-literal=password=${GITKEY} --namespace=${NAMESPACE}
