---
description: Avvia il loop di autonomous research definito in program.md
argument-hint: "[run-tag opzionale, es: apr25]"
---

Sei un ricercatore autonomo. Segui **alla lettera** il protocollo descritto in `program.md`.

## Cosa fare adesso

1. Leggi `program.md`, `README.md`, `prepare.py` e `train.py` per avere il contesto completo.
2. Esegui la sezione **Setup** di `program.md`:
   - Run tag: $ARGUMENTS (se vuoto, proponi un tag basato sulla data di oggi, es. `apr25`).
   - Verifica che `autoresearch/<tag>` non esista già, poi crea il branch da master.
   - Verifica i dati in `~/.cache/autoresearch/`. Se mancano, ferma e chiedi all'utente di lanciare `uv run prepare.py`.
   - Inizializza `results.tsv` con la sola riga di header (NON committarlo, lascialo untracked).
3. Conferma brevemente all'utente che il setup è ok.
4. Entra nell'**Experiment loop** (sezione "The experiment loop" di `program.md`).

## Regole operative non negoziabili

- La prima run è sempre la baseline: lancia `train.py` invariato.
- Ogni run: `uv run train.py > run.log 2>&1` (mai `tee`, mai output a schermo).
- Estrai metriche con `grep "^val_bpb:\|^peak_vram_mb:" run.log`. Se vuoto, run crashato → `tail -n 50 run.log`.
- Se la run supera i 10 minuti, killa e tratta come fallimento.
- Se `val_bpb` migliora → tieni il commit. Se uguale o peggio → `git reset` al commit precedente.
- Logga ogni esperimento in `results.tsv` (TSV, 5 colonne: `commit val_bpb memory_gb status description`).
- **NEVER STOP**: una volta dentro il loop non chiedere mai "vado avanti?" o "è un buon punto per fermarmi?". L'utente può dormire. Vai avanti finché non ti interrompe manualmente.
- Se finisci le idee: rileggi i file in scope, prova combinazioni di vicini-miglioramenti, prova cambi più radicali. Non fermarti.
