FROM quay.io/fedora/fedora:44

ARG DEFAULT_GROUP
ARG DEFAULT_USER

COPY . /dotfiles

RUN groupadd -g "$DEFAULT_GROUP" molter && \
        useradd -m -l -u "$DEFAULT_USER" -g molter molter && \
        echo 'molter        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers

USER molter

RUN sudo dnf install -y ansible cowsay && \
        ansible-playbook -i /dotfiles/ansible/local-inventory.yml \
            /dotfiles/ansible/devcontainer.yml && \
        source "$HOME/.cargo/env" && \
        nvim --headless "+lua vim.pack.update(nil, { force = true })" +qa && \
        rm -rf "$HOME/.cargo/registry/{cache,src}" && \
        rm -rf "$HOME/.cargo/git/checkouts" && \
        dnf clean all

ENTRYPOINT ["/usr/bin/zsh"]
