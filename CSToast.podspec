Pod::Spec.new do |s|
  s.name         = "CSToast"
  s.version      = "0.0.1"
  s.summary      = "本工具是一个简单的提示框（Toast）"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'Joslyn' => 'cs_joslyn@foxmail.com' }
  s.homepage     = 'https://github.com/JoslynWu/CSToast'
  s.social_media_url   = "http://www.jianshu.com/u/fb676e32e2e9"

  s.ios.deployment_target = '8.0'

  s.source       = { :git => 'https://github.com/JoslynWu/CSToast.git', :tag => s.version }
  
  s.source_files = 'Sources/*.swift'

end

