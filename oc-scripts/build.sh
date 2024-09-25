#!/bin/bash

cp sandbox.prop /opt/ssfs/runtime/sandbox.prop
echo "sandbox.prop copy completed"
cd /opt/ssfs/runtime/container-scripts/imagebuild
sudo -u omsuser /bin/bash << 'EOF'
#./generateImages.sh --REPO=localhost --MODE=app --WAR_FILES=smcfs --EXPORT=false
./generateImages.sh --REPO=localhost --MODE=agent --EXPORT=false
echo "Custom build completed"
(echo "{ \"auths\": " ; sudo cat $PUSH_DOCKERCFG_PATH/.dockercfg ; echo "}") > /tmp/.dockercfg
sleep 450
buildah tag om-agent:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom tagging completed"
#buildah push --tls-verify=false ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom Image Push conmpleted"
sleep 900
