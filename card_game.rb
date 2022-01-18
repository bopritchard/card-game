class CardGame
  require 'bundler/inline'
  
  # Shoutout to Shannon Skipper
  # I had used his deck of cards gem years ago on a side gig
  # why reinvent the wheel
  gemfile do
    source 'https://rubygems.org'
    gem 'deck-of-cards'
  end

  # couple of locals
  hand_count = 2
  player_count = 5
  
  # setup the players
  players = []
  player_count.times do |i|
    players << {name: "Player #{i+1}", cards: []} 
  end
  # Don't forget the dealer
  players << {name: "Dealer", cards: []} 

  # Get a new deck
  deck = DeckOfCards.new
  # shuffle for good measure
  deck.shuffle

  # Let's deal
  STDOUT.puts '----------Let''s Get Ready To Rumble-----------------' 
  hand_count.times.each_with_index do |i|
    STDOUT.puts "----Dealing Hand #{i+1}----"
    # make sure everyone gets a card
    players.each do |player|
      card = deck.draw
      STDOUT.puts "#{player[:name]} drew a #{card.to_s}"
      player[:cards] << card
    end
  end

  winner = []
  # Iterate through the players to determine the winner(s)
  # BIG MISS here is that I'm simply summing the value of cards....
  # Any card player knows that a pair of 2s beats an Ace/King
  # I'd definitely fix this with more time
  players.each do |player|
    value = player[:cards].sum{|card| card.value}
    winner_value = winner.first[:cards].sum{|card| card.value} unless winner.empty?
    # add player to winner array if it's empty
    # or replace current if it's cards are better
    if winner.empty? || value > winner_value
      winner.replace([player])
    elsif # might be a TIE
      value == winner_value
      winner << player
    end
  end
  
  result = ""
  # Annonce the Winner(s)
  # Might be one player
  if winner.count == 1
    result = "The winner is *#{winner.first[:name]}* with a hand of #{winner.first[:cards].map{|card| card.to_s}.join(', ')}"
  # Might be more than 1
  else
    result = "There was a tie between #{winner.map{|winner| winner[:name]}.join(', ')}"
    # If a player ties with the dealer...Too bad, so sad...Dealer always wins in a tie
    result << ". -|-|-|-|-The Dealer always wins a tie|-|-|-|-" unless winner.select {|w| w[:name] == 'Dealer' }.empty?
  end

  # Let em know what happened
  STDOUT.puts result

end