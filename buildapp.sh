#!/usr/bin/env bash

# Verify that the scripts are being run from Linux and not Mac
if [[ $OSTYPE != "linux-gnu" ]]; then
    echo -e "\e[91mERROR: This script has only been tested on Linux. Currently, only Linux (debian) is supported. Please run in Cloud Shell or in a VM running Linux".
    exit;
fi

# Export a SCRIPT_DIR var and make all links relative to SCRIPT_DIR
export SCRIPT_DIR=$(dirname $(readlink -f $0 2>/dev/null) 2>/dev/null || echo "${PWD}/$(dirname $0)")

# Set project to PROJECT_ID or exit
[[ ! "${PROJECT_ID}" ]] && echo -e "Please export PROJECT_ID variable (\e[95mexport PROJECT_ID=<YOUR POROJECT ID>\e[0m)\nExiting." && exit 0
echo -e "\e[95mPROJECT_ID is set to ${PROJECT_ID}\e[0m"

gcloud config set core/project ${PROJECT_ID}
echo -e "\e[95mStarting to build application image...\e[0m" && gcloud builds submit --config=apps/build-image.yaml --substitutions=_PROJECT_ID=${PROJECT_ID}  --async
echo -e "\e[95mYou can view the Cloudbuild status through https://console.cloud.google.com/cloud-build\e[0m"
