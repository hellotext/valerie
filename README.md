# VCard parser and generator

This is a simple VCard parser and generator extracted from Hellotext.
It implements the VCard 3.0 specification. It supports all of the cases we want to use in Hellotext.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'valerie'
```

Or install it yourself as: 

```bash
gem install valerie
```

## Usage

Parsing a VCard is as simple as passing a VCard string, like 

```ruby
data = "BEGIN:VCARD\r\nVERSION:3.0\r\nPRODID:-//Hellotext www.hellotext.com//EN\r\nN:Rosenbaum;Shira;;;\r\nTEL;:+598 00 000 00\r\nEND:VCARD"
Valerie::Card.parse(data)
```

## Generating a VCard

You usually start by initializing a new Card object.

```ruby
card = Valerie::Card.new
```

### Types of Properties

According to the VCard 3.0 specification, some types of properties can have multiple values. From the specs, Valerie supports the following properties:

- `EMAIL`: for email addresses
- `TEL`: for telephone numbers
- `ADR`: for addresses

Aside from these, every other support property supports a single value. 


### Single value properties

#### Name

To set the name property for the VCard, you can use the `Card#name=` setter. It accepts two types of arguments,

A hash that contains the following

```ruby
{
  first_name: 'Shira',
  last_name: 'Rosenbaum',
  middle_name: 'M',
  prefix: 'Ms.',
  suffix: 'PhD'
}
```

Or an array with the following order `[first_name, last_name, middle_name, prefix, suffix]`.

```ruby
card.name = %w[Shira Rosenbaum M Ms. PhD]
```

#### Gender 

To set the Gender of the card you can, set it value `Card#gender=`, this accepts one of the following constants: 
`male`, `female`, `other`, `none` and `unknown`. Passing another value raises an `ArgumentError`.

```ruby
card.gender = 'female'
```

#### Birthday

The birthday can be set via `Card#birthday=`. It accepts any object that responds to `strftime`, otherwise it stores the `to_s` version of the value.

```ruby
card.birthday = Date.new(1999, 11, 4)
```

#### Organization

The organization can be an tuple of `[organization_name, department]`, or a hash of `{organization: 'organization_name', department: 'department'}`.
When a string value is passed, only the `organization_name` is set.

```ruby
card.organization = %w[Hellotext Engineering]
card.organization = { organization: 'Hellotext', department: 'Engineering' }
card.organization = 'Hellotext'
```

### Collections 

The card exposes methods to adding the respective collectable properties. Email, telephone and address.

Adding an email,

```ruby
card.emails.add('user@domain.com')
```

Or a telephone number,

```ruby
card.phones.add('+598 00 000 00')
```

Or an address,

```ruby
card.addresses.add(
  {
    post_office_box: 'PO Box 123',
    extended_address: 'Suite 123',
    street_address: '123 Main St',
    locality: 'Anytown',
    region: 'CA',
    postal_code: '12345',
    country: 'United States'
  }
)
```

#### Positions 

Emails, phones and addresses are ordered. They can include an optional `position` argument 
to specify their order when the profile has multiple values. Whenever you add a new value,
a default position argument is picked and the value is appended as the last element. 

To specify the position, you can pass the `position` argument as a keyword argument. Unlike arrays
the position is 1-based and not 0-based.

```ruby
card.emails.add('user@domain.com')
card.emails.add('user@domain2.com', position: 1) # inserts the email as the first element
```

#### Types

Emails, phones and addresses can have types. The types are defined in the VCard 3.0 specification.
To specify the type of one of these properties, you can pass the `types` argument as a keyword argument.

```ruby
card.emails.add('user@domain.com', type: 'work')
card.emails.add('user@domain.com', type: %w[work internet])
```

### Configuration 

You can configure the following properties of the card. 

- `prodid`: The product id of the card. This defaults to 'Valerie www.hellotext.com'.
- `version`: The version of the card. This defaults to '3.0'.
- `language`: The language of the card. This defaults to 'en'.

```ruby
Valerie.configure do |config|
  config.product = 'Valerie www.hellotext.com'
  config.version = '3.0'
  config.language = 'en'
end
```

### Licence

This code is released under the MIT License. See the LICENSE file for more information.

### Contributing

Contributions are welcome. Please follow the steps below to contribute.

1. Fork it 
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
