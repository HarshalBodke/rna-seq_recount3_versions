FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    unzip \
    git \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libxt-dev \
    default-jre \
    python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

# ----------------------------
# Install FastQC v0.11.8
# ----------------------------
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip && \
    unzip fastqc_v0.11.8.zip && \
    chmod +x FastQC/fastqc && \
    mv FastQC /opt/fastqc && \
    ln -s /opt/fastqc/fastqc /usr/local/bin/fastqc && \
    rm fastqc_v0.11.8.zip

# ----------------------------
# Install STAR v2.7.3a
# ----------------------------
RUN wget https://github.com/alexdobin/STAR/archive/refs/tags/2.7.3a.tar.gz && \
    tar -xzf 2.7.3a.tar.gz && \
    cd STAR-2.7.3a/source && \
    make STAR && \
    install -m 755 STAR /usr/local/bin/STAR && \
    cd / && \
    rm -rf STAR-2.7.3a 2.7.3a.tar.gz

# ----------------------------
# Install RSEM v1.3.3
# ----------------------------
RUN git clone --branch v1.3.3 --depth 1 https://github.com/deweylab/RSEM.git && \
    cd RSEM && \
    make && \
    cp rsem-* /usr/local/bin/ && \
    cd .. && \
    rm -rf RSEM

# ----------------------------
# Verify installations
# ----------------------------
RUN fastqc --version && \
    STAR --version && \
    rsem-calculate-expression --version

# Default working directory
WORKDIR /data

CMD ["/bin/bash"]
