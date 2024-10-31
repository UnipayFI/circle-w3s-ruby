lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "circle_wallets/version"

Gem::Specification.new do |spec|
  spec.name = "circle_wallets"
  spec.version = CircleWallets::VERSION
  spec.authors = ["Madao-3"]
  spec.email = ["madao.chris@gmail.com"]

  spec.summary = "Circle User Controlled Wallets API Ruby SDK"
  spec.description = "Ruby SDK for Circle's User Controlled Wallets API"
  spec.homepage = "https://github.com/Madao-3/circle_wallets"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.files = Dir.glob("{lib}/**/*") + %w[README.md]
  
  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "json", "~> 2.0"
  spec.add_dependency "eth", "~> 0.5.9"
  spec.add_dependency "jwt", "~> 2.7"
  
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "dotenv", "~> 2.7"
end