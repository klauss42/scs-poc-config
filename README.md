# scs Proof-of-Concept Config

This repository contains the configuration for the [scs-poc](https://github.com/klauss42/scs-poc)
Applications.

To use the config locally start the consul server with the wrapper `consulw.sh`. That script downloads the consul binary if
the executable is not present in the path environment.

To get the config into consul you can use
 * `dev-git2consul.sh` to put the commited version or
 * `dev-data.yml2consul.sh` to put all local data.yml files
into the key value store.

You can also use the [Web UI](https://www.consul.io/intro/getting-started/ui.html) to add or edit configurations.
