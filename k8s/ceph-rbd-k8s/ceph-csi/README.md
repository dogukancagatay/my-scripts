
```sh
## Create pool for k8s
ceph osd pool create kubernetes
## Initialize pool
rbd pool init kubernetes
## Create user for kubernetes pool
ceph auth get-or-create client.kubernetes mon 'profile rbd' osd 'profile rbd pool=kubernetes' mgr 'profile rbd pool=kubernetes'
```

## Create ceph-csi config-map

Run the following command on ceph cluster to collect cluster *fsid* and monitor list.

```sh
ceph mon dump
```

Edit `csi-config-map.yaml` apply.

```sh
kubectl apply -f csi-config-map.yaml
## Apply an empty config-map
kubectl apply -f csi-kms-config-map.yaml
## Apply ceph.conf config-map
kubectl apply -f ceph-config-map.yaml
```

Collect *kubernetes* account key, edit `csi-rbd-secret.yaml` and apply.

```sh
## Apply rbd-secret
kubectl apply -f csi-rbd-secret.yaml
```

## Configure ceph-csi Plugins

```sh
kubectl apply -f https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-provisioner-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-nodeplugin-rbac.yaml
```

```sh
wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin-provisioner.yaml
kubectl apply -f csi-rbdplugin-provisioner.yaml
wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin.yaml
kubectl apply -f csi-rbdplugin.yaml
```

kubectl apply -f csi-rbd-sc.yaml
```

## Test

### Block Device
```sh
kubectl apply -f raw-block-pvc.yaml
kubectl apply -f raw-block-pod.yaml
```

### Filesystem Device
```sh
kubectl apply -f pvc.yaml
kubectl apply -f pod.yaml
```
