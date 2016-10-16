class Bot < SlackRubyBot::Bot
  @id = 0
  @marvel_client = Marvelite::API::Client.new( public_key: ENV['MARVEL_PUBLIC_KEY'], private_key: ENV['MARVEL_PRIVATE_KEY'])

  def self.next_id
    @id = @id % 10 + 1
  end

  command 'say' do |client, data, match|
    Rails.cache.write next_id, { text: match['expression'] }
    client.say(channel: data.channel, text: match['expression'])
  end

  command 'spiderman' do |client, data, match|
    spidey_results = @marvel_client.character('Spider-Man')
    client.say(text: "#{spidey_results[:data][:results][0][:thumbnail][:path]}.#{spidey_results[:data][:results][0][:thumbnail][:extension]}", channel: data.channel)
  end

  command 'character' do |client, data, match|
    results = @marvel_client.character(match['expression'])
    client.say(text: "#{results[:data][:results][0][:thumbnail][:path]}.#{results[:data][:results][0][:thumbnail][:extension]}", channel: data.channel)
  end

  # Make a class that stores what a person is reading
  # So let's say a comic
  # maybe an occurrence
  # a command here for "reading" - aliased to several other expresssions
  # "@marvelbot I'm reading/I've been reading/I read [spiderman]"
end
