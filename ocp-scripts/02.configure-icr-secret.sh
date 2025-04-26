export ENTITLEDKEY="$<IBM-Entitlement-Key>"

export NAMESPACE="oms-build"

oc create secret docker-registry ibm-entitlement-key --docker-server=cp.icr.io --docker-username=cp --docker-password=${ENTITLEDKEY} --namespace=${NAMESPACE}
