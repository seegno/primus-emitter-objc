platform :osx, '10.9'
inhibit_all_warnings!

pod 'Emitter', :path => '~/Projects/emitter-objc'

target :'PrimusEmitterTests' do
    link_with 'PrimusEmitter', 'PrimusEmitterTests'

    pod 'Primus', :path => '~/Projects/primus-objc'
    pod 'Specta'
    pod 'Expecta'
    pod 'OCMockito'
end
