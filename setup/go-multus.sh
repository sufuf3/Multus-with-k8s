curl -LO https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz && \
tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "export GOROOT=/usr/local/go" >> ~/.bash_profile
echo "export PATH=$PATH:$GOROOT/bin" >> ~/.bash_profile
source ~/.bash_profile
cd ~/ && git clone https://github.com/Intel-Corp/multus-cni.git
cd ~/multus-cni/ && ./build
cp ~/multus-cni/bin/multus /opt/cni/bin/
chmod 755 /opt/cni/bin/multus
cd ~/ && git clone https://github.com/Intel-Corp/sriov-cni.git
cd ~/sriov-cni && ./build
cp ~/sriov-cni/bin/sriov /opt/cni/bin/
chmod 755 /opt/cni/bin/sriov
