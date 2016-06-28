Pod::Spec.new do |s|

  s.name         = "Forest"
  s.version      = "0.1.0"
  s.summary      = "A collection of persistent immutable trees."

  s.description  = <<-DESC
                   A collection of persistent immutable trees.
                   DESC

  s.homepage     = "https://github.com/regexident/Forest"
  s.license      = { :type => 'BSD-3', :file => 'LICENSE' }
  s.author       = { "Vincent Esche" => "regexident@gmail.com" }
  s.source       = { :git => "https://github.com/regexident/Forest.git", :tag => '0.1.0' }
  s.source_files = "Forest/Classes/*.{swift,h,m}"
  # s.public_header_files = "Forest/*.h"
  s.requires_arc = true
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  
end
