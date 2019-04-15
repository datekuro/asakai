const { environment } = require('@rails/webpacker')
const { resolve } = require('path')
const webpack = require('webpack')
const CleanWebpackPlugin = require('clean-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const rootPath = resolve(__dirname, '../..')
const pathsToClean = [ 'packs', 'packs-test' ]
const cleanOptions = {
  root: resolve(rootPath, 'public'),
  verbose: true,
}

// defaultのcss関連のloaderをまとめて消す
environment.loaders.delete('css')
environment.loaders.delete('sass')
environment.loaders.delete('moduleSass')
environment.loaders.delete('moduleCss')

environment.loaders.prepend('scss', {
  test: /\.(css|sass|scss)$/,
  use: [
    MiniCssExtractPlugin.loader,
    'css-loader',
    'sass-loader',
    'import-glob-loader'
  ]
})

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/dist/jquery',
    jQuery: 'jquery/dist/jquery',
    Popper: ['popper.js', 'default']
  })
)

if (process.env.NODE_ENV !== 'test') {
  environment.plugins.insert('CleanWebpackPlugin', new CleanWebpackPlugin(cleanOptions))
}

environment.plugins.insert('MiniCssExtractPlugin', new MiniCssExtractPlugin({filename: '[name]_[contentHash].css'}))

module.exports = environment
