# @summary This class is used to control package repositories and package installation for the Lacework agent.
# @api private
#
class lacework::pkg (
  $pkg_manage_sources,
  $pkg_base_url,
  $pkg_apt_key,
) {
  case $::facts['os']['family'] {

    'Debian': {

      if $pkg_manage_sources {
        $os_name = downcase($::facts['os']['name'])
        $os_major = $::facts['os']['release']['major']
        $os_codename = $::facts['os']['distro']['codename']

        include apt
        apt::key { 'lacework':
          id     => $pkg_apt_key,
          server => 'keyserver.ubuntu.com',
        }

        apt::source { 'lacework':
          location => "${pkg_base_url}/DEB/${os_name}/${os_major}",
          release  => $os_codename,
          repos    => 'main',
          notify   => Exec['apt_update'],
          require  =>  Apt::Key['lacework'],
        }
        $require = Apt::Source['lacework']
      } else {
        $require = undef
      }

      package {'lacework':
        ensure  => $lacework::package_ensure,
        require => $require,
      }
    }

    'RedHat': {

      if $pkg_manage_sources {
        yumrepo { 'lacework':
          descr   => 'Lacework',
          enabled => 1,
          baseurl => "${pkg_base_url}/RPMS/x86_64/",
          gpgkey  => "${pkg_base_url}/keys/RPM-GPG-KEY-lacework",
        }
        $require = Yumrepo['lacework']
      } else {
        $require = Yumrepo['lacework']
      }

      package {'lacework':
        ensure  => $lacework::package_ensure,
        require => $require,
      }
    }

    default: {
      fail('Unsupported OS')
    }

  }

}
