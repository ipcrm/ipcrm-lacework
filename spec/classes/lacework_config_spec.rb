
# frozen_string_literal: true

require 'spec_helper'
require 'json'

describe 'lacework' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:conf_path) { '/var/lib/lacework/config/config.json' }
      let(:params) do
        { 'access_token' => 'no' }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('lacework::files') }

      describe 'lacework::files' do
        it { is_expected.to contain_file(conf_path).with('content' => %r{\"AccessToken\"\: \"no\"}) }
      end
    end

    context "with full params #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'access_token'              => 'no',
          'proxyurl'                  => 'proxy.host',
          'config_tags'               => { 'a' => 'b', 'b' => 'c' },
          'perfmode'                  => 'lite',
          'cpulimit'                  => '500m',
          'memlimit'                  => '750M',
          'auto_upgrade'              => 'disabled',
          'container_engine_endpoint' => 'tcp://0.0.0.0:2375',
          'cmdlinefilter_allow'       => '/bin/echo,/bin/ls',
          'cmdlinefilter_disallow'    => '/bin/java,/bin/node',
          'fim_filepath'              => ['/home/test/.ssh'],
          'fim_fileignore'            => ['/etc/fstab'],
          'fim_runat'                 => '23:50',
          'fim_mode'                  => 'disable',
          'fim_noatime'               => true,
        }
      end

      it { is_expected.to compile.with_all_deps }
      describe 'lacework::files' do
        it {
          json_data = catalogue.resource('file', '/var/lib/lacework/config/config.json').send(:parameters)[:content]
          File.write('/tmp/f.json', json_data)
          parsed = JSON.parse(json_data)
          expect(parsed['tokens']['AccessToken']).to eq('no')
          expect(parsed['tags']).to eq({ 'a' => 'b', 'b' => 'c' })
          expect(parsed['proxyurl']).to eq('proxy.host')
          expect(parsed['perfmode']).to eq('lite')
          expect(parsed['cpulimit']).to eq('500m')
          expect(parsed['memlimit']).to eq('750M')
          expect(parsed['AutoUpgrade']).to eq('disabled')
          expect(parsed['ContainerEngineEndpoint']).to eq('tcp://0.0.0.0:2375')
          expect(parsed['cmdlinefilter']).to eq({ 'allow' => '/bin/echo,/bin/ls', 'disallow' => '/bin/java,/bin/node' })
          expect(parsed['fim']['filepath']).to eq(['/home/test/.ssh'])
          expect(parsed['fim']['fileignore']).to eq(['/etc/fstab'])
          expect(parsed['fim']['runat']).to eq('23:50')
          expect(parsed['fim']['mode']).to eq('disable')
          expect(parsed['fim']['noatime']).to eq('true')
        }
      end
    end
  end
end
