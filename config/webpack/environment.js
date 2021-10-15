const { environment } = require('@rails/webpacker')

environment.loaders.insert(
  'customIcons',
  {
    test: /\/icons\/.*.svg$/,
    use: [{
      loader: require.resolve('./loaders/custom-icon-loader')
    }]
  },
  { after: 'file' }
)

environment.loaders.get('file').exclude = /\/icons\/.*.svg$/

module.exports = environment
