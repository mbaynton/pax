# == Function: pax::cmd
#
# Function used to install a command or other piece of
# software by its pax canonical name. For software commonly
# run from the command line whose name is consistent from
# distribution to ditribution (things like awk), its pax 
# canonical name should be what you expect.
#
# Internally, the pax database translates the cmd name to
# the name of the package that contains that command on your
# operating system, and installs that package. As a result,
# using this function in your manifests is, to the extent
# the pax database has knowledge, OS independent.
#
# === Parameters
#
# [*name*]
#   The name of the command or software to install.
#
# === Return
#   An array of Resource types that were added to the manifest as a result
#   of calling this function.
#   You can use this, for example, in require => metaparameters.
function pax::cmd(String $name) >> Array[Type[Resource]] {
  # Get the package name for this command
  $package = lookup("pax::cmd-package.${name}")

  # Ensure the package is included in the manifest
  pax::package($package)
}
