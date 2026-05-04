---
name: easy_mcp_add-server-annotations
description: Add easy_api annotations (@Server, @Tool, @Parameter) to existing Dart code to expose methods as MCP tools or REST API endpoints. Use when converting Dart libraries to MCP/REST servers, adding tool exposure to existing functions, or when the user wants to make their Dart code callable via the Model Context Protocol or HTTP APIs.
---

# Add Easy API Annotations to Dart Code

Convert existing Dart methods into MCP tools or REST API endpoints using easy_api annotations.

## Overview

This skill helps you add `@Server`, `@Tool`, and `@Parameter` annotations to existing Dart code, transforming it into an MCP server and/or REST API that can be called by AI assistants, MCP clients, or HTTP consumers.

> **Note:** `@Mcp` is still available as a deprecated typedef for backward compatibility. New code should use `@Server`.

## Prerequisites

Before adding annotations:
1. Add `easy_api_annotations` to dependencies
2. Add `easy_api_generator` and `build_runner` to dev_dependencies
3. Run `dart pub get`

## Annotation Quick Reference

### @Server
Marks the entry point for MCP server and/or REST API generation.

```dart
@Server(
  transport: McpTransport.stdio,  // or McpTransport.http
  port: 3000,                     // for HTTP transport (default: 3000)
  address: '127.0.0.1',           // for HTTP transport (default: '127.0.0.1')
  generateJson: false,            // generate .mcp.json metadata file (default: false)
  generateMcp: true,              // generate .mcp.dart MCP server (default: true)
  generateRest: false,            // generate .openapi.json + .openapi.dart REST server (default: false)
  codeMode: false,                // enable JavaScript sandbox for batch tool orchestration (default: false)
  codeModeTimeout: 30,            // max execution time for code mode in seconds (default: 30)
  toolPrefix: 'api_',             // prefix all tool names (optional)
  autoClassPrefix: true,          // prefix with class name (optional)
  logErrors: false,               // log errors to stderr for debugging (default: false)
)
```

**Parameters:**
- `transport`: `McpTransport.stdio` (default) or `McpTransport.http`
- `port`: HTTP server port (default: 3000, only for HTTP transport)
- `address`: HTTP bind address (default: '127.0.0.1', use '0.0.0.0' for all interfaces)
- `generateJson`: Whether to generate .mcp.json metadata file (default: false)
- `generateMcp`: Whether to generate .mcp.dart MCP server (default: true)
- `generateRest`: Whether to generate .openapi.json spec and .openapi.dart REST server (default: false)
- `codeMode`: Enable JavaScript sandbox for batch tool orchestration (default: **false**). Set to `true` to enable code mode with `search` and `execute` tools
- `codeModeTimeout`: Max execution time for code mode in seconds (default: 30, only when codeMode: true)
- `toolPrefix`: Prefix added to all tool names (e.g., 'user_' makes 'createUser' → 'user_createUser')
- `autoClassPrefix`: Automatically prefix tool names with class name (e.g., `UserService_createUser`)
- `logErrors`: Log internal errors to stderr for debugging (default: false)

### @Tool
Marks a method as an MCP tool and/or REST API endpoint.

```dart
@Tool(
  name: 'user_create',  // Custom tool name (optional, defaults to method name)
  description: 'Creates a new user in the system',
  icons: ['https://example.com/icon.png'],   // Optional icon URLs for visual identification
  codeMode: true,                            // Available in code mode sandbox (default: true)
  codeModeVisible: false,                    // Listed in tools/list when codeMode enabled (default: false)
)
```

**Parameters:**
- `name`: Optional custom tool name (defaults to method name). Useful for avoiding naming collisions
- `description`: Human-readable description (uses dartdoc if omitted)
- `icons`: Optional list of icon URLs for UI clients
- `codeMode`: Whether tool is available in code mode sandbox (default: true). Set to false for destructive operations
- `codeModeVisible`: Whether tool appears in tools/list when codeMode is enabled (default: false). Set to true to pin specific tools to the standard tool list

### @Parameter (Optional)
Provides rich metadata for individual parameters.

```dart
@Parameter(
  title: 'Email Address',
  description: 'A valid email address',
  example: 'user@example.com',
  pattern: r'^[\w\.-]+@[\w\.-]+\.\w+$',
)
```

**Parameters:**
- `title`: Human-readable parameter name
- `description`: Detailed explanation
- `example`: Example value for guidance
- `minimum`/`maximum`: Numeric validation bounds
- `pattern`: Regex pattern for string validation
- `sensitive`: Mark as sensitive (passwords, API keys)
- `enumValues`: List of allowed values

## Workflow

### Step 1: Identify Methods to Expose

Look for methods that:
- Are `public` (not private with `_` prefix)
- Return `Future<T>` or simple types
- Have serializable parameters (primitives, lists, maps)
- Perform useful operations (CRUD, calculations, API calls)

### Step 2: Choose Transport Mode

**Use stdio when:**
- Integrating with CLI tools
- Running as a subprocess
- Local development and testing

**Use HTTP when:**
- Remote access needed
- Docker/containerized deployment
- Multiple clients need access

### Step 3: Add @Server Annotation

Place `@Server` on the class or library containing your tools:

```dart
import 'package:easy_api_annotations/mcp_annotations.dart';

// Basic MCP server with code mode disabled (default)
@Server(
  transport: McpTransport.stdio,
  generateMcp: true,    // Generate MCP server
  generateRest: false,  // Set true to also generate REST API
  // codeMode: false is the default - all tools will be listed in tools/list
)
class UserService {
  // tools go here
}
```

### Step 4: Add @Tool Annotations

Mark each method you want to expose:

```dart
// MCP server with code mode disabled (default behavior)
@Server(
  transport: McpTransport.stdio,
  generateMcp: true,
  // codeMode: false is the default - all @Tool methods appear in tools/list
)
class UserService {
  @Tool(description: 'Get user by ID')
  Future<User?> getUser(int id) async {
    // existing implementation
  }
  
  @Tool(description: 'Create a new user')
  Future<User> createUser(String name, String email) async {
    // existing implementation
  }
}
```

### Step 5: Customize Tool Names (Optional)

By default, tool names match method names. Customize them to avoid collisions:

**Option A: Use `name` parameter on individual tools:**

```dart
@Server(transport: McpTransport.stdio)
class UserService {
  @Tool(
    name: 'user_create',  // Custom name instead of 'createUser'
    description: 'Creates a new user',
  )
  Future<User> createUser(String name, String email) async { ... }
}
```

**Option B: Use `toolPrefix` on the class (applies to all tools):**

```dart
@Server(transport: McpTransport.stdio, toolPrefix: 'user_service_')
class UserService {
  @Tool(description: 'Create user')
  Future<User> createUser() async { ... }  // Tool name: user_service_createUser
  
  @Tool(description: 'Delete user')
  Future<void> deleteUser(String id) async { ... }  // Tool name: user_service_deleteUser
}
```

**Option C: Use `autoClassPrefix` for automatic class-based naming:**

```dart
@Server(transport: McpTransport.stdio, autoClassPrefix: true)
class UserService {
  @Tool(description: 'Create user')
  Future<User> createUser() async { ... }  // Tool name: UserService_createUser
  
  @Tool(description: 'Delete user')
  Future<void> deleteUser(String id) async { ... }  // Tool name: UserService_deleteUser
}
```

**Combining `autoClassPrefix` with `toolPrefix`:**

```dart
@Server(transport: McpTransport.stdio, autoClassPrefix: true, toolPrefix: 'api_')
class UserService {
  @Tool(description: 'Create user')
  Future<User> createUser() async { ... }  // Tool name: api_UserService_createUser
}
```

### Step 6: Add @Parameter (Optional)

For parameters needing extra metadata:

```dart
@Tool(description: 'Search users')
Future<List<User>> searchUsers({
  @Parameter(
    title: 'Search Query',
    description: 'Name or email to search for',
    example: 'john@example.com',
  )
  required String query,
  
  @Parameter(
    title: 'Maximum Results',
    description: 'Limit number of results returned',
    minimum: 1,
    maximum: 100,
    example: 10,
  )
  int limit = 20,
}) async {
  // existing implementation
}
```

### Step 7: Generate Server Code

Run the build runner:

```bash
dart run build_runner build
```

This generates:
- `{file}.mcp.dart` - Complete MCP server implementation (when `generateMcp: true`)
- `{file}.mcp.json` - Tool metadata (when `generateJson: true`)
- `{file}.openapi.json` - OpenAPI 3.0 REST specification (when `generateRest: true`)
- `{file}.openapi.dart` - Complete REST API server (when `generateRest: true`)

> **Note on Code Mode**: By default, `codeMode: false` means all your `@Tool` methods will be listed in the standard `tools/list` response and directly callable by MCP clients. To enable code mode (which hides tools behind `search` and `execute` orchestration tools), explicitly set `codeMode: true` on `@Server`.

### Step 8: Run the Server

**For stdio transport:**
```bash
dart run bin/your_file.mcp.dart
```

**For HTTP transport:**
```bash
dart run bin/your_file.mcp.dart
# Server runs on configured port
```

## Common Patterns

### CRUD Service

```dart
@Server(
  transport: McpTransport.http,
  port: 8080,
  generateRest: true,  // Also generate REST API
)
class TodoService {
  @Tool(description: 'List all todos')
  Future<List<Todo>> listTodos() async { ... }
  
  @Tool(description: 'Get a todo by ID')
  Future<Todo?> getTodo(String id) async { ... }
  
  @Tool(description: 'Create a new todo')
  Future<Todo> createTodo({
    @Parameter(title: 'Title', example: 'Buy groceries')
    required String title,
    
    @Parameter(title: 'Priority', enumValues: ['low', 'medium', 'high'])
    String priority = 'medium',
  }) async { ... }
  
  @Tool(description: 'Update an existing todo')
  Future<Todo> updateTodo(String id, {String? title, bool? completed}) async { ... }
  
  @Tool(
    description: 'Delete a todo',
    codeMode: false,  // Disable from code mode for safety
  )
  Future<void> deleteTodo(String id) async { ... }
}
```

### API Client Wrapper

```dart
@Server(transport: McpTransport.stdio)
class WeatherApi {
  @Tool(description: 'Get current weather for a location')
  Future<Weather> getCurrentWeather({
    @Parameter(
      title: 'City Name',
      example: 'San Francisco',
      pattern: r'^[A-Za-z\s]+$',
    )
    required String city,
    
    @Parameter(
      title: 'Units',
      description: 'Temperature units',
      enumValues: ['celsius', 'fahrenheit'],
    )
    String units = 'celsius',
  }) async { ... }
}
```

### Utility Functions

```dart
@Server(transport: McpTransport.stdio)
class StringUtils {
  @Tool(description: 'Convert text to slug format')
  String toSlug(String text) { ... }
  
  @Tool(description: 'Count words in text')
  int countWords(String text) { ... }
  
  @Tool(description: 'Format date to readable string')
  String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) { ... }
}
```

## Best Practices

1. **Start Simple**: Begin with `@Server()` and `@Tool()` only, add `@Parameter` later if needed
2. **Default is No Code Mode**: By default `codeMode: false`, all tools are directly visible and callable in `tools/list`
3. **Enable Code Mode Intentionally**: Only set `codeMode: true` when you want LLM-driven batch orchestration via JavaScript sandbox
4. **Use dartdoc**: Write good doc comments; they become tool descriptions automatically
5. **Validate Parameters**: Use `@Parameter` with `pattern`, `minimum`, `maximum` for validation
6. **Return Types**: Ensure return types are JSON-serializable
7. **Error Handling**: Throw descriptive exceptions; they become error messages in MCP clients
8. **Avoid Naming Collisions**: Use `autoClassPrefix: true` when multiple classes have methods with the same name, or use `toolPrefix` to organize tools by domain
9. **Protect Destructive Operations**: Use `@Tool(codeMode: false)` for delete/update operations when code mode is enabled
10. **Enable REST API**: Set `generateRest: true` on `@Server` to automatically generate OpenAPI spec and REST server

## Troubleshooting

**Build fails with "annotation not found"**
- Ensure `easy_api_annotations` is in `dependencies` (not dev_dependencies)
- Run `dart pub get`

**Generated code has errors**
- Check that all tool methods are public
- Ensure return types are not private classes
- Verify all parameters have serializable types

**HTTP server not accessible**
- Use `address: '0.0.0.0'` to listen on all interfaces
- Check firewall settings for the configured port

## Migration Checklist

When converting existing code:
- [ ] Add dependency on `easy_api_annotations`
- [ ] Add `@Server` to the main class/library (or use deprecated `@Mcp` for backward compatibility)
- [ ] Add `@Tool` to methods you want to expose
- [ ] Add `@Parameter` for complex parameter validation (optional)
- [ ] Configure `toolPrefix` or `autoClassPrefix` if needed to avoid naming collisions
- [ ] Set `generateRest: true` if you want REST API generation
- [ ] Set `codeMode: true` if you want JavaScript sandbox for batch orchestration
- [ ] Run `dart run build_runner build`
- [ ] Test the generated server(s)
- [ ] Update documentation
