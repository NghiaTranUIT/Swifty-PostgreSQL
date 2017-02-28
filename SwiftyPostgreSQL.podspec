#
#  Be sure to run `pod spec lint SwiftyPostgreSQL.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "SwiftyPostgreSQL"
  s.version      = "0.1.0"
  s.summary      = "Swifty-PostgreSQL driver on macOS, written by Swift 3.0."
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.homepage = 'http://nghiatran.me'
  s.social_media_url = 'http://nghiatran.me'
  s.author             = { "Nghia Tran" => "vinhnghiatran@gmail.com" }
  s.source = { :git => 'https://github.com/NghiaTranUIT/Swifty-PostgreSQL.git', :tag => s.version }

  s.platform = :osx
  s.osx.deployment_target = '10.12'

  s.source_files = 'Source/*.swift'
  s.frameworks = 'libpq'

end
