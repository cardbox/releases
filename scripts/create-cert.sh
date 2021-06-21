#!/bin/bash

openssl req -x509 -out ./tls/cardbox.crt -keyout ./tls/cardbox.pem \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=cardbox.local' -extensions EXT -config <( \
   printf "[dn]\nCN=cardbox.local\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:cardbox.local\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

openssl dhparam -out ./tls/dhparam.pem 2048#!/bin/bash

openssl req -x509 -out ./tls/cardbox.crt -keyout ./tls/cardbox.pem \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=cardbox.local' -extensions EXT -config <( \
   printf "[dn]\nCN=cardbox.local\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:cardbox.local\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

openssl dhparam -out ./tls/dhparam.pem 2048