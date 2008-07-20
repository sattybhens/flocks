require 'socket'

$debug = false
$silent = true

class IRC

  def initialize(server, port, nick, chan, &message_action)
    @@started = nil
    @queue = Array.new
    @names = Hash.new
    @votekicks = Hash.new
    @nick   = nick
    @chan   = chan
    @server = server
    @port   = port
    @message_action = message_action
  end

  def connect
    @irc = TCPSocket.open(@server, @port)
    send("USER " + (@nick + " ") * 3 + " :" + (@nick + " ") * 2)
    send("NICK " + @nick)
    send("JOIN " + @chan)
  end

  def loop
    for x in @irc
      puts x unless $silent
      Thread.new{parse(x)}
    end
    connect()
    loop()
  end

  def parse(line)
    case line
      when /Closing Link/ then reconnect()
      when /^PING (.+)[\r\n]{1,2}?/ then send("PONG #{$1}");
      when /^:(.+)\!.+\@.+ PRIVMSG (\#.+) :(.+)/ then parse_msg($1, $2, $3)
      when /KICK (#.+)/ then send("JOIN #{$1}")
      when /353 #{@nick} = (\#.+) :(.+)/ then set_names($1, $2)
    end
  end

  def reconnect
    connect(@server, @port, @nick, @chan)
    loop()
  end

  def send(input)
    puts input if $debug
    if @queue.length > 4
      silence()
    end
    @queue.push(input)
    @irc.send(@queue[-1] + "\r\n", 0)
    @queue.delete_at(-1)
  end

# :maplealmond!n=michael@209.82.34.12 PRIVMSG #rubyfringe :When it comes time to convey information, I'm not sure predictable is bad... 
# :wycats!n=wycats@209.82.34.17 PRIVMSG #rubyfringe :fail at pronouncing Ezra's name 
  def parse_msg(user, chan, message)
    # chan = user if message =~ /-pm/
    # puts "Parsing Message\n" if $debug
    # case message
    #   when /^(hi|hello|sup|oy),? #{@nick}/i then send("PRIVMSG " + chan + " :Hi, " + user)
    #   when /wtf(\?)?[\r\n]{1,2}?$/ then send("PRIVMSG #{chan} :gtfo")
    #   when /(^#{@nick} stfu|^stfu #{@name})/ then silence()
    #   when /^#{@nick} join (\#.+)/ then send("JOIN #{$1}")
    #   when /^#{@nick} (load|reload) (\w+)/ then mod_load($2, chan)
    # end
    @message_action.call user, chan, message
  end

  def mod_load(file, chan)
    begin
      file = file + '.rb'
      send("PRIVMSG #{chan} :Attempting to load: #{file}")
      load "#{file}"
    rescue StandardError => e
      send("PRIVMSG #{chan} :#{e}")
    end
  end

  def set_names(chan, users_string)
    users = Array.new
    users = users_string.split(/ /)
    users.each do |user|
            if user =~ /\@\%\&\~(.+)/
                    user = $1
            end
    end
    @names[chan] = users
    #@names[chan].each do |user| send("PRIVMSG #{chan} :#{user}") end
  end

  def get_names(chan)
    # :irc.lessthanthree.us 353 Lmapan = #so :Lmapan @Napalm`
    send("NAMES #{chan}")
  end

  def silence
    @queue.each do |x| @queue.delete(x) end
    send "PRIVMSG #{@chan} :Silence!"
  end
end