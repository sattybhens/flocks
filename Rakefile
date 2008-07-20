# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'


namespace :db do
  task :populate => :environment do 
    Channel.create(:name => '#rubyfringe', :nickname => 'the_then', :server => "irc.freenode.net", :port => '6667')
    Channel.create(:name => '#rails-contrib', :nickname => 'the_then', :server => "irc.freenode.net", :port => '6667')
  end
end


task :monitor => :environment do
  channel_name = ENV['channel']
  puts "Start Monitoring: #{channel_name}"
  channel = Channel.find_by_name(channel_name)
  irc = IRC.new(channel.server, channel.port, channel.nickname, channel.name) do |user, channel_name, message|
    channel.messages.create(:nickname => user, :message => message)
  end
  irc.connect
  irc.loop
end

namespace :monitor do
  task :all => :environment do
    def create_child_process(channel_name, command)
      puts "STARTING: #{channel_name}"
      if Kernel.respond_to?(:fork)
        begin
          pid = fork || exec(command)
          pid_file = File.join(RAILS_ROOT, 'tmp', 'pids', 'crawlers', "#{channel_name}.pid")
          FileUtils.mkdir_p(File.dirname(pid_file))
          File.open(pid_file, "w") {|f| f.write pid }
        rescue NotImplementedError
          Thread.new { system(command) }
        end
      else
        Thread.new { system(command) }
      end
    end

    Channel.all.each do |channel|
      create_child_process(channel.name, "rake monitor channel=#{channel.name}")
    end    
  end
end