require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe AtomicTV::EpisodeMetadata do
  
  let(:series) do
    double('Mock Series', 
      :name => 'House', :network => 'FOX',
      :genres => ['Drama'],
      :artwork => [
        double('Artwork 1', :path => 'seasons/12345-7-1.jpg'), 
        double('Artwork 2', :path => 'seasons/12345-7-2.jpg')],
      :actors => [
        double('Actor 1', :name => 'Hugh Laurie'),
        double('Actor 2', :name => 'Olivia Wilde'),
        double('Actor 3', :name => 'Amber Tamblyn')]
    )
  end
  
  let(:episode) do
    double('Mock Episode',
      :name => 'Last Temptation',
      :season_number => '7',
      :number => '19',
      :overview => %Q{Masters faces a career crossroads on her last day as a medical student and struggles with the choice to continue on the path to become a surgeon or to accept the rare opportunity to join House’s team officially. Meanwhile, the team treats a 16-year-old girl who inexplicably collapsed days before embarking on an ambitious sailing tour around the globe. Despite the patient's life-changing diagnosis, the patient's family insists on getting her back on the seas in time for her potentially record-breaking launch. But to the team's surprise, including House, Masters makes a bold decision regarding the patient’s treatment.},
      :air_date => Date.new(2011, 4, 18),
      :guest_stars => ['Amber Tamblyn', 'Ron Perkins', 'Jennifer Landon'],
      :director => 'Tim Southam',
      :writer => '|David Foster|Liz Friedman|'
    )
  end
  
  let(:metadata) { AtomicTV::EpisodeMetadata.new(series, episode) }
  
  context "with complete show information" do
    
    it "should return 'TV Show' for media_type" do
      metadata.media_type.should == 'TV Show'
    end
    
    it "should return the series name for artist" do
      metadata.artist.should == 'House'
    end
    
    it "should return the episode name for title" do
      metadata.title.should == 'Last Temptation'
    end
    
    it "should return the series name and season for album" do
      metadata.album.should == 'House, Season 7'
    end
    
    it "should return the first genre for genre" do
      metadata.genre.should == 'Drama'
    end
    
    it "should return the first 255 characters, trucated to a complete sentence, of the overview for description" do
      metadata.description.should == 'Masters faces a career crossroads on her last day as a medical student and struggles with the choice to continue on the path to become a surgeon or to accept the rare opportunity to join House’s team officially.'
    end
    
    it "should return the full overview for long description" do
      metadata.long_description.should == %Q{Masters faces a career crossroads on her last day as a medical student and struggles with the choice to continue on the path to become a surgeon or to accept the rare opportunity to join House’s team officially. Meanwhile, the team treats a 16-year-old girl who inexplicably collapsed days before embarking on an ambitious sailing tour around the globe. Despite the patient's life-changing diagnosis, the patient's family insists on getting her back on the seas in time for her potentially record-breaking launch. But to the team's surprise, including House, Masters makes a bold decision regarding the patient’s treatment.}
    end
    
    it "should return the series network for tv network" do
      metadata.tv_network.should == 'FOX'
    end
    
    it "should return the series name for tv show name" do
      metadata.tv_show_name.should == 'House'
    end
    
    it "should return the series number and episode number for tv episode" do
      metadata.tv_episode.should == '719'
    end
    
    it "should return the season number for tv season number" do
      metadata.tv_season_number.should == '7'
    end
    
    it "should return the episode number for tv episode number" do
      metadata.tv_episode_number.should == '19'
    end
    
    it "should return the episode number for track number" do
      metadata.track_number.should == '19'
    end
    
    it "should return a date with timezone for air date" do
      metadata.air_date.should == '2011-04-18T00:00:00Z'
    end
    
    it "should return series cast and guest cast for actors" do
      metadata.actors.should =~ ['Hugh Laurie', 'Olivia Wilde', 'Amber Tamblyn', 'Ron Perkins', 'Jennifer Landon']
    end
    
    it "should return the episode's directors for directors" do
      metadata.directors.should =~ ['Tim Southam']
    end
    
    it "should return the episode's writers for writers" do
      metadata.writers.should =~ ['David Foster', 'Liz Friedman']
    end
    
  end
  
  context "with a missing air date" do
    
    before(:each) do
      episode.stub(:air_date).and_return(nil)
    end
    
    it "should return nil for air_date" do
      metadata.air_date.should be_nil
    end
    
  end
  
  context "with missing artwork" do
    
  end
  
  describe "#description" do
    pending "more logic"
  end
  
  describe "#tv_episode" do
    
    it "should format the episode number to two digits" do
      episode.stub(:number).and_return('2')
      metadata.tv_episode.should == '702'
    end
    
  end
  
  describe "#directors" do
    pending "more logic"
  end
  
  describe "#writers" do
    pending "more logic"
  end
  
  describe "#with_loaded_posters" do
    pending
  end
  
end
