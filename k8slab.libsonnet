local projectName = std.extVar('com.gitlab.ci.project');
local tag = std.extVar('qbec.io/tag');
{
  /* Return name with optional tag added */
  name(baseName=projectName)::
    if tag == '' then baseName else baseName + '-' + tag,

  /* Returns object's element pointed by path (string with dots or array of strings) */
  getByPath:: self.gbp,
  gbp(obj, path, defval=null)::
    local pathType = std.type(path);
    local _gbp(obj, path, defval) =
      local l = std.length(path);
      if l == 0 then
        obj
      else
        local e = path[0];
        if std.objectHas(obj, e) then
          _gbp(obj[e], path[1:l], defval)
        else defval;
    ({
       [pathType]: error '%s.gbp(obj, path, defval) called with unsupported path type "%s", should be string or array' % [std.thisFile, pathType],
     } + {
       string: _gbp(obj, std.split(path, '.'), defval),
       array: _gbp(obj, path, defval),
     })[pathType],

  /* Transforms array of Kubernetes objects into object.Kind.Name structure */
  arrayByKindAndName(arr)::
    local f(acc, e) =
      acc {
        [e.kind]+: {
          [e.metadata.name]+: e {
            local prev = if '_arrayByKindAndNameAssert' in super then super._arrayByKindAndNameAssert else 0,
            _arrayByKindAndNameAssert:: prev + 1,
            assert self._arrayByKindAndNameAssert == 1 : '%s.arrayByKindAndName() detected duplicate object (same Kind:%s and Name:%s)' % [std.thisFile, e.kind, e.metadata.name],
          },
        },
      };
    std.foldl(f, arr, {}),
}
