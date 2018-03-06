define pax::repo_helpers::repotrust (
  Hash $trust_info
) {
  create_resources($trust_info['resource'], {$title => $trust_info['params']})
}
