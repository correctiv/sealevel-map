# Rising seas

This web application is a tool for exploring [tide gauge](https://en.wikipedia.org/wiki/Tide_gauge) data, based on the [PSMSL](http://www.psmsl.org/) data set. It visualizes the sea level change over the past decades. This data explorer was originally built as part of CORRECTIV’s [reporting on climate change](https://correctiv.org/recherchen/klima/artikel/2017/07/28/steigende-meere-ueberblick-weltweit/).

## License 

The source code for this project is published under [MIT license](LICENSE). All artwork, such as videos and photos are copyrighted by their respective authors and can only be used in the context of the [correctiv.org](https://correctiv.org) website. Any other use must be authorized by the individal rights holders for each artwork.

## How to use:

```
yarn install
```

Start Development Server:

```
yarn dev
```

Build Production Version:

```
yarn build
```

Running in production:

This project uses the HTML history API for client-side routing. In order to serve it in production, the web server has to be configured to serve this app for all routes. Routes are then evaluated in the browser using JavaScript. 

Simply put, the webserver has to serve any files that exist, but if they don't exist, it needs to serve /index.html rather than a `404: not found`. This is sometimes called "HTML 5 mode". Learn more about it here: [React Router in the Real](https://gkedge.gitbooks.io/react-router-in-the-real/content/index.html) (this is about React Router rather than [riot/route](https://github.com/riot/route), which is used here, but the general concept is the same)