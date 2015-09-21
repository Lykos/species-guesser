require 'taxon'

module SpeciesGuesser

  # Helper class to find the subtaxons on a given page from https://species.wikimedia.org.
  class SubtaxonFinder

    # On the given page from https://species.wikimedia.org, finds all the subtaxons of the taxon the page represents.
    # +page+:: A page returned from the Mechanize crawler or a Nokogiri object.
    def find_subtaxons(page)
      interesting_area = page.at('#mw-content-text')
      p_children = interesting_area.children.select { |child| child.name == 'p' }
      p_children.map { |p_child| extract_below_selflink(p_child) }.flatten
    end

    def extract_below_selflink(element)
      children = element.children
      selflink_index = children.find_index { |child| puts child; p child.at('.selflink'); child.at('.selflink') }
      return [] if selflink_index == nil
      children_below = children[selflink_index + 1..-1]
      extract_from_links(children_below)
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
      links = children.map { |child| child.at('a') }.compact
      links.map { |link| taxon_from_link(link) }
    end

    def taxon_from_link(link)
      name = link.text.strip
      link = link.attribute('href').value
      Taxon.new(name, link)
    end

    private :taxon_from_link, :extract_from_links, :extract_top_taxons

  end

end
