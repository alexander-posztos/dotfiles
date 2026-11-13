---
name: texten-at
description: Write German prose without AI tells, in Austrian standard German. Apply when writing or editing German user-facing text (web pages, blog posts, UI strings, emails, meta descriptions). Catches English-shaped German, AI-tell vocabulary, grammar and structure tells, and Germany-German that should read Austrian. Can audit (report findings only) or rewrite. /texten-at <text> rewrites a passage.
---

# texten-at

Write German text that native speakers read without noticing anything unnatural or off. The target register is Austrian standard written German. Do not overdo it, so no dialect and no parody. If the project explicitly targets Germany or Switzerland, skip the Germany-German section and its table; everything else applies unchanged.

## Modes

- **Rewrite** (default when given text or asked to write). Produce the fixed or new text.
- **Audit.** When asked to check, review, or audit, report findings and don't edit. Each finding quotes the offending text, names the pattern, and shows a fix.
- **Null edit.** "Nothing wrong here" is a legitimate result in both modes. Over-editing clean human text is a failure in itself.

## Process

1. Draft or scan the given text, page, or whatever else. Match the project's voice (see Voice), then apply the patterns below.
2. A single match is just suspicion but not a verdict. One connector, one Gedankenstrich, one -ung noun does not read fully AI-generated. You should only act once patterns cluster in a paragraph or repeat across the page. Blacklist words (pattern 5), factual errors, and Germany-German in Austrian copy are findings on first occurrence.
3. Rewrite, but keep the meaning. Facts, numbers, prices, names, and § references stay exactly as given; if the project keeps canonical facts in a file, that file wins over the draft. Cut before you add. If fixing an existing text means changing more than about half of it, stop and show findings first instead of rewriting.
4. Fact diff. After rewriting, compare against the source. Did the rewrite add or drop a fact, number, name, date, or claim? An unsupported addition or a lost claim is an error. Fix it before delivering.
5. Self-audit: "Woran würde ein Leser merken, dass das eine KI geschrieben hat?" Fix what's left, then check the Gegengewicht section. Sterile prose is the opposite failure.
6. When the user rejects a line ("sounds weird", "sounds off"), answer with 5 to 10 flat declarative variants right in the chat. No bold, no cleverness, plain alternatives. When the user dictates a replacement (often typo-heavy), clean up spelling and grammar but keep their phrasing and structure. Transcription noise is not authorial voice, their word choice is. Don't reinterpret it into something more polished.

## Voice

The project's own voice rules win over everything in this section. Defaults when the project has none:

- Pick du or Sie once and keep it, never mixed. Imperative is fine. No exclamation marks unless something is actually being exclaimed.
- Concrete wording is better than polished phrases. When describing something, name the mechanism, the number or the law if applicable. "Antwort innerhalb von 24 Stunden" is better than "schneller und zuverlässiger Support".
- Concreteness includes the reader. A bare mention of a law or an unexplained abbreviation is jargon, not concreteness. On first use say what the thing is and why the reader should care ("Art 17 DSGVO, das Recht auf Löschung"), then the short form is fine.
- Write plainly, explain things as they come up, and keep the reader's benefit in view. Don't compress everything into aphorisms, and don't strip the text down until it reads dry.
- Repeating a word is fine. Uneven structure and different sentence lengths are fine and feel more natural. Avoid telegraphic copy ("We saw it. We felt it. We did it.", stuff that reads like a modern LinkedIn post).
- A project may declare signature phrases (deliberate, recurring wording) that are exempt from the patterns. 

## Patterns

Everything after `Bad:` is the pattern to remove, everything after `Good:` is the target. A bare list after `Bad:` means every item on it is a finding.

### English-shaped German

1. **Calques.** Sentence shapes thought in English. Rebuild in German syntax.
   Bad: "nur einen Klick entfernt", "macht es einfach, zu", "das ist, was", "am Ende des Tages", "Sinn machen", "in 2026", "mehr als je zuvor", "es gibt einen Grund, warum".
   Bad: "Die App macht es einfach, deine Ausgaben im Blick zu behalten."
   Good: "Mit der App behältst du deine Ausgaben im Blick."
2. **False agency.** Inanimate subjects act, decisions "entstehen", problems "entwickeln sich" to solutions, and the actor vanishes. Put the person or the product in subject position and name who does what.
   Bad: "Die App ermöglicht es dir, Termine direkt zu buchen."
   Good: "Du buchst Termine direkt in der App."
   Modal verbs stay. "Sie können X" / "du kannst X" describes an option and is not false agency; fix only sentences where the actor is missing. Bare indicative for an optional action ("Sie buchen einen Termin unter ...") reads like a manual, especially in Sie-register mails. Use the indicative for what actually happens, "können" or an imperative for what the reader may do.
3. **Typography and orthography.**
   Bad: "..." / “...” / mixed pairs. Good: „...“ throughout. Bad: 1,368.00 / Good: 1.368,00. Bad: auszuschliessen, heisst, Verstoss (Swiss ss is a model artifact) / Good: ß. Bad: 4% / Good: 4 %. Also bad: Title Case Headings, ISO dates in prose.
4. **Gedankenstrich.** German prose barely uses it. Clusters of dashes are a strong AI tell; a single one in a long text is not a finding.
   Bad: "Deine Website - schnell, sicher, online."
   Good: connect with a period or a comma.

### Vocabulary

5. **Blacklist.**
   Bad: nahtlos, ganzheitlich, maßgeschneidert, facettenreich, bahnbrechend, beispiellos, revolutionieren, transformieren, entfesseln, eintauchen, beleuchten, Landschaft (abstract), Mehrwert (filler), Synergie, Blaupause, Game-Changer, robust (software), leistungsstark, innovativ, intuitiv, "integraler Bestandteil", Reise/Fahrplan/Leuchtturm metaphors, "ist drin" / "sind drin" for features (say "kann" or name what the reader does).
6. **Stock phrases.**
   Bad: "In der heutigen digitalen Welt", "wichtiger denn je", "Es ist wichtig zu beachten", "spielt eine entscheidende Rolle", "Tauche ein", "auf das nächste Level", "volles Potenzial ausschöpfen", "Und das Beste daran?", "Egal, ob du ...", "Stell dir vor", "Kennst du das?", "Laut Studien" without a source, "Zusammenfassend lässt sich sagen", a Fazit that repeats the intro.
7. **Speed and effort claims.**
   Bad: "in Sekunden", "in unter einer Minute", "in 10 Minuten", "mit nur wenigen Klicks", "im Handumdrehen", "kinderleicht", "mühelos", "stressfrei", "keine Sorge".
   Good: say what the reader does. For example "Du wählst eine Vorlage und trägst deine Daten ein" instead of "kinderleicht erledigt".
8. **Connectors and intensifiers.** Fine alone. More than one per paragraph, or a paragraph opening with one, is a finding.
   Bad (clustered): zudem, darüber hinaus, des Weiteren, außerdem, ferner; entscheidend, essenziell, gewährleisten, sicherstellen, optimieren, umfassend, spannend.
   This targets additive filler only. Causal and explanatory connectors (weil, deshalb, damit, das heißt, dafür) are the glue of readable prose and never findings. Stripping them leaves disconnected statements the reader has to re-link himself.
9. **Anglicisms.** Use the German word where the audience does.
   Bad: Tool, Preview, Setup. Good: Programm, Vorschau, Einrichtung.
   Keep: established terms the audience uses daily (WhatsApp, PDF, Login, App, Feature).
10. **Bookish words.** The plain word wins. Exception: legal pages and formal letters keep their register.
    Bad: verfassen, erachten, sich bedienen, tätigen, übermitteln, erhalten, erfolgen, Eckwerte, samt, wahlweise.
    Good: schreiben, halten für, nutzen, machen, schicken, bekommen, passieren, Eckdaten, inklusive, nach Wunsch.

### Grammar shapes

11. **Kopula-Vermeidung.** Say "ist" or "hat".
    Bad: "dient als", "fungiert als", "stellt dar", "verfügt über", "bietet" (filler), "zeichnet sich aus durch".
    Bad: "Die App verfügt über einen Kalender." Good: "Die App hat einen Kalender."
12. **Nominalstil and Funktionsverbgefüge.** A noun on -ung usually hides a verb.
    Bad: "Die Anmeldung erfolgt über die App." Good: "Du meldest dich in der App an."
    Bad: "zur Verfügung stellen", "in Anspruch nehmen", "zum Einsatz kommen". Good: geben, nutzen, verwenden.
13. **Passiv and unpersönlich.** Name the actor. Passive only when the actor truly doesn't matter.
    Bad: "Der Bericht wird automatisch erstellt.", "Es wird geprüft, ob ..."
    Good: "Die App erstellt den Bericht automatisch."
14. **Trikolon.** Three adjectives or three short clauses for rhythm. One instance of this per page is ok, but more are seen as AI tells.
    Bad: "schnell, sicher und unkompliziert".
    Good: name only the qualities that actually matter, even if that's two or four. "schnell und sicher" when those are the two real points, no third adjective as padding.
15. **Negation stacks.**
    Bad: "Kein Download, kein Login, keine Einschulung." (also a Trikolon, doubly bad)
    Good: a positive sentence about what the reader already has or does. "Du brauchst nur einen Browser."
16. **Contrast figures.** State Y directly.
    Bad: "Nicht nur X, sondern auch Y", "Es geht nicht um X, sondern um Y", "X statt Y" as a repeated figure.
    Bad: "Die Seite ist nicht nur schön, sondern auch schnell."
    Good: "Die Seite lädt schnell und sieht gut aus."
17. **False ranges.** A list is not a scale.
    Bad: "von Studenten bis zu Pensionisten". Good: list them. ("von der Anmeldung bis zur ersten Bestellung" is a real sequence and fine.)
18. **Uniform rhythm.**
    Bad: every sentence SVO and 8 to 14 words, every paragraph three sentences, every card and every section the same shape and length.
    Good: one short sentence per paragraph, one that takes its time.
19. **Rhetorical questions as engagement.** Headline only, and only if the next line answers concretely.
    Bad: "Du willst Zeit sparen?" as body text.
20. **Partizip-I constructions.** English -ing calqued into German participles.
    Bad: "dabei Zeit sparend und Fehler vermeidend", "ein alle Anforderungen abdeckendes Konzept".
    Good: a relative clause or a second sentence. "Das spart Zeit und vermeidet Fehler."
21. **Chatbot and model residue.**
    Bad: "Gerne!", "Natürlich!", "Ich hoffe, das hilft", "Lass es mich wissen", knowledge-cutoff disclaimers ("Stand meines Wissens ..."), placeholders ([Name], [Datum]), Markdown artifacts (**bold**, ###) in plain-text output, vague authority ("Experten sind sich einig").

### Structure

22. **Fragments.** Give card copy and FAQ answers a subject and a verb. A FAQ answer is a full sentence, not a caption.
    Bad: "Per E-Mail oder im Chat."
    Good: "Du erreichst den Support per E-Mail oder im Chat."
    Also bad: epigram openers like "Die Regelung ist der Normalfall.", "Kurz gesagt: Österreich."
23. **Invented vignettes.** State the plain benefit instead of a clever punchline.
    Bad: fabricated example numbers ("Keine doppelte Buchung #4512"), mini-stories ("weil du am Handy den Überblick verloren hast"), distance metaphors ("nur eine Nachricht entfernt").
    Good: "So sparst du dir das Nachschauen und doppelte Buchungen."
24. **Checkable claims.** Every absolute carries its precondition or gets weakened to what the product verifiably does. Competitor statements name the verifiable difference, never a strawman.
    Bad: "Ihre Daten sind zu 100 % sicher.", "rechtlich korrekt", "garantiert", "100 % konform", self-labels like "ehrlich" or "objektiv".
    Good: "Die App verschlüsselt Ihre Daten und speichert sie auf Servern in der EU."
25. **Colon-glue, bold labels, fake-insight openers.** Start with the substance. A colon only introduces a real list or a quote. A short announcing clause glued to a full sentence by a colon is a finding on first occurrence, also in emails.
    Bad: "Das klassische Beispiel: Ein Fotograf ...", "Es ist umgesetzt: Produkte haben jetzt ein Feld „Details“.", "**Wichtig:**", "**Tipp:**", "**Achtung:**", "Ein häufiges Missverständnis:", "Das bedeutet:".
    Good: "Das klassische Beispiel ist ein Fotograf, der ...", "Produkte haben jetzt ein Feld „Details“." A follow-up like "Das wird oft verwechselt." can come after the claim.
26. **Fake-analysis endings.** Analysis-shaped sentences that add no analysis. End on the fact; if the conclusion is obvious, don't write it.
    Bad: ", was die Bedeutung von X unterstreicht", "Das zeigt einmal mehr, wie wichtig X ist."
27. **Headings as user questions.** On SEO content (blog H2s, lander sections) the heading is the question a user would type, and a yes/no question gets answered with Ja or Nein in the first line. This deliberately diverges from dramatic noun-phrase headings; UI and internal docs don't need it.
    Bad: "Die 14-Tage-Regel im Überblick".
    Good: "Wie lange kann ich einen Online-Kauf widerrufen?"

### Emails

No cold-outreach shapes. When in doubt cut sentences, never add reassurance boilerplate.
Bad: "Kurze Frage" / "Eine Frage" subjects, warm flattery openers, reply-pleading ("Ein Satz reicht, ich lese jede Antwort selbst"), pats on the head ("Sie nutzen das Programm ja schon fleißig"), boilerplate like "Ohne deine Freigabe geht nichts raus", "Sag einfach Bescheid", letter-style AI openers on casual mails.

### Germany-German (should read Austrian)

| Germany-German | Austrian |
|---|---|
| Januar | Jänner |
| das PDF | die PDF |
| USt-IdNr. | UID-Nummer (ATU...) |
| Elster | FinanzOnline |
| das zuständige Finanzamt [Stadt] | Finanzamt Österreich |
| Rentenversicherung / gesetzliche Krankenkasse | SVS |
| IHK | WKO / Wirtschaftskammer |
| § 19 UStG (Kleinunternehmer) | § 6 Abs 1 Z 27 UStG 1994 (check current thresholds, don't quote them from memory) |
| Handelsregister / HRB | Firmenbuch / FN |
| EC-Karte, Geldautomat | Bankomatkarte, Bankomat |
| Kasse | Kassa / Registrierkasse (§ 132a BAO) |
| Einzelunternehmer (only term) | EPU |
| Abfindung / Pfändung | Abfertigung / Exekution |
| Schulung, Einarbeitung | Einschulung |
| ein Angebot unterbreiten | ein Angebot legen |
| Ladengeschäft | Geschäftslokal |
| Mitarbeiter (SV context) | Dienstnehmer |

Safe Austrian markers when natural: heuer, allfällig, ehestmöglich (formal letters), in Evidenz halten, Rechnung legen. "fakturieren" only in legal register; in normal copy write "Rechnungen schreiben". "Angebot" and "Februar" are fine. Answer to a "Brauche ich ...?" question is "In der Regel nicht", not "In der Regel nein". Institutions: WKO, SVS, Arbeiterkammer, BMF, usp.gv.at, FinanzOnline.

## Gegengewicht

Removing tells is half the work. Prose with every pattern stripped can still read like a template, clipped, uniform, aggressively plain. That is its own tell.

- Plain is not short. An explainer earns its length. Subordinate clauses, weil-sentences, and a term explained in place are readable German, not slop. Sentence length alone is never a finding; only uniform rhythm is (pattern 18).
- Vary rhythm on purpose. A short sentence lands harder next to a long one.
- One short punch sentence per page is rhythm. Several ("Das ist neu.", "Mehr braucht es nicht.") are a drumbeat that reads edgy and self-satisfied. Write the second one as a normal sentence with its context attached.
- Where the author has a stance, keep it. One opinionated sentence does more than three neutral ones.
- A concrete detail beats a second adjective.
- Natural is not colloquial. Spoken contractions ("gibt's") are fine where the register allows, slang is not, and forced Modalpartikeln (halt, eh, ja) or decorative Austriacisms read as parody. If a marker doesn't come naturally, leave it out.

## Not a tell (don't touch)

- bzw., usw., parentheses, a repeated word, one short standalone sentence, a single connector, a single Gedankenstrich in a long text.
- "können" / "kann". A modal verb marking an option is not a tell and not a thing to tighten into bare indicative.
- Formal register on legal pages, contracts, Mahnungen, and AGB. That register is correct there.
- Correct Austrian forms. Jänner, die PDF, Kassa, heuer, Rechnung legen are never errors. Don't "fix" Austrian into Bundesdeutsch.
- Phrasing the user dictated or already approved, and declared house phrases. That wording is data, not a finding.
- du used consistently, or Sie used consistently. Only mixing is a finding.
- A real list that happens to have three items. Trikolon is three-for-rhythm, not three-because-there-are-three.
- Passive where the actor genuinely doesn't matter.
- An English term the audience actually uses daily.

## Self-audit

- Gedankenstriche, Doppelpunkt-Kleber, Dreiermuster, Konnektoren zählen. Cluster → fix.
- Kommt dieselbe Formulierung mehr als zweimal auf der Seite vor? Einmal erklären reicht.
- Hält jede absolute Aussage einer Prüfung stand?
- Stimmen nach dem Umschreiben noch alle Fakten, Zahlen und Namen mit der Vorlage überein?
- Wurde irgendwo korrektes Österreichisch zu Bundesdeutsch "korrigiert"? Dann wieder zurück korrigieren.
- Liest sich das Ergebnis steril oder abgehackt? Dann Gegengewicht anwenden, nicht noch mehr streichen.
- Würde ein Leser ohne Vorwissen jeder Abkürzung und jedem Verweis folgen können?
