# syntax=docker/dockerfile:1

FROM ubuntu:24.04 AS toolchain

RUN <<EOF
set -eux
apt-get update
apt-get install -y --no-install-recommends bzip2 ca-certificates wget
rm -rf /var/lib/apt/lists/*
mkdir -p /opt/venusa
cd /opt/venusa
wget -qO- https://download.nucleisys.com/upload/files/toolchain/gcc/nuclei_riscv_newlibc_prebuilt_linux64_2025.10.tar.bz2 | tar xjf -
EOF


FROM ubuntu:24.04

RUN <<EOF
set -eux
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    git \
    git-lfs \
    make \
    ninja-build \
    python3 \
    xxd
rm -rf /var/lib/apt/lists/*
EOF

COPY --link --from=toolchain /opt/venusa /opt/venusa

ENV NUCLEI_TOOLCHAIN_PATH=/opt/venusa/gcc \
    PATH=/opt/venusa/gcc/bin:${PATH}
