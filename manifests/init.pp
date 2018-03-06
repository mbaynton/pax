class pax {
  Pax::Repo_helpers::Repo <| |> -> Package <| |>

  if ($facts['os']['family'] == 'RedHat') {
    include pax::repo_helpers::el
  }
}
