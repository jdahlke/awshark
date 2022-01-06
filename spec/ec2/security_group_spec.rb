# frozen_string_literal: true

RSpec.describe Awshark::Ec2::SecurityGroup do
  let(:security_group_id) { 'security-group-id' }
  let(:username) { 'fake-user-name' }
  let(:group) { described_class.new(id: security_group_id, username: username) }

  describe '#authorize' do
    let(:ip) { '127.0.0.1' }
    let(:ports) { [80, 443] }

    it 'creates ingress rule for IP address' do
      expect(Awshark.config.ec2.client).to receive(:authorize_security_group_ingress).with({
        group_id: 'security-group-id',
        ip_permissions: [{
          from_port: 443,
          ip_protocol: 'tcp',
          ip_ranges: [{ cidr_ip: '127.0.0.1/32', description: 'fake-user-name' }],
          to_port: 443
        }]
      })
      expect(Awshark.config.ec2.client).to receive(:authorize_security_group_ingress).with({
        group_id: 'security-group-id',
        ip_permissions: [{
          from_port: 80,
          ip_protocol: 'tcp',
          ip_ranges: [{ cidr_ip: '127.0.0.1/32', description: 'fake-user-name' }],
          to_port: 80
        }]
      })

      group.authorize(ip: ip, ports: ports)
    end
  end

  describe '#unauthorize' do
    context 'when no ingress rules for username exists' do
      it 'removes no ingress rule' do
        expect(Awshark.config.ec2.client).to receive(:describe_security_groups).once.and_call_original

        group.unauthorize
      end
    end
  end
end
