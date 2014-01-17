Pod::Spec.new do |s|



  s.name         = "M13ProgressSuite"
  s.version      = "1.0"
  s.summary      = "A suite containing many tools to display progress information on iOS."

  s.description  = <<-DESC
                   All of which can be accessed by index, or key. This class is not a minimally finished class, with one or two methods. It follows Apple's subclassing protocols for NSArray and NSDictionary. It has methods comparable to all of NSArray's methods and all of NSDictionary's methods. It also supports NSCoding, NSCopying, KVO, and supports NSFastEnumeration over the objects or keys. It is the only fully implemented ordered dictionary class.
                   DESC

  s.homepage     = "https://github.com/Marxon13/M13ProgressSuite"


  s.license      = 'MIT'




  s.author       = { "Brandon McQuilkin" => "marxon13@yahoo.com" }



  s.ios.deployment_target = '7.0'



  s.source       = { :git => "https://github.com/Marxon13/M13ProgressSuite.git", :tag => "v#{s.version}" }


 

  s.source_files  = 'M13ProgressView/Classes/{Console,HUD,Progress Views,UINavigationController}/*

  s.framework  = 'Foundation','Accelerate','CoreImage','QuartzCore','CoreGraphics','UIKit'

  s.requires_arc = true

end
