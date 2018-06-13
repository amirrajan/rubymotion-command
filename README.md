These are auxiliary [RubyMotion](http://rubymotion.com) commands. Some are
provided by the community. Some are provided by RubyMotion
proper. Having these commands outside of RubyMotion allows for out of
band release/updates to the open source pieces of RubyMotion.

To author a command, create a starting point:

```ruby
module Motion; class Command
  class YourCommand < Command
    self.summary = "summary"
    self.description = "summary"

    def run
       puts "hello world"
    end
  end
end; end
```

You can locally run the command. Start `irb` and execute the following:

```
>$:.unshift '/Library/RubyMotion/lib'
>load '/Library/RubyMotion/lib/motion/command.rb'
>load './your_command.rb'
>c = Motion::Command::YourCommand.new []
>c.run
```

If you need to make updates, change the source file and run:

```
load './your_command.rb'
c.run
```
