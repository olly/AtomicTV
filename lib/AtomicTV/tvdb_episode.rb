module AtomicTV
  class TVDBEpisode
    
    class UnknownSeries < ::AtomicTV::AtomicTVError
      def initialize(series_name)
        @series_name = series_name
      end
      
      attr_reader :series_name
      
      def human_message
        "Unknown TV series: '#{series_name}'"
      end
    end
    
    class UnknownEpisode < ::AtomicTV::AtomicTVError
      def initialize(series_name, season_number, episode_number)
        @episode_id = "#{series_name} - S#{season_number.to_s.rjust(2, '0')}E#{episode_number.to_s.rjust(2, '0')}"
      end
      
      attr_reader :episode_id
      
      def human_message
        "Unknown episode: #{episode_id}"
      end
    end
    
    def self.metadata_for_filename(filename)
      parser = FilenameParser.parse(filename)
      search_results = client.search(parser.series_name)
      raise UnknownSeries.new(parser.series_name) if search_results.empty?
      
      series = client.get_series_by_id(search_results.first['seriesid'])
      episode = client.get_episode(series, parser.season_number, parser.episode_number)
      raise UnknownEpisode.new(series.name, parser.season_number, parser.episode_number) if episode.nil?
      return EpisodeMetadata.new(series, episode)
    end
    
    private
    
    def self.client
      @client ||= TvdbParty::Search.new('BD90B148E7D9E897', 'en')
    end
    
  end
end
