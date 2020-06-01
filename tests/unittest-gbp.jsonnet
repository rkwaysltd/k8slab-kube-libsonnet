local l = import '../k8slab.libsonnet';
local gbp = l.gbp;

local test_object = {
  name: 'foo',
  metadata: {
    name: 'bar',
    labels: {
      test: true,
    },
  },
};

local test_result =
  /* empty path returns object itself */
  std.assertEqual(
    gbp(test_object, []),
    test_object
  ) &&
  /* path by array */
  std.assertEqual(
    gbp(test_object, ['metadata', 'name']),
    'bar'
  ) &&
  /* path by string */
  std.assertEqual(
    gbp(test_object, 'metadata.name'),
    'bar'
  ) &&
  /* default value */
  std.assertEqual(
    gbp(test_object, 'metadata.annotations', {}),
    {}
  ) &&
  /* long name */
  std.assertEqual(
    l.getByPath(test_object, 'metadata.annotations', {}),
    {}
  ) &&
  true;

test_result
