#!/bin/bash
#
# Copyright 2024 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

export DEPLOY_CERT_MANAGER=${DEPLOY_CERT_MANAGER:-true}

if [[ $DEPLOY_CERT_MANAGER == true ]]; then
	CERT_MANAGER_VERSION="v1.14.4"
	echo "Installing cert-manager..."
	manifest="https://github.com/cert-manager/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.yaml"
	./cluster/kubectl.sh apply -f "$manifest"
	./cluster/kubectl.sh wait --namespace cert-manager --for=condition=Available deployment/cert-manager --timeout=5m
	./cluster/kubectl.sh wait --namespace cert-manager --for=condition=Available deployment/cert-manager-cainjector --timeout=5m
	./cluster/kubectl.sh wait --namespace cert-manager --for=condition=Available deployment/cert-manager-webhook --timeout=5m
fi
