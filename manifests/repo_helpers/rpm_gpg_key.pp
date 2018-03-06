define pax::repo_helpers::rpm_gpg_key (
  String $file,
  String $content,
) {
  file { $file:
    owner   => root,
    group   => root,
    mode    => '0644',
    content => $content,
  }

  exec { "pax::repo_helpers::rpm_gpg_import: ${title}":
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    require   => File[$file],
    unless    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids --keyid-format short < ${file}) | cut --characters=11-18 | tr '[A-Z]' '[a-z]')", # Credit https://github.com/stahnma/puppet-module-epel/blob/d5e090e6fa6797e66d745957582ecce90a5d36f7/manifests/rpm_gpg_key.pp#L24
    command   => "rpm --import ${file}",
    logoutput => 'on_failure'
  }
}
