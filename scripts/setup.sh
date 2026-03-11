#!/bin/bash

set -e 

docker network create --driver overlay --attachable vault_net