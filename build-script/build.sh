#!/bin/bash

# add your customization script here.

sudo -E -u omsuser /bin/bash
source ~/.bashrc


# Go to the directory where the script is located
cd /opt/ssfs/runtime/container-scripts/imagebuild

sudo cat $PUSH_DOCKERCFG_PATH/.dockerconfigjson > /tmp/.dockercfg
sudo cat /tmp/.dockercfg
# Generate the images
./generateImages.sh --REPO=localhost --MODE=app --WAR_FILES=sma --EXPORT=false
echo "Image generated"
echo ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
buildah tag om-agent:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Push completed"
