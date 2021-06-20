### Configuration
d
#### Envs

- `SERVER_NAME` — domain to listen
- `MAIN_UPSTREAM` — proxy from `location /`
- `BACKEND_UPSTREAM` — proxy from `location /api/v0`

#### Volumes

- `/var/lib/cardbox/tls/cardbox.crt`
- `/var/lib/cardbox/tls/cardboxd.pem`
- `/etc/ssl/certs/dhparam.pem`
