#!/bin/sh
vault_token=$(vault login -method=aws role=XXXX-jenkins | head -7 | tail -1 | awk '{print $2;}')
echo $vault_token >> vault_token.txt
