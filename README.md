This repo stores files used to build a [Discourse](https://www.discourse.org/) [Docker](https://www.docker.com/) image with [git](https://git-scm.com/) free of link to [libGnuTLS](https://www.gnutls.org).
It is based on the [official Docker base image](https://hub.docker.com/r/discourse/base) `discourse/base`, and tagged with `discourse/base:newgit`.

**Note**: this is not a standard way to install Discourse.
This repo may be useful only when you use proxy to do so.
See also this Discourse meta [post](https://meta.discourse.org/t/change-path-to-git-executable-for-discourse-docker-install/189096?u=minyez).

**注意**: 本仓库仅适用于需要代理 (以翻越 GFW) 来安装 Discourse 的朋友.
如果您的网络状态良好, 那么应该用不到本仓库.

## Synopsis

Users using proxy to install discourse container may experience the `gnutls_handshake()` error,
which is [caused by the use of libGnuTLS](https://askubuntu.com/questions/186847/error-gnutls-handshake-failed-when-connecting-to-https-servers). This is because the official Discourse image installs git from the Debian source, and although it uses `libcurl4-openssl-dev` as the SSL backend, it is linked to libGnuTLS due to use of [librtmp](https://linux.die.net/man/3/librtmp) and [libldap](https://www.openldap.org/).

To solve the `gnutls_handshake()` error, one needs to compile and install git with SSL support by OpenSSL instead of libGnuTLS in the Discourse image. This is done by modifying the [script](https://gist.github.com/seveas/6a00d20aa40f9ca677c96eb44a6c5140) offered by Shawna Jean and writing the install instructions in the Dockerfile. The modification is just disabling the use of librtmp and libldap in compiling curl,

```bash
./configure --without-gnutls --disable-ldap --without-librtmp
```

## Usage

1. Clone `discourse_docker`, and pull the official Discourse base image with `launcher`.
1. Run `build.sh` and check if the build succeeds
1. Modify the  `image` variable in `launcher` to `discourse/base:newgit`
1. Build the discourse container by rebuild.

During the last step, you may still encounter some network error when cloning GitHub repos, but should not be `gnutls_handshake` error.
In this case, you may try rebuild again, or find some repo mirror, e.g. mirrors on [gitee](https://gitee.com).

