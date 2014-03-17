module AtomicTV
  class EpisodeMetadata
    
    ArtworkBaseURL = "http://thetvdb.com/banners/"
    
    def initialize(series, episode)
      @series, @episode = series, episode
    end
    
    attr_reader :series, :episode
    
    def media_type
      'TV Show'
    end
    
    def artist
      series.name
    end
    
    def title
      episode.name
    end
    
    def album
      "#{series.name}, Season #{episode.season_number}"
    end
    
    def genre
      series.genres.first
    end
    
    def description
      episode.overview.to_s[0,255].gsub(/\.(.*)\Z/, '.')
    end
    
    def long_description
      episode.overview.to_s
    end
    
    def tv_network
      series.network
    end
    
    def tv_show_name
      series.name
    end
    
    def tv_episode
      "#{episode.season_number}#{episode.number.to_s.rjust(2, '0')}"
    end
    
    def tv_season_number
      episode.season_number
    end
    
    def tv_episode_number
      episode.number
    end
    
    def track_number
      episode.number
    end
    
    def air_date
      episode.air_date && episode.air_date.to_s + 'T00:00:00Z'
    end
    
    def actors
      (Array(series.actors).map {|a| a.name} + episode.guest_stars).uniq
    end
    
    def directors
      parse_names(episode.director)
    end
    
    def writers
      parse_names(episode.writer)
    end
    
    attr_reader :posters
    
    def with_loaded_posters
      temporary_directory = Dir.mktmpdir
      
      season_posters = series.season_posters(episode.season_number, 'en')
      season_posters = series.posters('en') if season_posters.empty?
      @posters = season_posters.map do |poster|
        url = ArtworkBaseURL + poster.path
        file = File.new(File.join(temporary_directory, File.basename(url)), 'w')
        file.write(open(url).read)
        file.close
        file
      end

      yield
      
    ensure
      FileUtils.rm_rf(temporary_directory)
      @posters = nil
    end
    
    private
    
    def parse_names(str)
      return [] if str.nil?
      
      str.gsub!(/\A\|/, '')
      str.gsub!(/\|\Z/, '') 
      str.split(/\|+/)
    end
    
  end
end
