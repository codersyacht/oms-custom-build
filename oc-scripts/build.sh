#!/bin/bash

cd /opt/ssfs/runtime/container-scripts/imagebuild
./generateImages.sh --MODE=app --WAR_FILES=smcfs --EXPORT=false
echo "Custom build completed"
buildah tag om-app:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
echo "Custom tagging completed"
buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
