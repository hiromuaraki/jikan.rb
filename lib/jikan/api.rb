require "http"
require "json"

module Jikan
  class API
    BASE_URL = "http://jikan.me/api"
    BASE_URL_SSL = "http://jikan.me/api"

    EXTENSIONS = {
      'anime' => { episodes: 'episodes', characters_staff: 'characters_staff',
                  news: 'news', pictures: 'pictures', videos: 'videos',
                  stats: 'stats' },
      'manga' => { character: 'character', news: 'news', pictures: 'pictures', 
                  stats: 'stats' },
      'character' => { pictures: 'pictures' },
      'person' => { pictures: 'pictures' },
      'user_list' => { anime: 'anime', manga: 'manga' }
    }

    def initialize(use_ssl=true)
			@endpoint = ""
			@id = nil
			@ext = nil
			@selected_base = if use_ssl then BASE_URL_SSL else BASE_URL end
		end

		def get(endpoint, id, ext=nil)
			@endpoint = endpoint
			@id = id
			@ext = ext
			@url = "#{@selected_base}/#{@endpoint}/#{@id}"
			unless @ext.nil?
				unless EXTENSIONS[@endpoint].include? @ext
					raise 'Extensions not supported'
				end
				@url << "/#{@ext}"
			end
			get_data
		end

    private

		def get_data
			res = HTTP.get(@url)
			if res.status >= 400
				raise "#{res.status}: error for id #{@id} on endpoint #{@endpoint}"
			end

			JSON.parse(res.body)
		end
  end
end