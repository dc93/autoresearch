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

- `defaultMode: acceptEdits` è attivo: edit di `train.py` non chiedono conferma.
- L'allowlist in `.claude/settings.json` copre `uv`, `git`, `grep`, `tail`, ecc. La denylist protegge `prepare.py`, `pyproject.toml`, `uv.lock`, `program.md`, `.claude/**`, `git push`, `pip install`, `rm -rf`.
- **Stop hook auto-continue**: quando sei su un branch `autoresearch/*` e provi a chiudere il turno, l'hook `.claude/hooks/continue-loop.sh` blocca lo stop e ti reinietta nel loop. Non ti chiedi mai "vado avanti?", vai e basta finché l'utente non interrompe (ESC/Ctrl-C o cambio branch). Vedi anche "NEVER STOP" in `program.md:112`.
- L'utente NON sarà presente per dare input. Tratta ogni decisione come tua. Se manca un dato, sceglilo tu in base a `program.md` e procedi.
