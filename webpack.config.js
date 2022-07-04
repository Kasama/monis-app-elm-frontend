const path = require("path");
const { merge } = require('webpack-merge');

const ClosurePlugin = require("closure-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const HTMLWebpackPlugin = require("html-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

const workbox = require('workbox-webpack-plugin');

// Production CSS assets - separate, minimised file
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");

var MODE =
  process.env.npm_lifecycle_event === "prod" ? "production" : "development";
var withDebug = !process.env["npm_config_nodebug"] && MODE === "development";
// this may help for Yarn users
// var withDebug = !npmParams.includes("--nodebug");
console.log(
  "\x1b[36m%s\x1b[0m",
  `** elm-webpack-starter: mode "${MODE}", withDebug: ${withDebug}\n`
);

var common = {
  mode: MODE,
  entry: "./src/index.ts",
  output: {
    path: path.join(__dirname, "dist"),
    publicPath: "/",
    // FIXME webpack -p automatically adds hash when building for production
    filename: MODE === "production" ? "[name]-[hash].js" : "index.js"
  },
  plugins: [
    new HTMLWebpackPlugin({
      // Use this template to get basic responsive meta tags
      template: "src/index.html",
      // inject details of output file at end of body
      inject: "body"
    }),
    new workbox.InjectManifest({
      swSrc: path.join(process.cwd(), "src/serviceworker.ts"),
      swDest: path.join(__dirname, "dist/serviceworker.js"),
      exclude: [/.*\.config.js$/],
    })
  ],
  resolve: {
    modules: [path.join(__dirname, "src"), "node_modules"],
    extensions: [".js", ".ts", ".elm", ".scss", ".png"]
  },
  module: {
    rules: [
      { test: /\.ts$/, loader: "ts-loader" },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        exclude: [/elm-stuff/, /node_modules/],
        // see https://github.com/webpack-contrib/css-loader#url
        use: ["style-loader", "css-loader", "sass-loader"]
      },
      {
        test: /\.css$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: ["style-loader", "css-loader"]
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: "url-loader",
          options: {
            limit: 10000,
            mimetype: "application/font-woff"
          }
        }
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "file-loader"
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "file-loader"
      }
    ]
  }
};

if (MODE === "development") {
  module.exports = merge(common, {
    optimization: {
      // Prevents compilation errors causing the hot loader to lose state
      emitOnErrors: false
    },
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            { loader: "elm-hot-webpack-loader" },
            {
              loader: "elm-webpack-loader",
              options: {
                // add Elm's debug overlay to output
                debug: withDebug

              }
            }
          ]
        }
      ]
    },
    devServer: {
      devMiddleware: {
        stats: "errors-only",
      },
      static: {
        directory: path.join(__dirname, "public/assets"),
      },
      historyApiFallback: true,
    }
  });
}

if (MODE === "production") {
  module.exports = merge(common, {
    optimization: {
      minimizer: [
        new ClosurePlugin(
          { mode: "STANDARD" },
          {
            // compiler flags here
            //
            // for debugging help, try these:
            //
            // formatting: 'PRETTY_PRINT',
            // debug: true
            // renaming: false
          }
        ),
        new OptimizeCSSAssetsPlugin({})
      ]
    },
    plugins: [
      // Delete everything from output-path (/dist) and report to user
      new CleanWebpackPlugin({
        root: __dirname,
        exclude: [],
        verbose: true,
        dry: false
      }),
      // Copy static assets
      new CopyWebpackPlugin({
        patterns: [
          {
            from: "public/assets"
          }
        ]
      }),
      new MiniCssExtractPlugin({
        // Options similar to the same options in webpackOptions.output
        // both options are optional
        filename: "[name]-[hash].css"
      })
    ],
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: {
            loader: "elm-webpack-loader",
            options: {
              optimize: true
            }
          }
        },
        {
          test: /\.css$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            MiniCssExtractPlugin.loader,
            "css-loader"
          ]
        },
        {
          test: /\.scss$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            MiniCssExtractPlugin.loader,
            "css-loader",
            "sass-loader"
          ]
        }
      ]
    }
  });
}
