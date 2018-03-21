class pax {
  Pax::Repo_helpers::Repo <| |> -> Package <| |>

  if ($facts['os']['family'] == 'RedHat') {
    contain pax::repo_helpers::el
  }
}
