# Visual Design Specification

## Color System

### Primary Palette
```
Primary Blue:    #007AFF
Primary Dark:    #0051D5
Primary Light:   #4DA2FF

Success Green:   #34C759
Warning Orange:  #FF9500
Error Red:       #FF3B30

Background:      #F2F2F7
Surface:         #FFFFFF
Surface Alt:     #FAFAFA

Text Primary:    #000000
Text Secondary:  #8E8E93
Text Disabled:   #C6C6C8

Border:          #C6C6C8
Border Light:    #E5E5EA
Divider:         #D1D1D6
```

### Semantic Colors
```
Input Background:    #FFFFFF
Input Border:        #C6C6C8
Input Border Focus:  #007AFF
Input Text:          #000000

Button Primary BG:   #007AFF
Button Primary Text: #FFFFFF
Button Secondary BG: #F2F2F7
Button Secondary Text: #007AFF

Result Item Even:    #FFFFFF
Result Item Odd:     #FAFAFA
Result Item Hover:   #F2F2F7
```

## Typography Scale

### Font Families
```
Primary:    -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif
Monospace:  "SF Mono", Monaco, "Cascadia Code", "Courier New", monospace
```

### Type Scale
```
Display:     32px / 40px line-height, 700 weight
H1:          24px / 32px line-height, 600 weight
H2:          20px / 28px line-height, 600 weight
H3:          18px / 24px line-height, 600 weight
Body Large:  18px / 28px line-height, 400 weight
Body:        16px / 24px line-height, 400 weight
Body Small:  14px / 20px line-height, 400 weight
Caption:     12px / 16px line-height, 400 weight
Mono:        14px / 20px line-height, 400 weight
```

## Spacing System

### Base Unit: 8px

```
Space 1:   4px   (0.5 units)
Space 2:   8px   (1 unit)
Space 3:   12px  (1.5 units)
Space 4:   16px  (2 units)
Space 5:   24px  (3 units)
Space 6:   32px  (4 units)
Space 7:   48px  (6 units)
Space 8:   64px  (8 units)
```

### Component Spacing
```
Card Padding:        24px (desktop), 16px (mobile)
Section Gap:         32px (desktop), 24px (mobile)
Component Gap:       16px
List Item Padding:   12px 16px
Button Padding:      12px 24px
Input Padding:       12px 16px
```

## Layout Grid

### Breakpoints
```
Mobile:      320px - 767px
Tablet:      768px - 1023px
Desktop:     1024px - 1439px
Wide:        1440px+
```

### Container Widths
```
Mobile:      100% - 32px padding
Tablet:      100% - 48px padding
Desktop:     1200px max-width
Wide:        1400px max-width
```

### Grid Columns
```
Mobile:      1 column
Tablet:      2 columns (input | results)
Desktop:     2 columns (40% | 60%)
```

## Component Specifications

### Buttons

#### Primary Button
```
Background:      #007AFF
Text:            #FFFFFF
Height:          44px
Padding:         12px 24px
Border Radius:   8px
Font:            16px, 600 weight
Shadow:          0 2px 8px rgba(0, 122, 255, 0.2)
Hover:           #0051D5
Active:          #0051D5 + scale(0.98)
Disabled:        #C6C6C8 background, #8E8E93 text
```

#### Secondary Button
```
Background:      #F2F2F7
Text:            #007AFF
Height:          44px
Padding:         12px 24px
Border Radius:   8px
Border:          1px solid #C6C6C8
Font:            16px, 600 weight
Hover:           #E5E5EA
Active:          #D1D1D6
```

### Input Fields

#### Text Area (Tile Input)
```
Background:      #FFFFFF
Border:          1px solid #C6C6C8
Border Radius:   8px
Padding:         12px 16px
Font:            14px monospace
Min Height:      200px
Max Height:      400px
Focus Border:    2px solid #007AFF
Placeholder:     #8E8E93
```

### Cards

#### Surface Card
```
Background:      #FFFFFF
Border:          1px solid #E5E5EA
Border Radius:   12px
Padding:         24px
Shadow:          0 2px 8px rgba(0, 0, 0, 0.04)
```

### Results List

#### List Item
```
Height:          40px
Padding:         8px 16px
Border Bottom:   1px solid #E5E5EA
Font:            16px
Even Row:        #FFFFFF
Odd Row:         #FAFAFA
Hover:           #F2F2F7
```

## Animations

### Transitions
```
Default:         200ms ease-in-out
Fast:            100ms ease-out
Slow:            300ms ease-in-out
```

### Effects
```
Button Hover:    transform: scale(1.02), 200ms
Button Active:   transform: scale(0.98), 100ms
Card Hover:      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08), 200ms
Fade In:         opacity 0 → 1, 200ms
Slide Up:        translateY(20px) → 0, 300ms ease-out
```

### Loading States
```
Spinner:         Circular, 40px diameter, 3px stroke
Skeleton:        Linear gradient shimmer effect
Progress:        Linear determinate bar, 4px height
```

## Icons

### Icon Set: Material Icons / SF Symbols

```
Solve:           play_arrow / play.fill
Clear:           clear / xmark.circle.fill
Copy:            content_copy / doc.on.doc
Export:          download / square.and.arrow.down
Help:            help_outline / questionmark.circle
Settings:        settings / gear
Sample:          description / doc.text
Success:         check_circle / checkmark.circle.fill
Error:           error / exclamationmark.circle.fill
```

### Icon Sizes
```
Small:           16px
Medium:          24px
Large:           32px
```

