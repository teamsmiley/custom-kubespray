# Ansible Role: HAProxy for Kubernetes masters

This role is used to setup HAProxy and keepalived to Kubernetes masters. This role should be included in [Kubespray](https://github.com/kubernetes-sigs/kubespray). It was made with reference to the [this document](https://kubespray.io/#/docs/ha-mode?id=kube-apiserver). You should set these variables in `group_vars/all/all.yml` in inventory directory:

```yaml
## External LB example config
## apiserver_loadbalancer_domain_name: "elb.some.domain"
loadbalancer_apiserver:
  address: 1.2.3.4
  port: 1234
```

## Requirements

- Kubespray
- Ubuntu 20.04+

## Role Variables

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

## Dependencies

None.

## Example Playbook

You should include this role to `cluster.yml` playbook of Kubespray:

```yaml
- hosts: kube-master
  become: true
  roles:
    - name: haproxy-for-k8s-masters
      tags:
        - haproxy
        - keepalived
```

## Example Inventory

You should configure the inventory of Kubespray like this:

```ini
[all]
node-01 ansible_host=10.211.55.34 vrrp_instance_state=MASTER vrrp_instance_priority=101
node-02 ansible_host=10.211.55.35 vrrp_instance_state=BACKUP vrrp_instance_priority=100
node-03 ansible_host=10.211.55.36 vrrp_instance_state=BACKUP vrrp_instance_priority=99
...

[kube-master]
node-01
node-02
node-03

...
[kube-master:vars]
vrrp_interface=enp0s5
vrrp_instance_virtual_router_id=51
...
```

## License

BSD

## Author Information

This role was created in 2019 by lapee79 to setup HAProxy for Kubernetes masters.
