Litecoin: https://github.com/litecoin-project/litecoin

Image: https://quay.io/repository/exodusmovement/litecoind

Every new litecoin release have own branch where branch name is litecoin version. For each docker image release we create tag `BRANCH_NAME-xxx`, where `xxx` is release version for *current* branch. Docker image with latest tag is used only for development and contain last build (please do not use it for production!).

Branches and releases:

  - [0.15.1](https://github.com/ExodusMovement/docker-litecoind/tree/0.15.1)
    - [0.15.1-001](https://github.com/ExodusMovement/docker-litecoind/tree/0.15.1-001)
