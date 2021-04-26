# @summary This class is used to control the Lacework service.
# @api private
#
class lacework::service {
  service {'datacollector':
    ensure  => $lacework::service_ensure,
    require =>  Package['lacework'],
  }
}
