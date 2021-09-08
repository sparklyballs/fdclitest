ARG UBUNTU_VER="focal"
FROM ubuntu:${UBUNTU_VER}

# build arguments
ARG DEBIAN_FRONTEND=noninteractive

RUN \
	apt-get update \
	&& apt-get install -y \
		--no-install-recommends \
		ca-certificates \
		git \
		python3-dev \
		python3-pip \
		python3-venv \
# cleanup
	&& rm -rf \
		/tmp/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

WORKDIR /fd-cli

RUN \
	git clone https://github.com/Flora-Network/fd-cli.git \
		/fd-cli \
	&& python3 -m venv venv \
	&& . venv/bin/activate \
	&& pip3 install --no-cache-dir -U wheel \
	&& pip3 install --no-cache-dir -e . --extra-index-url https://pypi.chia.net/simple
