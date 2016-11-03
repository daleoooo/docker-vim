#!/bin/bash

__create_user() {
    # Create a user to SSH into as.
    echo -e "$OWNER_PASSWORD\n$OWNER_PASSWORD" | (passwd --stdin $OWNER_NAME)
    echo ssh $OWNER_NAME password: $OWNER_PASSWORD
}

# Call all functions
__create_user
