This project is not active. The code is here for historical purposes. What follows is a braindump about splitsdb and how
it eventually spawned [splits.io][1].

[1]: https://splits.io/

# splitsdb
splitsdb was the prototype of splits.io. It was my first "get something down on paper" attempt to create a website for
sharing speedrunning splits. At the time, I believed it would be the final product. I was very wrong.

## Things that were wrong
The broad-strokes differences between splitsdb and splits.io are all in user experience. In splitsdb, I knew I wanted to
upload my splits so I could share them and compare to my friends' splits. But instead of honing those two core ideas
into a good experience, I built a bunch of boilerplate generic website features around them. They forced a real bad UX:

1. Uploading splits requires an account.
2. You need to select the game and category before uploading (from pre-known only, no write-ins).
3. ∴ Game and category have to exist on the site before uploading.

So if you're a new user running a new game, you make an account, make the game, make the category, then upload the run.
Compare that to splits.io's steps: upload the run.

Browsing runs was also pretty rough.

1. No search.
2. Run URLs look like `splitsdb.com/sonic-generations/1/runs/22`, where the first number is a globally unique category
   ID and the second is a globally unique run ID. Half of this URL is trying to be descriptive and the other half is
   trying to be functional, and you experience the bad parts of both. (To this day I still haven't figured out a clean
   way to put "any%" into a URL.)
3. There is just one way to browse games: a non-paginated list of all games *by boxart*. The by-boxart part means you
   can't even `^F` to perform a psuedo-search of your own.

Oh, and it only supported WSplit. (LiveSplit didn't exist, but other timers did.)

All these problems are solvable, but I honestly didn't feel like solving them within the confines of the system I had
built. Sure I could allow you to upload a run from any page, but then how would I know what game and category it
belonged to? Runs *had* to have a game and category. If they didn't, then what the fuck was the URL going to
say? (WSplit didn't have official fields for game+category, so it had to be up to the user.)

Every problem with splitsdb had a similar defense to it -- easy to solve, but solving it breaks something fundamental to
the site.

So I decided that I had too many fundamentals. I just need the two: share, and compare. Everything else was useless
surface area for breakage.

I often compare splits.io to Pastebin. But splitsdb is like if Pastebin required you to navigate to a category before
writing, like "social" or "gaming" or "sports", then click a "New paste in this category" button. Who the fuck wants to
do that? I don't care about discovery, I just want to throw a link at people! Let me write already!

That was the first time I thought about splits in a Pastebin style, and I liked it a lot. So I started from scratch with
the mindset that a run should be completely independent; that it doesn't need to belong in a beautifully organized
hierarchy of games and categories and users.

### This code
This is the code that powered that beautifully organized hierarchy that was oh so horrible to actually use. Feel free to
browse around.

##### Footnote: Things that were right
splitsdb did get some things uniquely right:

1. You can download blank splits, a feature I still haven't reimplemented into splits.io. LiveSplit has wrapped their
   own blankifier around the in-timer "download from splits.io" feature, however, which is cool.
2. When viewing your run, other runs' timelines in the category are shown inline, effectively turning every run page
   into a comparison page, which I like a lot.
