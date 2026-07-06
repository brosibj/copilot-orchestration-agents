---
name: UI and Style Standards
description: UI framework, component conventions, styling rules, and accessibility expectations for the repository's interface files.
applyTo: '**/*.razor,**/*.css,**/*.scss,**/*.tsx,**/*.vue'
---

# UI & Style Standards

> **Template:** Replace the sections below with your project's actual values.
> Scope this file to UI component and stylesheet files. If backend or data files have their own rules, keep them in separate instruction files.

## UI Framework

- **Framework / library:** <!-- e.g. Blazor Server, React 19, Vue 3, Angular 18 -->
- **Component library:** <!-- e.g. Radzen, MudBlazor, shadcn/ui, PrimeNG -->
- **CSS approach:** <!-- e.g. Tailwind CSS, CSS Modules, scoped SCSS, BEM -->

## Component Patterns

- **File structure:** <!-- e.g. one component per file; co-locate `.razor.css` with `.razor` -->
- **Naming:** <!-- e.g. PascalCase components (`UserCard.razor`); kebab-case CSS classes -->
- **Props / parameters:** <!-- e.g. Use `[Parameter]` with sane defaults; avoid deeply nested parameter passing -->
- **State management:** <!-- e.g. Local `StateContainer`; global `AppState` via DI; Zustand store -->
- **Event handling:** <!-- e.g. `EventCallback<T>` for child→parent; `Dispatcher` for cross-component -->

## Asset Rules

- **Images / icons:** <!-- e.g. SVG icons via `<Icon>` component; optimised WebP for photos -->
- **Fonts:** <!-- e.g. self-hosted via `wwwroot/fonts/`; no Google Fonts CDN calls -->
- **Bundling:** <!-- e.g. Vite; fingerprinted static assets under `wwwroot/` -->

## Style Conventions

- **Spacing / sizing:** <!-- e.g. 4 px base unit; use design tokens, not raw px values -->
- **Color:** <!-- e.g. CSS custom properties from `_variables.scss`; no hard-coded hex in components -->
- **Responsive breakpoints:** <!-- e.g. mobile-first; `sm:`, `md:`, `lg:` Tailwind prefixes -->
- **Accessibility:** <!-- e.g. Semantic HTML; ARIA labels on interactive elements without visible text -->

## Related Context

- **Project instructions:** <!-- e.g. `.github/instructions/project.instructions.md` -->
- **Additional UI-domain files:** <!-- e.g. `.github/instructions/frontend/design-system.instructions.md` -->