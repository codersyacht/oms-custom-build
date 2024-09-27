#!/bin/bash
mkdir -p /opt/ssfs/customization
cp ../* /opt/ssfs/customization 
chmod 777 -R /opt/ssfs/customization
chown omsuser:omsuser -R /opt/ssfs/customization
sudo -E -u omsuser /bin/bash << 'EOF'
source ~/.bashrc
cp /opt/ssfs/customization/properties/sandbox.cfg /opt/ssfs/runtime/properties/sandbox.cfg
echo "sandbox.cfg copy completed"
cd /opt/ssfs/runtime/bin
./install3rdParty.sh yfsextn 1_0 -j /opt/ssfs/customization/jars/* -targetJVM EVERY
echo "3rdPsarty jars installation completed"
cd /opt/ssfs/runtime/container-scripts/imagebuild
#./generateImages.sh --REPO=localhost --MODE=app --WAR_FILES=smcfs --EXPORT=false
./generateImages.sh --REPO=localhost --MODE=agent --EXPORT=false
echo "Custom build completed"
sudo cat $PUSH_DOCKERCFG_PATH/.dockerconfigjson > /tmp/.dockercfg
buildah tag om-agent:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom tagging completed"
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
sleep 900
echo "Custom Image Push conmpleted"

