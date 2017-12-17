Pod::Spec.new do |s|
  s.name         = "Sageru"
  s.version      = "0.3.0"
  s.summary      = "It is a menu library inspired by the music application, AWA."
  s.description  = <<-DESC
                    - It is a menu library inspired by the music application, AWA.
                   DESC
  s.homepage     = "https://github.com/hakota/Sageru"
  s.license      = { :type => "MIT" }
  s.author             = { "Kenta Araki" => "araki.kenta.db@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/hakota/Sageru.git", :tag => s.version }
  s.source_files  = "Sageru/**/*.swift"
  s.requires_arc = true
end
