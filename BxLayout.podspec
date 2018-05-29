Pod::Spec.new do |s|

    s.name             = 'BxLayout'
    s.version = '1.0.3'
    s.swift_version    = '4.1'
    s.summary          = 'Descriptive Autolayout for iOS in Swift.'

    s.description      = 'BxLayout aims to make UIKit\'s autolayout as easy as possible.'\
                         ' It provides a declarative and intutitive API that tries to'\
                         ' depict as precisely as possible the way one speaks about'\
                         ' layouting.'

    s.homepage          = 'https://bxlayout.borchero.com'
    s.documentation_url = 'https://bxlayout.borchero.com/docs'
    s.license           = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
    s.author            = { 'Oliver Borchert' => 'borchero@icloud.com' }
    s.source            = { :git => 'https://github.com/borchero/BxLayout.git',
                            :tag => s.version.to_s }

    s.platform = :ios
    s.ios.deployment_target = '11.0'

    s.source_files = 'BxLayout/**/*'

    s.dependency 'BxUtility', '~> 1.0'

    s.framework = 'UIKit'

end
