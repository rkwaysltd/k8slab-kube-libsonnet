local l = import '../k8slab.libsonnet';
local abkan = l.arrayByKindAndName;
local fromArr = l.arrayFromKindAndName;

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
      name: 'bar',
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

local test_result =
  std.assertEqual(
    abkan(t),
    {
      TestObject: {
        foo: t[0],
        bar: t[1],
      },
      TestOtherObject: {
        bar: t[2],
      },
    }
  ) &&
  std.assertEqual(
    fromArr(abkan(t)),
    t,
  ) &&
  true;

test_result
