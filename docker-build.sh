#!/bin/bash

set -euo pipefail

function validate() {
	if [[ ${SKIP_PUSH} == "true" ]]; then
		if [ -n "${DOCKER_USERNAME}" ] || [ -n "${DOCKER_PASSWORD}" ]; then
			echo >&2 "skip-push is not set, docker-username and docker-password are required"
			exit 2
		fi
	fi
}

function pick_tag() {
	tag=latest
	if [ "${GITHUB_REF##refs/tags/}" != "${GITHUB_REF}" ]; then
		tag=${GITHUB_REF##refs/tags/}
	fi
	echo "$tag"
}

function additional_tags() {
	original_tag=$1
	if echo "$original_tag" | grep -q '^v\d\+\.\d\+\.\d\+$'; then
		filtered=${original_tag#v}
		tags="${filtered} ${filtered%.*} ${filtered%%.*}"

		for tag in $tags; do
			docker tag "${IMAGE_NAME}:${original_tag} ${IMAGE_NAME}:${tag}"
		done
	fi
}

tag=$(pick_tag)
docker build -t "${IMAGE_NAME}:${tag}" -f "${DOCKERFILE}" .
additional_tags "${tag}"

if [[ ${SKIP_PUSH} != "true" ]]; then
	docker login -u "${DOCKER_USERNAME}" --password-stdin <<<"${DOCKER_PASSWORD}"
	docker push --all-tags "${IMAGE_NAME}"

	docker system prune -af

	# sanity check
	docker pull "${IMAGE_NAME}:${tag}"
fi
