# ==============================================================================
# Analisi del peso economico dello sport in Europa: script di elaborazione dati 
# e visualizzazione grafica
# ==============================================================================

# ------------------------------------------------------------------------------
# SEZIONE 1: CARICAMENTO LIBRERIE
# ------------------------------------------------------------------------------
library(tidyverse)
library(ggrepel)

# ------------------------------------------------------------------------------
# SEZIONE 2: PREPARAZIONE E UNIFORMAZIONE DEI DATASET
# ------------------------------------------------------------------------------

# 1. Definizione della lista di tutte le tabelle grezze
lista_tabelle <- list(
  Occupazione_totale_nello_sport = Occupazione_totale_nello_sport,
  Occupazione_donne_nello_sport = Occupazione_donne_nello_sport,
  Occupazione_uomini_nello_sport = Occupazione_uomini_nello_sport,
  Occupazione_nello_sport_per_età_15_29 = Occupazione_nello_sport_per_età_15_29,
  Occupazione_nello_sport_per_età_30_64 = Occupazione_nello_sport_per_età_30_64,
  Occupazione_nello_sport_per_età_over_65 = Occupazione_nello_sport_per_età_over_65,
  Persone_occupate_nello_sport_per_livelli_di_studio_0_2 = Persone_occupate_nello_sport_per_livelli_di_studio_0_2,
  Persone_occupate_nello_sport_per_livelli_di_studio_3_4 = Persone_occupate_nello_sport_per_livelli_di_studio_3_4,
  Persone_occupate_nello_sport_per_livelli_di_studio_5_8 = Persone_occupate_nello_sport_per_livelli_di_studio_5_8,
  Popolazione_totale = Popolazione_totale,
  Popolazione_femminile_totale = Popolazione_femminile_totale,
  Popolazione_maschile_totale = Popolazione_maschile_totale,
  PIL_pro_capite_in_potere_d_acquisto = PIL_pro_capite_in_potere_d_acquisto,
  Spesa_pubblica_indirizzata_allo_sport = Spesa_pubblica_indirizzata_allo_sport,
  TOTALE_OCCUPATI = TOTALE_OCCUPATI
)

# 2. Pulizia automatica dei tipi di dato e rimozione spazi vuoti
lista_tabelle_clean <- lapply(lista_tabelle, function(df) {
  df %>%
    mutate(
      ANNO = as.numeric(as.character(ANNO)),
      COUNTRY = trimws(as.character(COUNTRY))
    ) %>%
    filter(!is.na(COUNTRY) & !is.na(ANNO)) %>%
    distinct(COUNTRY, ANNO, .keep_all = TRUE)
})

# Ripristina i dataset puliti nell'ambiente di lavoro
list2env(lista_tabelle_clean, envir = .GlobalEnv)

# 3. Join unificato di tutti i dataset per Chiave (COUNTRY, ANNO)
dataset_indicatori <- Occupazione_totale_nello_sport %>%
  select(COUNTRY, ANNO, `OCCUPAZIONE TOTALE NELLO SPORT` = `THOUSAND PERSONS`) %>%
  left_join(Occupazione_donne_nello_sport %>% select(COUNTRY, ANNO, `OCCUPAZIONE DONNE NELLO SPORT` = `THOUSAND PERSONS`), by = c("COUNTRY", "ANNO")) %>%
  left_join(Occupazione_uomini_nello_sport %>% select(COUNTRY, ANNO, `OCCUPAZIONE UOMINI NELLO SPORT` = `THOUSAND PERSONS`), by = c("COUNTRY", "ANNO")) %>%
  left_join(Occupazione_nello_sport_per_età_15_29 %>% select(COUNTRY, ANNO, `OCCUPAZIONE NELLO SPORT 15-29` = `THOUSAND PERSONS`), by = c("COUNTRY", "ANNO")) %>%
  left_join(Occupazione_nello_sport_per_età_30_64 %>% select(COUNTRY, ANNO, `OCCUPAZIONE NELLO SPORT 30-64` = `THOUSAND PERSONS`), by = c("COUNTRY", "ANNO")) %>%
  left_join(Occupazione_nello_sport_per_età_over_65 %>% select(COUNTRY, ANNO, `OCCUPAZIONE NELLO SPORT OVER 65` = `THOUSAND PERSONS`), by = c("COUNTRY", "ANNO")) %>%
  left_join(Persone_occupate_nello_sport_per_livelli_di_studio_0_2 %>% select(COUNTRY, ANNO, `PERSONE OCCUPATE NELLO SPORT 0-2` = `THOUSAND PERSONS`), by = c("COUNTRY", "ANNO")) %>%
  left_join(Persone_occupate_nello_sport_per_livelli_di_studio_3_4 %>% select(COUNTRY, ANNO, `PERSONE OCCUPATE NELLO SPORT 3-4` = `THOUSAND PERSONS`), by = c("COUNTRY", "ANNO")) %>%
  left_join(Persone_occupate_nello_sport_per_livelli_di_studio_5_8 %>% select(COUNTRY, ANNO, `PERSONE OCCUPATE NELLO SPORT 5-8` = `THOUSAND PERSONS`), by = c("COUNTRY", "ANNO")) %>%
  left_join(Popolazione_totale %>% select(COUNTRY, ANNO, `POPOLAZIONE TOTALE` = `POP. TOTALE`), by = c("COUNTRY", "ANNO")) %>%
  left_join(PIL_pro_capite_in_potere_d_acquisto %>% select(COUNTRY, ANNO, `PIL PRO CAPITE IN POTERE D'ACQUISTO`), by = c("COUNTRY", "ANNO")) %>%
  left_join(TOTALE_OCCUPATI %>% select(COUNTRY, ANNO, `TOTALE OCCUPATI`), by = c("COUNTRY", "ANNO")) %>%
  left_join(Spesa_pubblica_indirizzata_allo_sport %>% select(COUNTRY, ANNO, `SPESA PUBBLICA NELLO SPORT`), by = c("COUNTRY", "ANNO"))

# ------------------------------------------------------------------------------
# SEZIONE 3: CALCOLO DEGLI INDICATORI E DELLE VARIAZIONI
# ------------------------------------------------------------------------------

dataset_indicatori <- dataset_indicatori %>%
  mutate(
    # Converti i valori espressi in migliaia di persone in unità assolute
    `OCCUPAZIONE TOTALE NELLO SPORT` = as.numeric(`OCCUPAZIONE TOTALE NELLO SPORT`) * 1000,
    `TOTALE OCCUPATI` = as.numeric(`TOTALE OCCUPATI`) * 1000,
    `POPOLAZIONE TOTALE` = as.numeric(`POPOLAZIONE TOTALE`),
    
    # 1. Quota di occupati nello sport sul totale dell'economia (%)
    `QUOTA SPORT` = (`OCCUPAZIONE TOTALE NELLO SPORT` / `TOTALE OCCUPATI`) * 100,
    
    # 2. Densità di occupati nello sport ogni 100K abitanti
    `OCCUPATI NELLO SPORT OGNI 100K ABITANTI` = (`OCCUPAZIONE TOTALE NELLO SPORT` / `POPOLAZIONE TOTALE`) * 100000,
    
    # 3. Composizione sociodemografica dell'occupazione sportiva (%)
    `% OCC. FEMMINILE SPORT` = (as.numeric(`OCCUPAZIONE DONNE NELLO SPORT`) * 1000 / `OCCUPAZIONE TOTALE NELLO SPORT`) * 100,
    `% OCC. MASCHILE SPORT`  = (as.numeric(`OCCUPAZIONE UOMINI NELLO SPORT`) * 1000 / `OCCUPAZIONE TOTALE NELLO SPORT`) * 100,
    `PERC. OCC. GIOVANI`     = (as.numeric(`OCCUPAZIONE NELLO SPORT 15-29`) * 1000 / `OCCUPAZIONE TOTALE NELLO SPORT`) * 100,
    `% OCC. LIVELLO 5-8`     = (as.numeric(`PERSONE OCCUPATE NELLO SPORT 5-8`) * 1000 / `OCCUPAZIONE TOTALE NELLO SPORT`) * 100,
    
    # 4. Rapporto tra occupati nello sport e spesa pubblica (in M€)
    `OCCUPATI PER MILIONE DI SPESA` = `OCCUPAZIONE TOTALE NELLO SPORT` / as.numeric(`SPESA PUBBLICA NELLO SPORT`)
  )

# --- Calcolo Variazioni Cumulate COVID (Base fissa 2019) ---
delta_covid <- dataset_indicatori %>%
  filter(ANNO %in% c(2019, 2020, 2022)) %>%
  group_by(COUNTRY) %>%
  arrange(ANNO, .by_group = TRUE) %>%
  mutate(
    occ_2019 = `OCCUPAZIONE TOTALE NELLO SPORT`[ANNO == 2019],
    `VAR PERC COVID 2019-2020` = ifelse(ANNO == 2020, ((`OCCUPAZIONE TOTALE NELLO SPORT` - occ_2019) / occ_2019) * 100, NA),
    `VAR PERC COVID 2019-2022` = ifelse(ANNO == 2022, ((`OCCUPAZIONE TOTALE NELLO SPORT` - occ_2019) / occ_2019) * 100, NA)
  ) %>%
  ungroup()

# ------------------------------------------------------------------------------
# SEZIONE 4: PALETTE COLORI E MEDIA UE PONDERATA
# ------------------------------------------------------------------------------

# Palette ufficiale per i grafici delle serie storiche (Italia in ROSSO)
colori_paesi <- c(
  "Denmark"     = "#66c2a5",
  "France"      = "#fc8d62",
  "Germany"     = "#8da0cb",
  "Italy"       = "red",
  "Netherlands" = "#a6d854",
  "Spain"       = "#ffd92f",
  "Sweden"      = "#e5c494"
)

paesi_focus <- names(colori_paesi)

# Calcolo Media UE Ponderata per l'occupazione giovanile (peso = totale occupati sport)
media_ue_ponderata_giovani <- dataset_indicatori %>%
  filter(ANNO >= 2016 & ANNO <= 2025) %>%
  filter(!is.na(`PERC. OCC. GIOVANI`) & !is.na(`OCCUPAZIONE TOTALE NELLO SPORT`)) %>%
  group_by(ANNO) %>%
  summarise(
    `PERC. OCC. GIOVANI` = weighted.mean(
      x = `PERC. OCC. GIOVANI`,
      w = `OCCUPAZIONE TOTALE NELLO SPORT`,
      na.rm = TRUE
    ),
    .groups = "drop"
  )

# ------------------------------------------------------------------------------
# SEZIONE 5: VISUALIZZAZIONI GRAFICHE (ggplot2)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# GRAFICO 1: Ranking Quota Occupati Sport sul Totale Economia (2025)
# ------------------------------------------------------------------------------
dati_plot_quota <- dataset_indicatori %>%
  filter(ANNO == 2025 & !is.na(`QUOTA SPORT`)) %>%
  mutate(
    COUNTRY = reorder(COUNTRY, `QUOTA SPORT`),
    is_italy = ifelse(COUNTRY == "Italy", "Italia", "Altri")
  )

ggplot(dati_plot_quota, aes(x = COUNTRY, y = `QUOTA SPORT`, fill = is_italy)) +
  geom_col(show.legend = FALSE) +  
  coord_flip() +
  scale_fill_manual(values = c("Altri" = "steelblue", "Italia" = "red")) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Quota di occupati nello sport rispetto al totale degli occupati - Ranking (2025)",
    subtitle = "Fonte: Eurostat, elaborazione dati",
    x = "Paese",
    y = "% occupati nello sport sul totale economia",
    caption = "Fonte: Eurostat – Elaborazione dati"
  )

# ------------------------------------------------------------------------------
# GRAFICO 2: Composizione di Genere nell'Occupazione Sportiva (2025)
# ------------------------------------------------------------------------------
dati_genere_2025 <- dataset_indicatori %>%
  filter(ANNO == 2025) %>%
  filter(!is.na(`% OCC. MASCHILE SPORT`) & !is.na(`% OCC. FEMMINILE SPORT`)) %>%
  select(COUNTRY, `% OCC. MASCHILE SPORT`, `% OCC. FEMMINILE SPORT`) %>%
  pivot_longer(
    cols = c(`% OCC. MASCHILE SPORT`, `% OCC. FEMMINILE SPORT`),
    names_to = "Genere",
    values_to = "Percentuale"
  ) %>%
  mutate(
    Genere = ifelse(str_detect(Genere, "MASCHILE"), "Uomini", "Donne"),
    COUNTRY = reorder(COUNTRY, Percentuale)
  )

ggplot(dati_genere_2025, aes(x = COUNTRY, y = Percentuale, fill = Genere)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.65) +
  coord_flip() +
  scale_fill_manual(values = c("Uomini" = "#4C78A8", "Donne" = "#E45756")) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Composizione di genere nell'occupazione sportiva (2025)",
    x = NULL,
    y = "% sugli occupati nello sport",
    fill = NULL,
    caption = "Fonte: Eurostat – Elaborazione dati"
  ) +
  theme(
    legend.position = "top",
    panel.grid.major.y = element_blank()
  )

# ------------------------------------------------------------------------------
# GRAFICO 3: Serie Storica 2016-2025 Occupazione Giovanile (+ Media UE Ponderata)
# ------------------------------------------------------------------------------
dati_serie_giovani <- dataset_indicatori %>%
  filter(ANNO >= 2016 & ANNO <= 2025 & !is.na(`PERC. OCC. GIOVANI`))

dati_focus_giovani <- dati_serie_giovani %>%
  filter(COUNTRY %in% paesi_focus)

ggplot() +
  # Sfondo: altri Paesi europei
  geom_line(
    data = filter(dati_serie_giovani, !COUNTRY %in% paesi_focus),
    aes(x = ANNO, y = `PERC. OCC. GIOVANI`, group = COUNTRY),
    color = "grey85", linewidth = 0.4, alpha = 0.6
  ) +
  # Paesi di riferimento
  geom_line(
    data = filter(dati_focus_giovani, COUNTRY != "Italy"),
    aes(x = ANNO, y = `PERC. OCC. GIOVANI`, color = COUNTRY, group = COUNTRY),
    linewidth = 1.0
  ) +
  # Italia in evidenza (Rosso, spessore maggiorato)
  geom_line(
    data = filter(dati_focus_giovani, COUNTRY == "Italy"),
    aes(x = ANNO, y = `PERC. OCC. GIOVANI`, color = COUNTRY, group = COUNTRY),
    linewidth = 1.6
  ) +
  # Media UE Ponderata
  geom_line(
    data = media_ue_ponderata_giovani,
    aes(x = ANNO, y = `PERC. OCC. GIOVANI`),
    color = "black", linetype = "dashed", linewidth = 1
  ) +
  # Etichetta Media UE
  geom_text(
    data = filter(media_ue_ponderata_giovani, ANNO == max(ANNO)),
    aes(x = ANNO, y = `PERC. OCC. GIOVANI`, label = "Media UE\nponderata"),
    hjust = -0.15, vjust = 0.5, size = 3.5, fontface = "bold", lineheight = 0.9
  ) +
  scale_color_manual(values = colori_paesi) +
  scale_x_continuous(
    breaks = 2016:2025,
    limits = c(2016, 2025.8),
    labels = as.character(2016:2025)
  ) +
  coord_cartesian(clip = "off") +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    plot.margin = margin(t = 15, r = 70, b = 15, l = 15, unit = "pt"),
    axis.title.y = element_text(margin = margin(r = 10))
  ) +
  guides(color = guide_legend(nrow = 1)) +
  labs(
    title = "Occupazione giovanile nello sport (15–29 anni)",
    subtitle = "Serie storica 2016–2025 – Italia in evidenza + Media UE (ponderata)",
    x = "Anno",
    y = "% giovani 15-29 anni sul totale occupati nello sport",
    color = "Paese",
    caption = "Fonte: Eurostat – Elaborazione dati"
  )

# ------------------------------------------------------------------------------
# GRAFICO 4: Scatter Plot PIL pro capite in PPS vs Quota Occupazione Sport (2025)
# ------------------------------------------------------------------------------
dati_scatter_2025 <- dataset_indicatori %>%
  filter(ANNO == 2025) %>%
  filter(!is.na(`PIL PRO CAPITE IN POTERE D'ACQUISTO`) & !is.na(`QUOTA SPORT`)) %>%
  mutate(IS_ITALY = (COUNTRY == "Italy"))

ggplot(dati_scatter_2025, aes(x = `PIL PRO CAPITE IN POTERE D'ACQUISTO`, y = `QUOTA SPORT`)) +
  geom_smooth(
    aes(x = `PIL PRO CAPITE IN POTERE D'ACQUISTO`, y = `QUOTA SPORT`), 
    method = "lm", se = FALSE, color = "grey70", linetype = "dashed"
  ) +
  geom_point(aes(color = IS_ITALY, size = IS_ITALY)) +
  geom_text_repel(
    aes(label = COUNTRY, color = IS_ITALY, fontface = ifelse(IS_ITALY, "bold", "plain")),
    size = 3.8,
    max.overlaps = 15
  ) +
  scale_color_manual(values = c("FALSE" = "steelblue", "TRUE" = "red"), guide = "none") +
  scale_size_manual(values = c("FALSE" = 2.5, "TRUE" = 4.5), guide = "none") +
  theme_minimal(base_size = 12) +
  labs(
    title = "Relazione tra ricchezza economica e occupazione sportiva (2025)",
    subtitle = "Posizionamento dei Paesi europei",
    x = "PIL pro capite in Potere d'Acquisto (PPS, Indice UE-27 = 100)",
    y = "% Occupati nello sport sul totale occupati",
    caption = "Fonte: Elaborazione su dati Eurostat"
  )