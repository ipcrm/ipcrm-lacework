# @summary
#    This class is used to control required files for the lacework agent, including config.json
# @api private
#
class lacework::files (
  String $access_token,
  Stdlib::HTTPSUrl $agent_server_url,
  Optional[Hash[String, String]] $config_tags,
  Optional[String] $proxyurl,
  Optional[String] $cmdlinefilter_allow,
  Optional[String] $cmdlinefilter_disallow,
  Optional[Array[String]] $fim_filepath,
  Optional[Array[String]] $fim_fileignore,
  Optional[Boolean] $fim_noatime,
  Optional[String] $fim_mode,
  Optional[String] $fim_runat,
  Optional[String] $perfmode,
  Optional[String] $cpulimit,
  Optional[String] $memlimit,
  Optional[String] $auto_upgrade,
  Optional[String] $container_engine_endpoint,
  Stdlib::Absolutepath $base_path = '/var/lib/lacework',
) {
  if $cmdlinefilter_allow or $cmdlinefilter_disallow {
    $cmdlinefilter = {
      allow    => pick_default($cmdlinefilter_allow, ''),
      disallow => pick_default($cmdlinefilter_disallow, ''),
    }
  } else {
    $cmdlinefilter = undef
  }

  if $fim_filepath or $fim_fileignore or $fim_noatime or $fim_mode or $fim_runat {
    $fim = {
      filepath   => $fim_filepath,
      fileignore => $fim_fileignore,
      mode       => $fim_mode,
      noatime    => String($fim_noatime),
      runat      => $fim_runat,
    }
    $fim_filtered = $fim.filter |$key, $val| { $val =~ NotUndef }
  } else {
    $fim_filtered = undef
  }

  $params = {
    tokens                    => { 'AccessToken' => $access_token },
    serverurl                 => $agent_server_url,
    serverurl                 => $agent_server_url,
    'AutoUpgrade'             => $auto_upgrade,
    'ContainerEngineEndpoint' => $container_engine_endpoint,
    proxyurl                  => $proxyurl,
    tags                      => $config_tags,
    perfmode                  => $perfmode,
    cmdlinefilter             => $cmdlinefilter,
    fim                       => $fim_filtered,
    cpulimit                  => $cpulimit,
    memlimit                  => $memlimit,
  }
  $params_filtered = $params.filter |$key, $val| { $val =~ NotUndef }

  file { [$base_path, "${base_path}/config"]:
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "${base_path}/config/config.json":
    ensure    => 'file',
    mode      => '0640',
    owner     => 'root',
    group     => 'root',
    content   => to_json_pretty($params_filtered),
    notify    => Service['datacollector'],
    show_diff => false,
  }
}
