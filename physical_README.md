# Test multus in Kubernetes 

## Kubernetes environment
| Role | hostname | BMC_IP | Static_IP(enp4s0f0) | Static_IP(enp4s0f1) |
| --- | --- | --- | --- | --- |
| Install_Node | |  100.67.5.9 | 100.67.75.1 | |
| Master | op1 | 100.67.5.1 | 100.67.77.1 | 100.67.79.2 |
| Worker | op2 | 100.67.5.2 | 100.67.77.2 | 100.67.79.3 |
| Worker | op3 | 100.67.5.3 | 100.67.77.3 | 100.67.79.4 |

### On Master node
```sh
root@op1:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp5s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:06:ff:44 brd ff:ff:ff:ff:ff:ff
    inet 100.67.131.8/16 brd 100.67.255.255 scope global enp5s0f0
       valid_lft forever preferred_lft forever
    inet6 fe80::226:2dff:fe06:ff44/64 scope link 
       valid_lft forever preferred_lft forever
3: enp5s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:06:ff:45 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::226:2dff:fe06:ff45/64 scope link 
       valid_lft forever preferred_lft forever
4: enp4s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:06:ff:42 brd ff:ff:ff:ff:ff:ff
    inet 100.67.77.1/16 brd 100.67.255.255 scope global enp4s0f0
       valid_lft forever preferred_lft forever
    inet 100.67.77.50/24 scope global enp4s0f0
       valid_lft forever preferred_lft forever
    inet6 fe80::226:2dff:fe06:ff42/64 scope link 
       valid_lft forever preferred_lft forever
5: enp4s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:06:ff:43 brd ff:ff:ff:ff:ff:ff
    inet 100.67.79.2/16 brd 100.67.255.255 scope global enp4s0f1
       valid_lft forever preferred_lft forever
    inet6 fe80::226:2dff:fe06:ff43/64 scope link 
       valid_lft forever preferred_lft forever
6: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:d3:ad:85:e8 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
7: tunl0@NONE: <NOARP,UP,LOWER_UP> mtu 1440 qdisc noqueue state UNKNOWN group default qlen 1
    link/ipip 0.0.0.0 brd 0.0.0.0
    inet 10.244.195.64/32 scope global tunl0
       valid_lft forever preferred_lft forever
8: cali35b0fe3a871@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 92:34:31:03:81:24 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::9034:31ff:fe03:8124/64 scope link 
       valid_lft forever preferred_lft forever
```

### On op1

```sh
root@op2:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp5s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:09:60:96 brd ff:ff:ff:ff:ff:ff
    inet 100.67.131.9/16 brd 100.67.255.255 scope global enp5s0f0
       valid_lft forever preferred_lft forever
    inet6 fe80::226:2dff:fe09:6096/64 scope link 
       valid_lft forever preferred_lft forever
3: enp5s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:09:60:97 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::226:2dff:fe09:6097/64 scope link 
       valid_lft forever preferred_lft forever
4: enp4s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:09:60:94 brd ff:ff:ff:ff:ff:ff
    inet 100.67.77.2/16 brd 100.67.255.255 scope global enp4s0f0
       valid_lft forever preferred_lft forever
    inet6 fe80::226:2dff:fe09:6094/64 scope link 
       valid_lft forever preferred_lft forever
5: enp4s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:09:60:95 brd ff:ff:ff:ff:ff:ff
    inet 100.67.79.3/16 brd 100.67.255.255 scope global enp4s0f1
       valid_lft forever preferred_lft forever
    inet6 fe80::226:2dff:fe09:6095/64 scope link 
       valid_lft forever preferred_lft forever
6: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:75:24:ad:c5 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
7: tunl0@NONE: <NOARP,UP,LOWER_UP> mtu 1440 qdisc noqueue state UNKNOWN group default qlen 1
    link/ipip 0.0.0.0 brd 0.0.0.0
    inet 10.244.3.192/32 scope global tunl0
       valid_lft forever preferred_lft forever
8: cali01efc7a8ed8@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether a2:04:1d:56:c9:9d brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::a004:1dff:fe56:c99d/64 scope link 
       valid_lft forever preferred_lft forever
9: cali35104d8ba9c@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 12:7b:7b:87:b5:a1 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::107b:7bff:fe87:b5a1/64 scope link 
       valid_lft forever preferred_lft forever
```


### On op2

```sh
root@op3:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp5s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:08:02:30 brd ff:ff:ff:ff:ff:ff
    inet 100.67.131.10/16 brd 100.67.255.255 scope global enp5s0f0
       valid_lft forever preferred_lft forever
    inet6 fe80::226:2dff:fe08:230/64 scope link 
       valid_lft forever preferred_lft forever
3: enp5s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:08:02:31 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::226:2dff:fe08:231/64 scope link 
       valid_lft forever preferred_lft forever
4: enp4s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:08:02:2e brd ff:ff:ff:ff:ff:ff
    inet 100.67.77.3/16 brd 100.67.255.255 scope global enp4s0f0
       valid_lft forever preferred_lft forever
    inet6 fe80::226:2dff:fe08:22e/64 scope link 
       valid_lft forever preferred_lft forever
5: enp4s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:26:2d:08:02:2f brd ff:ff:ff:ff:ff:ff
    inet 100.67.79.4/16 brd 100.67.255.255 scope global enp4s0f1
       valid_lft forever preferred_lft forever
    inet6 fe80::226:2dff:fe08:22f/64 scope link 
       valid_lft forever preferred_lft forever
6: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:83:d8:38:78 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
7: tunl0@NONE: <NOARP,UP,LOWER_UP> mtu 1440 qdisc noqueue state UNKNOWN group default qlen 1
    link/ipip 0.0.0.0 brd 0.0.0.0
    inet 10.244.43.192/32 scope global tunl0
       valid_lft forever preferred_lft forever
8: calia6ecaf1e34b@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 9e:08:c5:65:10:f2 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::9c08:c5ff:fe65:10f2/64 scope link 
       valid_lft forever preferred_lft forever
9: cali64d3c747522@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether a2:e6:78:0d:8c:12 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::a0e6:78ff:fe0d:8c12/64 scope link 
       valid_lft forever preferred_lft forever
10: caliefbe034750f@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 42:f6:da:99:a5:71 brd ff:ff:ff:ff:ff:ff link-netnsid 2
    inet6 fe80::40f6:daff:fe99:a571/64 scope link 
       valid_lft forever preferred_lft forever
11: cali91821778ac2@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 82:f5:43:b6:f5:dc brd ff:ff:ff:ff:ff:ff link-netnsid 3
    inet6 fe80::80f5:43ff:feb6:f5dc/64 scope link 
       valid_lft forever preferred_lft forever
```

## Working

### Copy `setup/go-multus.sh` to every node(master & workers) and exec it.
```sh
$ cd setup && sh go-multus.sh
```

### Run kubectl create command for the Custom Resource Definition

```sh
$ cd setup && kubectl create -f ./crdnetwork.yaml
```
