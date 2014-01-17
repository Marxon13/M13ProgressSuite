Pod::Spec.new do |s|

<<<<<<< HEAD
  s.name         = "M13ProgressSuite"
  s.version      = "1.0.0"
  s.summary      = "A suite containing many tools to display progress information on iOS."

  s.description  = <<-DESC
                   M13ProgressSuite includes many diffrent of styles of progress views: bar, ring, pie, etc. It also includes a HUD overlay and a UINavigationController with progress bar built in.
                   DESC

  s.homepage     = "https://github.com/Marxon13/M13ProgressSuite"
  s.license      = {:type => 'MIT',
                    :text => <<-LICENSE
 Copyright (c) 2013 Brandon McQuilkin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

    LICENSE
 }

  s.author             = { "Brandon McQuilkin" => "marxon13@yahoo.com" }

  s.platform     = :ios, '7.0'

  s.source       = { :git => "https://github.com/Marxon13/M13ProgressSuite.git"}

  s.source_files  = 'Classes/*/*'

  s.frameworks = 'Foundation', 'UIKit', 'QuartzCore', 'CoreImage', 'Accelerate', 'CoreGraphics'
=======


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

>>>>>>> b736abe86233310d24ae226402a9c05c37c3b6b6
end
