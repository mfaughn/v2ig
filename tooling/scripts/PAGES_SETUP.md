# Page Structure Management

This directory contains tooling for managing the V2+ IG page structure using `sushi-config.yaml`.

## Overview

Instead of manually editing the `<page>` elements in `input/v2plus.xml`, we now manage the page hierarchy in `sushi-config.yaml` and use a script to generate the XML.

## Files

- **`sushi-config.yaml`** (root directory) - Defines page hierarchy and IG metadata
- **`update_pages_from_sushi_config.rb`** - Converts YAML pages to XML and updates v2plus.xml

## Workflow

### 1. Edit Page Structure

Edit the `pages:` section in `sushi-config.yaml`:

```yaml
pages:
  index.md:
    title: V2+ Home
    generation: markdown

  introduction.md:
    title: Introduction
    generation: markdown

  foundation.md:
    title: Foundation
    generation: markdown
    foundation-intro.md:        # Indented = child page
      title: Introduction
      generation: markdown
    control.md:
      title: Control
      generation: markdown
```

**Key points:**
- **Indentation = hierarchy** - Child pages are indented under their parent
- **`.md` extension** - Use `.md` in YAML (converts to `.html` automatically)
- **`generation`** - Use `markdown` for markdown files, `html` for HTML
- **`title`** - The display title for navigation/menu

### 2. Run the Update Script

From the repository root:

```bash
ruby tooling/scripts/update_pages_from_sushi_config.rb
```

This will:
1. Read the pages structure from `sushi-config.yaml`
2. Create a backup of `v2plus.xml` (if not already backed up)
3. Replace the `<page>` elements in `v2plus.xml`
4. Preserve all other content (parameters, metadata, etc.)

### 3. Verify the Output

Check `input/v2plus.xml` to ensure the pages were generated correctly.

The script converts this YAML:
```yaml
pages:
  index.md:
    title: Home
    child.md:
      title: Child Page
```

Into this XML:
```xml
<page>
  <name value="index.html"/>
  <title value="Home"/>
  <generation value="html"/>
  <page>
    <name value="child.html"/>
    <title value="Child Page"/>
    <generation value="html"/>
  </page>
</page>
```

## Content Management

### Where Content Lives

- **Page structure** → `sushi-config.yaml`
- **Page content** → `.md` or `.adoc` files in `input/pagecontent/`
- **Domain content** → `.adoc` files in `website/domains/`
- **Data type content** → FHIR StructureDefinitions with markdown in `description` fields

### AsciiDoc Includes

If a page uses AsciiDoc includes (e.g., for technical specs), you **don't need to list those in YAML**:

```adoc
= Registration Domain

include::technical_specs/A01.adoc[]
include::technical_specs/A02.adoc[]
```

Just list the main page in `sushi-config.yaml`:
```yaml
registration.md:
  title: Registration
```

The includes are handled within the AsciiDoc file itself.

## Best Practices

### Page Naming

- Use **kebab-case**: `general-orders-and-results.md` (not `GeneralOrdersAndResults.md`)
- Be **descriptive**: `complex-data-types.md` (not `cdt.md`)
- Match **directory names** where applicable

### Hierarchy Depth

Keep hierarchy to **3-4 levels max** for usability:
```
✓ Good:
  domains.md
    administration.md
      registration.md

✗ Too deep:
  domains.md
    administration.md
      registration.md
        use-cases.md
          inpatient.md
            admit.md
```

### Organization

Group related pages under logical parents:
```yaml
domains.md:
  title: Domain Messaging
  administration.md:      # Domain
    title: Administration
    registration.md:      # Subdomain
      title: Registration
    scheduling.md:
      title: Scheduling
```

## Troubleshooting

**Script fails to read YAML:**
- Check YAML syntax with a validator
- Ensure indentation uses spaces (not tabs)

**Pages not showing in IG:**
- Verify the corresponding `.md` files exist in `input/pagecontent/`
- Check IG Publisher logs for missing file warnings

**Wrong hierarchy:**
- Check indentation in `sushi-config.yaml`
- Remember: 2 spaces per level

**Parameters missing:**
- The script only updates `<page>` elements
- `<parameter>` elements are preserved from the existing XML

## Future Enhancements

Potential improvements:
- Auto-generate pages from directory structure
- Validate page files exist before generating XML
- Support for page-level extensions or metadata
- Integration with menu.xml generation
