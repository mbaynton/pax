# == Function: pax::package
#
# Function used to install a package by the name known to your OS's
# package manager.
#
# === Parameters
#
# [*name*]
#   The name of the package to install.
#
# === Return
#   An array of Resource types that were added to the manifest as a result
#   of calling this function.
#   You can use this, for example, in require => metaparameters.
function pax::package(String $name) >> Array[Type[Resource]] {
  # Ensure the required repository is ready.
  $package_info = lookup("pax::package.${name}")
  pax::repo($package_info['repo'])

  $default_params = lookup('pax::defaults.package')
  if ($package_info.has_key('params')) {
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

  # Return the Package we selected, so callers can set up ordering relationships.
  [Package[$name]]
}
