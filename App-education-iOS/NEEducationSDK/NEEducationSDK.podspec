#
# Be sure to run 'pod lib lint NEEducationLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NEEducationSDK'
  s.version          = '1.0.0'
  s.summary          = 'A short description of NEEducationSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://yunxin.163.com/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NetEase, Inc.' => 'guoyuanyuan02@corp.netease.com'}
  s.source           = { :path => '' }

  s.ios.deployment_target = '10.0'
  s.vendored_frameworks = '**/*.framework'
  s.dependency 'NEDyldYuv', '0.0.1'
  s.dependency 'NERtcSDK', '3.8.1'
  s.dependency 'NIMSDK_LITE', '~> 7.9.1'
  s.dependency 'Reachability'
  s.dependency 'YYModel', '~> 1.0.4'
  s.dependency 'Nama-lite', '7.1.2'
end
