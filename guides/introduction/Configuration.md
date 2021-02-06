# Configuration

```elixir
config :tinkoff_invest, 
  token: "MYTOKEN",
  broker_account_id: "SB123123",
  mode: :production # You can also use :sandbox for Sandbox mode (:production by default)
  # Tokens and account ids are different depending on your mode
```

- `:mode` - Set it to production or sandbox environment depending on your needs. Production by default. 
- `:token` - Token you created on broker website
- `:broker_account_id` - Your broker account id you created
- `:endpoint` (optional) - You can set your custom endpoint if you're behind proxy/whatever
- `:logs_enabled` (optional) - Whether to log API response to Logger.debug (FALSE by default)

You can also change your token, broker account id, endpoint and mode programmatically, it will change immediately. See `TinkoffInvest` module for details.