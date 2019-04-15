process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const merge = require('webpack-merge')
const environment = require('./environment')
const config = environment.toWebpackConfig()

module.exports = merge(config, {
  mode: process.env.NODE_ENV,
  devtool: 'inline-source-map'
})
