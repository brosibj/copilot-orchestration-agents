---
name: blazor-js-interop-disposal
description: "Blazor Server JS interop disposal patterns. Use when implementing or debugging IAsyncDisposable components that use IJSRuntime/IJSObjectReference for cleanup during disposal."
user-invocable: false
---

# Blazor Server JS Interop Disposal

## Problem
`JSDisconnectedException` during `DisposeAsync` when the Blazor circuit disconnects before component disposal completes (navigation, tab close, network loss, idle timeout).

## Pattern

| | Approach |
|:---|:---|
| **Anti-pattern** | Calling JS interop in `DisposeAsync` without exception handling |
| **Correct** | Wrap JS interop calls in try/catch for `JSDisconnectedException` |

### Anti-pattern
```csharp
public async ValueTask DisposeAsync()
{
    if (jsModule != null)
    {
        await jsModule.InvokeVoidAsync("cleanup");
        await jsModule.DisposeAsync();
    }
}
```

### Correct
```csharp
public async ValueTask DisposeAsync()
{
    if (jsModule != null)
    {
        try
        {
            await jsModule.InvokeVoidAsync("cleanup");
            await jsModule.DisposeAsync();
        }
        catch (JSDisconnectedException)
        {
            // Expected during disposal — not an error, do not log
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Error during JS module disposal");
        }
    }

    dotNetRef?.Dispose();
}
```

## Rules
1. **Catch `JSDisconnectedException` specifically** — silently handle, do not log.
2. **Catch other exceptions separately** — log as warning for debugging.
3. **Still call `DisposeAsync` on JS module** — module disposal may succeed even if `InvokeVoidAsync` failed.
4. **Always dispose `DotNetObjectReference`** (`dotNetRef?.Dispose()`) outside the try/catch.

## Applies When
Component implements `IAsyncDisposable` AND uses `IJSRuntime` / `IJSObjectReference` for JS cleanup during disposal.