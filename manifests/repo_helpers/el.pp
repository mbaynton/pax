class pax::repo_helpers::el {
  if $::operatingsystemmajrelease {
    $releasever = $::operatingsystemmajrelease
  } elsif $::os_maj_version {
    $releasever = $::os_maj_version
  } else {
    $releasever = inline_template('<%= @operatingsystemrelease.split(".").first %>')
  }
}
