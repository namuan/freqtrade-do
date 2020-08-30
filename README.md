# Freqtrade setup on DigitalOcean

Setting up infrastructure for running [freqtrade](https://github.com/freqtrade/freqtrade) on [DigitalOcean](https://m.do.co/c/da51ec30754c) (Affiliate link).

### Setting up venv

```bash
make venv requirements
```

### Running on DigitalOcean

*Pre-requisite*

- [ ] Set `DIGITALOCEAN_ACCESS_TOKEN` environment variable to token from [Digital Ocean API Key](https://cloud.digitalocean.com/account/api/tokens).
- [ ] Set `DIGITAL_OCEAN_SSH_FINGERPRINT` environment variable to SSH fingerprint from [Digital Ocean SSH Key](https://cloud.digitalocean.com/account/security).
- [ ] Set `DIGITAL_OCEAN_SSH_KEY` environment variable to the file path of private SSH key. For eg. ~/.ssh/py-flask-digitalocean as this will be used when setting up the Digital Ocean droplet.

These can be setup by

```bash
export DIGITAL_OCEAN_TOKEN=
export DIGITAL_OCEAN_SSH_FINGERPRINT=
export DIGITAL_OCEAN_SSH_KEY=
export FLASK_SECRET_KEY=
```

*Setting up application*

- Start up DigitalOcean droplet

```bash
make doplaybook
```

- Setup user for management and deployment

```bash
make bootstrap
```

- Setup and Secure Ubuntu etc

```bash
make setupplaybook
```

*Initial setup*
```bash
make setupfq
```

*Update freqtrade*
```bash
make updatefq
```

*Running or Updating bot*

To re-deploy changes and restart bot after deployment

```bash
make runbot
```

*Cleanup*

Make sure you have [doctl](https://github.com/digitalocean/doctl) installed

It can be initialised with the token in the environment variable

```bash
doctl auth init --access-token $DIGITAL_OCEAN_TOKEN
```

Then run the following to delete the droplet.

> Please note that the following action is destructive and remove any unsaved changes/data on the droplet.

```
make deleteinfra
```
