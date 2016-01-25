### Useless Hearthstone
Analyzes decks from [Hearthpwn](http://www.hearthpwn.com/) to get some idea of what cards are useless in Hearthstone.

### Future
Right now it's pretty rudimentary. There's ~1000 decks in the SQLite database, and the cards as recent as 1/23/16. `analyzer.rb` prints a simple list of those cards and the times they showed up in those ~1000 decks. (If a deck has two copies, it gets counted twice.). `useless.txt` is the result of running that program

### Technological Significance
We're using ActiveRecord standalone, and configuring rake for the typical database Rake tasks. We're using `config/loader.rb` to get Rails-like auto-loading in `analyzer.rb`. And we've created a `.irbrc` to load some project specific irb code following the pattern found [here](http://samuelmullen.com/2010/04/irb-global-local-irbrc/).

### Credits
We used omgvamp's Hearthstone card API which can be found [here](http://hearthstoneapi.com/) and [here](https://market.mashape.com/omgvamp/hearthstone).