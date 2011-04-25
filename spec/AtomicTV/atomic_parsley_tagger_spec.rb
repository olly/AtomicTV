require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe AtomicTV::AtomicParsleyTagger do
  
  describe ".executable" do
    
    before(:each) do
      stub!(:`).and_return('')
    end
    
    context "with AtomicParsley installed" do
      
      let(:executable_path) { stub(:executable? => true) }
      
      before(:each) do
        Pathname.stub!(:new).and_return(executable_path)
      end
      
      it "should return a pathname with executable's location" do
        path = AtomicTV::AtomicParsleyTagger.executable
        path.should == executable_path
      end
      
    end
    
    context "without AtomicParsley installed" do
      
      before(:each) do
        Pathname.stub!(:new).and_return(stub(:executable? => false))
      end
      
      it "should raise a AtomicParsleyUnavailable error" do
        expect {
          AtomicTV::AtomicParsleyTagger.executable
        }.to raise_error(AtomicTV::AtomicParsleyTagger::AtomicParsleyUnavailable)
      end
      
    end
    
  end
  
  describe "#cast_metadata" do
    
    let(:file_path) { stub(:exist? => true) }
    
    let(:metadata) do
      stub(
        :actors => ['Actor 1', 'Actor 2'], 
        :directors => ['Director 1', 'Director 2'], 
        :writers => ['Writer 1', 'Writer 2']
      )
    end
    
    it "should generate a plist string from the actors, directors and writers" do
      tagger = AtomicTV::AtomicParsleyTagger.new(file_path, metadata)
      tagger.cast_metadata.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n\t<key>cast</key>\n\t<array>\n\t\t<dict>\n\t\t\t<key>name</key>\n\t\t\t<string>Actor 1</string>\n\t\t</dict>\n\t\t<dict>\n\t\t\t<key>name</key>\n\t\t\t<string>Actor 2</string>\n\t\t</dict>\n\t</array>\n\t<key>directors</key>\n\t<array>\n\t\t<dict>\n\t\t\t<key>name</key>\n\t\t\t<string>Director 1</string>\n\t\t</dict>\n\t\t<dict>\n\t\t\t<key>name</key>\n\t\t\t<string>Director 2</string>\n\t\t</dict>\n\t</array>\n\t<key>screenwriters</key>\n\t<array>\n\t\t<dict>\n\t\t\t<key>name</key>\n\t\t\t<string>Writer 1</string>\n\t\t</dict>\n\t\t<dict>\n\t\t\t<key>name</key>\n\t\t\t<string>Writer 2</string>\n\t\t</dict>\n\t</array>\n</dict>\n</plist>\n"
    end
  end
  
end
