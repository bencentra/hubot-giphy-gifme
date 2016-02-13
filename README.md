# hubot-giphy-gifme

Get a random GIF from Giphy! Search by tags! Yeah!

Built with the wonderful [Giphy API](https://github.com/Giphy/GiphyAPI).

## Commands

* `hubot gif me` or `hubot giphy` returns a random GIF
* `hubot gif me american psycho` or `hubot giphy american psycho` returns a GIF tagged with "american" and "psycho"

You can include tags in a number of ways:
* Space delimited: `hubot gif me american psycho`
* Comma separated: `hubot gif me american, psycho`
* Quoted: `hubot gif me "american psycho"`

These will all result in the same search `"american+psycho"`. See the [random endpoint docs](https://github.com/Giphy/GiphyAPI#random-endpoint) for more info.

## Usage

In your hubot instance, include this script like so:

external-scripts.json:
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
  dependencies: {
    ...
    "hubot-giphy-gifme": "^1.0.0"
  }
}
```

You can configure the script with the following environment variables:
* `HUBOT_GIPHY_API_KEY` - Your Giphy API key. Uses Giphy's demo API key as a default. You can request your own [here](http://api.giphy.com/submit).
* `HUBOT_GIPHY_RATING` - The maximum allowed GIF rating (to prevent NSFW results). Possible values are: y, g, pg, pg-13 or r. Defaults to pg.

## Contributing

* Fork/clone this project and make your changes
* Test against a local hubot instance (see below)
* Submit a PR and badger [bencentra]() until it is merged and a new version is published

### Setting up a Hubot instance

See the [hubot docs](https://hubot.github.com/docs/) for info on setting up your own hubot instance.

To include your local copy of hubot-giphy-gifme in your hubot instance:

```bash
mkdir hubot/scripts
cp hubot-giphy-gifme/src/giphy-gifme.coffee hubot/scripts/giphy-gifme.coffee
```

You can set the additional environment variable `DEBUG` to enable console output:

`DEBUG=* bin/hubot`

## License

MIT. See [LICENSE.md](LICENSE.md).
