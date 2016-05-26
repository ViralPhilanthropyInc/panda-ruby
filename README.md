# PandaPay Stripe Bindings

This is an early development release of the PandaPay Ruby bindings.  Currently, only PandaPay Ecommerce integration with Stripe Connect is supported.

## Installation

```bash
  pip install pandapay
```

## Usage

The PandaPay ECS client is meant to be a drop-in replacement for users who are already using Stripe and would now like to donate a percentage of their revenue through PandaPay ECS w/ Stripe Connect.  Currently, only the Charge/Donation method is supported.

To start processing payments through PandaPay and allocate revenue to charity, this:

```ruby
require 'stripe'

Stripe.api_key = "sk_test_mystripesecretkey"

Stripe::Charge.create(
  amount: 400,
  currency: "usd",
  source: "tok_18An5IGxtonQ6vBUBnw2t7LQ", # obtained with Stripe.js
  description: "Charge for test@example.com"
)
```

becomes this:

```ruby

require 'pandapay'

PandaPay.api_key = "sk_test_myPANDAsecretkey"

PandaPay::StripeEcommerce::Charge.create(
  amount: 400,
  donation_amount: 100,
  receipt_email: thedonator@email.com,
  destination_ein: "12-3456789", # Optional
  currency: "usd",
  source: "tok_18An5IGxtonQ6vBUBnw2t7LQ", # still the same token from Stripe.js
  description: "Charge for test@example.com"
)
```

The PandaPay API takes this charge, relays it to Stripe on your behalf using the OAuth token obtained via Stripe Connect, less the donation amount (which will show up in Stripe as a "Panda Fee").  This also works with the standard Stripe **customer** parameter instead of a **source**.

