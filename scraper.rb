# -*- coding: utf-8 -*-

require 'json'
require 'mechanize'
require 'turbotlib'

urls = {
  'Bank' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1736',
  'Insurance' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1737',
  'Pension Fund Manager' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1738',
  'Financial Corporation' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1739',
  'Leasing Company' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1740',
  'Rural Bank' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1741',
  'Local Bank' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1742',
  'Business Development' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1743',
  'Retirement' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1744',
  'Funds Transfer' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1745',
  'Surety' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1746',
  'Deposit Account' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1747',
  'Transportation' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1748',
  'Trust Company' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1749',
  'Cooperative' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1750',
  'Exchange Service Company' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1751',
  'Company Fund' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1752',
  'Factoring Company' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1753',
  'Mortgage' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1886',
  'Credit Union' => 'http://www.sbs.gob.pe/0/modulos/JER/JER_Interna.aspx?ARE=0&PFL=0&JER=1887'
}

urls.each do |category, url|
  agent = Mechanize.new
  page = agent.get(url)
  page.search('.JER_filaContenido').each do |bank|
    next unless [5,6].include?(bank.search('td').size) # skip group header rows

    data = {
      company_name: bank.search('td')[0].text.strip.split("\r\n").first,
      president: bank.search('td')[1].text.strip.split("\r\n").first,
      general_manager: bank.search('td')[2].text.strip.split("\r\n").first,
      address: bank.search('td')[3].text.strip.gsub(/\r\n/, ', ').squeeze(' '),
      telephone: bank.search('td')[4].text.strip.gsub(/\r\n/, ', ').squeeze(' '),
      fax: (bank.search('td')[5].text.strip.gsub(/\r\n/, ', ').squeeze(' ') rescue ''),
      url: (bank.search('td')[0].search('a')[0].attr('href') rescue ''),
      category: category,
      source_url: url,
      sample_date: Time.now
    }

    puts JSON.dump(data)
  end
end
