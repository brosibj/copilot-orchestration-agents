# Blazor Server JavaScript Interop Disposal Pattern

## The Issue

When disposing Blazor Server components that use JavaScript interop, you may encounter a `JSDisconnectedException` if the Blazor circuit has already disconnected before the component's `DisposeAsync` method completes.

This commonly occurs when:
- Users navigate away from the page
- Users close their browser tab/window
- The connection is lost due to network issues
- The server terminates the circuit due to inactivity

## The Error

```
Microsoft.JSInterop.JSDisconnectedException: JavaScript interop calls cannot be issued at this time. 
This is because the circuit has disconnected and is being disposed.
```

## Why It Happens

In Blazor Server, all JavaScript interop calls are sent over a SignalR connection (circuit). When the circuit disconnects:
1. The component disposal process begins
2. The component tries to call JavaScript cleanup methods
3. The circuit is already gone, so the JS interop call fails

This is a **race condition** between circuit disconnection and component disposal.

## The Solution

Always wrap JavaScript interop calls in `DisposeAsync` with a try-catch block that handles `JSDisconnectedException`:

### ? Incorrect Pattern

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

### ? Correct Pattern

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
            // Circuit disconnected - this is expected during disposal
            // No need to log as this is normal when users navigate away or close browser
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Error during JS module disposal");
        }
    }
}
```

## Key Points

1. **Catch JSDisconnectedException specifically** - This exception is expected and should be silently handled
2. **Don't log JSDisconnectedException** - It's not an error; it's expected behavior
3. **Catch other exceptions separately** - Log unexpected errors for debugging
4. **Still call DisposeAsync on the JS module** - Even if InvokeVoidAsync fails, the module disposal might succeed

## When to Apply This Pattern

Apply this pattern whenever your Blazor Server component:
- Implements `IAsyncDisposable`
- Uses JavaScript interop (`IJSRuntime` or `IJSObjectReference`)
- Needs to call JavaScript cleanup methods during disposal

## Real-World Example

```csharp
@implements IAsyncDisposable
@inject IJSRuntime JSRuntime

@code {
    private IJSObjectReference? keyboardModule;
    private DotNetObjectReference<MyComponent>? dotNetRef;

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (firstRender)
        {
            keyboardModule = await JSRuntime.InvokeAsync<IJSObjectReference>(
                "import", "./js/keyboard-handler.js");
            
            dotNetRef = DotNetObjectReference.Create(this);
            await keyboardModule.InvokeVoidAsync("initialize", dotNetRef);
        }
    }

    public async ValueTask DisposeAsync()
    {
        // Dispose JS module
        if (keyboardModule != null)
        {
            try
            {
                await keyboardModule.InvokeVoidAsync("cleanup");
                await keyboardModule.DisposeAsync();
            }
            catch (JSDisconnectedException)
            {
                // Expected during disposal - no action needed
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Error disposing keyboard module");
            }
        }

        // Dispose .NET object reference
        dotNetRef?.Dispose();
    }
}
```

## Additional Resources

- [ASP.NET Core Blazor JavaScript interoperability (JS interop)](https://learn.microsoft.com/en-us/aspnet/core/blazor/javascript-interoperability/)
- [Blazor Lifecycle](https://learn.microsoft.com/en-us/aspnet/core/blazor/components/lifecycle)
- [IAsyncDisposable implementation in Blazor](https://learn.microsoft.com/en-us/aspnet/core/blazor/components/lifecycle#component-disposal-with-idisposable-and-iasyncdisposable)

## Related Files

- `MediaLens/Components/Pages/MediaGallery.razor` - Reference implementation
