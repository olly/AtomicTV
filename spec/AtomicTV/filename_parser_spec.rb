require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe AtomicTV::FilenameParser do
  
  describe ".parse" do
    
    context "with valid filenames" do
      
      let(:parser) { AtomicTV::FilenameParser.parse('Battlestar Galactica (2003) - S04E20.m4v') }
      
      it "should extract the series name" do
        parser.series_name.should == 'Battlestar Galactica (2003)'
      end
      
      it "should extract the season number" do
        parser.season_number.should == 4
      end
      
      it "should extract the episode number" do
        parser.episode_number.should == 20
      end
    end
    
    context "with invalid filenames" do
      
      it "should raise an AtomicTV::FilenameParser::InvalidFilename error" do
        expect {
          AtomicTV::FilenameParser.parse('V for Vendetta (2006).m4v')
        }.to raise_error(AtomicTV::FilenameParser::InvalidFilename)
      end
      
      it "should expose the invalid filename in the error" do
        invalid_filename = 'V for Vendetta (2006).m4v'
        
        begin
          AtomicTV::FilenameParser.parse(invalid_filename)
        rescue AtomicTV::FilenameParser::InvalidFilename => error
          error.filename.should == invalid_filename
        end
      end
      
    end
    
  end
  
end
