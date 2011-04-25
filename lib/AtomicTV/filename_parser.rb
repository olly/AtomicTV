module AtomicTV
  class FilenameParser
    
    class InvalidFilename < ::AtomicTV::AtomicTVError
      def initialize(filename)
        @filename = filename
      end
      
      attr_reader :filename
      
      def human_message
        "Invalid filename: #{filename} (filenames must be in the format: 'Series Name - S01E01')."
      end
    end
    
    FilenameFormat =  /\A(.*) - S(\d{2})E(\d{2})\.\w{3}\Z/
    
    def self.parse(filename)
      if filename.to_s =~ FilenameFormat
        new($1, $2.to_i(10), $3.to_i(10))
      else
        raise InvalidFilename.new(filename)
      end
    end
    
    attr_reader :series_name, :season_number, :episode_number
    
    private
    
    def initialize(series_name, season_number, episode_number)
      @series_name = series_name
      @season_number = season_number
      @episode_number = episode_number
    end
    
  end
end
