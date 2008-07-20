# def create_child_process(channel_name, command)
#   puts "STARTING: #{channel_name}"
#   if Kernel.respond_to?(:fork)
#     begin
#       pid = fork || exec(command)
#       pid_file = File.join(RAILS_ROOT, 'tmp', 'pids', 'crawlers', "#{channel_name}.pid")
#       FileUtils.mkdir_p(File.dirname(pid_file))
#       File.open(pid_file, "w") {|f| f.write pid }
#     rescue NotImplementedError
#       Thread.new { system(command) }
#     end
#   else
#     Thread.new { system(command) }
#   end
# end
# 
# Channel.all.each do |channel|
#   create_child_process(channel.name, "rake monitor channel=#{channel.name}")
# end
