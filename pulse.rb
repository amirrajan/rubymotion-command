# encoding: utf-8

# Copyright (c) 2017, Scratchwork Development LLC and contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'digest/sha1'
require 'net/http'
require 'date'

module Motion; class Command
  class Pulse < Command
    self.summary = "See recent news about RubyMotion."
    self.description = "View up-to-the-minute news about RubyMotion without any newsletters or social media nonsense. Straight text."

    # This file contains an MD5 hash of all pulse entries.
    def read_pulses_file
      File.expand_path('~/.rubymotion/rubymotion-command/.read-pulses')
    end

    def hash_string s
      Digest::SHA1.hexdigest(s.strip)
    end

    def read_pulse_hashes
      return [] unless File.exists?(read_pulses_file)
      File.read(read_pulses_file).each_line.to_a.map { |l| l.strip }
    end

    def unread pulse_texts, hashes
      pulse_texts.reject { |p| hashes.include?(hash_string(p)) }
    end

    def mark_pulses_as_read pulses
      path = File.expand_path(read_pulses_file)
      `rm #{path}` if File.exists?(path)
      `touch #{read_pulses_file}`
      File.open(read_pulses_file, 'w') do |f|
        pulses.each do |p|
          f.write hash_string(p) + "\n"
        end
      end
    end

    def run
      return if ENV['RUBYMOTION_OFFLINE']
      pulses = Net::HTTP.get('pulse.rubymotion.com', '/').split("\n\n").map { |l| l.strip }
      unread_pulses = unread(pulses, read_pulse_hashes)
      if unread_pulses.length > 0
        mark_pulses_as_read(pulses)
        unread_pulses.each do |p|
          puts ""
          puts p
          puts ""
        end
      end
    rescue => e
      puts e
      puts "WARNING: http://pulse.rubymotion.com doesn't seem to be reachable at this time. Let someone know in the Slack channel or community forum."
    end
  end
end; end

# Don't attempt to auto run the pulse if the `RUBYMOTION_OFFLINE` flag is set.
if !ENV['RUBYMOTION_OFFLINE']
  # Attept to get the last time pulse was run
  last_pulse_path = File.expand_path('~/.rubymotion/rubymotion-command/.last-pulse')
  does_last_pulse_exist = File.exists?(last_pulse_path)

  begin
    # If the "last pulse" file is there, get the date out of the file
    # and determine if pulse should be run.
    if does_last_pulse_exist
      last_pulse_date = File.read(last_pulse_path).strip
      if Date.today.to_s != last_pulse_date
        pulse = Motion::Command::Pulse.new []
        pulse.run
        `touch #{last_pulse_path}`
        File.open(last_pulse_path, 'w') do |f|
          f.write(Date.today.to_s)
        end
      end
    else
      # if the "last pulse" file _doesn't_ exist, then run pulse and
      # create the file for future use
      pulse = Motion::Command::Pulse.new []
      pulse.run
      `touch #{last_pulse_path}`
      File.open(last_pulse_path, 'w') do |f|
        f.write(Date.today.to_s)
      end
    end
  rescue => e
    puts e
    puts "WARNING: http://pulse.rubymotion.com doesn't seem to be reachable at this time. Let someone know in the Slack channel or community forum."
  end
end
