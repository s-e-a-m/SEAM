---
description: one lib to
---

# seam.lib

#### Declarations

```text
declare name "Faust SEAM main lib";
declare version "0.2";
declare author "Giuseppe Silvi";
declare author "Davide Tedesco";
declare license "CC3";
```

Calling standard faust libraries one time for all

```text
import("stdfaust.lib");
```

### Including libraries

#### Standard Faust Lib extensions

```text
import("seam.basic.lib");
import("seam.math.lib");
import("seam.filters.lib");
```

#### Michael Gerzon and General Ambisonic Theory

```text
import("seam.gerzon.lib");
import("seam.ambisonic.lib");
```

#### Stereophony and Perception

```text
import("seam.stereophony.lib");
import("seam.hrtf.lib");
```

#### Author Specific Literature

```text
import("seam.nono.lib");
import("seam.nottoli.lib");
```

#### Live Electronics Stuff

```text
import("seam.gui.lib");
import("seam.hardware.lib");
import("seam.analyzers.lib");
import("seam.mixer.lib");
```

#### Instrument Specific Literature

```text
import("seam.vcs3.lib");
import("seam.cyclone.lib");
import("seam.csound.lib");
```

