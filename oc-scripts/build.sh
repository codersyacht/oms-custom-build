#!/bin/bash

cp sandbox.prop /opt/ssfs/runtime/sandbox.prop
echo "sandbox.prop copy completed"
cd /opt/ssfs/runtime/container-scripts/imagebuild
./generateImages.sh --MODE=app --WAR_FILES=smcfs --EXPORT=false
echo "Custom build completed"
(echo "{ \"auths\": " ; sudo cat $PUSH_DOCKERCFG_PATH/.dockercfg ; echo "}") > /tmp/.dockercfg
buildah tag om-app:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom tagging completed"
echo "Going to sleep"
sleep 1800
echo "Woke after 15 minutes"



buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom Image Push conmpleted"
