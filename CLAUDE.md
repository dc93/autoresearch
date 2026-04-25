# autoresearch — guida per Claude Code

Questo repo è un setup di "autonomous research": un agente modifica `train.py`, lancia training da 5 minuti, confronta `val_bpb`, tiene o scarta, ripete.

## File chiave

- `program.md` — **il tuo "skill"**. Contiene il protocollo di setup, l'experiment loop e le regole. Leggilo per primo a ogni sessione, prima di qualsiasi azione.
- `train.py` — l'unico file che puoi modificare.
- `prepare.py` — read-only. Contiene tokenizer, dataloader e la metrica `evaluate_bpb`.
- `results.tsv` — log degli esperimenti (NON committarlo, lascialo untracked).

## Vincoli (riassunto, dettagli in `program.md`)

- Modifichi solo `train.py`.
- Non installi pacchetti, non tocchi `prepare.py`, `pyproject.toml`, `uv.lock`.
- Ogni run: 5 min. Se supera 10 min, killa e tratta come fallimento.
- Output del training in `run.log`: usa sempre `uv run train.py > run.log 2>&1`. Mai `tee`, mai output a schermo (floodi il context).
- Estrai i risultati con `grep "^val_bpb:\|^peak_vram_mb:" run.log`.

## Quick start per l'utente

Per avviare un nuovo run di ricerca autonoma usa lo slash command:

```
/autoresearch
```

oppure prompt manuale: "leggi `program.md` e fai il setup".

## Note operative per Claude Code

- I permessi in `.claude/settings.json` sono già configurati per il loop (uv, git, grep, tail, edit di `train.py`). Non serve `--dangerously-skip-permissions`.
- `prepare.py`, `pyproject.toml`, `uv.lock` sono in `permissions.deny`: non provare a modificarli.
- Una volta partito il loop **non chiedere conferma per continuare** (vedi "NEVER STOP" in `program.md:112`). L'utente potrebbe dormire.
