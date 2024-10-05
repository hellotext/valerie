Gem::Specification.new do |s|
  s.name = 'valerie'
  s.version = '0.0.1'
  s.summary = 'VCard (Contact Card) parser and generator.'
  s.description = 'VCard (Contact Card) parser and generator.'
  s.authors = ['Hellotext', 'Ahmed Khattab']
  s.files = 'lib/valerie.rb'
  s.homepage = 'https://github.com/hellotext/valerie'
  s.license = 'MIT'

  s.required_ruby_version = '>= 3.3.0'
  
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
end
