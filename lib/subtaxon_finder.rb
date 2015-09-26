require 'taxon_ref'
require 'taxon_info'

module SpeciesGuesser

  # Helper class to find the subtaxons on a given page from https://species.wikimedia.org.
  class SubtaxonFinder

    TOP_TAXON_LEVEL = 'Superregnum'

    # On the given page from https://species.wikimedia.org, finds all the subtaxons of the taxon the page represents.
    # +taxon_ref+:: The TaxonRef for which this taxon was fetched. Only used for reporting purposes.
    # +page+:: A page returned from the Mechanize crawler or a Nokogiri object.
    def find_subtaxons(taxon_ref, page)
      interesting_area = page.at('#mw-content-text')
      p_children = interesting_area.children.select { |child| child.name == 'p' }
      extractions = p_children.map do |p_child|
        extract_around_selflink(p_child)
      end.compact
      raise "Unable to extract taxon information from #{taxon_ref.link}." if extractions.empty?
      extractions.reduce { |a, b| a.merge(b) }
    end

    def extract_around_selflink(element)
      selflink_element = element.at('.selflink')
      return nil unless selflink_element
      previous_sibling = selflink_element.previous_sibling
      level_name = if previous_sibling
                     clean_level_name(previous_sibling.text)
                   else
                     nil
                   end
      taxon_name = selflink_element.text
      sibling = selflink_element
      sub_level_name = nil
      sub_taxons = []
      while sibling = sibling.next_sibling
        sub_level_name ||= clean_level_name(sibling.text) if sibling.text?
        link = if sibling.name == 'a' then sibling else sibling.at('a') end
        sub_taxons.push(taxon_from_link(link)) if link
      end
      return TaxonInfo.new(level_name, taxon_name, sub_level_name, sub_taxons.compact)
    end

    def taxon_from_link(link)
      return nil unless link.attribute('href')
      name = link.text.strip
      taxon_link = link.attribute('href').value
      TaxonRef.new(name, taxon_link)
    end

    def clean_level_name(level_name)
      level_name.gsub(/\s/, ' ').gsub(/[^A-Za-z_ ]/, '').strip
    end

    private :extract_around_selflink, :taxon_from_link, :clean_level_name

  end

end
