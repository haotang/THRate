Pod::Spec.new do |s|
  s.name     = 'THRate'
  s.version  = '0.1'
  s.platform = :ios, '6.1'
  s.license  = 'MIT'
  s.summary  = 'A rate kit for iOS.'
  s.homepage = 'https://github.com/haotang/THRate'
  s.authors   = { 'Hom Tang ' => 'th9188@yahoo.com' }
  s.source   = { :git => 'https://github.com/haotang/THRate.git', :tag => s.version.to_s }

  s.description = 'THRate is a rate kit for iOS.'

  s.source_files = 'THRate/*.{h,m}'
  s.requires_arc = true
end