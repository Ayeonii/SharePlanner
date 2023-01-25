# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

use_frameworks!

def commonPod 
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'Swinject'
  
  #Rx
  pod 'RxSwift', '6.1.0'
  pod 'RxGesture', '4.0.2'
  pod 'RxKeyboard', '2.0.0'
  pod 'ReactorKit', '3.2.0'
  
  #UI
  pod 'SnapKit'
  pod 'Then'
  
end

target 'SharePlanner' do
  commonPod
end

target 'SharePlannerTests' do
  commonPod
  pod 'RxTest'
  pod 'RxBlocking'
end
