// k8slab qbec post-processing
local gbp = (import 'k8slab.libsonnet').gbp;

// Common annotations:
// - com.gitlab.ci.cijoburl - CI job URL [$CI_JOB_URL]
// - com.gitlab.ci.revision - Git commit ID [$CI_COMMIT_SHA]
local common_annotations(obj) =
  local fix = if gbp(obj, ['metadata', 'annotations']) == null then {
    metadata+: {
      annotations: {},
    },
  } else {};
  obj + fix + {
    metadata+: {
      annotations+: {
        'com.gitlab.ci.cijoburl': std.extVar('com.gitlab.ci.cijoburl'),
        'com.gitlab.ci.revision': std.extVar('com.gitlab.ci.revision'),
      },
    },
  };

// Common labels:
// - rkways.com/prune-key - identify project and environment [$CI_PROJECT_PATH_SLUG-$CI_ENVIRONMENT_SLUG]
local common_labels(obj) =
  local fix = if gbp(obj, ['metadata', 'labels']) == null then {
    metadata+: {
      labels: {},
    },
  } else {};
  obj + fix + {
    metadata+: {
      labels+: {
        'rkways.com/prune-key': std.extVar('rkways.com/prune-key'),
      },
    },
  };

// Deployment, StatefulSet, DaemonSet `kubectl rollout history ...`
// https://kubernetes.io/docs/tasks/manage-daemon/rollback-daemon-set/
local change_cause_annotation(obj) = {
  metadata+: {
    annotations+: {
      'kubernetes.io/change-cause': std.extVar('kubernetes.io/change-cause'),
    },
  },
};

// Per-Kind changes
local transform_per_kind = {
  Deployment: [change_cause_annotation],
  StatefulSet: [change_cause_annotation],
  DaemonSet: [change_cause_annotation],
};

// Common changes
local transform_common = [
  common_annotations,
  common_labels,
];

// Common changes exceptions
local transform_uncommon_per_kind = {
  Namespace: [],
};

// qbec post-processing function
function(object)
  object
  + (
    if std.objectHas(transform_uncommon_per_kind, object.kind) then
      std.foldl(function(acc, fn) fn(acc), transform_uncommon_per_kind[object.kind], {})
    else
      std.foldl(function(acc, fn) fn(acc), transform_common, {})
  )
  + (
    if std.objectHas(transform_per_kind, object.kind) then
      std.foldl(function(acc, fn) fn(acc), transform_per_kind[object.kind], {})
    else {}
  )
