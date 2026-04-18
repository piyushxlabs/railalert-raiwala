# Design System Strategy: The Kinetic Sentinel

## 1. Overview & Creative North Star
This design system is built upon the **"Kinetic Sentinel"** concept. In the context of Indian rail travel—a complex, high-velocity environment—the UI must act as a calm, authoritative guardian. We are moving beyond the "generic utility" look by merging the structural logic of Material Design 3 with a high-end editorial aesthetic. 

The "Kinetic Sentinel" breaks the traditional grid through **Intentional Asymmetry**. We use large, confident typography scales and overlapping tonal surfaces to create a sense of forward motion. While the primary saffron orange (#a43700) provides the energy, the layout remains sophisticated through the use of generous white space and a "borderless" philosophy.

---

## 2. Color & Tonal Architecture
The palette is rooted in a deep, premium saffron, balanced by a sophisticated grayscale that favors warmth over sterile blues.

### The "No-Line" Rule
To achieve a high-end feel, **explicitly prohibit the use of 1px solid borders** for sectioning content. Boundaries must be defined solely through:
- **Background Color Shifts:** Use the `surface-container` tiers to delineate areas.
- **Tonal Transitions:** A `surface-container-low` section sitting on a `surface` background provides enough contrast for the eye without the "clutter" of a line.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the following hierarchy to create "nested" depth:
- **Base Layer:** `surface` (#f9f9f9) for the global background.
- **Sectional Layer:** `surface-container-low` (#f3f3f3) for grouping related content blocks.
- **Interactive Layer:** `surface-container-highest` (#e2e2e2) for secondary interactive elements or inset cards.
- **Prominence Layer:** `surface-container-lowest` (#ffffff) to make critical information "pop" off a greyed background.

### Signature Textures & Gradients
To avoid a flat, "out-of-the-box" Material look:
- **Hero CTAs:** Use a subtle linear gradient (45°) from `primary` (#a43700) to `primary_container` (#cd4700). This adds "soul" and a tactile, premium quality to main actions.
- **Glassmorphism:** For floating navigation bars or high-level overlays, use `surface` at 80% opacity with a `24px` backdrop-blur. This integrates the element into the environment rather than feeling "pasted on."

---

## 3. Typography: Editorial Authority
We utilize **Public Sans** (as defined in the tokens) to bridge the gap between technical utility and high-fashion editorial.

- **The Power Gap:** Create high contrast between `display-lg` (3.5rem) for hero titles (e.g., Train Status) and `body-md` (0.875rem) for metadata. This "big and small" approach is the hallmark of premium design.
- **Tracking & Leading:** For `label-sm` and `label-md`, increase letter spacing by 5% to maintain legibility and a sophisticated, airy feel in small-print utility data.
- **Color Logic:** Use `on_surface_variant` (#5a4138) for secondary text to maintain a warm, cohesive look that avoids the harshness of pure black-on-white.

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are often a crutch for poor layout. In this system, depth is achieved through **Tonal Layering**.

- **The Layering Principle:** Stack `surface-container-lowest` cards on a `surface-container-low` background. The natural delta in HEX values creates a soft, sophisticated "lift."
- **Ambient Shadows:** When a floating action button (FAB) or high-priority modal requires a shadow, use a **Double-Soft Shadow**:
    - Shadow 1: 0px 4px 20px, 4% opacity of `on_surface`.
    - Shadow 2: 0px 8px 40px, 8% opacity of `on_surface`.
    - This mimics natural, diffused light rather than a digital "glow."
- **The Ghost Border:** If a boundary is strictly required for accessibility, use a "Ghost Border": `outline-variant` (#e3bfb2) at **15% opacity**. It should be felt, not seen.

---

## 5. Components & Primitive Styling

### Buttons
- **Primary:** High-gloss gradient (Primary to Primary-Container). `xl` (1.5rem) roundedness. No border.
- **Secondary:** `surface-container-high` background with `on_primary_fixed_variant` text.
- **Tertiary:** No background. Bold `title-sm` typography in `primary` color.

### Interactive Inputs
- **Text Fields:** Use the "Filled" Material 3 style but replace the bottom stroke with a subtle background shift to `surface-container-highest`. Upon focus, transition the background to `primary_fixed` (#ffdbcf) at 20% opacity.
- **Checkboxes & Radios:** Use `primary` for the active state. The "unselected" state should be `outline` (#8f7066) at a thin 1.5px weight.

### Cards & Lists (The Utility Core)
- **Forbid Dividers:** Do not use lines to separate list items (e.g., PNR entries or station lists).
- **The Spacing Separation:** Use the `1.5rem` (xl) spacing scale to create clear visual groupings.
- **Asymmetric Metadata:** In a list item, right-align the most critical data (e.g., "On Time") in a `label-md` chip with a `tertiary_container` (#0072e4) background to create a visual anchor.

### PNR Status Chips
- Use high-contrast pairings: `tertiary` (#005ab7) background with `on_tertiary` text for "Confirmed" status. This provides a clear, high-contrast visual cue that stands out from the Saffron-heavy brand colors.

---

## 6. Do’s and Don’ts

### Do:
- **Embrace White Space:** Give your data room to breathe. Utility doesn't mean "cluttered."
- **Use Tonal Stacking:** Always check if a background color change can replace a border.
- **Prioritize the "On-Surface" Hierarchy:** Use `on_surface` for headers, but `on_surface_variant` for supporting text to guide the user's eye.

### Don't:
- **Don't use 100% Black:** It breaks the premium warmth of the saffron palette. Always use `on_surface` (#1a1c1c).
- **Don't use standard MD3 elevation shadows:** They are too aggressive for this "Editorial" look. Stick to the Ambient Shadow spec.
- **Don't use sharp corners:** This design system relies on the `DEFAULT` (0.5rem) and `lg` (1rem) roundedness to feel approachable and modern.