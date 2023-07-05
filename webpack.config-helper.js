'use strict'

const path = require('path')
const Webpack = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const UglifyJSPlugin = require('uglifyjs-webpack-plugin')
const ExtractSASS = new ExtractTextPlugin('/styles/bundle.css')

module.exports = (options) => {
  const webpackConfig = {
    devtool: options.devtool,
    externals: {
      'mapbox-gl': 'mapboxgl'
    },
    entry: [
      `webpack-dev-server/client?http://localhost:${options.port}`,
      'webpack/hot/dev-server',
      './src/js/index'
    ],
    resolve: {
      extensions: ['', '.html', '.js', '.json', '.scss', '.css'],
    },
    output: {
      path: path.join(__dirname, 'dist'),
      filename: '/bundle.js'
    },
    plugins: [
      new Webpack.ProvidePlugin({
        riot: 'riot'
      }),
      new Webpack.DefinePlugin({
        'process.env': {
          NODE_ENV: JSON.stringify(options.isProduction ? 'production' : 'development')
        }
      }),
      new HtmlWebpackPlugin({
        template: './src/index.html'
      }),
      new CopyWebpackPlugin([{
        from: './src/data',
        to: 'data'
      }, {
        from: './src/assets/content',
        to: 'assets/content'
      }])
    ],
    module: {
      preLoaders: [{
        test: /\.tag$/,
        exclude: /node_modules/,
        include: /src/,
        loader: 'riotjs-loader',
        query: {
          type: 'none'
        }
      }],
      loaders: [
        {
          test: /\.js$|\.tag$/,
          exclude: /(node_modules|bower_components)/,
          loader: 'babel',
          query: {
            presets: ['es2015']
          }
        },
        {
          test: /\.(png|jpg|gif|svg)$/,
          loader: 'url-loader'
        },

        {
          test: /\.css?$/,
          loader: 'style-loader!css-loader!'
        },
        {
          test: /\.md$/,
          loaders: ['html', 'markdown']
        }
      ]
    }
  }

  if (options.isProduction) {
    webpackConfig.entry = ['./src/js/index']

    webpackConfig.plugins.push(
      new Webpack.optimize.OccurenceOrderPlugin(),
      new UglifyJSPlugin(),
      ExtractSASS
    )

    webpackConfig.module.loaders.push({
      test: /\.scss$/i,
      loader: ExtractSASS.extract(['css', 'sass'])
    })
  } else {
    webpackConfig.plugins.push(
      new Webpack.HotModuleReplacementPlugin()
    )

    webpackConfig.module.loaders.push({
      test: /\.scss$/i,
      loaders: ['style', 'css', 'sass']
    }, {
      test: /\.js$/,
      loader: 'eslint',
      exclude: /node_modules/
    })

    webpackConfig.devServer = {
      contentBase: './dist',
      historyApiFallback: true,
      hot: true,
      port: options.port,
      inline: true,
      progress: true
    }
  }

  return webpackConfig
}
