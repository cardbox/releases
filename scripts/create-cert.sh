#!/bin/bash

mkcert -key-file tls/cardbox-local.pem -cert-file tls/cardbox-local.cert cardbox.localhost "*.cardbox.localhost"
