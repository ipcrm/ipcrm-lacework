# @summary This class is used to control required files for the lacework agent, including config.json
# @api private
#
class lacework::files (
  $access_token,
  $agent_server_url,
  $config_tags,
  $proxyurl,
  $cmdlinefilter_allow,
  $cmdlinefilter_disallow,
  $fim_filepath,
  $fim_fileignore,
  $fim_noatime,
  $fim_mode,
  $fim_runat,
  $perfmode,
  $cpulimit,
  $memlimit,
  $auto_upgrade,
  $container_engine_endpoint,
  $base_path = '/var/lib/lacework',
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
    agent_server_url          => $agent_server_url,
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
