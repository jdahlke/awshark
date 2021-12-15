# frozen_string_literal: true

RSpec.describe Awshark::Ecs::Manager do
  let(:manager) { described_class.new }
  let(:cluster) { Awshark::Ecs::Cluster.new('example') }
  let(:service) do
    Aws::ECS::Types::Service.new({
      cluster_arn: 'arn:aws:ecs:us-east-1:012345678910:cluster/default',
      created_at: Time.parse('2016-08-29T16:25:52.130Z'),
      deployment_configuration: {
        maximum_percent: 200,
        minimum_healthy_percent: 100
      },
      deployments: [
        {
          created_at: Time.parse('2016-08-29T16:25:52.130Z'),
          desired_count: 1,
          id: 'ecs-svc/9223370564341623665',
          pending_count: 0,
          running_count: 0,
          status: 'PRIMARY',
          task_definition: 'arn:aws:ecs:us-east-1:012345678910:task-definition/hello_world:6',
          updated_at: Time.parse('2016-08-29T16:25:52.130Z')
        }
      ],
      desired_count: 1,
      events: [],
      load_balancers: [],
      pending_count: 0,
      running_count: 0,
      service_arn: 'arn:aws:ecs:us-east-1:012345678910:service/ecs-simple-service',
      service_name: 'ecs-simple-service',
      status: 'ACTIVE',
      task_definition: 'arn:aws:ecs:us-east-1:012345678910:task-definition/hello_world:6'
    })
  end

  describe '#clusters' do
    it 'returns array of Ecs::Cluster' do
      expect(manager.clusters).to all(be_an(Awshark::Ecs::Cluster))
    end
  end

  describe '#inspect_cluster' do
    it 'returns String' do
      expect(manager.inspect_cluster(cluster)).to be_kind_of(String)
    end
  end

  describe '#inspect_service' do
    it 'returns String' do
      expect(manager.inspect_service(service)).to be_kind_of(String)
    end
  end
end
