# texten-at

Ein Claude-Skill, der KI-Agents hilft, besseren deutschen Text für Österreich zu schreiben. Im SKILL.md sind 27 Muster mit Beispielen gelistet, die vermieden werden sollen, inklusive Klassikern wie „Es ist nicht X, sondern Y“. Dazu kommen übliche Begriffe, bei denen Modelle gern die deutsche Version verwenden, mit der österreichischen daneben (z. B. Jänner statt Januar).

## Vergleich

Ich habe diesen Prompt in Claude Web verwendet:

> Schreib für die Website eines kleinen Fotostudios einen kurzen Abschnitt, inklusive Überschrift plus ein Absatz mit maximal 80 Wörtern. Inhalt: Termine kann man jetzt online buchen und bis 48 Stunden vorher kostenlos stornieren.

**Ergebnis ohne Skill** (Hervorhebungen nachträglich):

> **Termine jetzt online buchen**
>
> Ihr Fototermin ist ab sofort **mit wenigen Klicks** gebucht **– rund um die Uhr, ganz ohne Anruf**. Wählen Sie einfach den Wunschtermin, der in Ihren Kalender passt, und **wir kümmern uns um den Rest**. Sollte etwas dazwischenkommen, können Sie bis 48 Stunden vor dem Termin kostenlos stornieren. **So bleiben Sie flexibel** und wir freuen uns auf Sie!

**Ergebnis mit texten-at:**

> **Termine online buchen**
>
> Sie können Ihren Fototermin ab sofort direkt auf unserer Website buchen. Im Kalender sehen Sie die freien Zeiten und wählen den Termin, der Ihnen passt. Wenn etwas dazwischenkommt, stornieren Sie bis 48 Stunden vor dem Termin kostenlos. Wir freuen uns auf Sie.

Meiner Meinung nach ist der zweite Text viel einfacher zu lesen und klingt natürlicher. Etwas nachbessern muss man meistens immer noch, aber der Ausgangspunkt ist deutlich besser.

## Was der Skill prüft

- **Deutscher Text in englischer Form.** KI-Modelle schreiben gern englische Floskeln einfach auf Deutsch, zum Beispiel „Sinn machen“ oder „nur einen Klick entfernt“. Die sind im Skill als Negativbeispiele gelistet.
- **Vokabular.** Eine Blacklist mit überverwendeten Wörtern wie „nahtlos“, „ganzheitlich“ oder „maßgeschneidert“, dazu Tempo-Versprechen („im Handumdrehen“) und Papierdeutsch.
- **Grammatik.** Diese Muster sind als Negativbeispiele gelistet: Nominalstil, Passiv ohne Grund, Trikolon, Negationsketten, Kontrastfiguren, gleichförmiger Rhythmus, Partizip-I-Konstruktionen.
- **Struktur.** Fragmente statt Sätze, erfundene Beispiele, unhaltbare absolute Aussagen, Doppelpunkt-Kleber, Pseudo-Analyse-Schlüsse („... was die Bedeutung von X unterstreicht“).
- **Bundesdeutsch.** Jänner statt Januar, UID statt USt-IdNr., FinanzOnline statt Elster, Firmenbuch statt Handelsregister, dazu die Begriffe aus dem Steuer- und Sozialversicherungsrecht.

## Warum österreichisch

Für Deutsch gibt es solche Listen schon. Österreichisches Deutsch kommt darin höchstens als Variante vor, die man in Ruhe lassen soll. Hier ist es das Ziel, der Skill schreibt aktiv auf Jänner, UID und FinanzOnline hin. Wer für Deutschland schreibt, lässt die Tabelle weg, alles andere funktioniert gleich.

## Installation

Der Skill liegt in meinem [dotfiles-Repo](https://github.com/alexander-posztos/dotfiles) unter `claude-skills/texten-at`:

```
git clone https://github.com/alexander-posztos/dotfiles
cp -r dotfiles/claude-skills/texten-at ~/.claude/skills/
```

Oder als Projekt-Skill nach `.claude/skills/` kopieren.

## Anpassen

Der Abschnitt „Voice“ im Skill ist nur ein Default. Eigene Projektregeln (du oder Sie, Ton, eigene Haus-Phrasen) gehen vor.

## Verwandte Projekte

Inspiriert von [poteto/plugins](https://github.com/poteto/plugins) (unslop). Für Deutschland-Deutsch gibt es [marmbiz/humanizer-de](https://github.com/marmbiz/humanizer-de).

## Lizenz

MIT
