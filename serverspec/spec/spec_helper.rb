require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'yaml'

## 変数ymlファイル読み込み
key = ENV['INVENTORY_HOST']
project_name = ENV['PROJECT_NAME']
properties = YAML.load_file("./spec_hosts/#{project_name}.yml")
set_property properties["#{key}"]

set :backend, :ssh
set :path, '/sbin:/usr/sbin:$PATH'

## ssh実行部
RSpec.configure do |c|
  c.before :all do
    set :host, property['ansible_host']
    options = Net::SSH::Config.for(c.host)
    options[:user] = property['ansible_user']
    if property['ansible_password']
      options[:password] = property['ansible_password']
    else
      options[:keys] = [ property['ansible_ssh_private_key_file'] ]
    end
    options[:user_known_hosts_file] = '/dev/null'
    set :ssh_options, options
  end
end

# 文字列が整数だったら整数に、文字列だったらそのままにするメソッドを追加
class String
  def str_int?
    Integer(self) #小数も変換したい場合は、Float(self)
  rescue
    self
  end
end