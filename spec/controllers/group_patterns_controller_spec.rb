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
end
