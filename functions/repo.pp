function pax::repo(String $name) {
  if ! defined(Class['pax']) {
    fail('You must include the pax base class before using any pax functions.')
  }

  if ($::pax::manage_repos or $::pax::manage_repo_trust) {
    $repo_info = lookup("pax::repo.${name}")

    if ($::pax::manage_repo_trust) {
      # Ensure any required repository trust configuration is imported.
      if (has_key($repo_info, 'repotrust')) {
        $repo_require = [Pax::Repo_helpers::Repotrust[$repo_info['repotrust']]]

        if (! defined(Pax::Repo_helpers::Repotrust[$repo_info['repotrust']])) {
          $trust_info = lookup("pax::repotrust.${repo_info['repotrust']}")
          pax::repo_helpers::repotrust{ $repo_info['repotrust']:
            trust_info => $trust_info,
          }
        }
      } else {
        $repo_require = undef
      }
    } else {
      $repo_require = undef
    }

    if ($::pax::manage_repos) {
      # Repository resources are of types specified in yaml data, and there is no
      # defined() syntax for resource types specified as data, so wrap the resource
      # creation in a defined resource type of our own.
      $resource = $repo_info['resource']
      $title = "${resource}/${name}"
      if (! defined(Pax::Repo_helpers::Repo[$title])) {
        pax::repo_helpers::repo{ $title:
          name      => $name,
          require   => $repo_require,
          repo_info => $repo_info,
        }
      }
    }
  }
}
