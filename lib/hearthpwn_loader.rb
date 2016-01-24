# require File.join(File.expand_path('../..', __FILE__), 'config/loader.rb')

class HearthpwnLoader
  HOST = "http://www.hearthpwn.com"
  HOT_LIST = "#{HOST}/decks?filter-deck-tag=1"
  NEW_LIST = "#{HOST}/decks?filter-deck-tag=2"

  # hot: true, to use HOT_LIST, otherwise NEW
  # count: X, number of decks to add
  def initialize(options={})
    @list = options[:hot] ? HOT_LIST : NEW_LIST
    @count = options[:count] || 1
  end

  def load_decks
    self.deck_links.each do |link|
      page = Nokogiri::HTML(open(link_with_host(link)))
      details = {}

      begin # at this point if something goes wrong, i'm still going to create a deck entry
        details[:hearthpwn_id] = link.match(/\/decks\/(\d+)/)[1]
        details[:name]         = page.css("h2.deck-title").text
        details[:style]        = page.css("ul.deck-details > li > span.deck-type").text
        details[:cost]         = page.css("ul.deck-details > li > span.craft-cost").text
        details[:uploaded_at]  = parse_time(
          page.css("ul.deck-details > li").last.css("span").text.split(" ").first
        )

        cards    = {}
        listings = [page.css("section.class-listing"), page.css("section.neutral-listing")]
        selector = "div.listing-container > div.listing-body > table > tbody > tr > td.col-name > b > a"

        listings.each do |listing|
          listing.css(selector).each { |link| cards[link.text.strip] = link["data-count"] }
        end

        # we've already saved this deck, don't do it again
        next if details[:hearthpwn_id] && Deck.exists?(hearthpwn_id: details[:hearthpwn_id])

        deck = Deck.new(details)
        if deck.save
          cards.each do |card_name, count|
            DeckListing.create(card: Card.find_by_name(card_name), deck: deck, count: count)
          end
        
        else # we'll just raise an error since we handle them below
          raise StandardError.new("Unable to save deck: #{deck.errors.full_messages}")
        end
        
      rescue StandardError => e
        details[:last_error] = "#{e.message}:\n#{e.backtrace}"
        details[:failed] = true

        Deck.create(details)
      end
    end
  end

  def deck_links
    @deck_links ||= scrape_deck_links
  end

  private

    def scrape_deck_links
      selector = "table.listing-decks > tbody > tr > td.col-name > div > span > a"

      page = 1
      links = []
      while links.length < @count # TODO - this doesn't handle running out of pages
        url = "#{@list}&page=#{page}"

        links += Nokogiri::HTML(open(url)).css(selector).collect { |link| link["href"] }
        page += 1
      end

      links[0...@count]
    end

    def link_with_host(link)
      link.include?(HOST) ? link : "#{HOST}#{link}"
    end

    def parse_time(time)
      ActiveSupport::TimeZone['UTC'].parse(DateTime.strptime(time, "%m/%d/%Y").to_s)
    end
end