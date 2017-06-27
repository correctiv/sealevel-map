'use strict'

const Path = require('path')
const Webpack = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const ExtractSASS = new ExtractTextPlugin('/styles/bundle.css')

module.exports = (options) => {
  const webpackConfig = {
    devtool: options.devtool,
    entry: [
      `webpack-dev-server/client?http://localhost:${options.port}`,
      'webpack/hot/dev-server',
      './src/js/index'
    ],
    resolve: {
      extensions: ['', '.html', '.js', '.json', '.scss', '.css'],
      alias: {
        leaflet_css: Path.join(__dirname, '/node_modules/leaflet/dist/leaflet.css'),
        leaflet_marker: Path.join(__dirname, '/node_modules/leaflet/dist/images/marker-icon.png'),
        leaflet_marker_2x: Path.join(__dirname, '/node_modules/leaflet/dist/images/marker-icon-2x.png'),
        leaflet_marker_shadow: Path.join(__dirname, '/node_modules/leaflet/dist/images/marker-shadow.png')
      }
    },
    output: {
      path: Path.join(__dirname, 'dist'),
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
      new Webpack.optimize.UglifyJsPlugin({
        compressor: {
          warnings: false
        }
      }),
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
