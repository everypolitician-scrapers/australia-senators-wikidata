#!/bin/env ruby
# encoding: utf-8

require 'everypolitician'
require 'wikidata/fetcher'

sparq = 'SELECT ?item WHERE { ?item wdt:P39 wd:Q6814428 . }'
members = EveryPolitician::Wikidata.sparql(sparq)

urls = [
  'Members of the Australian Senate, 2014–2017',
  'Members of the Australian Senate, 2011–2014',
  'Members of the Australian Senate, 2008–2011',
  'Members of the Australian Senate, 2005–2008',
  'Members of the Australian Senate, 2002–2005',
  'Members of the Australian Senate, 1999–2002',
  'Members of the Australian Senate, 1996–1999',
  'Members of the Australian Senate, 1993–1996',
  'Members of the Australian Senate, 1990–1993',
  'Members of the Australian Senate, 1987–1990',
]

names = urls.map do |url|
  EveryPolitician::Wikidata.wikipedia_xpath(
    url: "https://en.wikipedia.org/wiki/#{url}",
    xpath: '//table[.//th[contains(., "Senator")]]//tr[td]//td[1]//a[not(@class="new")]/@title',
  )
end.inject(&:|)

existing = EveryPolitician::Index.new.country("Australia").upper_house.popolo.persons.map(&:wikidata).compact

EveryPolitician::Wikidata.scrape_wikidata(ids: members | existing, names: { en: names })

