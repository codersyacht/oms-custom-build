#!/bin/bash

# add your customization script here.

sudo -E -u omsuser /bin/bash << 'EOF'

source ~/.bashrc

export REPO=${REPO:-"localhost"}
export MODE=${MODE:-"app"}
export WAR_FILES=${WAR_FILES:-"smcfs"}

# Go to the directory where the script is located
cd /opt/ssfs/runtime/container-scripts/imagebuild

sudo cat $PUSH_DOCKERCFG_PATH/.dockerconfigjson > /tmp/.dockercfg
echo /tmp/.dockercfg
# Generate the images
./generateImages.sh --REPO=$REPO --MODE=$MODE --WAR_FILES=$WAR_FILES --EXPORT=false
echo "Image generated"
echo ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Push completed"

EOF
