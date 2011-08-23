require 'spec_helper'

describe GroupPatternsController do
  it "should parse html" do
    json = GroupPatternsController.new.parse(File.read(Rails.root.join("spec/fixtures/patterns.html")))
    json[0].should == {
      "name" => "Aesthetics of Space",
      "pic" => "http://s3.amazonaws.com/grouppatterns.wagn.org/card_images/2671/NatureRoom1_medium.JPG",
      "heart" => "The way you arrange the meeting room greatly influences the possibilities and success of your session.  Even spaces that are less than ideal can, with creative attention, be made more beautiful and pleasant.  Optimize the space available to meet your intentions and support the group.",
      "category" => "Context",
      "related" => [
        "Circle",
        "Gaia",
        "Hosting",
        "Power of Constraints",
        "Power of Place",
        "Preparedness",
        "Nooks in Space and Time"
      ]
    }
    json.size.should == 91
  end
    
  describe "get page" do
    before do
      @cache = stub("cache")
      Rails.stub!(:cache).and_return(@cache)
    end
    
    it "should try to get page and save it on cache miss" do
      @cache.stub!(:read).with("a url").and_return(nil)
      @cache.should_receive(:write).with("a url", "some html", :expires_in => 1.hour)
      @cache.should_receive(:write).with("last.a url", "some html", :expires_in => 1.month)
      controller.should_receive(:open).with("a url").and_return("some html")
      
      controller.get_page("a url").should == "some html"
    end
    
    it "should not try to get a page on cache miss" do
      @cache.stub!(:read).with("a url").and_return("some html")
      @cache.should_not_receive(:write)
      controller.should_not_receive(:open)
      
      controller.get_page("a url").should == "some html"
    end
    
    it "should try to read from last value on timeout" do
      @cache.stub!(:read).with("a url").and_return(nil)
      @cache.stub!(:read).with("last.a url").and_return("last html")
      @cache.should_receive(:write).with("a url", "last html", :expires_in => 1.hour)
      controller.should_receive(:open).with("a url").and_raise("timeout")
      
      controller.get_page("a url").should == "last html"
    end
  end
end
