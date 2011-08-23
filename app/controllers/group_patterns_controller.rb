require 'nokogiri'
require 'open-uri'

class GroupPatternsController < ApplicationController
  def index
    render :json => parse(get_page("http://grouppatternlanguage.org/wagn/Info_appearing_on_each_card?layout=none&view=content"))
  end
  
  def show
  end
  
  def parse(html)
    doc = Nokogiri::HTML(html)
    
    doc.css(".item-naked").map do |item|
      {
        "name" => item.at_css(".known-card").content,
        "pic" => item.at_css("img").attribute("src").value,
        "heart" => clean(item.at_css(".RIGHT-heart").content),
        "category" => item.at_css(".RIGHT-category .item-name").content,
        "related" => item.css(".RIGHT-related_pattern_printed_on_card .known-card").map(&:content)
      }
    end
  end

  def get_page(url)
    html = Rails.cache.read(url)
    unless html
      begin
        html = open(url)
        Rails.cache.write(["last", url].join("."), html, :expires_in => 1.day)
      rescue
        html = Rails.cache.read(["last", url].join("."))
      end
      Rails.cache.write(url, html, :expires_in => 1.hour)
    end
    html
  end
    
  protected
  
  def clean(html) 
    html.gsub("&nbsp;", " ")
  end
end
