ARG UBUNTU_VER="focal"
FROM ubuntu:${UBUNTU_VER}

# build arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG RELEASE

# install build packages
RUN \
	apt-get update \
	&& apt-get install -y \
		--no-install-recommends \
		ca-certificates \
		curl \
		git \
		jq \
		python3-dev \
		python3-pip \
		python3-venv \
# cleanup
	&& rm -rf \
		/tmp/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

# set workdir
WORKDIR /fd-cli

# set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install package
RUN \
	if [ -z ${RELEASE+x} ]; then \
	RELEASE=$(curl -u "${SECRETUSER}:${SECRETPASS}" -sX GET "https://api.github.com/repos/Flora-Network/fd-cli/commits/master" \
		| jq -r ".sha"); \
	RELEASE="${RELEASE:0:7}"; \
	fi \
	&& git clone https://github.com/Flora-Network/fd-cli.git \
		/fd-cli \
	&& git checkout "${RELEASE}" \
	&& python3 -m venv venv \
	&& . venv/bin/activate \
	&& pip3 install --no-cache-dir -U wheel \
	&& pip3 install --no-cache-dir -e . --extra-index-url https://pypi.chia.net/simple
