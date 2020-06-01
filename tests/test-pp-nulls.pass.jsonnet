local pp = import '../pp.libsonnet';

local o =
  {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      annotations: null,
      labels: null,
      name: 'test',
    },
  };

pp(object=o)
