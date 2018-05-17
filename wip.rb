# autorun:
# brew install fswatch
# fswatch ./wip.rb | xargs -n1 -I{} ruby ./wip.rb

require 'open3'

class Wip
  def self.pretty_print *string
    puts "\n======================================================================================\n"
    string.each do |s|
       if s.is_a? Array
         send(s[0], s[1])
       else
         puts s
       end
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
    
    pretty_print "You should have at least Java 1.8 installed.",
                 "This is the version of Java you have installed:",
                 ['system', 'javac -version']

    pretty_print "You should have Android Studio installed:\n\n",
                 ['system', 'ls /Applications/Android*']
    
    pretty_print "'android-27' should be available:",
                 ['system', 'ls /Users/*/.rubymotion-android/sdk/platforms'],
                 "\nIf not, check all API 27 boxes in Android SDK Manager and install."
  end
end

Wip.run
