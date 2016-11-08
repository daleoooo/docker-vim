#!/bin/bash

__init() {
    # setup sshd
    /usr/sbin/sshd -D
}

__init
