# -*- encoding: utf-8 -*-
# stub: octicons_helper 17.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "octicons_helper".freeze
  s.version = "17.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["GitHub Inc.".freeze]
  s.date = "2022-10-07"
  s.description = "A rails helper that makes including svg Octicons simple.".freeze
  s.email = ["support@github.com".freeze]
  s.homepage = "https://github.com/primer/octicons".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.33".freeze
  s.summary = "Octicons rails helper".freeze

  s.installed_by_version = "3.2.33" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<octicons>.freeze, ["= 17.7.0"])
    s.add_runtime_dependency(%q<railties>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<actionview>.freeze, [">= 0"])
  else
    s.add_dependency(%q<octicons>.freeze, ["= 17.7.0"])
    s.add_dependency(%q<railties>.freeze, [">= 0"])
    s.add_dependency(%q<actionview>.freeze, [">= 0"])
  end
end
