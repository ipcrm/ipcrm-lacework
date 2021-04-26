require 'spec_helper_acceptance'

pp_basic = <<-PUPPETCODE
  class {'lacework':
    # access_token => "no",
    # config_tags => {
      # test => "b",
      # testa => "c",
      # testb => "d",
      # testc => "e",
    # }


          access_token              => 'no',
          proxyurl                  => 'proxy.host',
          config_tags               => {a => 'b', b => 'c'},
          perfmode                  => 'lite',
          cpulimit                  => '500m',
          memlimit                  => '750M',
          auto_upgrade              => 'disabled',
          container_engine_endpoint => 'tcp://0.0.0.0:2375',
          cmdlinefilter_allow       => "/bin/echo,/bin/ls",
          cmdlinefilter_disallow    => "/bin/java,/bin/node",
          fim_filepath              => ["/home/test/.ssh"],
          fim_fileignore            => ["/etc/fstab"],
          fim_runat                 => "23:50",
          fim_mode                  => "disable",
          fim_noatime               => true,

  }
PUPPETCODE

describe 'lacework class' do
  describe 'withba basic test' do
    it 'sets up the service' do
      idempotent_apply(pp_basic)
      expect(service('datacollector')).to be_running
      expect(service('datacollector')).to be_enabled
    end
  end
end
