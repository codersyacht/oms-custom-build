#!/bin/bash
mkdir -p /opt/ssfs/customization
cp -r ../* /opt/ssfs/customization 
chmod 777 -R /opt/ssfs/customization
chown omsuser:omsuser -R /opt/ssfs/customization
sudo -E -u omsuser /bin/bash << 'EOF'
source ~/.bashrc
sudo cat $PUSH_DOCKERCFG_PATH/.dockerconfigjson > /tmp/.dockercfg
cp /opt/ssfs/customization/properties/sandbox.cfg /opt/ssfs/runtime/properties/sandbox.cfg
echo "sandbox.cfg copy completed"
cd /opt/ssfs/runtime/bin
./install3rdParty.sh yfsextn 1_0 -j /opt/ssfs/customization/jars/* -targetJVM EVERY
echo "3rdParty jars installation completed"
cd /opt/ssfs/runtime/container-scripts/imagebuild
buildah login --authfile=/tmp/.dockercfg docker.io
./generateImages.sh --MODE=app,agent --REPO=localhost --WAR_FILES=smcfs --DEV_MODE=true --EXPORT=false
echo "Custom build completed"
buildah tag om-app:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
export OUTPUT_IMAGE=codersyacht/oms-agent:v1
buildah tag om-agent:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom Image Push conmpleted"
sleep 900
