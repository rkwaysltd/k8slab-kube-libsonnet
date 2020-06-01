local kube = import '../kube.libsonnet';

local test_pod = kube.Pod('foo') {
  metadata+: { labels+: { bar: 'pod_bar', qxx: 'pod_qxx' } },
  spec+: {
    containers_+: {
      foo: kube.Container('foo') {
        image: 'nginx',
        ports_: {
          http: { containerPort: 8080 },
          https: { containerPort: 8443 },
          udp: { containerPort: 5353, protocol: 'UDP' },
        },
      },
    },
  },
};

local test_deploy = kube.Deployment('foo') {
  metadata+: { labels+: { bar: 'deploy_bar', qxx: 'deploy_qxx' } },
  spec+: { template+: { metadata+: test_pod.metadata, spec+: test_pod.spec } },
};

local test_ds = kube.DaemonSet('foo') {
  metadata+: { labels+: { bar: 'ds_bar', qxx: 'ds_qxx' } },
  spec+: {
    template+: {
      spec: test_pod.spec,
    },
  },
};

local test_ss = kube.StatefulSet('foo') {
  metadata+: { labels+: { bar: 'ss_bar', qxx: 'ss_qxx' } },
  spec+: {
    template+: {
      spec: test_pod.spec,
    },
  },
};

local test_job = kube.Job('foo') {
  metadata+: { labels+: { bar: 'job_bar', qxx: 'job_qxx' } },
  spec+: {
    template+: {
      spec+: {
        containers_+: {
          foo_cont: kube.Container('foo-cont') {
            image: 'busybox',
          },
        },
      },
    },
  },
};

local test_cronjob = kube.CronJob('foo') {
  metadata+: { labels+: { bar: 'cronjob_bar', qxx: 'cronjob_qxx' } },
  spec+: {
    jobTemplate+: test_job.spec.template,
    schedule: '0 * * * *',
  },
};

local test_pdb = kube.PodDisruptionBudget('foo-pdb') {
  metadata+: { labels+: { bar: 'pdb_bar', qxx: 'pdb_qxx' } },
  target_pod: test_pod,
  spec+: { minAvailable: 1 },
};

local test_svc = kube.Service('foo-svc') {
  metadata+: { labels+: { bar: 'svc_bar', qxx: 'svc_qxx' } },
  target_pod: test_pod,
};

local test_result =
  std.assertEqual(
    kube.podLabelsSelector(test_deploy),
    { podSelector: { matchLabels: { name: 'foo', bar: 'pod_bar', qxx: 'pod_qxx', app: 'foo' } } }
  ) &&
  std.assertEqual(
    test_deploy.metadata.labels,
    { name: 'foo', app: 'foo', bar: 'deploy_bar', qxx: 'deploy_qxx' }
  ) &&
  std.assertEqual(
    test_deploy.spec.selector,
    { matchLabels: { app: 'foo' } }
  ) &&
  std.assertEqual(
    test_ds.metadata.labels,
    { name: 'foo', app: 'foo', bar: 'ds_bar', qxx: 'ds_qxx' }
  ) &&
  std.assertEqual(
    test_ds.spec.selector,
    { matchLabels: { app: 'foo' } }
  ) &&
  std.assertEqual(
    test_ss.metadata.labels,
    { name: 'foo', app: 'foo', bar: 'ss_bar', qxx: 'ss_qxx' }
  ) &&
  std.assertEqual(
    test_ss.spec.selector,
    { matchLabels: { app: 'foo' } }
  ) &&
  std.assertEqual(
    test_job.metadata.labels,
    { name: 'foo', app: 'foo', bar: 'job_bar', qxx: 'job_qxx' }
  ) &&
  std.assertEqual(
    test_cronjob.metadata.labels,
    { name: 'foo', app: 'foo', bar: 'cronjob_bar', qxx: 'cronjob_qxx' }
  ) &&
  std.assertEqual(
    test_pdb.metadata.labels,
    { name: 'foo-pdb', app: 'foo-pdb', bar: 'pdb_bar', qxx: 'pdb_qxx' }
  ) &&
  std.assertEqual(
    test_pdb.spec.selector,
    { matchLabels: { app: 'foo' } }
  ) &&
  std.assertEqual(
    test_svc.metadata.labels,
    { name: 'foo-svc', app: 'foo-svc', bar: 'svc_bar', qxx: 'svc_qxx' }
  ) &&
  std.assertEqual(
    test_svc.spec.selector,
    { app: 'foo' }
  ) &&
  true;
test_result
