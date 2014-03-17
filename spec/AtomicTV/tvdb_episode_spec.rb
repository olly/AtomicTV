require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

WebMock.disable_net_connect!

describe AtomicTV::TVDBEpisode do
  
  describe ".metadata_for_filename" do
    
    context "with a correct series, season and episode" do
      
      before(:each) do
        @mock_parser = double('Mock Parser', :series_name => 'The Wire', :season_number => 3, :episode_number => 6)
        AtomicTV::FilenameParser.stub(:parse).and_return(@mock_parser)
        
        @result1 = double('Mock Search Result - 1', :[] => '123456789')
        @result2 = double('Mock Search Result - 2', :[] => '987654321')
        @episode = double('Mock Episode')
        @mock_client = double('Mock Client', :search => [@result1, @result2], :get_series_by_id => @result1, :get_episode => @episode)
        AtomicTV::TVDBEpisode.stub(:client).and_return(@mock_client)
      end
      
      it "should search for the series using the name" do
        @mock_client.should_receive(:search).with('The Wire')
        
        AtomicTV::TVDBEpisode.metadata_for_filename('The Wire - S03E06.m4v')
      end
      
      it "should use the first search result as the series" do
        @mock_client.should_receive(:get_series_by_id).with('123456789')
        
        AtomicTV::TVDBEpisode.metadata_for_filename('The Wire - S03E06.m4v')
      end
      
      it "should return the correct episode for the series" do
        @mock_client.should_receive(:get_episode).with(@result1, 3, 6)
        
        AtomicTV::TVDBEpisode.metadata_for_filename('The Wire - S03E06.m4v')
      end
      
      it "should return an EpisodeMetadata instance for the episode" do
        metadata = AtomicTV::TVDBEpisode.metadata_for_filename('The Wire - S03E06.m4v')
        metadata.should be_kind_of(AtomicTV::EpisodeMetadata)
        metadata.series.should == @result1
        metadata.episode.should == @episode
      end
      
    end
    
    context "with an unknown series" do
      
      before(:each) do
        @mock_client = double('Mock Client', :search => [])
        AtomicTV::TVDBEpisode.stub(:client).and_return(@mock_client)
      end
      
      it "should raise an AtomicTV::TVDBEpisode::UnknownSeries error" do
        expect {
          AtomicTV::TVDBEpisode.metadata_for_filename('Teh Wires - S01E01.m4v')
        }.to raise_error(AtomicTV::TVDBEpisode::UnknownSeries)
      end
      
      it "should expose the invalid series name in the error" do
        begin
          AtomicTV::TVDBEpisode.metadata_for_filename('Teh Wires - S01E01.m4v')
        rescue AtomicTV::TVDBEpisode::UnknownSeries => error
          error.series_name.should == 'Teh Wires'
        end
      end
      
    end
    
    context "with an unknown episode" do
      
      before(:each) do
        @series = double('Mock Series', :[] => '1234789', :name => 'The Wire')
        @mock_client = double('Mock Client', :search => [@series], :get_series_by_id => @series, :get_episode => nil)
        AtomicTV::TVDBEpisode.stub(:client).and_return(@mock_client)
      end
      
      it "should raise an AtomicTV::TVDBEpisode::UnknownEpisode error" do
        expect {
          AtomicTV::TVDBEpisode.metadata_for_filename('The Wire - S01E99.m4v')
        }.to raise_error(AtomicTV::TVDBEpisode::UnknownEpisode)
      end
      
      it "should expose the invalid episode ID in the error" do
        begin
          AtomicTV::TVDBEpisode.metadata_for_filename('The Wire - S01E99.m4v')
        rescue AtomicTV::TVDBEpisode::UnknownEpisode => error
          error.episode_id.should == 'The Wire - S01E99'
        end
      end
      
    end
    
  end
  
end
