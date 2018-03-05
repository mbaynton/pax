function pax::cmd(String $name) {
  # Get the package name for this command
  $package = lookup("pax.cmd-package.${name}")

  # Ensure the package is included in the manifest
  pax::package($package)
}
