<img src="https://avatars3.githubusercontent.com/u/251374?s=200&v=4" width="75" alt="Spotify Logo" />

# Token Swap Service for Spotify 🔑 ⛓

**TL;DR** This is a super tiny [Ruby][ruby] service for supporting [Authorization Code Flow][authorization-code-flow] on iOS, Android, and static frontend apps with Spotify.

When should I use [Implicit Grant Flow][implicit-grant-flow] instead of [Authorization Code Flow][authorization-code-flow]?

* You only want users to authenticate once, but your application will never go into production, so security isn't a priority.
* You don't mind users re-authenticating every 60 minutes.

Read more about token swapping [on Spotify for Developers][token-swap-refresh-guide].

## Contents 📖

* [How It Works](#how-it-works)
* [Install](#install)
  * [One-click with Heroku](#one-click-with-heroku)
  * [Manual Install](#manual-install)
* [Configuration](#configuration)

## How It Works

When authenticating users with your Spotify application, you can authenticate them through two ways: [Implicit Grant Flow][implicit-grant-flow] and [Authorization Code Flow][authorization-code-flow].

### Implicit Grant Flow

You don't need to setup this service, and you can close your window.

The Implicit Grant Flow returns an `access_token` directly back to your application once the user has authorized your application. It expires in 60 minutes, after which the user has to re-authorize your application.

### Authorization Code Flow

**Recommended**

The Authorization Code Flow returns a `code` directly back to your application once the user has authorized your application. This `code` can be exchanged for an `access_token` through the Spotify Accounts API.

This could be performed directly inside of your iOS, Android, or static web apps and will work as intended - but it is extremely insecure as it exposes your client secret to the world. **This should never be done for production apps, ever.**

The right way is to handle the "exchange" on a server and have your application call that server. This would securely store your client secret away from developers who might reverse engineer your iOS, Android, or static web apps. **This repository is a lightweight implementation of that exchange server.**

## Install

### One-click with Heroku

Just click that button below. Fill in the form and it'll work like magic. ✨

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

### Manual Install

Install the project locally:

```bash
$ git clone https://github.com/bih/spotify-token-swap-service.git
$ cd spotify-token-swap-service/
$ bundle install
```

Then to run the server:

```bash
$ cp .sample.env .env
$ vim .env
$ rackup
```

## Configuration

There are several environment variables you'll need to set:

| Environment Variable          | Description                                                                                                       | Required    |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------- |
| `SPOTIFY_CLIENT_ID`           | A valid client ID from [Spotify for Developers][s4d].                                                             | Required ✅ |
| `SPOTIFY_CLIENT_SECRET`       | A valid client secret from [Spotify for Developers][s4d].                                                         | Required ✅ |
| `SPOTIFY_CLIENT_CALLBACK_URL` | A registered callback from [Spotify for Developers][s4d].                                                         | Required ✅ |
| `ENCRYPTION_SECRET`           | A random "salt" for securing your refresh token. [Grab one here](https://api.wordpress.org/secret-key/1.1/salt/). | Optional ╳  |

As mentioned in [Manual Install](#manual-install), these are all outlined in `.sample.env` which you can move over to `.env` and modify with your respective credentials.

[ruby]: https://ruby-lang.org
[s4d]: https://beta.developer.spotify.com
[authorization-code-flow]: https://beta.developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow
[implicit-grant-flow]: https://beta.developer.spotify.com/documentation/general/guides/authorization-guide/#implicit-grant-flow
[token-swap-refresh-guide]: https://beta.developer.spotify.com/documentation/ios-sdk/guides/token-swap-and-refresh/

To use the new [Spotify SDK](https://github.com/spotify/ios-sdk) we are required to run our own [Token Exchange Service](https://developer.spotify.com/technologies/spotify-ios-sdk/tutorial/#setting-up-your-token-exchange-service). This repository provides you with an easy installation on [Heroku](http://heroku.com/home). The current `CLIENT_ID`, `CLIENT_SECRET` and `CLIENT_CALLBACK_URL` are straight from [Spotifys Repo](https://github.com/spotify/ios-sdk/tree/master/Demo%20Projects) and work with their example apps.

# Setup

* Sign up for [Heroku](https://signup.heroku.com/) and follow the first two [Getting Started Steps](https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction)

Unless you are expecting **massive** traffic, the free plan will work for you. Be patient, it can take up to 60 min until you get the confirmation Mail from Heroku.

* [Clone](https://devcenter.heroku.com/articles/getting-started-with-ruby#prepare-the-app) this Repository

```bash
git clone https://github.com/simontaen/SpotifyTokenSwap.git
cd SpotifyTokenSwap
```

From here on forward it's basically following the Getting Started Guide.

* [Deploy](https://devcenter.heroku.com/articles/getting-started-with-ruby#deploy-the-app) the app using git

```bash
heroku create --http-git
git push heroku master
heroku ps:scale web=1
```

* [View logs](https://devcenter.heroku.com/articles/getting-started-with-ruby#view-logs)

```bash
heroku logs --tail
```

* Verify its running

```bash
curl https://peaceful-sierra-1249.herokuapp.com
```

and you should get a `<h1>Not Found</h1>` back. Also check the logs should show something like

```
app[web.1]: ip-10-147-165-35.ec2.internal - - [<timestamp>] "GET / HTTP/1.1" 404 18
app[web.1]: - -> /
app[web.1]: <your-ip> - - [<timestamp>] "GET / HTTP/1.1" 404 18 0.0005
heroku[router]: at=info method=GET path="/" host=peaceful-sierra-1249.herokuapp.com <...>
```

Or run the Spotify examples with a corrected `kTokenSwapServiceURL` and `kTokenRefreshServiceURL`.

* Your own app

As mentioned above the current code is configured to what Spotify provided us. So you need to syncronize the `CLIENT_ID`, `CLIENT_SECRET` and `CLIENT_CALLBACK_URL` between your [Spotify Account](https://developer.spotify.com/my-applications/#!/applications), your iOS App and the `spotify_token_swap.rb`.

# Run Locally

```bash
bundle install
foreman start
```

`foreman`is part of the [Heroku Toolbelt](https://devcenter.heroku.com/articles/getting-started-with-ruby#set-up).

# Contributing

## Access the console

```bash
bundle install
bin/console
```

# Convenience

I personally will host an instance on Heroku for public use as it is very annoying to go through setting everything up when you just want to try something with the SDK. I'll keep it on the free plan and won't pay much attention to it. We'll see how it goes but if the service it getting slammed it'll crash, so be polite.

```
https://peaceful-sierra-1249.herokuapp.com/swap
https://peaceful-sierra-1249.herokuapp.com/refresh
```
