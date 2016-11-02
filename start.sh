#!/bin/bash

__create_user() {
    # Create a user to SSH into as.
    SSH_USERPASS=00000000
    echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin dale)
    echo ssh dale password: $SSH_USERPASS
}

# Call all functions
__create_user
