module AtomicTV
  class AtomicParsleyTagger
    
    class AtomicParsleyUnavailable < ::AtomicTV::AtomicTVError
      def human_message
        'AtomicParsley is not installed or could not be found. Try checking your PATH.'
      end
    end
    
    class FileNotFound < ::AtomicTV::AtomicTVError
      def initialize(file_path)
        @file_path = file_path
      end
      
      attr_reader :file_path
      
      def human_message
        "File not found: #{file_path}"
      end
    end
    
    class TaggingError < ::AtomicTV::AtomicTVError
      def initialize(command)
        @command = command
      end
      
      attr_reader :command
      
      def human_message
        "A tagging error occured: #{command}."
      end
      
    end
    
    def self.executable
      path = Pathname.new(`which AtomicParsley`.chomp)
      raise AtomicParsleyUnavailable unless path.executable?
      path
    end
    
    def initialize(file_path, metadata)
      @file_path = file_path
      raise FileNotFound.new(file_path) unless file_path.exist?
      
      @metadata = metadata
    end
    
    def cast_metadata
      format_names = lambda {|name| {'name' => name}}
      {
        'cast' => metadata.actors.map(&format_names),
        'directors' => metadata.directors.map(&format_names),
        'screenwriters' => metadata.writers.map(&format_names)
      }.to_plist
    end
    
    def run
      options = {
        'stik' => metadata.media_type,
        'artist' => metadata.artist,
        'title' => metadata.title,
        'album' => metadata.album,
        'genre' => metadata.genre,
        'description' => metadata.description,
        'longdesc' => metadata.long_description,
        'TVNetwork' => metadata.tv_network,
        'TVShowName' => metadata.tv_show_name,
        'TVEpisode' => metadata.tv_episode,
        'TVSeasonNum' => metadata.tv_season_number,
        'TVEpisodeNum' => metadata.tv_episode_number,
        'tracknum' => metadata.track_number,
        'year' => metadata.air_date
      }
      
      metadata.with_loaded_posters do
        command =  %Q{#{self.class.executable} }
        command << %Q{"#{file_path}" }
        command << %Q{--overWrite }
        command << %Q{--rDNSatom "#{escape_double_quotes(cast_metadata)}" name=iTunMOVI domain=com.apple.iTunes }
        metadata.posters.each do |poster|
          command << %Q{--artwork #{poster.path} }
        end
        command << options.map {|option, value| %Q{--#{option} "#{escape_double_quotes(value)}"}}.join(' ')
        
        `#{command}`
        raise TaggingError.new(command) unless $?.success?
      end
    end
    
    private
    
    attr_reader :file_path, :metadata
    
    def escape_double_quotes(str)
      str.to_s.gsub('"', '\"')
    end
    
  end
end
