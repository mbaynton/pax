function pax::repo(String $name) {
  $repo_info = lookup("pax::repo.${name}")

  # Ensure any required repository trust configuration is imported.
  if (has_key($repo_info, 'repotrust')) {
    $repo_require = [Pax::Repo_helpers::Repotrust[$repo_info['repotrust']]]

    if (! defined(Pax::Repo_helpers::Repotrust[$repo_info['repotrust']])) {
      $trust_info = lookup("pax::repotrust.${repo_info['repotrust']}")
      pax::repo_helpers::repotrust{ $repo_info['repotrust']:
        trust_info => $trust_info
      }
    }
  } else {
    $repo_require = undef
  }

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
