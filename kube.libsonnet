local kube = import 'kube-libsonnet/kube.libsonnet';

local applabels = {
  metadata+: { labels+: { app: $.metadata.name } },
};

local fix_selector = {
  spec+: { selector+: { matchLabels: { app: $.metadata.labels.app } } },
};

local fix_selector_pdb = {
  spec+: { selector+: { matchLabels: { app: $.target_pod.metadata.labels.app } } },
};

local fix_selector_svc = {
  spec+: { selector: { app: $.target_pod.metadata.labels.app } },
};

kube {
  Deployment(name):: kube.Deployment(name) + applabels + fix_selector,
  Pod(name):: kube.Pod(name) + applabels,
  DaemonSet(name):: kube.DaemonSet(name) + applabels + fix_selector,
  StatefulSet(name):: kube.StatefulSet(name) + applabels + fix_selector,
  Job(name):: kube.Job(name) + applabels,
  CronJob(name):: kube.CronJob(name) + applabels,
  PodDisruptionBudget(name):: kube.PodDisruptionBudget(name) + applabels + fix_selector_pdb,
  Service(name):: kube.Service(name) + applabels + fix_selector_svc,
}
