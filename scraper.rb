#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

urls = [
  'Members of the Australian Senate, 2014–2017',
]

names = urls.map do |url|
  EveryPolitician::Wikidata.wikipedia_xpath( 
    url: "https://en.wikipedia.org/wiki/#{url}",
    xpath: '//table[.//th[contains(., "Senator")]]//tr[td]//td[1]//a[not(@class="new")]/@title',
  ) 
end.inject(&:|)

EveryPolitician::Wikidata.scrape_wikidata(names: { en: names })

