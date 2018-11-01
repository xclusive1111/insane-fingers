### A simple typing game for practicing

Build project:

```
elm make src/Main.elm --optimize --output=assets/main.js
```

To view the site in a browser, bring up `index.html` from any local HTTP server.
For example [`http-server`](https://www.npmjs.com/package/http-server):

```
$ http-server -p 9000
```

> Note: Serving port must be 9000. You can enrich word list in `assets/quotes.txt`
