#!/bin/bash

# add your customization script here.

sudo -u omsuser /bin/bash << 'EOF'

source ~/.bashrc

export REPO=${REPO:-"localhost"}
export MODE=${MODE:-"app"}
export WAR_FILES=${WAR_FILES:-"smcfs"}

# Go to the directory where the script is located
cd /opt/ssfs/runtime/container-scripts/imagebuild

sudo cat $PUSH_DOCKERCFG_PATH/.dockerconfigjson > /tmp/.dockercfg
cp /opt/ssfs/customization/properties/sandbox.cfg /opt/ssfs/runtime/properties/sandbox.cfg

# Generate the images
./generateImages.sh --REPO=$REPO --MODE=$MODE --WAR_FILES=$WAR_FILES --EXPORT=false

  echo "Pushing image $REPO/om-$i:10.0"
  buildah push --tls-verify=false --authfile=/tmp/.dockercfg $REPO/om-$i:10.0
done

EOF
