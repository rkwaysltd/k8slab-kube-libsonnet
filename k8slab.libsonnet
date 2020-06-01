local projectName = std.extVar('com.gitlab.ci.project');
local tag = std.extVar('qbec.io/tag');
{
  name(baseName=projectName)::
    if tag == '' then baseName else baseName + '-' + tag,
}
