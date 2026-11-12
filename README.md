# 📊 Analisi del Peso Economico dello Sport in Europa

Analisi statistica e comparativa del mercato del lavoro sportivo nei paesi europei nel decennio 2016–2025, sviluppata in R. Lo studio esamina la densità occupazionale, la struttura demografica e di genere, il livello di istruzione degli occupati, l'impatto del Covid-19 e l'efficienza della spesa pubblica dedicata allo sport.

---

## 📌 Descrizione

Il progetto ricostruisce il peso economico dello sport in Europa attraverso indicatori Eurostat (codici: `sprt_emp_sex`, `sprt_emp_age`, `sprt_emp_edu`, `lfsa_egan2`, `demo_pjan`, `nama_10_pc`, `gov_10a_exp`) su 35+ paesi — UE-27, EFTA (Svizzera, Norvegia, Islanda) e paesi candidati — con serie storiche 2016–2025 e focus sulla posizione dell'Italia rispetto alla media UE ponderata.

Nel 2016 l'Italia contava 150–200 occupati ogni 100.000 abitanti, tra le posizioni più basse in Europa; nel 2025 ha superato quota 300 — quasi raddoppiata — raggiungendo la media UE e classificandosi sesta per crescita occupazionale. Il settore sportivo italiano vale circa 0,8–0,85% dell'occupazione totale. Sul fronte Covid, la Croazia ha perso quasi il 50% degli occupati nel 2020, mentre l'Italia ha mantenuto stabilità grazie agli ammortizzatori sociali. La ripresa è stata guidata da Slovenia, Francia e Grecia. Strutturalmente il settore è a maggioranza maschile (Italia 60–40), con bassa occupazione giovanile e circa 1/3 di laureati — sotto la media UE ma con un indice di propensione di 2,1 che segnala una sovra-rappresentazione relativa dei giovani laureati nel comparto. La spesa pubblica italiana produce 25–30 occupati per milione di euro, in linea con la media UE.

---

## 🎯 Obiettivi

- Analizzare la densità occupazionale nel settore sportivo (occupati ogni 100.000 abitanti) e la sua evoluzione 2016–2025 nei paesi europei
- Esplorare la relazione tra PIL pro capite in PPS e quota di occupati nello sport sul totale dell'occupazione
- Misurare l'impatto del Covid-19 (2019 vs 2020) e la ripresa post-pandemica (2020 vs 2022) per paese
- Studiare la composizione di genere del mercato del lavoro sportivo e le variazioni strutturali 2016–2025
- Costruire classifiche comparative per fascia d'età (15–29, 30–64, over 65) e per livello di istruzione (ISCED 0–2, 3–4, 5–8)
- Calcolare l'indice di propensione dei laureati a lavorare nello sport rispetto alla media occupazionale giovanile nazionale
- Quantificare l'efficienza della spesa pubblica dedicata allo sport (occupati per milione di euro di investimento pubblico) e confrontarla tra paesi

---

## 🔬 Metodologia

**Fonti dati e indicatori**
I dati sono stati estratti da Eurostat (Labour Force Survey) per i principali paesi europei. Gli indicatori analizzati comprendono: persone occupate nel settore sportivo per sesso, per fascia d'età (15–29, 30–64, over 65), per livello di istruzione ISCED (0–2, 3–4, 5–8), densità occupazionale ogni 100.000 abitanti, spesa pubblica dedicata allo sport e reddito disponibile delle famiglie per classificazione per reddito.

**Analisi temporale**
Costruzione di serie storiche 2016–2025 per ciascun indicatore, con calcolo delle variazioni percentuali per misurare l'impatto della crisi Covid (2019 vs 2020), la fase di ripresa (2020 vs 2022) e il trend strutturale di lungo periodo.

**Indice di propensione dei laureati**
Calcolato come rapporto tra la quota di giovani laureati (ISCED 5–8) sul totale dei giovani occupati nello sport e la medesima quota sull'intera economia nazionale, per misurare la sovra- o sotto-rappresentazione relativa dei laureati nel comparto sportivo rispetto al mercato del lavoro generale.

**Efficienza della spesa pubblica**
Misurata come numero di occupati nel settore sportivo per milione di euro di spesa pubblica dedicata, con confronto tra paesi europei sull'intero periodo 2016–2024.

**Visualizzazioni**
I risultati sono presentati tramite grafici a barre comparativi, serie storiche, scatter plot (relazione ricchezza–occupazione sportiva) e grafici di differenza temporale per evidenziare variazioni strutturali.

---

## 📊 Risultati principali

- **Densità occupazionale:** nel 2016 l'Italia contava 150–200 occupati/100k abitanti (tra le più basse in Europa); nel 2025 ha superato 300, raggiungendo la media UE e posizionandosi 6ª per crescita. L'Islanda guida con ~1.500 occupati/100k; i paesi nordici dominano la classifica. L'Italia vale 0,8–0,85% dell'occupazione totale
- **PIL e sport:** confermata relazione positiva tra PIL pro capite (PPS) e quota di occupati nello sport. Eccezioni: l'Islanda ha forte cultura sportiva indipendentemente dalla ricchezza; l'Irlanda, nonostante un PIL molto superiore, ha una quota simile all'Italia — a dimostrazione dell'influenza di politiche e cultura nazionali
- **Covid-19:** contrazione generalizzata nel 2020; Croazia –50%. L'Italia ha mantenuto stabilità grazie agli ammortizzatori sociali, alla formalizzazione contrattuale e alla riconversione verso attività outdoor e digitali. Ripresa guidata da Slovenia, Francia e Grecia; più lenta per Lettonia, Bulgaria e Svizzera
- **Genere:** settore a maggioranza maschile; Italia 60–40, leggermente sotto la media UE. Solo 6 paesi a prevalenza femminile (Islanda, Estonia, Austria, Svezia, Svizzera, Finlandia, Paesi Bassi). L'Italia ha perso ~5 p.p. di occupazione femminile dal 2016; Malta e Turchia i migliori progressi (+15–20 p.p.)
- **Età:** dominanza degli adulti 30–64 in quasi tutti i paesi; Lituania unica sopra l'80%, Italia ~70%. Paesi nordici con la quota più alta di giovani (15–29). L'Italia è sempre sotto la media UE per occupazione giovanile, avvicinandosi solo nel 2022
- **Istruzione:** in Italia <15% di occupati con licenza media (ISCED 0–2), oltre 50% diplomati (ISCED 3–4), ~1/3 laureati — sotto la media UE. Indice di propensione dei laureati = 2,1: i giovani laureati nello sport sono proporzionalmente più del doppio rispetto alla media occupazionale giovanile nazionale. Paesi baltici e Sud-Est Europa sopra il 60% di laureati nel settore
- **Spesa pubblica:** l'Italia produce 25–30 occupati per milione di euro di spesa pubblica sportiva, in linea con la media UE. Spagna la più efficiente (35–45 occupati/M€); Francia la meno efficiente (~15 occupati/M€)

---

## 🛠️ Tecnologie utilizzate

- **R** — elaborazione statistica, analisi comparativa e visualizzazione
- **Eurostat (Labour Force Survey)** — dati sull'occupazione nel settore sportivo disaggregati per sesso, età e istruzione, spesa pubblica e PIL per paese europeo 2016–2025
- **ggplot2 / base R graphics** — grafici a barre, serie storiche, scatter plot e grafici di differenza temporale

---

## 📁 Struttura del progetto

```
Analisi_Peso_Economico_Sport_Europa/
├── README.md
├── Analisi del peso economico dello sport in Europa.r
└── Analisi del peso economico dello sport in Europa.pdf
```

> ⚠️ I dataset di input (file Eurostat per occupazione, spesa pubblica, PIL e popolazione) non sono inclusi nel repository per ragioni di dimensione. Le fonti sono indicate nella sezione Dati.

---

## 📂 Dati

| Fonte | Descrizione |
|-------|-------------|
| [Eurostat](https://ec.europa.eu/eurostat) | Occupazione nel settore sportivo per sesso, età e livello di istruzione — paesi europei 2016–2025 |
| [Eurostat](https://ec.europa.eu/eurostat) | Spesa pubblica per lo sport e PIL nazionale per paese europeo |
| [Eurostat](https://ec.europa.eu/eurostat) | Popolazione totale per fascia d'età — base per il calcolo della densità occupazionale |

---

## 🔗 Link utili

- 🌐 [Sport Business Lab Consultancy](https://www.sblconsultancy.it/)
