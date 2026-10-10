# Weapons Proliferation and Patterns of Terrorist Violence in the Syrian Civil War

How does the spread of weapons to armed groups, including arms supplied by outside state sponsors, show up in where, when and how terrorist violence happens?

This project analyzes 2,848 terrorist attacks in Syria from 2011 to 2020, recorded in the Global Terrorism Database (GTD). It maps where attacks occurred, identifies the most active perpetrator groups, compares the weapons each group used, and tracks how the main attack types rose and fell over the course of the war. The results are interpreted through a principal–agent framework, which asks how much control a sponsor keeps over an armed group once weapons have changed hands.

*Final project for GVPT429K: Researching Contentious Politics, University of Maryland, Fall 2025.*

---

## What the Data Show

- **Violence peaked in 2015–2016.** Recorded attacks rose from 49 in 2011 to 491 in 2015 and 474 in 2016, then fell to roughly 250–300 a year through 2020.
- **Attacks were concentrated in a few governorates.** Aleppo (843 attacks) and Damascus (445) account for nearly half of all incidents, followed by Idlib, Homs and Deir ez-Zor.
- **Two groups dominate the attributed attacks.** The Islamic State (818 attacks) and Al-Nusrah Front/Hay'at Tahrir al-Sham (359) carried out far more attacks than any other identified group. More than a third of attacks (1,016) have no attributed perpetrator.
- **Weapon choice differs sharply by group.** The Islamic State, Al-Nusrah/HTS, the PKK and the SDF relied most on vehicle-borne explosives. The Free Syrian Army and the Islamic Front relied overwhelmingly on projectiles such as rockets, mortars and RPGs, which are weapons typically acquired through supply networks rather than built locally.
- **Projectiles were the most common weapon overall** (895 attacks), followed by vehicle-borne explosives (674) and suicide attacks (131).

## Methods

| Step | What it does | Tools |
|---|---|---|
| **1. Data preparation** | Filters the GTD to Syria from 2011 onward, merges organizations that renamed or reorganized (e.g. Al-Nusrah Front → Hay'at Tahrir al-Sham; YPG/YPJ → SDF; Ahrar al-Sham and allied factions → Islamic Front), and builds event dates | `tidyverse`, `readxl` |
| **2. Geospatial analysis** | Plots every geocoded attack on a map of Syria with governorate boundaries | `sf`, `rnaturalearth` |
| **3. Perpetrator analysis** | Ranks the six most active identified groups by number of attacks | `ggplot2` |
| **4. Weapons analysis** | Compares the six most-used weapon types for each of those groups | `ggplot2` |
| **5. Time-series analysis** | Tracks the three main attack types (projectiles, vehicle-borne explosives, suicide attacks) with a 120-day rolling count, to smooth day-to-day noise and show the war's longer phases | `zoo`, `ggplot2` |

## Figures Produced

1. Map of terrorist attacks in Syria, 2011–2020
2. Perpetrating organizations by number of attacks
3. Weapon types used by each of the six most active groups (six charts)
4. 120-day rolling count of attacks by attack type

## Data

This project uses the **Global Terrorism Database** (June 2022 release, `globalterrorismdb_0522dist.xlsx`), maintained by the National Consortium for the Study of Terrorism and Responses to Terrorism (START) at the University of Maryland.

**The data is not included in this repository.** The GTD's terms of use don't allow the data to be posted publicly, but they do allow published analysis and visualizations. To run the code, request the dataset from START through the [GTD website](https://www.start.umd.edu/gtd/).

## How to Run

1. **Install R** (4.1 or later) and the required packages:

   ```r
   install.packages(c("tidyverse", "readxl", "sf", "rnaturalearth",
                      "rnaturalearthdata", "tidytext", "zoo"))
   # Governorate boundaries also need the high-resolution map package:
   install.packages("rnaturalearthhires",
                    repos = "https://ropensci.r-universe.dev")
   ```

2. **Download the GTD** and place `globalterrorismdb_0522dist.xlsx` in the same folder as the script. If you have a newer GTD release, change the file name on the `read_excel()` line to match.

3. **Run the script:**

   ```r
   source("syria_gtd_analysis.R")
   ```

   The script also saves the filtered Syria data as `syria20112020.csv` for faster reloading.

## Limitations

- **Many attacks are unattributed.** More than a third of the incidents have no known perpetrator, so the group-level comparisons cover only part of the violence.
- **The GTD records terrorism, not all violence.** Battlefield combat, airstrikes and other conventional military operations are outside its scope, and those make up much of the war's violence.
- **Reporting is uneven in a war zone.** The GTD is built from media reports, so attacks in areas with little press access are likely undercounted.
- **Weapon sources aren't recorded.** The GTD lists the type of weapon used, not where it came from, so links between arms supply and attack patterns are inferred rather than directly observed.

## Data Citation

National Consortium for the Study of Terrorism and Responses to Terrorism (START), University of Maryland. (2022). *The Global Terrorism Database (GTD)* [Data file]. https://www.start.umd.edu/gtd

## Author

**Mikael Gandilyan**, M.S. Applied Political Analytics, University of Maryland
[LinkedIn](https://www.linkedin.com/in/mikael-gandilyan)
