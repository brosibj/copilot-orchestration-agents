# MediaLens UI Style Guide

## Overview
This style guide defines the UI styling approach for MediaLens, prioritizing Radzen components and utilities while maintaining clean, maintainable code.

---

## Priority Order for Styling

When styling UI elements, follow this strict priority order:

### 1. **Radzen Component Properties** (HIGHEST PRIORITY)
Always use Radzen's built-in component properties first.

**Examples:**
```razor
<!-- ✅ CORRECT: Use Radzen's Gap property -->
<RadzenStack Gap="0.5rem">
    <RadzenText>Content</RadzenText>
</RadzenStack>

<!-- ❌ WRONG: Don't use inline styles for spacing -->
<RadzenStack Style="gap: 0.5rem;">
    <RadzenText>Content</RadzenText>
</RadzenStack>
```

**Common Radzen Properties:**
- `Gap` - for RadzenStack spacing
- `JustifyContent` - for horizontal alignment
- `AlignItems` - for vertical alignment
- `Orientation` - for stack direction
- `Wrap` - for wrapping behavior
- `Size`, `SizeMD`, `SizeLG` - for RadzenColumn sizing

---

### 2. **Radzen Utility Classes** (SECOND PRIORITY)
Use Radzen's built-in CSS utility classes for common styling needs.

**Spacing Classes:**
```razor
<!-- Margins -->
<div class="rz-m-0">    <!-- margin: 0 -->
<div class="rz-m-1">    <!-- margin: 0.25rem -->
<div class="rz-m-2">    <!-- margin: 0.5rem -->
<div class="rz-m-3">    <!-- margin: 1rem -->
<div class="rz-m-4">    <!-- margin: 1.5rem -->
<div class="rz-mt-3">   <!-- margin-top: 1rem -->
<div class="rz-mb-4">   <!-- margin-bottom: 1.5rem -->
<div class="rz-mr-2">   <!-- margin-right: 0.5rem -->

<!-- Paddings -->
<div class="rz-p-0">    <!-- padding: 0 -->
<div class="rz-p-1">    <!-- padding: 0.25rem -->
<div class="rz-p-2">    <!-- padding: 0.5rem -->
<div class="rz-p-3">    <!-- padding: 1rem -->
<div class="rz-p-4">    <!-- padding: 1.5rem -->
```

**Size Classes:**
```razor
<div class="rz-w-100">  <!-- width: 100% -->
<div class="rz-h-100">  <!-- height: 100% -->
```

---

### 3. **Radzen CSS Variables** (THIRD PRIORITY)
Use Radzen's CSS variables for colors and theming to ensure dark/light mode compatibility.

**Examples:**
```razor
<!-- ✅ CORRECT: Use Radzen CSS variables -->
<RadzenText Style="color: var(--rz-primary);">Primary Color Text</RadzenText>
<RadzenText Style="color: var(--rz-text-color);">Themed Text</RadzenText>

<!-- ❌ WRONG: Don't hardcode colors -->
<RadzenText Style="color: #007bff;">Blue Text</RadzenText>
```

**Common Radzen Variables:**
- `--rz-primary` - Primary theme color
- `--rz-secondary` - Secondary theme color
- `--rz-text-color` - Main text color (theme-aware)
- `--rz-base-900` - Dark background
- `--rz-border-color` - Border color (theme-aware)

---

### 4. **Custom CSS Classes** (FOURTH PRIORITY)
Create custom CSS classes in `wwwroot/css/` ONLY when:
- The pattern appears in **3+ places**
- Cannot be accomplished with Radzen components or utilities
- Need theme-aware styling (dark/light mode support)

**Location:** `MediaLens/wwwroot/app.css`

**Current Custom Classes:**
```css
/* Text opacity utilities */
.opacity-80 { opacity: 0.8; }  /* Muted text */
.opacity-70 { opacity: 0.7; }  /* Very muted text */
.opacity-90 { opacity: 0.9; }  /* Slightly muted text */

/* Interactive elements */
.cursor-pointer { cursor: pointer; }

/* Empty state icons */
.icon-empty-state {
    font-size: 3rem;
    opacity: 0.4;
}
```

**Usage:**
```razor
<!-- Caption text with muted opacity -->
<RadzenText TextStyle="TextStyle.Caption" class="opacity-80">
    This is helper text
</RadzenText>

<!-- Clickable label -->
<RadzenLabel Text="Click Me" class="cursor-pointer opacity-90" />

<!-- Empty state icon -->
<RadzenIcon Icon="folder_open" class="icon-empty-state" />
```

---

### 5. **Inline Styles** (LAST RESORT)
Use inline styles ONLY for:
- **Truly unique** one-off styling
- **Dynamic values** from component state
- Values that **cannot be predefined**

**Examples of Acceptable Inline Styles:**
```razor
<!-- ✅ Dynamic color from data -->
<RadzenIcon Icon="check_circle" 
           Style="@($"color: {(isSuccess ? "var(--rz-success)" : "var(--rz-danger)")};")" />

<!-- ✅ Dynamic Radzen variable -->
<RadzenText Style="color: var(--rz-primary);">Themed Text</RadzenText>

<!-- ✅ Unique value that won't be reused -->
<div Style="min-height: 450px;">Content</div>
```

**Examples of UNACCEPTABLE Inline Styles:**
```razor
<!-- ❌ WRONG: Use opacity-80 class -->
<RadzenText Style="opacity: 0.8;">Text</RadzenText>

<!-- ❌ WRONG: Use cursor-pointer class -->
<RadzenLabel Style="cursor: pointer;">Label</RadzenLabel>

<!-- ❌ WRONG: Use rz-mt-3 class -->
<div Style="margin-top: 1rem;">Content</div>


<!-- ❌ WRONG: Use radzen color classes -->
<RadzenIcon Icon="check_circle" 
           Style="@($"color: {(isSuccess ? "green" : "red")};")" />
```

---

## Component-Specific Guidelines

### RadzenSwitch and RadzenSlider
**Never** use `RadzenFormField` wrapper for switches or sliders.

```razor
<!-- ✅ CORRECT -->
<RadzenSwitch @bind-Value="@enableFeature" />
<RadzenSlider @bind-Value="@threshold" Min="0.5m" Max="1.0m" />

<!-- ❌ WRONG -->
<RadzenFormField Text="Enable Feature">
    <RadzenSwitch @bind-Value="@enableFeature" />
</RadzenFormField>
```

### Form Fields
Use `RadzenFormField` for inputs like `RadzenTextBox`, `RadzenNumeric`, etc.

```razor
<!-- ✅ CORRECT -->
<RadzenFormField Text="File Path" class="rz-w-100">
    <RadzenTextBox @bind-Value="@filePath" />
</RadzenFormField>
```

### Empty States
Use the `icon-empty-state` class for empty state icons.

```razor
<!-- ✅ CORRECT -->
<RadzenStack Orientation="Orientation.Vertical" AlignItems="AlignItems.Center" class="rz-p-4">
    <RadzenIcon Icon="folder_open" class="icon-empty-state" />
    <RadzenText TextStyle="TextStyle.H6" class="opacity-80">No items found</RadzenText>
    <RadzenButton Text="Add Item" Click="@AddItem" />
</RadzenStack>
```

---

## Common Patterns

### Card with Spacing
```razor
<RadzenCard class="rz-mb-4">
    <RadzenText TextStyle="TextStyle.H5" class="rz-mb-3">
        <RadzenIcon Icon="settings" class="rz-mr-2" />
        Card Title
    </RadzenText>
    <RadzenText TextStyle="TextStyle.Caption" class="opacity-80">
        Description text
    </RadzenText>
</RadzenCard>
```

### Icon with Text
```razor
<RadzenText TextStyle="TextStyle.H5">
    <RadzenIcon Icon="image" class="rz-mr-2" />
    Section Title
</RadzenText>
```

### Horizontal Layout with Spacing
```razor
<RadzenStack Orientation="Orientation.Horizontal" Gap="0.5rem" AlignItems="AlignItems.Center">
    <RadzenSwitch @bind-Value="@enabled" />
    <RadzenLabel Text="Enable Feature" class="cursor-pointer opacity-90" />
</RadzenStack>
```

### Data Grid
```razor
<RadzenDataGrid Data="@items" TItem="ItemType" 
               AllowPaging="true" AllowSorting="true" 
               class="rz-w-100">
    <Columns>
        <RadzenDataGridColumn TItem="ItemType" Property="Name" Title="Name" />
    </Columns>
</RadzenDataGrid>
```

---

## Bootstrap Conflicts

### Avoiding Bootstrap Class Conflicts
**Never** override Bootstrap classes. If a class name conflicts (e.g., `.text-muted`), use a different name.

**Example Conflict Resolution:**
```css
/* ❌ WRONG: Conflicts with Bootstrap */
.text-muted { opacity: 0.8; }

/* ✅ CORRECT: Use descriptive non-conflicting name */
.opacity-80 { opacity: 0.8; }
```

---

## Mobile Responsiveness

### Radzen Responsive Columns
```razor
<RadzenRow>
    <RadzenColumn Size="12" SizeMD="6" SizeLG="4">
        <!-- Full width on mobile, half on tablet, third on desktop -->
    </RadzenColumn>
</RadzenRow>
```

### Responsive Stacks
```razor
<RadzenStack Orientation="Orientation.Horizontal" Wrap="FlexWrap.Wrap" Gap="0.5rem">
    <!-- Buttons will wrap on smaller screens -->
    <RadzenButton Text="Action 1" />
    <RadzenButton Text="Action 2" />
</RadzenStack>
```

---

## Theme Compatibility

### Always Use Theme-Aware Styles
Ensure all custom styles work in both light and dark themes.

```razor
<!-- ✅ CORRECT: Theme-aware -->
<RadzenText Style="color: var(--rz-text-color);">Text</RadzenText>

<!-- ❌ WRONG: Hardcoded color breaks dark theme -->
<RadzenText Style="color: black;">Text</RadzenText>
```

---

## Code Organization

### CSS File Structure
```
MediaLens/
  wwwroot/
    css/
      media-viewer.css        # Component-specific styles
      media-gallery.css       # Component-specific styles
    app.css                   # Global custom utilities
```

### When to Create Component-Specific CSS
Create a separate CSS file for a component when:
1. The component has **complex styling** needs
2. Styles are **unique to that component**
3. The file would be **50+ lines** of CSS

**Example:** `media-viewer.css` for the MediaViewerDialog component

---

## Code Comments

### When to Use Comments
Comments should explain **WHY**, not **WHAT**.

```razor
<!-- ✅ GOOD: Explains the reasoning -->
<!-- Use empty string to allow system PATH lookup -->
<RadzenTextBox @bind-Value="@ffmpegPath" Placeholder="Leave empty for system PATH" />

<!-- ❌ BAD: States the obvious -->
<!-- This is a text box -->
<RadzenTextBox @bind-Value="@ffmpegPath" />
```

### Placeholder Comments
Use `// TODO:` format for code to be implemented later.

```csharp
// TODO: Implement batch processing for multiple files
private async Task ProcessFilesAsync() 
{
    // Implementation pending
}
```

---

## Performance Considerations

### Avoid Excessive Re-renders
```csharp
// ✅ CORRECT: Use shouldRender pattern when needed
protected override bool ShouldRender()
{
    return isDataChanged;
}
```

### Minimize JavaScript Interop
Prefer Radzen components over custom JavaScript when possible.

---

## Accessibility

### Use Semantic Components
```razor
<!-- ✅ CORRECT: Semantic button -->
<RadzenButton Text="Submit" Click="@Submit" />

<!-- ❌ WRONG: Non-semantic clickable div -->
<div @onclick="@Submit">Submit</div>
```

### Provide Tooltips
```razor
<RadzenButton Icon="delete" Size="ButtonSize.Small" 
             title="Delete item" 
             Click="@Delete" />
```

---

## Testing Changes

### Before Committing
1. **Build the solution** - Verify no compilation errors
2. **Test in both themes** - Check dark and light modes
3. **Test responsiveness** - Verify mobile, tablet, and desktop layouts
4. **Review for consistency** - Ensure all similar patterns use the same styling approach

---

## Quick Reference

### Decision Tree
```
Need to style something?
├─ Can Radzen component property handle it?
│  └─ YES → Use component property ✅
│  └─ NO ↓
├─ Is there a Radzen utility class?
│  └─ YES → Use utility class ✅
│  └─ NO ↓
├─ Need theme-aware color?
│  └─ YES → Use Radzen CSS variable ✅
│  └─ NO ↓
├─ Pattern used 3+ times?
│  └─ YES → Create custom CSS class ✅
│  └─ NO ↓
└─ Dynamic or truly unique?
   └─ YES → Use inline style ✅
   └─ NO → Reconsider if it's really needed ⚠️
```

---

## Examples from Codebase

### Settings Page Pattern
```razor
<!-- Card with proper spacing -->
<RadzenCard class="rz-mb-4">
    <RadzenText TextStyle="TextStyle.H5" class="rz-mb-3">
        <RadzenIcon Icon="settings" class="rz-mr-2" />
        Section Title
    </RadzenText>
    
    <!-- Form field -->
    <RadzenFormField Text="Setting Name" class="rz-w-100">
        <RadzenNumeric @bind-Value="@value" Min="1" Max="100" />
    </RadzenFormField>
    
    <!-- Helper text -->
    <RadzenText TextStyle="TextStyle.Caption" class="opacity-80">
        Description of the setting
    </RadzenText>
</RadzenCard>
```

### Empty State Pattern
```razor
<RadzenStack Orientation="Orientation.Vertical" 
             AlignItems="AlignItems.Center" 
             Gap="0.5rem" 
             class="rz-p-4">
    <RadzenIcon Icon="folder_open" class="icon-empty-state" />
    <RadzenText TextStyle="TextStyle.H6" class="opacity-80">
        No items configured
    </RadzenText>
    <RadzenButton Icon="add" Text="Add First Item" Click="@AddItem" />
</RadzenStack>
```

---

## Maintenance

This style guide should be updated when:
- New Radzen utility classes are discovered
- New common patterns emerge (used 3+ times)
- Bootstrap conflicts are identified
- New Radzen CSS variables are needed

**Last Updated:** 2025-01-20
