function pax::repo(String $name) {
  $repo_info = lookup("pax.repo.${name}")

  # Repository resources are of types specified in yaml data, and there is no
  # defined() syntax for resource types specified as data, so wrap the resource
  # creation in a defined resource type of our own.
  $title = "${repo_info['resource']}/${name}"
  if (! defined(Pax::Repo_helpers::Repo[$title])) {
    pax::repo_helpers::repo{ $title:
      name  => $name,
      stage => 'pax-repos',
      *     => $repo_info
    }
  }
}
