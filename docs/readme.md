# Welcome to Hyperstack!

## Hyperstack

Hyperstack is a Ruby-based DSL and modern web toolkit for building spectacular, interactive web applications fast!

+ **One language** throughout the client and server. All Ruby code is compiled by [Opal](https://opalrb.com/) into JavaScript automatically.
+ Webpacker and Yarn tooling for a **modern, fast hot-reloader build environment with Ruby source maps**.
+ A well documented and stable Ruby DSL for wrapping **React** and **ReactRouter** as well as **any** JavaScript library or component. No need to learn JavaScript!
+ **Isomorphic Models with bi-directional data** so you can access your models as if they were on the client.

All that means you can write simple front-end code like this:

```ruby
class GoodBooksToRead < Hyperstack::Component
  render(UL) do
    Book.good_books.each do |book|
      LI { "Read #{book.name}" }.on(:click) { display book } if book.available?
    end
  end
end
```

In the code above, if the `good_books` scope changed (even on the server), the UI would update automatically. That's the magic of React and Isomorphic Models with bi-directional data at work!

## Website and documentation

+ Website: [hyperstack.org](https://hyperstack.org)

Our website serves as a Hyperstack example application. All the doc content is loaded dynamically from this repo and converted to HTML on the fly. It uses React Semantic UI and a client-side JavaScript full-text search engine. Its a Rails app hosted on Heroku.

## Setup and installation

You can be up and running in **less than 5 minutes**. Just follow the simple setup guide for a new Rails application all correctly configured and ready to go with Hyperstack.

+ Setup and Installation: https://hyperstack.org/edge/docs/installation

Beyond the installation we strongly suggest new developers work trough the [ToDo tutorial](https://github.com/hyperstack-org/hyperstack/blob/edge/docs/tutorial/todo.md).
As it gives a minial understanding of the Hyperstack framework.

## Community and support

Hyperstack is supported by a friendly, helpful community, both for users, and contributors. We welcome new people, please reach out and say hello.

+ Reach us at: [Gitter chat](https://gitter.im/ruby-hyperloop/chat)

## Roadmap

Hyperstack is evolving; we are improving it all the time. As much as we love Ruby today, we see ourselves embracing new languages in the future. [Crystal](https://crystal-lang.org/) perhaps? We are also watching [Wasm](https://webassembly.org/) carefully.

Please see the [ROADMAP](https://github.com/hyperstack-org/hyperstack/blob/edge/ROADMAP.md) for more information.

## Contributing

We have a [Feature Matrix](https://github.com/hyperstack-org/hyperstack/blob/edge/docs/feature_matrix.md) that needs to be filled with missing features.
The idea is that you can check here what the implementation status is of a Ruby (on Rails) feature.
And if you have the time and skill you're more then encuraged to implement or fix one or two.
But if you're not in a position to contribute code, just expanding and maintaining this table would be very excellent.

If you would like to help in any other way, please read the [CONTRIBUTING](https://github.com/hyperstack-org/hyperstack/blob/edge/CONTRIBUTING.md) file for suggestions.

## Links

+ Rubygems: https://rubygems.org/profiles/hyperstack
+ Travis: https://travis-ci.org/hyperstack-org
+ Website edge: https://edge.hyperstack.org/
+ Website master: https://hyperstack.org/

## License

Released under the MIT License. See the [LICENSE][https://github.com/hyperstack-org/hyperstack/blob/edge/LICENSE] file for further details.

## History

Hyperstack is an evolution of [Ruby-Hyperloop](https://github.com/ruby-hyperloop). We decided to rename the project to drop the Ruby suffix and also took the opportunity to simplify the repos and project overall.

+ Old website: http://ruby-hyperloop.org/
+ Old Github: https://github.com/ruby-hyperloop
+ Legacy branch: https://github.com/hyperstack-org/hyperstack/tree/hyperloop-legacy
+ Legacy install script: https://github.com/hyperstack-org/hyperstack/tree/hyperloop-legacy/install
