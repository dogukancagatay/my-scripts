```sh
kubectl apply -f ceph-rbd-provisioner.yml
kubectl get pods -l app=rbd-provisioner -n kube-system

## Get ceph cluster admin key
ceph auth get-key client.admin

## Create secret from secret
kubectl create secret generic ceph-admin-secret \
  --type="kubernetes.io/rbd" \
  --from-literal=key='<key-value>' \
  --namespace=kube-system

## Show secret
kubectl get secrets ceph-admin-secret -n kube-system


## Create a new pool for k8s
# sudo ceph ceph osd pool create <pool-name> <pg-number>
sudo ceph ceph osd pool create k8s 100

## Add k8s user for ceph
# sudo ceph auth add client.kube mon 'allow r' osd 'allow rwx pool=<pool-name>
sudo ceph auth add client.kube mon 'allow r' osd 'allow rwx pool=k8s'

sudo ceph osd pool application enable <pool-name> rbd
sudo rbd pool init <pool-name>

## Get k8s user key
sudo ceph auth get-key client.kube

## Add k8s ceph user key as secret
kubectl create secret generic ceph-k8s-secret \
  --type="kubernetes.io/rbd" \
  --from-literal=key='<key-value>' \
  --namespace=kube-system

## Set monitors on ceph-rbd-sc.yml
# you can list with sudo ceph -s

## Add storage class
kubectl apply -f ceph-rbd-sc.yml

## Check storage classes
kubectl get sc


kubectl apply -f test-ceph-rbd-claim.yml
kubectl apply -f test-rbd-pod.yml

kubectl describe pod rbd-test-pod
```

