require 'nokogiri'
require 'open-uri'

class GroupPatternsController < ApplicationController
  def index
    render :json => parse(open("http://grouppatternlanguage.org/wagn/Pattern_Hearts_and_Pics_by_Name?layout=none&view=content"))
  end
  
  def show
  end
  
  def parse(html)
    doc = Nokogiri::HTML(html)
    
    doc.css(".RIGHT-medium_pic_and_heart").map do |item|
      {
        "name" => item.at_css(".known-card").content,
        "pic" => item.at_css("img").attribute("src").value,
        "heart" => item.at_css(".RIGHT-heart").content
      }
    end
  end
end
