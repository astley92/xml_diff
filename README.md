# XmlDiff

## The Plan

To write a gem making it simple to compare 2 XML documents and generate the difference between the objects that each contain.

### Goal Usage Example

**Given the following XML documents**

```xml
<movies>
    <movie>
        <title>Harry Potter and the Philospher Stone</title>
        <genre>Fantasy</genre>
        <boxofficeearnings>$974,755,371</boxofficeearnings>
        <year>2001</year>
    </movie>
    <movie>
        <title>Fantastic Beasts</title>
        <genre>Action</genre>
        <boxofficeearnings>$803,798,342</boxofficeearnings>
        <year>2016</year>
    </movie>
</movies>
```

```xml
<movies>
    <movie>
        <title>Newest Title</title>
        <genre>Fantasy</genre>
        <boxofficeearnings>$100</boxofficeearnings>
        <year>2024</year>
    </movie>
    <movie>
        <title>Fantastic Beasts</title>
        <genre>Action</genre>
        <boxofficeearnings>$814,798,342</boxofficeearnings>
        <year>2018</year>
    </movie>
</movies>
```

Then the following is an example of how to get the diff

```ruby
inspector = XmlDiff::Inspector.new
inspector.add_data_type(
    type: "Movie",
    css_path: "movies movie",
    attributes: [:title, :year, :boxofficeearnings],
    identifier_attributes: [:title],
)

diff = XmlDiff::Generator.run( # returns an XmlDiff::Diff object
    inspector: inspector,
    data_one: first_data,
    data_two: second_data,
)

diff.removals # Should include Harry Potter Xml::Diff::Addition object
diff.additions # Should include Newest Title Xml::Diff::Removal object
diff.changes # Should include Fantastic beasts Xml::Diff::Change object
```

### Things Not Considered

These won't be considered until the above is working but will need to be before release.

- Namespaces

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/xml_diff. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/xml_diff/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the XmlDiff project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/xml_diff/blob/main/CODE_OF_CONDUCT.md).
