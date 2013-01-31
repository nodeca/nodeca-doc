# Define the Configuration
docpadConfig = {

  templateData:
    site:
      # url: "."
      title: "Nodeca"
    getUrl: (document) -> return @site.url + (document.url or document.get?('url'))
    getPreparedTitle: -> if @document.title then "#{@document.title} | #{@site.title}" else @site.title

	collections:
		pages: ->
			@getCollection('html').findAllLive({isPage:true},[{order:1},{filename:1}]).on "add", (model) ->
				model.setMetaDefaults({layout:"default", order:1000})
}

# Export the Configuration
module.exports = docpadConfig
