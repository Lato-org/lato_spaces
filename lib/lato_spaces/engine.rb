module LatoSpaces
  class Engine < ::Rails::Engine
    isolate_namespace LatoSpaces

    initializer 'lato_spaces.importmap', before: 'importmap' do |app|
      app.config.importmap.paths << root.join('config/importmap.rb')
    end

    initializer "lato_spaces.precompile" do |app|
      app.config.assets.precompile << "lato_spaces_manifest.js"
    end
  end
end
