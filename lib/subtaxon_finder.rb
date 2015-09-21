require 'taxon'
require 'taxon_group'

module SpeciesGuesser

  # Helper class to find the subtaxons on a given page from https://species.wikimedia.org.
  class SubtaxonFinder

    NEUTRAL_TAXON_GROUP = TaxonGroup.new(nil, [])

    # On the given page from https://species.wikimedia.org, finds all the subtaxons of the taxon the page represents.
    # +page+:: A page returned from the Mechanize crawler or a Nokogiri object.
    def find_subtaxons(page)
      interesting_area = page.at('#mw-content-text')
      p_children = interesting_area.children.select { |child| child.name == 'p' }
      group = nil
      p_children.map { |p_child| extract_below_selflink(p_child) }.inject(NEUTRAL_TAXON_GROUP) do |group1, group2|
        group = TaxonGroup.new(group2.level_name || group1.level_name, group1.taxons + group2.taxons)
      end
      if group.level_name
        group
      else
        TaxonGroup.new('taxons', group.taxons)
      end
    end

    def extract_below_selflink(element)
      children = element.children
      selflink_index = children.find_index do |child|
        (child.attribute('class') and child.attribute('class').value == 'selflink') or child.at('.selflink')
      end
      return NEUTRAL_TAXON_GROUP if selflink_index == nil
      children_below = children[selflink_index + 1..-1]
      level_name = extract_level_name(children_below)
      taxons = extract_from_links(children_below)
      return TaxonGroup.new(level_name, taxons)
    end

    # On the given main page from https://species.wikimedia.org, finds all the top level taxons.
    # +page+:: A page returned from the Mechanize crawler or a Nokogiri object.
    def find_top_taxons(page)
      interesting_area = page.at('#mw-content-text')
      extract_top_taxons(interesting_area)
    end

    def extract_top_taxons(element)
      if element.children.empty?
        return []
      elsif element.children[0].text? and element.children.length >= 2 and element.children[0].text.include?("Superregnum")
        return taxon_from_link(element.children[1])
      else
        element.children.map { |child| extract_top_taxons(child) }.flatten
      end
    end

    def extract_from_links(children)
      links = children.map do |child|
        if child.name == 'a'
          child
        else
          child.at('a')
        end
      end.compact
      links.map { |link| taxon_from_link(link) }
    end

    def taxon_from_link(link)
      name = link.text.strip
      link = link.attribute('href').value
      Taxon.new(name, link)
    end

    def extract_level_name(children)
      children.find { |child| child.text? and child.text }
    end

    private :taxon_from_link, :extract_from_links, :extract_top_taxons, :extract_level_name

  end

end
