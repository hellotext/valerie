Gem::Specification.new do |s|
  s.name = 'valerie'
  s.version = '0.0.3'
  s.summary = 'Easily parse and generate VCard (Contact Card) objects that can be exported to other systems with ease.'
  s.description = 'VCard (Contact Card) parser and generator.'
  s.authors = ['Hellotext', 'Ahmed Khattab']
  s.files = 'lib/valerie.rb'
  s.homepage = 'https://github.com/hellotext/valerie'
  s.license = 'MIT'

  s.required_ruby_version = '>= 3.3.0'
  
  s.add_development_dependency 'minitest', '~> 5.14'
  s.add_development_dependency 'rake', '~> 13.0'
end
