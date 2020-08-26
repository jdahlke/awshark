lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'awshark/version'

Gem::Specification.new do |spec|
  spec.name          = 'awshark'
  spec.version       = Awshark::VERSION
  spec.authors       = ['Joergen Dahlke']
  spec.email         = ['joergen.dahlke@infopark.de']

  spec.summary       = %q{Simple CLI for for aws related tasks}
  spec.description   = %q{Simple CLI for for aws related tasks}
  spec.homepage      = 'https://github.com/jdahlke/awshark'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/jdahlke/awshark'
  spec.metadata['changelog_uri'] = 'https://github.com/jdahlke/awshark/blob/develop/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'aws-sdk-cloudformation'
  spec.add_dependency 'aws-sdk-cloudwatch'
  spec.add_dependency 'aws-sdk-ec2'
  spec.add_dependency 'aws-sdk-rds'
  spec.add_dependency 'aws-sdk-s3'
  spec.add_dependency 'mini_mime'
  spec.add_dependency 'thor', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec'
end
