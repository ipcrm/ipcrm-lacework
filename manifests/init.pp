# @summary This class is used to install the Lacework Agent onto a target machine
#
# This class will install the Lacework agent onto a target machine.  At a minimum, you must provide the access key to
# be used by the agent.   
#
# @example
#   class{'lacework':
#     access_token =>  "<your token here>"
#   }
#
# @param package_ensure
#   Used to configure a specific version of the agent to be installed.  Defaults to 'present'.
#
# @param service_ensure
#   Used to configure the service state.  Defaults to 'running'.
#
# @param pkg_manage_sources
#   Control if this module should add package repositories or not.  Defaults to true.
#
# @param access_token
#   Supply access token for the Lacework agent. See https://support.lacework.com/hc/en-us/articles/360036425594-Create-Agent-Access-Tokens-and-Download-Agent-Installers for info on access tokens. 
#
# @param agent_server_url
#    Supply the correct server api url. See https://docs.lacework.net/onboarding/agent-server-url for details.
#
# @param agent_server_url
#    Supply the correct server api url. See https://docs.lacework.net/onboarding/agent-server-url for details.
#
# @param config_tags
#   Provide agent tags.  See https://support.lacework.com/hc/en-us/articles/360008466893-Add-Agent-Tags for details on agent tags
#
# @param cmdlinefilter_allow
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#cmdlinefilter-property for details on 'allow'.
#
# @param cmdlinefilter_disallow
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#cmdlinefilter-property for details on 'allow'.
#    
# @param fim_filepath
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#filepath-property for details on the FIM 'filepath' property.
#
# @param fim_fileignore
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#fileignore-property for details on the FIM 'fileignore' property
#   
# @param fim_noatime
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#noatime-property for details on the FIM 'noatime' property
#
# @param fim_runat
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#runat-property for details on the FIM 'runat' property
#
# @param fim_mode
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#mode-property for details on the FIM 'mode' property
#
# @param container_engine_endpoint
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#containerengineendpoint-property for details on the 'container_engine_endpoint' parameter.
#
# @param proxyurl
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#proxyurl-property for details on using a proxy in the agent.
#
# @param perfmode
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#perfmode-property for details on the perfmode parameter.
#
# @param cpulimit
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#cpulimit-property for details on setting agent CPU limits.
#
# @param memlimit
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#memlimit-property for details on setting agent memory limits.
#  
# @param auto_upgrade
#   See https://support.lacework.com/hc/en-us/articles/360024365753-Configure-Agent-Behavior-in-config-json-File#autoupgrade-property for details on configuring agent auto-upgrades.
#
#
class lacework (
  String $access_token,
  Lacework::Agenturls $agent_server_url = 'https://api.lacework.net',
  String $package_ensure = 'present',
  String $service_ensure = 'running',
  Boolean $pkg_manage_sources = true,
  Optional[Hash[String, String]] $config_tags,
  Optional[String] $cmdlinefilter_allow,
  Optional[String] $cmdlinefilter_disallow,
  Optional[Array[String]] $fim_filepath,
  Optional[Array[String]] $fim_fileignore,
  Optional[Boolean] $fim_noatime,
  Optional[String] $fim_runat,
  Optional[String] $fim_mode,
  Optional[String] $container_engine_endpoint,
  Optional[String] $proxyurl,
  Optional[String] $perfmode,
  Optional[String] $cpulimit,
  Optional[String] $memlimit,
  Optional[String] $auto_upgrade,
) {
  class {  'lacework::files':
    access_token              => $access_token,
    agent_server_url          => $agent_server_url,
    agent_server_url          => $agent_server_url,
    config_tags               => $config_tags,
    proxyurl                  => $proxyurl,
    cmdlinefilter_allow       => $cmdlinefilter_allow,
    cmdlinefilter_disallow    => $cmdlinefilter_disallow,
    fim_filepath              => $fim_filepath,
    fim_fileignore            => $fim_fileignore,
    fim_noatime               => $fim_noatime,
    fim_mode                  => $fim_mode,
    fim_runat                 => $fim_runat,
    container_engine_endpoint => $container_engine_endpoint,
    perfmode                  => $perfmode,
    cpulimit                  => $cpulimit,
    memlimit                  => $memlimit,
    auto_upgrade              => $auto_upgrade,
  }

  class {  'lacework::pkg':
    pkg_manage_sources => $pkg_manage_sources,,
  }
  contain lacework::service

  Class['lacework::files']
  -> Class['lacework::pkg']
  -> Class['lacework::service']
}
