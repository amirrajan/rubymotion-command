# autorun:
# brew install fswatch
# fswatch ./wip.rb | xargs -n1 -I{} ruby ./wip.rb

require 'open3'

class Wip
  def self.pretty_print *string
    puts "\n======================================================================================\n"
    string.each do |s|
      puts s
    end
    puts "======================================================================================\n\n"
  end

  def self.rubymotion_to_xcode_version_parities
    {
      "5.7" => "9.3",
      "5.8" => "9.2"
    }
  end

  def self.rubymotion_version
    `motion --version`
  end

  def self.xcode_version
    `xcodebuild -version | head -n 1 | cut -d " " -f 2`
  end

  def self.run
    puts "\n"
    pretty_print "RubyMotion Doctor"

    pretty_print "This is the RubyMotion version you have installed:",
                 rubymotion_version

    pretty_print "This is the Xcode version you have installed:",
                 xcode_version

    pretty_print "This is your xcode-select path:",
                 `xcode-select --print-path`

    pretty_print "You are executing this command from the following process working directory:",
                 `pwd`

    pretty_print "Mac OS frameworks that are supported by this RubyMotion installation:",
                 `ls -lah /Library/RubyMotion/data/osx/`

    pretty_print "iOS frameworks that are supported by this RubyMotion installation:",
                 `ls -lah /Library/RubyMotion/data/ios/`

    pretty_print "TV OS frameworks that are supported by this RubyMotion installation:",
                 `ls -lah /Library/RubyMotion/data/tvos/`

    pretty_print "Watch OS frameworks that are supported by this RubyMotion installation:",
                 `ls -lah /Library/RubyMotion/data/watchos/`

    pretty_print "Android frameworks that are supported by this RubyMotion installation:",
                 `ls -lah /Library/RubyMotion/data/android`

  end
end

Wip.run
