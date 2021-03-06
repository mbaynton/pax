define pax::repo_helpers::repo(
  Hash $repo_info
) {
  case $repo_info['resource'] {
    'yumrepo': {
      $params = pax::repo_helpers::yumrepo_params($repo_info['params'])
    }
    default: {
      $params = $repo_info['params']
    }
  }

  create_resources($repo_info['resource'], {$name => $params})
}
