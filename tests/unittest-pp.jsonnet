local pp = import '../pp.libsonnet';

local test_object = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    annotations: null,
    labels: null,
    name: 'test',
  },
};

local test_result =
  // handle null labels/annotations
  std.assertEqual(
    pp(test_object),
    {
      apiVersion: 'v1',
      kind: 'ServiceAccount',
      metadata: {
        annotations: { 'com.gitlab.ci.cijoburl': 'test', 'com.gitlab.ci.revision': 'test' },
        labels: { 'rkways.com/prune-key': 'test' },
        name: 'test',
      },
    }
  ) &&
  // don't wipe out existing annotations
  std.assertEqual(
    pp(test_object {
      metadata+: {
        annotations: { check: 'this' },
      },
    }),
    {
      apiVersion: 'v1',
      kind: 'ServiceAccount',
      metadata: {
        annotations: { 'com.gitlab.ci.cijoburl': 'test', 'com.gitlab.ci.revision': 'test', check: 'this' },
        labels: { 'rkways.com/prune-key': 'test' },
        name: 'test',
      },
    }
  ) &&
  // don't wipe out existing labels
  std.assertEqual(
    pp(test_object {
      metadata+: {
        labels: { check: 'this' },
      },
    }),
    {
      apiVersion: 'v1',
      kind: 'ServiceAccount',
      metadata: {
        annotations: { 'com.gitlab.ci.cijoburl': 'test', 'com.gitlab.ci.revision': 'test' },
        labels: { 'rkways.com/prune-key': 'test', check: 'this' },
        name: 'test',
      },
    }
  ) &&
  true;

test_result
