const path = require('path');

module.exports = {
  entry: './frontend/src/blurbs.jsx',
  output: {
    path: path.resolve(__dirname, 'public'),
    filename: "blurbs.bundle.js",
  },
  module: {
    rules:  [{test: /\.jsx$/, use: 'babel-loader'}],
  },
  mode: 'development',
}
