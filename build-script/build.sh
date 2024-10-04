#!/bin/bash
mkdir -p /opt/ssfs/customization
cp -r ../* /opt/ssfs/customization 
chmod 777 -R /opt/ssfs/customization
chown omsuser:omsuser -R /opt/ssfs/customization
sudo -E -u omsuser /bin/bash
source ~/.bashrc
sudo cat $PUSH_DOCKERCFG_PATH/.dockerconfigjson > /tmp/.dockercfg
cp -f /opt/ssfs/customization/properties/sandbox.cfg /opt/ssfs/runtime/properties/sandbox.cfg
echo "sandbox.cfg copy completed"
cd /opt/ssfs/runtime/bin
./setupfiles.sh
echo "setupfiles execution completed"
./install3rdParty.sh yfsextn 1_0 -j /opt/ssfs/customization/jars/* -targetJVM EVERY
echo "3rd party jars installation completed"
cd /opt/ssfs/runtime/container-scripts/imagebuild
./generateImages.sh --MODE=app,agent --REPO=localhost --WAR_FILES=smcfs,sbc,sma --DEV_MODE=true --EXPORT=false
echo "Custom build completed"
echo "Generated images"
buildah images
echo " Tagging and pusing image : " ${OUTPUT_IMAGE}
buildah tag om-app:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
export OUTPUT_IMAGE=${agentimage}
echo "Tagging and pusing image : " ${OUTPUT_IMAGE}
buildah tag om-agent:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom Imagea Push conmpleted"
sleep 100
