# UI Style Guide

## 1. Styling Priority Logic (Strict Order)
1. **Component Properties:** Use native parameters first (`Gap`, `JustifyContent`, `AlignItems`, `Orientation`, `Wrap`).
2. **Radzen Utility Classes:** Use `rz-` prefixed classes for spacing (`rz-m-#`, `rz-p-#`) and sizing (`rz-w-100`, `rz-h-100`).
3. **Radzen CSS Variables:** Use `var(--rz-*)` for theme-aware colors (e.g., `--rz-primary`, `--rz-text-color`). **Never hardcode hex/RGB.**
4. **Custom CSS Classes:** Use only for patterns that are repeated or have a high likleyhood of being reused. 
   - Prefer placing CSS as "code-behind" to a custom component (e.g., `MyComponent.razor.css`) to avoid global pollution.
   - If a new component is not appropriate, the class must be used across many components, is intended to affect multiple components, or affects a component/html tag that we do not own (`div`, package-added components like `RadzenButton`), store globally available classes in `wwwroot/app.css`. 
5. **Inline Styles:** **Last resort.** Use only for unique one-off styles.

## 2. Component Implementation Rules
- **Form Fields:** Use `RadzenFormField` for text/numeric inputs. **Exception:** Never wrap `RadzenSwitch` or `RadzenSlider` in a FormField.
- **Empty States:** Use `RadzenStack` (centered) + `RadzenIcon` (`icon-empty-state`) + `RadzenText` (`opacity-80`).
- **Responsiveness:** Use `RadzenRow`/`RadzenColumn` with `Size`, `SizeMD`, and `SizeLG`. Use `FlexWrap.Wrap` on stacks for mobile-friendly wrapping.
- **Accessibility:** Use semantic components (e.g., `RadzenButton`) over `div @onclick`. Always provide `title` attributes for icon-only buttons.

## 3. Component Data Access Patterns
| Component Type | Pattern | Strategy |
|:---|:---|:---|
| **Edit/Detail Pages** | `OwningComponentBase` | Scoped context, `ChangeTracker` for dirty state, Concurrency handling. |
| **Read/List Pages** | `IDbContextFactory` | Short-lived `await using`, `AsNoTracking()` for performance. |
| **Hybrid** | Mixed | `OwningComponentBase` for main entity; Services for lookups. |

- JS interop → see `.github/docs/errata/blazor-js-interop-disposal.errata.md`.

## 4. Custom Utility Inventory
- **Opacity:** `.opacity-70` to `.opacity-90` for muted/helper text.
- **Interactions:** `.cursor-pointer` for clickable non-button elements.
- **Icons:** `.icon-empty-state` (3rem size, 0.4 opacity).
- **Constraint:** Avoid Bootstrap-conflicting names (e.g., use `.opacity-80` instead of `.text-muted`).

## 5. Development Standards
- **Theming:** Every style must support Light/Dark mode via Radzen variables.
- **Organization:** Create component-specific CSS only if unique and >50 lines.
- **Comments:** Document **why** (intent), not **what** (syntax). Use `// TODO:` for pending logic.
- **Performance:** Use `ShouldRender()` for complex UI; minimize JS Interop in favor of native Radzen features.