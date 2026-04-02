
## How Configuration Works

This module uses a **layered configuration** approach. Rather than defining dozens of individual input variables, all configuration is expressed in a single YAML file that you provide. The module then combines that file with its own built-in defaults and live data discovered from AWS to produce a single, authoritative configuration object that drives every resource it creates.

The diagram below walks through that process step by step.

```mermaid
flowchart TD
    subgraph LAYER1["Layer 1 - Module built-ins"]
        DEFAULTS["Default values"]
        LUT["Lookup tables"]
    end

    subgraph LAYER2["Layer 2 - User Provided"]
        CFGFILE["User YAML config file"]
    end

    subgraph LAYER3["Layer 3 - Discovered at runtime"]
        DS["Live AWS data</br>(account, region, AZs)"]
    end

    subgraph ASSEMBLY["Assembly pipeline  (automatic)"]
        direction TB
        STEP1["<b>1. Scope</b></br>Extract the section</br>for this module"]
        STEP2["<b>2. Feature mask</b></br>Strip settings for</br>disabled features"]
        STEP3["<b>3. Deep merge</b></br>User values override</br> the defaults"]
        STEP4["<b>4. Resource names</b></br>Combine naming tokens</br> with lookup tables"]
        OVERLAY(["Final merged config"])
    end

    subgraph RESOURCES["AWS resources created"]
        RES["Module resources"]
    end

    CFGFILE  --> STEP1
    STEP1    --> STEP2
    STEP2    --> STEP3
    DEFAULTS --> STEP3
    STEP3    --> STEP4
    LUT      --> STEP4
    STEP4    --> OVERLAY

    OVERLAY  --> RES
    DS       --> RES
```

> **Tip — one file, many modules.**  Because the YAML file is keyed by module name at the top level, a single file can hold configuration for several modules side by side. Each module ignores every section that does not belong to it.

