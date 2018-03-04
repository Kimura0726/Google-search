# _*_ coding: utf-8 _*_
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'cgi'
require 'csv'

# Google検索を行う関数
def google_search(domain)
  escaped_url = URI.escape(
      "https://www.google.com/search?q=site:"+ domain[0] +"&oe=utf-8&hl=ja")
  doc = Nokogiri::HTML(open(escaped_url,'User-Agent' => 'Googlebot/2.1'))

  # 検索結果の数
  result = doc.xpath("//*[@id='resultStats']/text()").text
  puts domain[0], result
  result_ = result.slice(/\b\d{1,3}(,\d{3})*\b/)
  array = [domain[0], result_]
  sleep(30)
  return array
end

list = [["domain","result"]]
time = Time.now
year = time.year
month = sprintf('%02d', time.month)
day = sprintf('%02d', time.day)

domain_list = CSV.read("search.csv")
domain_list[1..-1].each do |domain|
  domain[0].downcase!
  list << google_search(domain)
end

CSV.open("Google_search_#{year}#{month}#{day}.csv", "w") do |csv|
  list.each do |row|
    csv << row
  end
end

puts ""
puts "Program Finish..."