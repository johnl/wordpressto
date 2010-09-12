Gem::Specification.new do |s|
  s.name    = 'wordpressto'
  s.version = '0.1'
  s.date    = '2010-09-12'
  
  s.summary = "A Ruby library to interact with the Wordpress XMLRPC interface"
  s.description = "A Ruby library to interact with the Wordpress XMLRPC interface"
  
  s.authors  = ['John Leach']
  s.email    = 'john@johnleach.co.uk'
  s.homepage = 'http://github.com/johnl/wordpressto'

	s.add_dependency('mime-types')

	s.add_development_dependency('rake')
	s.add_development_dependency('rspec')
  
  s.has_rdoc = true

  s.files = Dir.glob("lib/**/*")
  s.test_files = Dir.glob("spec/**/*")

  s.rdoc_options << '--title' << 'Wordpressto' <<
    '--main' << 'README.rdoc' <<
    '--line-numbers'

  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]

end
