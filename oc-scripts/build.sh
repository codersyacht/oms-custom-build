#!/bin/bash

cd /opt/ssfs/runtime/container-scripts/imagebuild
./generateImages.sh --MODE=app --WAR_FILES=smcfs --EXPORT=false
