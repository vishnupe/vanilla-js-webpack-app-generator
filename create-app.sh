#!/bin/bash

echo "Creating app '"$1"' ..."

mkdir $1

cd $1

mkdir -p src/assets/{js,less,media}

touch package.json

echo 'console.log("Hurray!");' >> src/app.js

echo '<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title></title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
    Hurray!
</body>
</html>' >> src/index.html

echo '{
  "name": "'$1'",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "build": "./node_modules/.bin/webpack",
    "build:prod": "./node_modules/.bin/webpack -p",
    "watch": "./node_modules/.bin/webpack --watch",
    "dev": "./node_modules/.bin/webpack-dev-server"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "babel-core": "^6.26.3",
    "babel-loader": "^7.1.5",
    "babel-preset-env": "^1.7.0",
    "babel-preset-es2017": "^6.24.1",
    "clean-webpack-plugin": "^0.1.19",
    "css-loader": "^1.0.0",
    "extract-text-webpack-plugin": "^4.0.0-beta.0",
    "file-loader": "^1.1.11",
    "html-loader": "^0.5.5",
    "html-webpack-plugin": "^3.2.0",
    "less-loader": "^4.1.0",
    "mini-css-extract-plugin": "^0.4.1",
    "node-sass": "^4.9.3",
    "sass-loader": "^7.1.0",
    "style-loader": "^0.22.1",
    "url-loader": "^1.1.1",
    "webpack": "^4.16.5",
    "webpack-cli": "^3.1.0",
    "webpack-dev-server": "^3.1.5"
  }
}' >> package.json

echo '{
    "presets": ["es2017"]
}' >> .babelrc

echo '# See http://help.github.com/ignore-files/ for more about ignoring files.

# compiled output
/dist
/dist-server
/tmp
/out-tsc

# dependencies
/node_modules

# IDEs and editors
/.idea
.project
.classpath
.c9/
*.launch
.settings/
*.sublime-workspace

# IDE - VSCode
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json

# misc
/.sass-cache
/connect.lock
/coverage
/libpeerconnection.log
npm-debug.log
yarn-error.log
testem.log
/typings

# e2e
/e2e/*.js
/e2e/*.map

# System Files
.DS_Store
Thumbs.db
' >> .gitignore

echo 'const path = require("path");
const CleanWebpackPlugin = require("clean-webpack-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const webpack = require("webpack");

const config = {
    context: path.resolve(__dirname, "src"),
    entry: {
        app: "./app.js"
    },
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "./assets/js/[name].bundle.js"
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                include: /src/,
                exclude: /node_modules/,
                use: {
                    loader: "babel-loader",
                    options: {
                        presets: ["es2017"]
                    }
                }
            },
            {
                test: /\.html$/,
                use: ["html-loader"]
            },
            {
                test: /\.css$/,
                include: /src/,
                exclude: /node_modules/,
                use: [{
                        loader: MiniCssExtractPlugin.loader,
                    },
                    "css-loader"
                ]
            },
            {
                test: /\.less$/,
                include: [path.resolve(__dirname, "src", "assets", "less")],
                use: ExtractTextPlugin.extract({
                    use: [{
                            loader: "css-loader",
                            options: {
                                sourceMap: true
                            }
                        },
                        {
                            loader: "less-loader",
                            options: {
                                sourceMap: true
                            }
                        },
                    ],
                    fallback: "style-loader"
                })
            },
            {
                test: /\.(jpg|png|gif|svg)$/,
                use: [{
                    loader: "file-loader",
                    options: {
                        name: "[name].[ext]",
                        outputPath: "./assets/media/"
                    }
                }]
            },
            {
                test: /\.(mp3|mp4)$/,
                use: [{
                    loader: "file-loader",
                    options: {
                        name: "[name].[ext]",
                        outputPath: "./assets/media/"
                    }
                }]
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: ["file-loader"]
            }

        ]
    },
    plugins: [
        new CleanWebpackPlugin(["dist"]),
        new HtmlWebpackPlugin({
            template: "index.html"
        }),
        new MiniCssExtractPlugin({
            filename: "[name].css",
            chunkFilename: "[id].css"
        }),
        new ExtractTextPlugin({
            filename: "assets/css/[name].css",
        })
    ],
    devServer: {
        contentBase: path.resolve(__dirname, "./dist/assets/media"),
        compress: true,
        port: 8081,
        stats: "errors-only",
        open: true
    },
    devtool: "inline-source-map"
}

module.exports = config;' >> webpack.config.js

npm install

