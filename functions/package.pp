function pax::package(String $name) {
  # Ensure the required repository is ready.
  $package_info = lookup("pax.package.${name}")
  pax::repo($package_info['repo'])

  $default_params = lookup('pax.defaults.package')
  $override_params = $package_info['params']
  if (defined('$package_info[\'params\']')) {
    $override_params = $package_info['params']
  } else {
    $override_params = {}
  }

  $params = merge($default_params, $override_params)

  # Include the package, if it is not already in the catalog.
  if (! defined(Package[$name])) {
    package { $name:
      * => $params
    }
  }
}
