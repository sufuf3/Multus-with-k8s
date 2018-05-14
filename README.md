# Test multus in Kubernetes using Vagrant
在 Ubuntu16.04 上使用 Vagrant 建立簡單 Kubernetes 環境來測試 [multus](https://github.com/intel/multus-cni)  
Thanks https://github.com/michalskalski/vagrant-multus  
> Study: https://github.com/sufuf3/kubernetes-hard-way-deploy/blob/master/container-networking-study/Multi-networking-interfaces/multus-cni.md

## Kubernetes environment

| role | hostname | interface1 IP(eth1) | interface2 IP(eth2) |
| --- | --- | --- | -- |
| master | master | 10.14.0.11 | None |
| worker | node1 | 10.14.0.12 | 10.230.0.12 |
| worker | node2 | 10.14.0.13 | 10.230.0.13 |

> pod-network-cidr: 10.244.0.0/16

## Prepare
- Install virtualbox (因為 vagrant 的限制，所以不能安裝最新的 5.2 版)
```sh
$ vim /etc/apt/sources.list
deb https://download.virtualbox.org/virtualbox/debian xenial contrib


$ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
$ wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

$ sudo apt-get update
$ sudo apt-get install virtualbox-5.1
```
- Install vagrant
```sh
$ apt install vagrant
```
- clone repository
```sh
git clone https://github.com/sufuf3/Multus-with-k8s.git
```
- Setup VM
```sh
cd Multus-with-k8s
vagrant up --provider=virtualbox
```
> On each node
> 1. Install kubelet & kubeadm  
> 2. Install golang v1.8.3  
> 3. Install multus-cni(/opt/cni/bin/)  


## deploy Kubernetes with kubeadm
> You can use `tmux` to do these.
### On Master node
```sh
$ vagrant ssh master
[vagrant@master ~]$ sudo swapoff -a 
[vagrant@master ~]$ sudo kubeadm init --apiserver-advertise-address 10.14.0.11 --pod-network-cidr 10.244.0.0/16
kubectl version
[vagrant@master ~]$ kubectl version
Client Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.2", GitCommit:"81753b10df112992bf51bbc2c2f85208aad78335", GitTreeState:"clean", BuildDate:"2018-04-27T09:22:21Z", GoVersion:"go1.9.3", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.2", GitCommit:"81753b10df112992bf51bbc2c2f85208aad78335", GitTreeState:"clean", BuildDate:"2018-04-27T09:10:24Z", GoVersion:"go1.9.3", Compiler:"gc", Platform:"linux/amd64"}
[vagrant@master ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:5f:94:78 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 85256sec preferred_lft 85256sec
    inet6 fe80::5054:ff:fe5f:9478/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:54:7a:ef brd ff:ff:ff:ff:ff:ff
    inet 10.14.0.11/24 brd 10.14.0.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe54:7aef/64 scope link 
       valid_lft forever preferred_lft forever
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
    link/ether 02:42:31:c7:c8:d9 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
```
- On node1
```sh
$ vagrant ssh node1
[vagrant@node1 ~]$ sudo swapoff -a 
[vagrant@node1 ~]$ sudo kubeadm join 10.14.0.11:6443 --token fa1iw1.57d2ckel1t6hetk6 --discovery-token-ca-cert-hash sha256:08cb21eab6d74e26368edf281eddcba76eb02be83efaa55e9d9eaf21a25c4bbe
[vagrant@node1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:5f:94:78 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 85430sec preferred_lft 85430sec
    inet6 fe80::5054:ff:fe5f:9478/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:70:47:42 brd ff:ff:ff:ff:ff:ff
    inet 10.14.0.12/24 brd 10.14.0.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe70:4742/64 scope link 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:30:94:4f brd ff:ff:ff:ff:ff:ff
    inet 10.230.0.12/24 brd 10.230.0.255 scope global eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe30:944f/64 scope link 
       valid_lft forever preferred_lft forever
5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
    link/ether 02:42:46:6c:14:33 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
```
- On node2
```sh
$ vagrant ssh node2
[vagrant@node2 ~]$ sudo swapoff -a 
[vagrant@node2 ~]$ sudo kubeadm join 10.14.0.11:6443 --token fa1iw1.57d2ckel1t6hetk6 --discovery-token-ca-cert-hash sha256:08cb21eab6d74e26368edf281eddcba76eb02be83efaa55e9d9eaf21a25c4bbe
[vagrant@node2 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:5f:94:78 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 85709sec preferred_lft 85709sec
    inet6 fe80::5054:ff:fe5f:9478/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:b7:18:4f brd ff:ff:ff:ff:ff:ff
    inet 10.14.0.13/24 brd 10.14.0.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feb7:184f/64 scope link 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:99:72:31 brd ff:ff:ff:ff:ff:ff
    inet 10.230.0.13/24 brd 10.230.0.255 scope global eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe99:7231/64 scope link 
       valid_lft forever preferred_lft forever
5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
    link/ether 02:42:e1:25:0b:ff brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
```

## Add mutltus & pod
### On master node
```sh
[vagrant@master ~]$ kubectl apply -f /vagrant/files/rbac.yaml
clusterrole.rbac.authorization.k8s.io "multus" created
clusterrolebinding.rbac.authorization.k8s.io "mutltus" created
[vagrant@master ~]$ kubectl apply -f /vagrant/files/multus.yaml
serviceaccount "multus" created
configmap "kube-multus-cfg" created
daemonset.extensions "kube-multus-ds" created
[vagrant@master ~]$ kubectl get pods --namespace=kube-system
NAME                             READY     STATUS    RESTARTS   AGE
etcd-master                      1/1       Running   0          5m
kube-apiserver-master            1/1       Running   0          5m
kube-controller-manager-master   1/1       Running   0          5m
kube-dns-86f4d74b45-vrmr6        0/3       Pending   0          6m
kube-multus-ds-slhl7             2/2       Running   0          15s
kube-multus-ds-wdb4n             2/2       Running   0          15s
kube-proxy-2g55w                 1/1       Running   0          6m
kube-proxy-4g5n8                 1/1       Running   0          5m
kube-proxy-n5ql2                 1/1       Running   0          4m
kube-scheduler-master            1/1       Running   0          5m
[vagrant@master ~]$ kubectl apply -f /vagrant/files/busybox.yaml
pod "busybox" created
[vagrant@master ~]$ kubectl get pods -o wide
NAME      READY     STATUS    RESTARTS   AGE       IP           NODE
busybox   1/1       Running   0          12s       10.244.2.2   node2
[vagrant@master ~]$ kubectl exec busybox -it ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
3: eth0@if8: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1450 qdisc noqueue 
    link/ether 0a:58:0a:f4:02:02 brd ff:ff:ff:ff:ff:ff
    inet 10.244.2.2/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::944c:b9ff:fe9c:47a3/64 scope link 
       valid_lft forever preferred_lft forever
4: net0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue 
    link/ether 22:8a:2d:ce:9e:5a brd ff:ff:ff:ff:ff:ff
    inet 10.230.0.100/24 scope global net0
       valid_lft forever preferred_lft forever
    inet6 fe80::208a:2dff:fece:9e5a/64 scope link 
       valid_lft forever preferred_lft forever
```

## Another check
- On master, node1, node2
```sh
vim /etc/cni/net.d/10-flannel.conf
{
  "name": "cbr0",
  "type": "flannel",
  "delegate": {
    "isDefaultGateway": true
  }
}
```
- On node1, node2
```sh
{
  "name": "multus-demo",
  "type": "multus",
  "delegates": [
    {
      "type": "macvlan",
      "master": "eth2",
      "mode": "bridge",
      "ipam": {
        "type": "host-local",
        "subnet": "10.230.0.0/24",
        "rangeStart": "10.230.0.100",
        "rangeEnd": "10.230.0.200",
        "routes": [
          { "dst": "0.0.0.0/0" }
        ],
        "gateway": "10.230.0.1"
     }
    },
    {
      "type": "flannel",
      "masterplugin": true,
      "delegate": {
        "isDefaultGateway": true
      }
    }
  ]
}
```


Reference: https://github.com/michalskalski/vagrant-multus
