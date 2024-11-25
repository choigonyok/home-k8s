sudo passwd root
su root

apt update
apt-get update
apt install openssh-server -y
systemctl enable ssh
systemctl restart ssh


ssh-keygen -t rsa -b 2048 -m PEM -f ~/.ssh/k8s-{NUM}.pem # 수정
cat ~/.ssh/k8s-{NUM}.pem.pub > ~/.ssh/authorized_keys # 수정
cat ~/.ssh/k8s-1.pem.pub > ~/.ssh/authorized_keys
apt-get install net-tools

swapoff -a
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get update && sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker choigonyok
mkdir /home/choigonyok/.docker
chown "choigonyok":"choigonyok" /home/choigonyok/.docker -R
chmod g+rwx "/home/choigonyok/.docker" -R
systemctl enable docker.service && systemctl enable containerd.service
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd.service && systemctl restart docker.service
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl && sudo systemctl enable --now kubelet

{ kubeadm init / kubeadm token create --print-join-command / kubeadm join ~ }

mkdir -p /home/choigonyok/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/choigonyok/.kube/config
sudo chown choigonyok:choigonyok /home/choigonyok/.kube/config
export KUBECONFIG=/home/choigonyok/.kube/config

kubectl label node k8s-2 node-role.kubernetes.io/worker-1=
kubectl label node k8s-3 node-role.kubernetes.io/worker-2=
kubectl label node k8s-4 node-role.kubernetes.io/worker-3=


CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
sudo curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin && sudo rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update && sudo apt-get install helm

LATEST=$(curl -s https://api.github.com/repos/prometheus-operator/prometheus-operator/releases/latest | jq -cr .tag_name)
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/${LATEST}/bundle.yaml | kubectl create -f -

kubectl label node k8s-1 node-type=master
kubectl label node k8s-2 node-type=worker
kubectl label node k8s-3 node-type=worker
kubectl label node k8s-4 node-type=worker

sudo apt update && sudo apt install git -y
cd /home/choigonyok && git clone https://github.com/choigonyok/home-k8s.git

helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.15.6 \
  --set operator.replicas=1 \
  --set operator.nodeSelector.node-type=master \
  --set nodePort.enabled=true \
  --namespace kube-system

helm upgrade cilium cilium/cilium --version 1.15.6 \
  --set kubeProxyReplacement=true \
  --set k8sServiceHost="API_SERVER_IP_ADDR" \
  --set k8sServicePort="6443" \
  --reuse-values \
  --namespace kube-system

helm upgrade cilium cilium/cilium --version 1.15.6 \
  --reuse-values \
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true \
  --set hubble.relay.replicas=1 \
  --set hubble.ui.replicas=1 \
  --set hubble.ui.nodeSelector.node-type=master \
  --set hubble.relay.nodeSelector.node-type=master \
  --namespace kube-system

cilium connectivity test

helm upgrade cilium cilium/cilium --version 1.15.6 \
    --set l2announcements.enabled=true \
    --set externalIPs.enabled=true \
    --reuse-values \
    --namespace kube-system

cilium connectivity test

helm upgrade cilium cilium/cilium --version 1.15.6 \
    --set ingressController.enabled=false \
    --reuse-values \
    --namespace kube-system
    # --set ingressController.default=true \
    # --set ingressController.loadbalancerMode=shared \
    # --set ingressController.enforceHttps=false \
    # --set ingressController.service.loadBalancerClass="io.cilium/l2-announcer" \
    # --set ingressController.service.insecureNodePort="30080" \
    # --set ingressController.service.secureNodePort="30443"   \
    # --set ingressController.hostNetwork.enabled=true \

kubectl -n kube-system rollout restart deployment/cilium-operator
kubectl -n kube-system rollout restart ds/cilium

kubectl apply -f ~/home-k8s/cilium/manifests/external-ip.yaml

cilium connectivity test

HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
HUBBLE_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then HUBBLE_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-linux-${HUBBLE_ARCH}.tar.gz{,.sha256sum}
sha256sum --check hubble-linux-${HUBBLE_ARCH}.tar.gz.sha256sum
sudo tar xzvfC hubble-linux-${HUBBLE_ARCH}.tar.gz /usr/local/bin
sudo rm hubble-linux-${HUBBLE_ARCH}.tar.gz{,.sha256sum}

cilium hubble port-forward&

sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords yes/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
systemctl restart openssh-server

kubectl apply -f /home/choigonyok/home-k8s/metrics-server/components.yaml

sudo vim /home/choigonyok/.bashrc
source /home/choigonyok/.bashrc

# swapoff -a
# sudo modprobe rbd
# sudo modprobe ceph



