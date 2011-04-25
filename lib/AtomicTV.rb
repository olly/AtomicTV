require 'open-uri'
require 'pathname'
require 'tempfile'

require 'plist'
require 'tvdb_party'

module AtomicTV
  class AtomicTVError < StandardError; end
end

['atomic_parsley_tagger', 'episode_metadata', 'filename_parser', 'tvdb_episode'].each do |file|
  require File.expand_path(File.join(File.dirname(__FILE__), 'AtomicTV', file))
end
