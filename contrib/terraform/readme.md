


## Etcd

I had to provide a wrapper over coreos etcd. The reason is that etcd module is a part of the whole kubernetes setup and it has some dependencies, like certificates, coreos ignition, dns. If we ran the dependent modules, it would create redundant resources for other k8s components. That's why I had to extract some parts of tectonic installer into the etcd wrapper (`modules/etcd`).