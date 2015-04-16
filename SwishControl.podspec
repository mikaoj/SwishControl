Pod::Spec.new do |s|
  s.name             = "SwishControl"
  s.version          = "0.1.0"
  s.summary          = "Attach sound effects to UIControls"
  s.description      = <<-DESC
                       A cateogory on UIControl for adding sound effects for different events.
                       DESC
  s.homepage         = "https://github.com/mikaoj/SwishControl"
  s.license          = 'MIT'
  s.author           = { "Joakim Gyllstrom" => "joakim@backslashed.se" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/SwishControl.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.private_header_files = 'Pod/Classes/BSSoundContainer.h'
  s.frameworks = 'UIKit', 'AudioToolbox'
end
