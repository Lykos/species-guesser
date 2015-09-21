require 'taxon'
require 'taxon_group'
require 'taxon_info'

module SpeciesGuesser

  # Helper class to find the subtaxons on a given page from https://species.wikimedia.org.
  class SubtaxonFinder

    TOP_TAXON_LEVEL = 'Superregnum'

    # On the given page from https://species.wikimedia.org, finds all the subtaxons of the taxon the page represents.
    # +page+:: A page returned from the Mechanize crawler or a Nokogiri object.
    def find_subtaxons(page)
      interesting_area = page.at('#mw-content-text')
      p_children = interesting_area.children.select { |child| child.name == 'p' }
      p p_children.find do |p_child|
        extract_around_selflink(p_child)
      end
    end

    def extract_around_selflink(element)
      selflink_element = element.at('.selflink')
      return nil unless selflink_element
      level_name = clean_level_name(selflink_element.previous_element.text)
      taxon_name = selflink_element.text
      sibling = selflink_element
      sub_level_name = nil
      sub_taxons = []
      while sibling = sibling.next_sibling
        sub_level_name ||= clean_level_name(sibling.text) if sibling.text?
        link = if sibling.name == 'a' then sibling else sibling.at('a') end
        sub_taxons.push(taxon_from_link(link)) if link
      end
      taxon_group = TaxonGroup.new(sub_level_name, sub_taxons.compact)
      return TaxonInfo.new(level_name, taxon_name, taxon_group)
    end

    # On the given main page from https://species.wikimedia.org, finds all the top level taxons.
    # +page+:: A page returned from the Mechanize crawler or a Nokogiri object.
    def find_top_taxons(page)
      interesting_area = page.at('#mw-content-text')
      TaxonGroup.new(TOP_TAXON_LEVEL, extract_top_taxons(interesting_area))
    end

    def extract_top_taxons(element)
      if element.children.empty?
        return []
      elsif element.children[0].text? and element.children.length >= 2 and element.children[0].text.include?(TOP_TAXON_LEVEL)
        return taxon_from_link(element.children[1])
      else
        element.children.map { |child| extract_top_taxons(child) }.flatten
      end
    end

    def taxon_from_link(link)
      return nil unless link.attribute('href')
      name = link.text.strip
      taxon_link = link.attribute('href').value
      Taxon.new(name, taxon_link)
    end

    def clean_level_name(level_name)
      level_name.gsub(/\s/, ' ').gsub(/[^A-Za-z_ ]/, '').strip
    end

    private :extract_around_selflink, :taxon_from_link, :extract_top_taxons, :clean_level_name

  end

end
