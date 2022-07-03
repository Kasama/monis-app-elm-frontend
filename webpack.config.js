const webpack = require("webpack");
const path = require("path");
const workbox = require('workbox-webpack-plugin');
const MODE =
  process.env.npm_lifecycle_event === "build" ? "production" : "development";

module.exports = function(env) {
  return {
    devtool: 'inline-source-map',
    devServer: {
      static: {
        directory: path.join(__dirname),
      },
      port: 8000,
      allowedHosts: 'all',
      bonjour: true,
      client: {
        overlay: true,
        progress: true,
      }
    },
    mode: MODE,
    entry: { main: "./index.ts"/*, serviceworker: "./serviceworker.ts" */ },
    output: {
      path: path.resolve(__dirname, "dist"),
      filename: "[name].js",
    },
    plugins:
      [
      ].concat(
        MODE === "development"
          ? [
            // Suggested for hot-loading
            // Prevents compilation errors causing the hot loader to lose state
            new webpack.NoEmitOnErrorsPlugin(),
            // new serviceWorker({
            //   entry: path.join(__dirname, "serviceworker.ts"),
            //   filename: path.join(__dirname, "dist/serviceworker.js"),
            // }),
          ]
          : [
            new workbox.InjectManifest({
              swSrc: path.join(process.cwd(), "serviceworker.ts"),
              swDest: path.join(__dirname, "dist/serviceworker.js"),
              exclude: [/.*\.config.js$/],
            })
          ]
      ),
    module: {
      rules: [
        {
          test: /\.html$/,
          exclude: /node_modules/,

          use: [
            "file-loader?name=[name].[ext]",
          ]
        },
        {
          test: [/\.elm$/],
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            { loader: "elm-hot-webpack-loader" },
            {
              loader: "elm-webpack-loader",
              options: MODE === "production" ? {} : { debug: true },
            },
          ],
        },
        { test: /\.ts$/, loader: "ts-loader" },
      ],
    },
    resolve: {
      extensions: [".js", ".ts", ".elm"],
    },
  };
};
