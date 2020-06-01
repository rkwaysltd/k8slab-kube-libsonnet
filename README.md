# kube.libsonnet library for k8slab project

- `kube.libsonnet` Fix for [kube-libsonnet issue #16](https://github.com/bitnami-labs/kube-libsonnet/issues/16).
- `k8slab.libsonnet` Helper functions for k8slab project.
- `pp.libsonnet` [Qbec](https://github.com/splunk/qbec) postprocessing.

## Usage

Please use [jsonnet bundler](https://github.com/jsonnet-bundler/jsonnet-bundler) to install this library and upstream dependency.

    jb install https://github.com/rkwaysltd/k8slab-kube-libsonnet

## Testing

    cd tests && make

## Upstream update

This project uses [jsonnet bundler](https://github.com/jsonnet-bundler/jsonnet-bundler).

    jb update
