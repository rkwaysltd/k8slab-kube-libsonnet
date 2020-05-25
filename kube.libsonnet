local kube = import 'vendor/kube-libsonnet/kube.libsonnet';

local applabels = {
  metadata+: {labels: {app: $.metadata.name}},
};

