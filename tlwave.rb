# -*- coding: utf-8 -*-

Plugin.create(:tlwave) do
  words = ['ゆ', 'yu', 'ゆれ', 'yure', 'yureda', '#筑波大学は核実験をやめろ', 'じしん', '地震']
  
  expire = Time.now
  matched_tweets = []
  short_tweets = []
  on_update do |s, ms|
    time = Time.now
    ms.each do |message|
      break if message.introducer.created < time - 60
      matched_tweets << message if words.include?(message.body)
      short_tweets << message if message.body.length < 5
    end

    matched_tweets.delete_if { |m| m.created < time - 60 }
    short_tweets.delete_if { |m| m.created < time - 60 }

    if (matched_tweets.size > 2 && short_tweets.size > 5) && expire < Time.now
      activity :system, "TL波を観測しました #{Time.now}"
      expire = Time.now + 120
    end
  end
end

