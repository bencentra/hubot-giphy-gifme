# hubot-giphy-gifme

Get a random GIF from Giphy! Search by tags! Yeah!

Built with the wonderful [Giphy API](https://github.com/Giphy/GiphyAPI).

## Commands

* `hubot gif me` or `hubot giphy` returns a random GIF
* `hubot gif me american psycho` or `hubot giphy american psycho` returns a random GIF tagged with "american" and "psycho"
* `hubot gif me /search american psycho` or `hubot giphy /search american psycho` returns a random GIF selected from the search results for "american psycho" (using the `/search` endpoint instead of the default `/random`)

You can include tags in a number of ways:
* Space delimited: `hubot gif me american psycho`
* Comma separated: `hubot gif me american, psycho`
* Quoted: `hubot gif me "american psycho"`

These will all result in the same search `"american+psycho"`. See the [random endpoint docs](https://github.com/Giphy/GiphyAPI#random-endpoint) for more info.

## Usage

In your hubot instance, include this script like so:

external-scripts.json
```json
[
  ...
  "hubot-giphy-gifme"
]
```

package.json
```json
{
  ...
  "dependencies": {
    ...
    "hubot-giphy-gifme": "^1.0.0"
  }
}
```

You can configure the script with the following environment variables:
* `HUBOT_GIPHY_API_KEY` - Your Giphy API key. Uses Giphy's demo API key as a default. You can request your own [here](http://api.giphy.com/submit).
* `HUBOT_GIPHY_RATING` - The maximum allowed GIF rating (to prevent NSFW results). Possible values are: y, g, pg, pg-13 or r. Defaults to pg.
* `HUBOT_GIPHY_FORCE_HTTPS` - If true, transform all search results from `http` to `https`. Defaults to `false`.
* `HUBOT_GIPHY_INLINE_IMAGES` - If true, send results as in-line images instead of raw URLs. Defaults to `false`
* `HUBOT_GIPHY_DEFAULT_ENDPOINT` - The default Giphy API endpoint to use for searches. Defaults to `/random`.
* `HUBOT_GIPHY_RESULTS_LIMIT` - The number of results to return when getting GIFs from the `/search` endpoint. Defaults to 25.

## Contributing

* Fork/clone this project
* Run bootstrap script (installs dependencies, etc): `npm start`
* Make and test your changes
  * Test against a local hubot instance (see below)
  * Run and update the tests: `npm test`
* Submit a PR and badger [bencentra](https://github.com/bencentra) until it is merged and a new version is published

### Setting Up a Hubot Instance

See the [hubot docs](https://hubot.github.com/docs/) for info on setting up your own hubot instance.

To run Hubot with your local copy of hubot-giphy-gifme, add it to the `scripts/` directory:

```bash
mkdir hubot/scripts
cp hubot-giphy-gifme/src/giphy-gifme.coffee hubot/scripts/giphy-gifme.coffee
```

You can set the additional environment variable `DEBUG` to enable console output:

`DEBUG=* bin/hubot`

## License

MIT. See [LICENSE.md](LICENSE.md).
