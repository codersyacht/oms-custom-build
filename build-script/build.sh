#!/bin/bash
sudo -u omsuser /bin/bash << 'EOF'
source ~/.bashrc
cp sandbox.prop /opt/ssfs/runtime/properties/sandbox.prop
echo "sandbox.cfg copy completed"
cd /opt/ssfs/runtime/bin
./install3rdParty.sh yfsextn 1_0 -j /root/sources/oms-custom-build/jars/* -targetJVM EVERY
echo "3rdPsarty jars installation completed"
cd /opt/ssfs/runtime/container-scripts/imagebuild
#./generateImages.sh --REPO=localhost --MODE=app --WAR_FILES=smcfs --EXPORT=false
./generateImages.sh --REPO=localhost --MODE=agent --EXPORT=false
echo "Custom build completed"
cat /var/run/secrets/openshift.io/push/.dockerconfigjson
sudo cat $PUSH_DOCKERCFG_PATH/.dockerconfigjson > /tmp/.dockercfg
cat /tmp/.dockercfg
buildah tag om-agent:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom tagging completed"
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom Image Push conmpleted"
