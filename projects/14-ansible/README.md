# Project 14 - Ansible Basics

## Overview

This project demonstrates the basics of Ansible by configuring a local inventory and using a playbook to install Nginx automatically.

## Project Structure

```
14-ansible/
├── ansible.cfg
├── inventory/
│   └── hosts
├── playbooks/
│   └── install-nginx.yml
└── README.md
```

## Requirements

- Debian / Ubuntu
- Ansible Core 2.19+
- Python 3

## Verify Installation

```bash
ansible --version
```

## Inventory

```ini
[local]
localhost ansible_connection=local
```

## Test Connection

```bash
ansible all -m ping
```

Expected output:

```
localhost | SUCCESS => {
    "ping": "pong"
}
```

## Playbook

Run:

```bash
ansible-playbook playbooks/install-nginx.yml -K
```

Example playbook:

```yaml
---
- hosts: local
  become: true

  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
        update_cache: yes
```

## Verify

```bash
nginx -v
```

or

```bash
systemctl status nginx
```

## Concepts Learned

- Inventory
- Playbooks
- Modules
- Become (Privilege Escalation)
- Idempotency
- Localhost Automation
