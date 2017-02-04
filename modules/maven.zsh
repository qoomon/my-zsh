autoload +X -U colors && colors



function mvn_project_version {
  'mvn' exec:exec -Dexec.executable='echo' -Dexec.args='${project.version}' --quiet --non-recursive 
}

function mvn_project_version_all {
  'mvn' exec:exec -Dexec.executable='echo' -Dexec.args='${project.version}' --quiet
}