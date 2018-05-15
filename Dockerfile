FROM quay.io/jcallen/che-fedora-base

EXPOSE 8080 8000 9191
ENV REQUIRED_PKGS="bzip2 procps python3-pip dnf-plugins-core kubectl" \
    OPTIONAL_PKGS="python-psycopg2 zsh vim vim-jedi vim-powerline vim-pysmell vim-syntastic vim-syntastic-python" \
    PIP_PKGS="kube-shell"

USER root
COPY kubernetes.repo /etc/yum.repos.d/

RUN dnf install -y ${REQUIRED_PKGS} ${OPTIONAL_PKGS} && \
    dnf clean all && \
    pip3 install ${PIP_PKGS}

# Optional - download and install oh-my-zsh
ADD https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh /home/user/
RUN chown user:users /home/user/install.sh && \
    chmod 755 /home/user/install.sh

USER user

RUN /home/user/install.sh >/dev/null 2>&1 && \
    ln -s /usr/share/vim/vimfiles/ /home/user/.vim
COPY .vimrc /home/user
