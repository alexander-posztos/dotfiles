---
name: variants
description: >-
  Build N genuinely distinct design variants of a UI section, served inside the real app
  behind an on-page switcher, so the user can flip through them live, pick a winner, and
  have it promoted while every trace of the scaffolding is deleted. Use whenever the user
  wants design options to choose from - "give me a few versions", "5 different directions",
  "redesign this hero and let me pick", "I don't like this section, show me alternatives" -
  instead of iterating one design back and forth.
---

# Variants

One design iterated by chat ("hmm, try again") converges slowly and anchors on the first
attempt. N designs compared side by side in the real app converge in one pick. This skill
builds the comparison harness: real variants, real app, one floating switcher, then a
clean promotion.

## Before you start: does this apply?

1. There's a **running dev server for the app** the section lives in, and you can add a
   dev-only route/page to it. If the user's app can't take one, say so and agree on the
   closest real alternative - but never fall back to a separate static file server. A
   variant rendered outside the app lies to you: different CSS pipeline, missing fonts,
   no real layout context, fake data. The comparison is only honest inside the app.
2. The user will look at the variants **in their own browser**. Your job is to hand them
   a URL, not a pile of screenshots (screenshots are for your own verification).
3. Agree on the scope first: which section, on which page, and how many variants.
   Default to **5** if the user didn't say.

## The loop

### 1. Diverge - genuinely distinct, not five shades

The most common failure mode, in the user's own words: "5 shades of the same thing."
Before writing markup, name each variant and its **layout archetype** - they must differ
structurally, not cosmetically. Force divergence across axes like:

- structure: split / stacked / grid / asymmetric / full-bleed
- density: airy editorial vs compact utilitarian
- emphasis: image-led vs type-led vs data-led
- alignment and rhythm: centered vs left-anchored vs staggered

If two variants would survive a squint test as siblings, replace one. Genuinely different
also means each variant would need different *content shaping* (headline length, image
crop) - that's a good sign, not a problem. Keep the app's existing design language
(fonts, colors, component library) unless the user asked to explore outside it.

### 2. Build the harness

- **Dev-only route in the real app**, e.g. a Django `DEBUG`-gated view, a Next.js page
  excluded from production builds, an Express route behind `NODE_ENV !== 'production'`.
  Same server, same port, same CSS pipeline as the real page.
- Each variant is **full real markup** - the same partial/component structure the winner
  will ship with. Promotion must be a move, not a rewrite. No lorem ipsum: use the real
  content of the section being replaced.
- **Floating switcher** fixed on the page: current variant name + number, click or arrow
  keys to cycle, selection persisted (query param or localStorage) so a reload doesn't
  reset it. Keep it visually tiny - it must not compete with the designs.
- **CSS pipeline check**: if the project JIT-compiles utility classes, confirm the
  variant file is watched and one variant-only class actually renders before showing
  anything to the user. An unstyled variant poisons the whole comparison.

### 3. Verify, then hand over the URL

Screenshot each variant once (cropped to the section) and check: all render, all styled,
all distinct. Then give the user the URL and the variant list with one line each on the
idea behind it. They flip through live - don't narrate every variant at length and don't
keep re-screenshotting what they're already looking at.

### 4. Iterate by name

Feedback arrives per variant ("3 but tighter", "the header from 2 on the layout of 4").
Make the targeted change, nothing else. Hybrid requests are normal and usually the real
winner - build the hybrid as a new named variant rather than mutating one the user might
still want to compare against. For fiddly visual positioning, add a temporary on-page
control (sliders/arrow keys that emit the offset values), let the user place it, then
bake the values in.

### 5. Promote and burn the scaffolding

On the pick:

1. Replace the production section with the winner's markup.
2. **Delete everything else**: the dev route, the variant files, the switcher, any
   temporary controls. `grep` for the route name and variant names to prove nothing is
   left - shipped scaffolding is the failure mode here.
3. Screenshot the real page and compare against the chosen variant - identical, on the
   spot where it actually ships.

## Closing summary

- **Picked**: which variant (or hybrid) won, one line on what it is.
- **Promoted**: where the markup landed.
- **Deleted**: the scaffolding that's gone, and the grep that proves it.
- **Verified**: the real page renders the winner (screenshot taken).
