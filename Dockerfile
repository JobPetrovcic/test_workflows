# Container image that runs your code
FROM ubuntu:22.04

CMD bash

RUN apt-get update -q \
        && apt-get install -y -q --no-install-recommends procps less emacs-lucid sudo m4 opam \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ARG guest=VL
ARG guest_uid=1000
ARG guest_gid=${guest_uid}

RUN groupadd -g ${guest_gid} ${guest} \
        && useradd --no-log-init -m -s /bin/bash -g ${guest} -G sudo -p '' -u ${guest_uid} ${guest} \
        && mkdir -p -v /home/${guest}/.local/bin \
        && chown -R ${guest}:${guest} /home/${guest} \
        && sed -i -e '/%sudo/s/)/) NOPASSWD:/' /etc/sudoers

WORKDIR /home/${guest}
USER ${guest}

COPY entrypoint.sh /home/VL/entrypoint.sh
RUN sudo chmod +x /home/VL/entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT [ "/home/VL/entrypoint.sh" ]