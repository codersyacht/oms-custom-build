#!/bin/bash

cp sandbox.prop /opt/ssfs/runtime/sandbox.prop
echo "sandbox.prop copy completed"
#sudo -u omsuser /bin/bash << 'EOF'
#source ~/.bashrc
cd /opt/ssfs/runtime/container-scripts/imagebuild
#./generateImages.sh --REPO=localhost --MODE=app --WAR_FILES=smcfs --EXPORT=false
./generateImages.sh --REPO=localhost --MODE=agent --EXPORT=false
echo "Custom build completed"
cat /var/run/secrets/openshift.io/push/.dockerconfigjson
#(echo "{ \"auths\": " ; sudo cat $PUSH_DOCKERCFG_PATH/.dockerconfigjson ; echo "}") > /tmp/.dockercfg
sudo cat $PUSH_DOCKERCFG_PATH/.dockerconfigjson > /tmp/.dockercfg
cat /tmp/.dockercfg
buildah tag om-agent:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom tagging completed"
#buildah push --tls-verify=false ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom Image Push conmpleted"
