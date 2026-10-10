#author: "Mikael Gandilyan"
#date: "2025-11-24"
  
##Data and packages
#install.packages("readxl")
#install.packages("rnaturalearth")
#install.packages("rnaturalearthdata")
#install.packages("tidytext")
library(tidytext)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(readxl)
library(tidyverse)
gtd <- read_excel("globalterrorismdb_0522dist.xlsx")
syria <- gtd|>
  filter(country == 200)|>
  filter(iyear >= 2011)|>
  mutate(
    gname_recode = case_when(
      gname %in% c("Hay'at Tahrir al-Sham", "Al-Nusrah Front") ~ "Al-Nusrah Front/HTS",
      gname %in% c("Syrian Democratic Forces (SDF)", "Women's Protection Units (YPJ)", "People's Protection Units (YPG)") ~ "Syrian Democratic Forces",
      gname %in% c("Ahrar al-Sham", "Islamic Front (Syria)", "Jaysh al-Islam (Syria)", "Liwa al-Tawhid") ~ "Islamic Front",
      TRUE ~ gname
    )
  )|>
  mutate(
    event_date = paste0(iyear, "-", imonth, "-", iday),
    event_date = as.Date(event_date, format = "%Y-%m-%d")
  )

#saving the data
write_csv(syria, "syria20112020.csv")
syria <- read_csv("syria20112020.csv")

#mapping
syria_geo <- gtd|>
  filter(country == 200)|>
  filter(iyear >= 2011)|>
  filter(!is.na(latitude), !is.na(longitude))|>
  filter(!(latitude == 0 & longitude == 0))
syria_map <- rnaturalearth::ne_countries(
  scale = "medium",
  country = "Syria",
  returnclass = "sf"
)
syria_admin1 <- ne_states(
  country = "Syria",
  returnclass = "sf"
) #governorates
attacks_sf <- st_as_sf(
  syria_geo,
  coords = c("longitude", "latitude"),
  crs = 4326,           # WGS84
  remove = FALSE
)

ggplot() +
  geom_sf(data = syria_map, fill = "grey90", color = "grey40") +
  geom_sf(data = syria_admin1, fill = NA, color = "grey50", linewidth = 0.3) +
  geom_sf(data = attacks_sf, color = "#800020", alpha = 0.4, size = 0.6) +
  coord_sf(xlim = st_bbox(syria_map)[c("xmin", "xmax")],ylim = st_bbox(syria_map)[c("ymin", "ymax")]) +
  labs(
    title = "Figure 1: Terrorist Attacks in Syria, 2011–2020",
    x = "Longitude",
    y = "Latitude",
    caption = "Source: Global Terrorism Database (GTD), START, University of Maryland."
  ) +
  theme_minimal()

#Perpetrator groups
terror_groups <- syria|>
  count(gname_recode)|>
  filter(gname_recode != "Unknown")|>
  filter(gname_recode != "Muslim extremists")|>
  slice_max(n, n=6)
ggplot(terror_groups, aes(x=reorder(gname_recode, n), y=n)) + 
  geom_bar(stat='identity', fill="#800020")  +
  geom_text(aes(label = n), 
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  theme_bw() +
  labs(
    title = "Figure 2: Perpetrating Organizations by Number of Attacks (Syria 2011-2020)",
    y='Number of Attacks',
    x ='Group Name',
    caption = "Source: Global Terrorism Database (GTD), START, University of Maryland."
  )

##bar plots of weapons used by each org
#isil
syria_isil <- syria|>
  filter(gname_recode == "Islamic State of Iraq and the Levant (ISIL)")|>
  count(weapsubtype1_txt)|>
  drop_na()|>
  slice_max(n, n=6)
ggplot(syria_isil, aes(x=reorder(weapsubtype1_txt, n), y=n)) + 
  geom_bar(stat='identity', fill="#800020")  +
  geom_text(aes(label = n), 
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  theme_bw() +
  labs(
    title = "Islamic State of Iraq and the Levant (ISIL)",
    y = "Number of Attacks",
    x = "Weapon Type"
  )
#al-nusrah/hts
syria_hts <- syria|>
  filter(gname_recode == "Al-Nusrah Front/HTS")|>
  count(weapsubtype1_txt)|>
  drop_na()|>
  slice_max(n, n=6)
ggplot(syria_hts, aes(x=reorder(weapsubtype1_txt, n), y=n)) + 
  geom_bar(stat='identity', fill="#800020")  +
  geom_text(aes(label = n), 
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  theme_bw() +
  labs(
    title = "Al-Nusrah Front/Hay'at Tahrir al-Sham",
    y = "Number of Attacks",
    x = "Weapon Type"
  )
#Free Syrian Army
syria_fra <- syria|>
  filter(gname_recode == "Free Syrian Army")|>
  count(weapsubtype1_txt)|>
  drop_na()|>
  slice_max(n, n=6)
ggplot(syria_fra, aes(x=reorder(weapsubtype1_txt, n), y=n)) + 
  geom_bar(stat='identity', fill="#800020")  +
  geom_text(aes(label = n), 
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  theme_bw() +
  labs(
    title = "Free Syrian Army",
    y = "Number of Attacks",
    x = "Weapon Type"
  )
#Islamic Front
syria_if <- syria|>
  filter(gname_recode == "Islamic Front")|>
  count(weapsubtype1_txt)|>
  drop_na()|>
  slice_max(n, n=6)
ggplot(syria_if, aes(x=reorder(weapsubtype1_txt, n), y=n)) + 
  geom_bar(stat='identity', fill="#800020")  +
  geom_text(aes(label = n), 
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  theme_bw() +
  labs(
    title = "Islamic Front",
    y = "Number of Attacks",
    x = "Weapon Type"
  )
#Kurdistan Workers' Party (PKK)
syria_pkk <- syria|>
  filter(gname_recode == "Kurdistan Workers' Party (PKK)")|>
  count(weapsubtype1_txt)|>
  drop_na()|>
  slice_max(n, n=6)
ggplot(syria_pkk, aes(x=reorder(weapsubtype1_txt, n), y=n)) + 
  geom_bar(stat='identity', fill="#800020")  +
  geom_text(aes(label = n), 
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  theme_bw() +
  labs(
    title = "Kurdistan Workers' Party (PKK)",
    y = "Number of Attacks",
    x = "Weapon Type"
  )
#Syrian Democratic Forces
syria_sdf <- syria|>
  filter(gname_recode == "Syrian Democratic Forces")|>
  count(weapsubtype1_txt)|>
  drop_na()|>
  slice_max(n, n=6)
ggplot(syria_sdf, aes(x=reorder(weapsubtype1_txt, n), y=n)) + 
  geom_bar(stat='identity', fill="#800020")  +
  geom_text(aes(label = n), 
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  theme_bw() +
  labs(
    title = "Syrian Democratic Forces",
    y = "Number of Attacks",
    x = "Weapon Type"
  )

##attack count
attack_count<-syria|>
  filter(weapsubtype1_txt%in% c("Vehicle", "Projectile (rockets, mortars, RPGs, etc.)", "Suicide (carried bodily by human being)"))|>
  count(event_date, weapsubtype1_txt)
attack_count<-attack_count|>
  complete(event_date = full_seq(event_date, period=1), # get a complete sequence of days
           nesting(weapsubtype1_txt),                         # nest by the grouping variable
           fill=list(n=0)                               # fill empty rows with 0
  )
attack_count<-attack_count|>
  group_by(weapsubtype1_txt)|>
  mutate(rolling_count = zoo::rollsum(n, 
                                      k=120,  # the size of the rolling window
                                      na.pad=T)) 


attack_timeline <- ggplot(
  attack_count,
  aes(x = event_date, y = rolling_count, color = weapsubtype1_txt)
) +
  geom_line(linewidth = 0.7) +
  theme_bw() +
  labs(
    x = 'Date',
    y = '120 day Rolling Count of Attacks',
    color = 'Attack Type',
    title = 'Figure 4: Terrorist Attacks in Syria (2011–2020)',
    caption = 'Source: Global Terrorism Database (GTD), START, University of Maryland'
  ) +
  scale_x_date(
    date_labels = "%b '%y",
    date_breaks = '12 month'
  ) +
  scale_color_manual(
    values = c(
      "Projectile (rockets, mortars, RPGs, etc.)" = "#800020",
      "Vehicle" = "#2F4F6F",
      "Suicide (carried bodily by human being)" = "#6B7F3E"
    )
  )

attack_timeline
