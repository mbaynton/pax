class pax (
  Boolean $manage_repos,
  Boolean $manage_repo_trust
){
  Pax::Repo_helpers::Repo <| |> -> Package <| tag == pax_package |>

  if ($facts['os']['family'] == 'RedHat') {
    contain pax::repo_helpers::el
  }
}
