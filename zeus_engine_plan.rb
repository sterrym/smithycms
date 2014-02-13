require 'zeus/rails'

ROOT_PATH = File.expand_path(Dir.pwd)
ENV_PATH  = File.expand_path('spec/dummy/config/environment',  ROOT_PATH)
BOOT_PATH = File.expand_path('spec/dummy/config/boot',  ROOT_PATH)
APP_PATH  = File.expand_path('spec/dummy/config/application',  ROOT_PATH)
ENGINE_ROOT = File.expand_path(Dir.pwd)
ENGINE_PATH = File.expand_path('lib/my_engine/engine', ENGINE_ROOT)

class ZeusEnginePlan < Zeus::Rails
  # see https://github.com/burke/zeus/blob/master/docs/ruby/modifying.md
  def guard
    if File.exists?(ROOT_PATH + "/Guardfile")
      require 'guard'
      require 'guard/cli'
      Guard::CLI.start
    end
  end
end

Zeus.plan = ZeusEnginePlan.new
