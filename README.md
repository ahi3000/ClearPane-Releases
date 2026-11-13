# ClearPane

Windows aufräumen, schützen und schneller machen – jede Änderung lässt sich rückgängig machen.

Diese Seite enthält nur die fertigen Downloads. Der Quellcode liegt nicht hier.

## Installieren

**Am einfachsten:** das neueste Setup herunterladen und doppelklicken.

👉 [ClearPane-setup.exe (neueste Version)](https://github.com/ahi3000/ClearPane-Releases/releases/latest/download/ClearPane-setup.exe)

**Oder mit einer Zeile in PowerShell** (lädt das Setup, prüft die SHA-256-Prüfsumme, installiert):

```powershell
irm https://raw.githubusercontent.com/ahi3000/ClearPane-Releases/main/install.ps1 | iex
```

- Keine Admin-Rechte nötig, installiert nach `%LocalAppData%\Programs\ClearPane`
- Bringt alles mit, was es braucht – kein .NET oder sonstiges vorher installieren
- Läuft auf Windows 10 (ab Version 1809) und Windows 11, auf x64 und ARM64
- Ohne Installation: die `…-portable.zip` für deinen Prozessor entpacken und `ClearPane.exe` starten

> Windows SmartScreen zeigt beim ersten Start eventuell „Unbekannter Herausgeber“, weil das Setup noch nicht signiert ist.
> „Weitere Informationen“ → „Trotzdem ausführen“.

## Updates

ClearPane prüft beim Start selbst, ob es hier eine neue Version gibt, und installiert sie nach einem Klick.
Vor der Installation wird die SHA-256-Prüfsumme jeder Datei geprüft. Unter *Einstellungen* lässt sich das abschalten
oder auf *Vorschau-Versionen* umstellen.

## Deinstallieren

Windows-Einstellungen → Apps → ClearPane → Deinstallieren.
