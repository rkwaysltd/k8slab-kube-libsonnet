local l = import '../k8slab.libsonnet';
local abkan = l.arrayByKindAndName;

local t = [
  {
    kind: 'TestObject',
    metadata: {
      name: 'foo',
      foo: 'foo',
    },
  },
  {
    kind: 'TestObject',
    metadata: {
      name: 'foo',
      bar: 'bar',
    },
  },
  {
    kind: 'TestOtherObject',
    metadata: {
      name: 'bar',
      bar: 'bar',
    },
  },
];
abkan(t)
