#!/bin/bash

cp sandbox.prop /opt/ssfs/runtime/sandbox.prop
echo "sandbox.prop copy completed"
cd /opt/ssfs/runtime/container-scripts/imagebuild
./generateImages.sh --MODE=agent --EXPORT=false
echo "Custom build completed"
(echo "{ \"auths\": " ; sudo cat $PUSH_DOCKERCFG_PATH/.dockercfg ; echo "}") > /tmp/.dockercfg
buildah tag om-agent:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom tagging completed"
#buildah login --username codersyacht --password Call2@Allah docker.io
buildah push --tls-verify=false ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
# buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom Image Push conmpleted"
sleep 900
