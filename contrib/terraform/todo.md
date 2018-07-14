# TODO

* bastion ami - instance store?
* custom ip to  bastion - parameter
* creation of ssh key ?
* separate bucket (creation) for ignition config ?
* change tectonic version (commit hash)
* describe resources created (with s3 ignition)
* tls https://coreos.com/etcd/docs/latest/op-guide/security.html, https://coreos.com/etcd/docs/latest/etcd-live-http-to-https-migration.html
* create bucket with enc /Users/marcin.baniowski/Projects/devops/tectonic-installer/modules/aws/etcd/ignition_s3.tf
* libkv store does not initialize with tls config (main.go)
* switch off certs creation - commented out
* run with remote url (priv repo)
* licence - notice

sudo ETCDCTL_API=3 etcdctl --cacert=/etc/ssl/etcd/ca.crt --cert=/etc/ssl/etcd/client.crt --key=/etc/ssl/etcd/client.key --endpoints=https://event-gateway-etcd-0.etcd:2379,https://event-gateway-etcd-1.etcd:2379,https://event-gateway-etcd-2.etcd:2379 endpoint health