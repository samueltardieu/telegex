# Telegex GitHub Copilot Instructions

## Project Overview

Telegex is a Telegram bot framework for Elixir that provides both a complete Bot API client library and a framework for building bots. It features automatic code generation from the official Telegram Bot API documentation.

## Project Structure

- `lib/telegex.ex` - Main module with all Bot API methods (auto-generated)
- `lib/telegex/` - Core framework modules
  - `chain.ex` - Chain-based update processing system
  - `polling/` - Long polling mode support
  - `hook/` - Webhook mode support
  - `caller/` - HTTP client adapters (Finch, HTTPoison)
  - `type.ex` - All Telegram API types (auto-generated)
  - `method_definer.ex` - Macro system for defining API methods
  - `type_definer.ex` - Macro system for defining types
- `lib/mix/tasks/` - Mix tasks for code generation from API docs
- `examples/` - Example bot implementations
- `test/` - Test suite

## Development Workflow

### Setup
```bash
# Install dependencies
mix deps.get

# For examples
cd examples/echo_bot && mix deps.get
```

### Code Quality
```bash
# Format code (ALWAYS run before committing)
mix format

# Run linter
mix credo

# Run type checker
mix dialyzer

# Check everything
just check
```

### Testing
```bash
# Run tests
mix test

# Run specific test
mix test test/telegex/helper_test.exs
```

## Important Conventions

### Code Generation
- **DO NOT manually edit** `lib/telegex.ex` or `lib/telegex/type.ex` - these are generated files
- API methods and types are auto-generated from the official Telegram documentation
- To update API: `mix api.upgrade` (runs gen.doc_html, gen.doc_json, gen.code, format)
- Code generation is defined in `lib/mix/tasks/gen.*.ex`

### Coding Style
- Follow Elixir standard style guidelines
- Use `mix format` with the project's `.formatter.exs` configuration
- Import deps in formatter config: `typed_struct`, `plug`
- Run Credo for additional style checks (configured in `.credo.exs`)
- Use `@moduledoc` for module documentation
- Use `@doc` for public function documentation
- Use `@spec` for function type specifications
- Private functions should use `@moduledoc false` or no moduledoc

### Module Organization
- Use `TypedStruct` for defining structured data types
- Separate concerns: caller adapters, hook adapters, chain handlers
- Follow the `GenHandler` behaviour pattern for polling and webhook handlers
- Use macros in `Telegex.Chain` for common chain patterns

### Chain System
The chain system is a key architectural pattern:
- Chains process updates in sequence
- Each chain implements `call/2`, `match?/2`, and `handle/2` callbacks
- Use `use Telegex.Chain, :message` for message chains
- Use `use Telegex.Chain, {:command, :start}` for command chains
- Use `use Telegex.Chain, {:callback_query, prefix: "btn:"}` for callback queries
- Return `{:ok, context}` to continue, `{:stop, context}` to stop processing, `{:done, context}` to end

### Testing Guidelines
- Use ExUnit for testing
- Place tests in `test/` mirroring `lib/` structure
- Use `doctest` for testing documentation examples
- Mock external API calls in tests
- Test both success and error cases

### Configuration
- Global config in `config/config.exs` under `:telegex` key
- Use `Telegex.Global` to read global configuration
- Use `Telegex.Instance` for instance-specific configuration
- Support for multiple HTTP adapters: Finch (recommended), HTTPoison
- Support for multiple webhook adapters: Bandit (default), Cowboy

### HTTP Client Adapters
- Finch is the recommended adapter (with multipart support for file uploads)
- HTTPoison is supported but cannot send local files
- Adapters are configured via `caller_adapter` in config
- Pass adapter-specific options as tuple: `{Finch, [receive_timeout: 5000]}`

### Webhook vs Polling
- **Polling**: Simple, reliable, messages arrive in order per group
  - Use `Telegex.Polling.GenHandler` behaviour
  - Implement `on_boot/0` and `on_update/1`
  - Returns `Telegex.Polling.Config` struct
- **Webhook**: More efficient for production
  - Use `Telegex.Hook.GenHandler` behaviour
  - Requires `plug`, `remote_ip` dependencies
  - Implement `on_boot/0` and `on_update/1`
  - Returns `Telegex.Hook.Config` struct
  - Requires webhook adapter (Bandit or Cowboy)

### Dependencies
- Optional dependencies for different use cases:
  - `finch`, `multipart` - for Finch HTTP client
  - `httpoison` - for HTTPoison client
  - `plug`, `remote_ip` - for webhook mode
  - `plug_cowboy` or `bandit` - for webhook server
- Development dependencies: `dialyxir`, `credo`, `ex_doc`, `floki`
- Core dependencies: `typed_struct`, `jason`

## Common Tasks

### Adding a New Feature
1. Check if it involves API changes (likely auto-generated)
2. For framework features, add to appropriate module under `lib/telegex/`
3. Add tests in `test/telegex/`
4. Update documentation
5. Run `mix format` and `mix credo`

### Working with Generated Code
- Do not modify `lib/telegex.ex` or `lib/telegex/type.ex` directly
- To understand generation, see `lib/mix/tasks/gen.code.ex`
- Generator uses structured data from `telegex/api_doc.json` repository

### Adding Tests
- Create test file matching source file path
- Use `use ExUnit.Case`
- Add `doctest ModuleName` if module has doctests
- Test public API functions
- Consider edge cases and error conditions

### Documentation
- Use `@moduledoc` at module level
- Use `@doc` for public functions
- Include examples in doctests when helpful
- Use `@spec` for function signatures
- Generate docs with `mix docs`

## Key Patterns to Follow

1. **Behaviour-based Design**: Use behaviours for extensibility (GenHandler, Chain, Adapter)
2. **Configuration via Structs**: Use structs for configuration (Config modules)
3. **Adapter Pattern**: Support multiple implementations (HTTP clients, webhook servers)
4. **Macro-based DSL**: Leverage macros for clean API (MethodDefiner, TypeDefiner, Chain)
5. **Functional Core**: Keep business logic pure, side effects at edges
6. **Supervised Processes**: Handlers run under supervision tree

## Anti-Patterns to Avoid

1. Don't manually edit generated files (`telegex.ex`, `type.ex`)
2. Don't add dependencies without marking them as optional when appropriate
3. Don't skip `mix format` before committing
4. Don't hard-code configuration values, use config system
5. Don't forget to clean `_build` when upgrading dependencies (especially plug-dependent modules)
6. Don't return raw maps from API functions, use typed structs

## Examples

See `examples/echo_bot/` for a complete working bot implementation demonstrating:
- Polling handler setup
- Chain-based message processing
- Command handling (`/start`, `/ping`)
- Callback query handling
- Text echoing

## Resources

- [Telegram Bot API Documentation](https://core.telegram.org/bots/api)
- [Hex Documentation](https://hexdocs.pm/telegex/)
- [GitHub Repository](https://github.com/telegex/telegex)
- [Telegram Group](https://t.me/elixir_telegex)
