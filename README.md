# Fake KAMAR Portal
KAMAR rate limits requests, blocks you sporadically and often times outs, making testing difficult.

This ruby server listens on `localhost:2019`, which you use instead of your portal URL.

## Install
```sh
gem install bundler
bundle install
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout pkey.pem -out cert.crt
```

## Run
```sh
ruby server.rb
```

## Download and store data from real portal
It can cache data for multiple students. If you do this, the `key` must have access to all accounts, viz. it must be a master key.
```sh
ruby download.rb keyyyyyyyy StuID_1 StuID_2 ... StuID_n
```
e.g. `node download abc123def456 15201 15999 13798`
