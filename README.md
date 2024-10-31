# Circle Web3 Services Ruby Client

Ruby client for Circle's Web3 Services API.

## Installation

Add this line to your application's Gemfile:
```ruby
gem "circle-w3s-ruby"
```

And then execute:
```bash
bundle install
```

Or install it yourself as:
```bash
gem install circle-w3s-ruby
```

## Usage

### Configuration

First, configure the client with your API credentials:

```ruby
CircleW3s.configure do |config|
  config.access_token = "TEST_API_KEY:your-key-id:your-key-secret"
  config.host = "https://api-sandbox.circle.com"
  config.entity_secret = "your-entity-secret"  # 32-byte hex string
end
```

### Examples

#### List Wallet Sets

```ruby
# Create API client
client = CircleW3s::ApiClient.new(CircleW3s.configuration)
wallet_sets_api = CircleW3s::WalletSetsApi.new(client)

# Get wallet sets
response = wallet_sets_api.get_wallet_sets
puts response.data  # Access the wallet sets data
```

#### Create Wallet Set

```ruby
# Create API client
client = CircleW3s::ApiClient.new(CircleW3s.configuration)
wallet_sets_api = CircleW3s::WalletSetsApi.new(client)

# Create request with automatically generated entity_secret_ciphertext
request = CircleW3s::CreateWalletSetRequest.new(
  name: "My First Wallet Set",
  entity_secret_ciphertext: CircleW3s.configuration.generate_entity_secret_ciphertext
)

# Create wallet set
response = wallet_sets_api.create_wallet_set(request)
puts response.data  # Access the created wallet set data
```

## Response Structure

All API responses are wrapped in a structured object with the following attributes:
- `data`: The actual response data
- `success`: Boolean indicating if the request was successful
- `status`: HTTP status code

## Error Handling

The client will raise exceptions for various error cases:
- `CircleW3s::UnauthorizedError`: 401 authentication errors
- `CircleW3s::ApiError`: Other API errors

```ruby
begin
  response = wallet_sets_api.get_wallet_sets
rescue CircleW3s::UnauthorizedError => e
  puts "Authentication failed: #{e.message}"
rescue CircleW3s::ApiError => e
  puts "API error: #{e.message}"
end
```