#!/bin/bash -eu


## NOTE: THIS SCRIPT IS EXPERIMENTAL


# see: http://github.com/spantaleev/matrix-docker-ansible-deploy/blob/master/docs/configuring-dns.md
function install_matrix_checkdns {
  if [ -z "${domain}" ] ;then
    echo ERROR: /etc/resolv.conf needs to have a search clause
    return 1
  fi

  local srv8448=$(dig +short _matrix._tcp.${domain} srv | fgrep 8448)
  local srv443=$(dig +short _matrix-identity._tcp.${domain} srv | fgrep 443)
  [[ ! -z "${srv8448}" ]] && [[ ! -z "${srv443}" ]] && return 0
  echo ERROR: please configure DNS as per http://github.com/spantaleev/matrix-docker-ansible-deploy/blob/master/docs/configuring-dns.md
  return 1
}

function install_matrix_binaries {
  local email="$1"

  apt+ install git pwgen

  mkdir -p "${WORKSPACE}"
  pushd "${WORKSPACE}"
  if [ ! -d matrix-docker-ansible-deploy ] ;then
    git clone http://github.com/spantaleev/matrix-docker-ansible-deploy
  fi
  cd matrix-docker-ansible-deploy
  git pull

cat << EOD > inventory/hosts
[matrix-servers]
${fqdn} ansible_host=${ip} ansible_ssh_user=root
EOD

mkdir -p inventory/host_vars/matrix.${domain}
cat << EOD > inventory/host_vars/matrix.${domain}/vars.yml
host_specific_matrix_ssl_lets_encrypt_support_email: "${email}"
host_specific_hostname_identity: "${domain}"
matrix_coturn_turn_static_auth_secret: "$(pwgen -s 128 1)"
matrix_synapse_macaroon_secret_key: "$(pwgen -s 128 1)"
EOD

  if [ ! -f ~/.ssh/id_rsa ] ;then
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  fi

  python3 -m pip install --user --upgrade ansible

  sudo ufw allow http
  sudo ufw allow https
  sudo ufw enable

  ansible-playbook -i inventory/hosts setup.yml --tags=setup-all
popd
}

function install_matrix_start {
  pushd "${WORKSPACE}"/matrix-docker-ansible-deploy
    ansible-playbook -i inventory/hosts setup.yml --tags=start
  popd
}

function install_matrix_register {
  local username="$1"
  local password="$2"
  local admin="${3:-no}"
  pushd "${WORKSPACE}"/matrix-docker-ansible-deploy
    ansible-playbook -i inventory/hosts setup.yml --extra-vars="username=${username} password=${password} admin=${admin}" --tags=register-user
  popd
}

function install_matrix_status {
  pushd "${WORKSPACE}"/matrix-docker-ansible-deploy
    ansible-playbook -i inventory/hosts setup.yml --tags=self-check
  popd
}

function install_matrix {
    local username="${1:-admin}"
    local password="${2:-secret}"
    local email="${3:-admin@${domain}}"

    local fqdn=$(hostname --fqdn)
    local ip=$(dig @ns1.he.net +short ${fqdn} a)
    local domain=$(cat /etc/resolv.conf | fgrep search | cut -d' ' -f2 | tail -1)

    install_matrix_checkdns && \
        install_matrix_binaries "${username}" && \
        install_matrix_start && install_matrix_register "${username}" "${password}" yes && \
        install_matrix_status
}

if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
