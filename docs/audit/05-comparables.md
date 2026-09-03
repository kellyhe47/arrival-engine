# 05 — Comparables

**Audit phase. We measure ground truth; we do not design.**

Scope: what comparable products actually do, the shape of their core artifact, what they charge,
and how each handles the line between attentive and creepy.

**Evidence rule applied throughout.** A search-result snippet is not a source. Every claim below
carries a short verbatim quote and the URL that was actually fetched. Where a primary artifact
could not be reached, the claim is marked **UNVERIFIED** rather than inferred or filled in from
memory. No product feature is asserted that was not read on a vendor page, help centre, API doc,
filing, or published report.

**Quoting convention.** Quotes are kept short and attributed. US Government works (AR 25-50, FTC
and ICO releases) are public domain and quoted at greater length. Vendor documentation is quoted
in fragments sufficient to establish the claim.

## The sharpest comparable

**Our product already exists, and it prints on paper.** PeopleVine — the platform behind Casa
Cipriani, Zero Bond, San Vicente Bungalows, Aman and Park House — ships a door app that produces
a **paper arrival chit** carrying birthday, membership tier, recent visits, 90-day purchases and
priority notes, and sells "face scan or fingerprint" check-in alongside it. No member-facing
document at any of those clubs mentions that this happens. That is the artifact we are
specifying, live, in our own category. See §2.

**Soho House is the sharpest comparable for the programme around it.** It runs a capitalised
**"Member Recognition"** function — a job description calls for overseeing "Member Recognition,
allowing in person, real time follow through with check in flags from Reception (table touches,
introductions, etc.)" — and its CTO says on the record that "Members are matched to other members
using a proprietary algorithm." Its House Rules publish member consent to hold "a photograph of
you in our membership database." Stack: Salesforce + OpenTable + Opera + MICROS.

**Chief is the sharpest comparable for the introduction itself**: it sells "A curated
introduction designed to confirm alignment," with a human reviewing every group before launch.

Outside the club category, the sharpest *format* comparable is the declassified **President's
Daily Brief** — five items, ~265 words, ~87 seconds read aloud (§B).

## The cross-category finding

Read sections 3 and 5 against each other. The two markets closest to our "who should you meet,
with a score and reasoning" feature have each solved exactly half of it, and neither has solved
both:

| | Exposes a score? | Shows the reasoning? |
|---|---|---|
| **Relationship CRM** (Affinity, Attio, Mesh) | **Yes** — Affinity 10–100 plus colour bands; Attio six named bands | **No.** Affinity says the opacity is deliberate. |
| **Event matchmaking** (Brella, Swapcard, Grip, Whova) | **No** — no vendor exposes a numeric score to the person being matched | **Yes** — shared-interest tags, "what you have in common", explicit explanations |

**Nobody ships a per-person "here is the number *and* here is why."** Affinity states the
concealment is a design choice; the event platforms converged on ranked lists with categorical
reasons and no arithmetic. Our brief asks for both at once. That is genuinely unoccupied
territory — which is a differentiator and a warning in equal measure, since section A shows that
legible reasoning is exactly what makes personalization survive contact with its subject.

**The one product that has solved the explanation half properly is Swapcard**, and its design is
worth copying wholesale. Reasoning is not post-hoc copy — it is the graph edge itself: "These
similarities or associations are the **explanations**." It ships **two-level disclosure**: the
first level "provides the attendee with general information on what people have in common", and
on click "Attendees will find the events they have in common, interests, jobs". Its internal
weights are published (interest **5.0** vs biography **0.3**) but deliberately never surfaced.
So even the best explainer in the category shows *which* factors matched, never *how much* each
one counted.

A second split worth carrying forward, from section 5: matchmaking inputs are either
**declared** (Brella gates matches on interests the attendee selected at registration — the
matches tab does not exist until you declare) or **inferred** (Whova: "SmartProfiles are
pre-populated… without relying on attendees' manual inputs"; SXSW asks the attendee to "Enable
Bluetooth to ensure that you are able to receive our personalized recommendations"). Section A,
principle 2, says which of those ages better.

## How to read this

Sections 1–5 are the market survey, one per category. **Sections A and B are the deliverable** —
A is the seen-vs-dossiered line with the evidence behind it, B is the observed format of a real
sub-two-minute brief. If you read two things, read those.

## Contents

1. Hospitality guest-recognition — SevenRooms, Resy, Tock, OpenTable, hotel PMS, Ritz "Mystique"
2. Private members clubs — Soho House, The Battery, NeueHouse, Zero Bond, Chief, Texas
3. Relationship intelligence / personal CRM — Clay/Mesh, Affinity, 4Degrees, Dex, folk, Attio
4. Sales / contact enrichment — Clearbit/Breeze, Apollo, ZoomInfo, People Data Labs, Clay.com
5. Conference / event matchmaking — Grip, Brella, Swapcard, Twine, Web Summit, SXSW, CES
- **A. The seen-vs-dossiered line, with evidence**
- **B. Register and format of a good staff brief**

---

# 1. Hospitality guest-recognition

## Hospitality guest-recognition

Competitive audit of guest-recognition systems in hospitality, read as prior art for a staff-facing arrival brief (a host reads a 90-second digest about an arriving member and uses it to make an introduction).

**Evidence standard used throughout.** Every factual claim carries a verbatim quote and the exact URL that was fetched and read. Search-result snippets were not treated as sources. Anything that could not be confirmed on a fetched page is marked **UNVERIFIED** rather than inferred. Where a vendor's help center or API reference was gated, that gating is reported as itself a finding, and open-source connector schemas (which publish literal wire field names) were used as a substitute where available.

**The three things worth knowing before reading the sections.**

1. **The real note format in this industry is coded shorthand, not prose.** Working guest notes are dominated by two-to-four-letter codes — PX, PPX, HWC, FOM, WW, S.O.E., f.t.d., "o" — roughly half of which encode service facts and half of which encode un-appealable judgements about a person's body, character or wallet. Shorthand is what people write when they would not want the sentence version read aloud. See the cross-cutting press section.

2. **Almost no vendor tells staff what not to write.** Across SevenRooms, Mews, Cloudbeds and OPERA Cloud, not one reachable page offers guidance on the *substance* of a guest note. Vendors handle the problem structurally — retention, masking, visibility flags, authorship — or not at all. The sharpest articulations of the line come from practitioners, not policies, and the single best one is a leak test rather than a consent test: "You want to be careful what you put in the notes. It could be very embarrassing if it got out."

3. **Oracle OPERA Cloud is the most mature model, and Ritz-Carlton is the most interesting one.** OPERA answers the question with mechanism: a lockable internal flag, a 2,000-character cap, a first-class *Incognito* mode for guests who wish not to be recognized, automatic decay of dormant data, and an irreversible anonymization routine that deletes notes outright. Ritz-Carlton answers it with identity: privacy is Service Value 11, sitting in the same numbered first-person list as the empowerment to personalize — and a human curation role (the guest recognition office) sits between what staff observe and what enters the record.



### SevenRooms

*Source-grounded audit. Every claim below carries a verbatim quote and the URL actually fetched. Claims that could not be confirmed from a fetched page are marked **UNVERIFIED**.*

---

**1. What SevenRooms actually does**

SevenRooms is a sales-led, enterprise hospitality operating platform — reservations, waitlist, table management, CRM, and marketing automation — sold to restaurants, hotels, nightlife venues and membership clubs, and positioned around *owning and exploiting first-party guest data* rather than around booking supply. Its own homepage frames it as "More than just reservations" and promises to "help restaurants increase sales, delight guests and keep them coming back—automatically," organized into four modules: "Reservations & Waitlist," "Table Management," "Guest Data & Personalization," and "Marketing Automation" (https://sevenrooms.com/). The data engine is the differentiator: "Build rich customer profiles automatically with over 100 data points per guest, from dining preferences and order history to real-time point-of-sale spend" and "Centralize customer profiles for a unified view of the customer across all locations and departments" (https://sevenrooms.com/platform/crm/). Hotel Tech Report describes it the same way: "One of the key features of SevenRooms is its CRM (Customer Relationship Management) system, which creates detailed guest profiles based on collected guest data" (https://hoteltechreport.com/food-and-beverage/restaurant-crm/sevenrooms). Wikipedia summarizes it as "a cloud-based data platform used by restaurants, hotels, and other venues to take reservations, manage bookings, and collect guest information" (https://en.wikipedia.org/wiki/SevenRooms). **Ownership note:** SevenRooms is now a DoorDash subsidiary — "DoorDash has agreed to acquire hospitality software company SevenRooms for $1.2 billion in an all-cash transaction" (https://www.restaurantdive.com/news/DoorDash-acquires-sevenrooms-1-billion/747226/).

---

**2. The SHAPE of the guest profile artifact**

SevenRooms' own Help Center (help.sevenrooms.com) is login-gated and returned **HTTP 403** to unauthenticated fetch, and the API reference is gated too: "Effective February 26, we have moved to individually provisioned accounts for access to our API documentation" (https://api-docs.sevenrooms.com/). So the strongest available field-level evidence is the **public JSON Schema for the SevenRooms `clients` object**, published in an open-source Singer tap built against the SevenRooms API (AGPL-3.0, archived Nov 2024). These are literal wire field names, not marketing paraphrase.

***2a. `clients` object — the guest profile record*** (https://raw.githubusercontent.com/uptilab2/tap-sevenrooms/master/tap_sevenrooms/schemas/clients.json)

| Group | Verbatim field names |
|---|---|
| Identity | `first_name`, `last_name`, `salutation`, `title`, `gender`, `company`, `photo`, `photo_crop_info`, `reference_code`, `external_user_id`, `id` |
| Contact | `email`, `email_alt`, `phone_number`, `phone_number_alt`, `phone_number_locale`, `phone_number_alt_locale`, `address`, `address_2`, `city`, `state`, `postal_code`, `country` |
| Dates / occasions | `birthday_day`, `birthday_month`, `birthday_alt_day`, `birthday_alt_month`, `anniversary_day`, `anniversary_month` |
| **Notes (two distinct types)** | **`notes`**, **`private_notes`** |
| Tags | `tags`, `client_tags` |
| Extensibility | `custom_fields` |
| Membership / loyalty | `member_groups`, `loyalty_id`, `loyalty_rank`, `loyalty_tier`, `has_billing_profile` |
| **Lifetime behavior stats** | `total_visits`, `total_covers`, `total_spend`, `total_spend_per_visit`, `total_spend_per_cover`, `total_noshows`, `total_cancelations`, `avg_rating` |
| Privacy / consent flags | **`is_contact_private`**, `marketing_opt_in`, `marketing_opt_in_ts`, `is_one_time_guest` |
| System | `created`, `updated`, `deleted`, `status`, `venue_group_id`, `user` |

Three things worth flagging for an arrival-brief product:

- **There are exactly two note types on the profile: `notes` and `private_notes`.** Both are flat `["null","string"]` free text — no structure, no schema, no length constraint, no category. Whatever discipline exists is human, not enforced.
- **`is_contact_private`** is a real boolean on the profile — a discretion flag exists at the record level.
- **Lifetime spend is not one number but four**: `total_spend`, `total_spend_per_visit`, `total_spend_per_cover`, plus `total_covers`. Reliability signals (`total_noshows`, `total_cancelations`) sit in the same object as spend.

***2b. Tag structure — tags are grouped, labeled, and color-coded***

`client_tags` is an array of objects with exactly these properties (verbatim from the same schema):

```
"color", "group", "group_display", "tag", "tag_display"
```
(https://raw.githubusercontent.com/uptilab2/tap-sevenrooms/master/tap_sevenrooms/schemas/clients.json)

So a tag is not a bare string — it carries a **category** (`group` / `group_display`), a **display label** distinct from its internal key (`tag` vs `tag_display`), and a **color** used for visual encoding at the host stand. `custom_fields` similarly carries `"system_name"`, `"display_order"`, `"name"`, `"value"` — i.e. operators define their own labeled profile fields with a controlled render order.

***2c. Reservation object — visit-scoped fields*** (https://raw.githubusercontent.com/uptilab2/tap-sevenrooms/master/tap_sevenrooms/schemas/reservations.json)

Verbatim field names relevant to an arrival brief: **`is_vip`** (boolean), **`client_requests`**, **`notes`**, **`tags`** (same five-property tag shape), **`table_numbers`**, **`served_by`**, **`booked_by`**, `rating`, `loyalty_tier`, `loyalty_rank`, `shift_category`, `reservation_type`, `arrival_time`, `seated_time`, `left_time`, `arrived_guests`, `venue_group_client_id`, `custom_fields`, `pos_tickets`, `mf_ratio_male`, `mf_ratio_female`, `comps`, `total_payment`. There is also a **`problems`** structure whose leaf properties are `"problem_name"` and `"is_major"` — a formal incident/flag concept attached to a visit.

Note the layering: **`client_requests` (what the guest said) is a separate field from `notes` (what staff wrote)**, and reservation `notes`/`tags` are separate from the profile-level `notes`/`private_notes`/`client_tags`. That's a four-way note/annotation split across two objects.

***2d. Note TYPES, restated plainly***

| Type | Where | Evidence |
|---|---|---|
| `notes` | client profile | clients.json |
| `private_notes` | client profile | clients.json |
| `notes` | reservation | reservations.json |
| `client_requests` | reservation (guest-supplied) | reservations.json |

SevenRooms' own setup docs confirm the tag split matches: the account-setup checklist lists **"Client & Reservation Tags"** as one configuration area and tells operators to "Customize Tags to identify important qualities of a guest or reservation" (https://sevenrooms.com/newcustomer/settings/). Their training page repeats it: "Edit Client & Reservation tags to enhance Client Profiles" and "Customize client Auto-Tags and create email automations" (https://sevenrooms.com/newcustomer/training/).

***2e. Auto-tags — machine-written profile annotations***

Tags are not only hand-entered. "Add unlimited tags and Auto-tags like 'positive reviewer' or 'steak lover' to customer profiles to optimize personalized service for every guest," driven by "rules-based criteria to segment guests by behavior, dining preferences and spend, applied to guest profiles automatically" (https://sevenrooms.com/platform/crm/). Their auto-tag blog enumerates condition families verbatim — "Visit Frequency," "Spend Thresholds," "Frequent No-Shows," "Big tipper," "Order Frequency," "Order Volume," "Re-engagement," "Abandoned Waitlist," "Cancellations," "Booked Through a Third-Party" — and states there are "more than 75 different tagging conditions" with "and/or logic" (https://sevenrooms.com/blog/how-to-elevate-your-hospitality-and-drive-repeat-revenue-with-auto-tags/).

***2f. UI layout / what staff actually see***

I could not reach a screenshot-level walkthrough (Help Center gated). What the product pages state verbatim: "360° Guest Profiles" with "Auto-tags" that track "allergies, order preferences and reservation notes automatically"; staff "know every guest before they sit down with real-time guest data alerts"; teams "spot regulars, high spenders and first-timers"; pre-shift prep gives "every guest, reservation note and tag for the next shift"; predefined filters "quickly surface VIP experiences, special parties, cancellations and no-shows" (https://sevenrooms.com/platform/table-management/). A profile photo is part of the artifact and is used for door recognition — a case-study page notes "Thanks to the presence of profile pictures, reception teams can welcome guests by name as they walk in" (https://sevenrooms.com/tools-resources/success-stories/) — and `photo` with `small`/`medium`/`large`/`raw` variants is in the schema. **The precise on-screen pane arrangement, field ordering and iconography is UNVERIFIED.**

***2g. Members-club framing (directly relevant to a private club)***

"Bring your guests into the inner circle using details and dining preferences in automated guest profiles, like preferred cocktails or favorite bites." / "Upgrade the member experience with standard, custom and automated guest tags like 'VIP' or 'Martini lover.'" / "Ensure guests get the same personal experience at any club location by hosting guests profiles in a shared CRM database." / "Centralize VIP and guest communications with Private Line." (https://sevenrooms.com/membership-clubs/)

---

**3. What staff-facing NOTES look like in practice**

**Format:** unstructured free text. Both `notes` and `private_notes` are plain nullable strings with no sub-structure (https://raw.githubusercontent.com/uptilab2/tap-sevenrooms/master/tap_sevenrooms/schemas/clients.json). Structured facts (allergy, occasion, spend tier) are pushed into *tags* and *custom_fields*; the note field is the residue.

**Voice and quality — SevenRooms' own diagnosis is that notes are bad.** Their AI Notes page is unusually candid: "Guest notes entered mid-service are often rushed, inconsistent and hard to action later. AI Notes cleans up those entries automatically, formatting and standardizing them so every profile in your restaurant CRM is clear, structured and ready to use before the next shift starts." Features listed verbatim: "One-click cleanup: Reformat rushed, inconsistent guest notes instantly." / "Customizable templates: Match your team's own operational language." / "Review panel: Confirms no critical guest details are missed before saving." (https://sevenrooms.com/platform/artificial-intelligence/). The CRM page repeats the pitch: "Keep guest notes clean and actionable with AI Notes, which automatically standardizes CRM data so teams can deliver more personalized guest experiences" (https://sevenrooms.com/platform/crm/).

That is a vendor admitting the raw artifact is *rushed, inconsistent, and hard to action* — telegraphic fragments typed during service, not composed prose, with per-venue idiolect ("your team's own operational language") strong enough that templates must be customizable.

**Typical length:** short enough that a "one-click cleanup" reformat is the remedy, but **no published length statistic exists — UNVERIFIED.**

**Real example note text:** I could not obtain a genuine SevenRooms note verbatim from a primary source. The closest is a third-party analyst's characterization of legacy SevenRooms CRM data: "If you've inherited a CRM where six servers have written 'allergy?? shellfish maybe' in six different formats across three years, this is worth more than the marketing suggests" (https://www.usecarly.com/blog/sevenrooms-ai/) — explicitly a hypothetical, not a captured note. Content *types* that go into notes are attested: SevenRooms' privacy policy says "Guest notes (such as dining preferences) may be recorded in the Platform by Venue staff" (https://sevenrooms.com/privacy-policy/), and a venue-facing GDPR page lists what is held as "name, email, phone, address, picture, food allergies, eating or seating preferences, birthday, anniversary, IP address, and other specific notes you provide" (https://www.sevenrooms.com/gdpr-policy/ahNzfnNldmVucm9vbXMtc2VjdXJlchwLEg9uaWdodGxvb3BfVmVudWUYgIC4-uevwwoM). Fortune reports notes go well past preferences: a profile "could also include any notes of how you treated (or mistreated) the staff" (https://fortune.com/2016/09/29/sevenrooms-nightclub-restaurant/).

**UNVERIFIED:** A widely-repeated list of example manual tags — "allergic to shellfish," "wine $$$$," "always accommodate," "VIP" — appears in search snippets attributed to reporting on SevenRooms, but I could not retrieve it from any page I actually fetched. Do not cite it as sourced.

---

**4. Pricing**

**SevenRooms does not publish prices.** The pricing page exists and lists three tiers — **Starter, Growth, Premium** — with the Starter tier described as "Essential Operations" / "Streamline core business operations to grow revenue & automate driving repeat business," and Starter inclusions listed as "CRM & Guest Profiles," "Branded Reservations & Waitlist Management," "Access to +50 mil DoorDash & Deliveroo Reservation Marketplace Users with No Cover Fees," "Table Management," "Reputation Management," "Basic Marketing Automations," plus paid add-ons "Email Marketing," "Event Management," "Voice AI," "WhatsApp / Text Marketing," "API & Integrations," "Group Portal." No figures appear anywhere; the CTA is "Get a quote" (https://sevenrooms.com/pricing/).

Third-party confirmations and reported figures:

- Hotel Tech Report: "Pricing Available By Request — SEVENROOMS has opted not to share general pricing on their profile but you can request a quote below." The same profile adds: "This vendor has not met the minimum criteria for the Certificate of Excellence which is awarded to vendors who exemplify transparent cultures and come highly recommended by their clients." (https://hoteltechreport.com/food-and-beverage/restaurant-crm/sevenrooms)
- **The only concrete reported per-venue figure I could verify from a fetched page:** "SevenRooms charges restaurants about $500 a month per location for its table-management and guest-profile software" (https://thehustle.co/opentable-reservation-tech-sevenrooms). Note this figure dates to the OpenTable data-ownership dispute era and predates the current tiering and the DoorDash acquisition.
- A 2026 pricing explainer confirms the opacity but supplies no numbers: "SevenRooms does not publish list prices on its website" and "SevenRooms uses a sales-led process...they do not show a standard price list"; it explicitly cautions that "Figures from old reviews, anonymous comments, or third-party estimates may reflect a different package" (https://restaurantbookingsystem.com/compare/sevenrooms-pricing/).
- Capterra lists "Starting Price: Starting at $1.00 per month," "Free Trial: Not available," "Free Version: Not available," pricing model "Per Feature, Per Month" (https://www.capterra.com/p/165480/SevenRooms/pricing/). **The $1.00 figure is a directory placeholder, not a real price — do not use it.**
- G2's review/pricing pages returned **HTTP 403** and could not be read.

**Bottom line:** unpublished, quote-only, annual-contract enterprise pricing. One verifiable data point (~$500/venue/month, dated). Commonly cited ranges of $300–$1,200/venue/month and $5K–$25K implementation fees appeared **only in search snippets and could not be confirmed from any fetched page — UNVERIFIED.**

---

**5. MOST IMPORTANT — the attentive-vs-creepy line**

**Finding: SevenRooms has essentially no product-level answer to this. The line is delegated wholesale to the operator, by contract.** This is the sharpest competitive gap.

***5a. There is no published guidance to staff on what NOT to write in a guest note.***
Across the CRM page, table-management page, AI Notes page, membership-clubs page, account-setup guide, training page, MSA, DPA and privacy policy, I found **zero** instances of restraint guidance — no "avoid recording appearance/health/behavior," no note-field warning copy, no prohibited-content list for notes. The AI Notes review panel's stated purpose is completeness, not restraint: "Confirms no critical guest details are missed before saving" (https://sevenrooms.com/platform/artificial-intelligence/). **Guidance to operators about what not to write in a guest note: UNVERIFIED / none found.**

***5b. Field-level restrictions: none specific to sensitive data.*** The MSA's only content restriction is a generic acceptable-use clause: "Client and Users may not use the Services to transmit, store, display, distribute or otherwise make available Client Information that is illegal, harmful, or offensive, including content that is defamatory, obscene, abusive, invasive of privacy, or pornographic" (§4.4, https://sevenrooms.com/msa/). Notably it does *not* carve out special-category personal data. I grepped the full DPA text for "sensitive," "special categor," "article 9," "health data," and "racial" — **zero matches** (https://go.sevenrooms.com/rs/519-YNM-008/images/SevenRooms%20Data%20Processing%20Addendum%20-%20September%202021.docx.pdf). The word "note" likewise does not appear in the DPA.

***5c. The DPA enumerates data types per module — and free-text notes are absent from the enumeration.*** Schedule 1's CRM row reads verbatim:

> "CRM | Venue Guests / Venue Staff | First Name, Last Name, IP Address (of user), Email Address (optional), Phone Number (optional), Membership Number, Dietary Restrictions (optional), Birthday (optional), Special Occasion (optional), Address (optional), Occupation (optional) | ● Managing Client profile data (CRM) ● Correcting information as requested by the guest, and capturing Guest preferences or special requests ● Building a profile for Guests at the inception of our Clients' use of the platform"

Other modules add "Social ID (optional)," "Picture (optional)," "Spend (optional)," "Server Full Name" (https://go.sevenrooms.com/rs/519-YNM-008/images/SevenRooms%20Data%20Processing%20Addendum%20-%20September%202021.docx.pdf). **"Dietary Restrictions" is contractually scoped as optional and treated as ordinary personal data.** The critical gap: the schema-level `notes` and `private_notes` free-text fields — where the genuinely sensitive material actually accumulates — are not enumerated as a data type anywhere in Schedule 1. The contract describes a tidy field list; the product ships an unbounded text box.

***5d. Liability is contractually pushed to the venue.*** SevenRooms is the processor, the venue is the controller: "With respect to personal information of Guests of the Venues that are SevenRooms' customers, SevenRooms processes such information as a processor" and such Venues "constitute the controller under GDPR" (https://sevenrooms.com/privacy-policy/); "Client is the Controller, SevenRooms is the Processor" (https://sevenrooms.com/dpa/). The MSA makes the operator warrant the lawful basis: "Client represents and warrants that it has provided and will continue to provide adequate notices, and that it has obtained and will continue to obtain the necessary permissions and consents, to provide Guest Information for processing," and must "address Guest requests related to their personal data rights, including access, deletion, and opt-out requests" (§§4.2, 4.7, https://sevenrooms.com/msa/). A venue-facing GDPR page pushes the same downstream to the guest, who may "Rectify or edit incomplete or incorrect personal data" and "Request erasure of your personal data (be 'forgotten')" — but only by contacting the venue, since SevenRooms is a processor (https://www.sevenrooms.com/gdpr-policy/ahNzfnNldmVucm9vbXMtc2VjdXJlchwLEg9uaWdodGxvb3BfVmVudWUYgIC4-uevwwoM).

***5e. Marketing copy is unambiguously maximalist, not restrained.*** "over 100 data points per guest" (https://sevenrooms.com/platform/crm/); "Automatically capture and unify guest data across every booking, visit and order" (https://sevenrooms.com/); "Bring your guests into the inner circle" (https://sevenrooms.com/membership-clubs/). There is no counter-message about limits. The one privacy-adjacent campaign is about *ownership*, not restraint — "Restaurants continue to solely own their first-party guest data. That hasn't changed" / "There is no transfer of ownership or sharing of this data with DoorDash—it remains with the restaurant" / "Guest data collected through your first-party channels does not flow back to DoorDash to power its marketplace" (https://sevenrooms.com/blog/guest-data-sevenrooms/). That reassures the *operator*, not the guest.

***5f. Published journalism raising privacy concerns.*** Fortune's 2016 profile is the sharpest and remains the most-cited critique. Verbatim:

- What staff see: "a customer's photo, as well as his or her zip code, birthday, allergy information, previous food and drink orders, and spending"
- Behavioral notes: the profile "could also include any notes of how you treated (or mistreated) the staff"
- Cross-venue propagation: "Your profile can be shared across different nightclub and restaurant properties owned by the same company"
- Founder Joel Montaniel's defense: "Even if it's someone's very first day working at that venue, they can treat the customer like gold" and "The idea is that you're willing to do that because it means a better experience"
- **Opt-out burden placed on the guest:** "if you don't want any of this data tracked? Montaniel says you could personally call the venue to say you don't want a profile; the onus is on you, the customer."
- Provenance history: SevenRooms previously automated collection from LinkedIn and Facebook but "lost the ability to automate that data" when those platforms restricted their APIs; now "all other data is entered manually by staff."

(https://fortune.com/2016/09/29/sevenrooms-nightclub-restaurant/)

Adjacent industry criticism of the guest-notes practice generally (not SevenRooms-specific, and the source page could not be fetched in full — treat as **UNVERIFIED**): commentary that staff record subjective judgments like "Guest is difficult" and that these surface on a Subject Access Request.

***5g. The one genuine restraint primitives in the product.*** Two, both structural rather than editorial: the profile-level boolean **`is_contact_private`** and the separate **`private_notes`** field alongside public `notes` (https://raw.githubusercontent.com/uptilab2/tap-sevenrooms/master/tap_sevenrooms/schemas/clients.json). Neither is documented publicly — **who can see `private_notes`, and what `is_contact_private` actually gates, is UNVERIFIED** (Help Center gated, HTTP 403).

***Implication for an arrival brief at a private members club.*** SevenRooms' posture is: capture maximally, standardize afterward with AI, and let the contract assign the risk to the venue. The note field is an unbounded, unaudited, non-enumerated free-text box; behavioral judgments demonstrably land in it; profiles propagate across sibling properties in a group; and guest opt-out is a phone call to the venue. A product that (a) types its notes, (b) enforces decay/expiry on behavioral observations, (c) makes visibility scope explicit per note, and (d) ships actual write-time guidance on what not to record, is differentiating against a market leader that publishes none of those.

---

**Access limitations encountered (for the record)**
- `help.sevenrooms.com/hc/en-us` — HTTP 403, Help Center is login-gated.
- `api-docs.sevenrooms.com` — gated: "Effective February 26, we have moved to individually provisioned accounts for access to our API documentation."
- `g2.com/products/sevenrooms/reviews` — HTTP 403.
- `go.sevenrooms.com/gdpr-info-and-faq.html` — 302 redirect to homepage; content retired.
- A `go.sevenrooms.com`-hosted PDF retrieved during this audit turned out to be a **ResyOS User Guide**, not SevenRooms material; it was discarded and none of its field names are reported here.


### Resy (ResyOS)

> **Status note (as of 2026-09-03):** Resy and Tock are now the *same company*. American Express acquired Resy (2019) and Tock from Squarespace (closed 2024-10-15). Resy's own marketing footer now reads "Log in to Resy OS  Log in to Tock Dashboard" and links "Resy Privacy Policy / Tock Privacy Policy / Resy Merchant Terms of Service / Tock Merchant Terms of Service" side by side — <https://resy.com/join/platform-security/>. Tock's help center now routes plan questions to `hospitality@resy.com`. Treat the two as one vendor with two still-distinct data models.

#### 1. What it actually does

ResyOS is the operator-side iPad/web system behind Resy: reservations, floorplan/timeline service management, waitlist, walk-ins, ticketed events, and a persistent guest CRM called the **Guest Book** (also "guestbook"). Its distinguishing move is that the guest record is *networked* — a guest identity resolved against a global Resy account database, annotated by staff with tags and notes, shared (selectively) across a venue group, and increasingly piped into POS and marketing systems. Resy's own framing: "Guest profiles can include visit history, spend patterns, preferences, notes, tags, and special occasions, giving teams meaningful context at a glance." (<https://resy.com/join/guest-data/>) and "Guest intel — Notes, tags, visit history, and spend. Your restaurant data will always belong to you." (<https://resy.com/join/guest-data/>). The identity-resolution behavior is explicit in the 2017 user guide: "When you enter an email address, it will be checked against the Resy database so if it matches another account you will have the option of booking the reservation under that account or editing the email address." and "Within the guestbook, entering a new phone number will check the Resy database." (<https://blog.resy.com/wp-content/uploads/2017/01/ResyOS-User-Guide-2.0-1.pdf>)

#### 2. Shape of the guest profile artifact

**Real UI, transcribed from screenshots in the official ResyOS User Guide 2.0 (January 2017)** — <https://blog.resy.com/wp-content/uploads/2017/01/ResyOS-User-Guide-2.0-1.pdf> (PDF rendered to image and read directly; the figures are product screenshots, not mockup filler).

Guest profile screen, top to bottom:
- Guest photo, name, a 5-star rating row, and a red VIP chip (e.g. `PX`, `PPX`)
- A stats block labelled **`TOTAL VISITS`** with a six-cell grid: **`Reservations`**, **`Invites`**, **`No Shows`**, **`Walk-ins`**, **`Cancellations`**, **`Notifies`**. Example values read verbatim off the screenshots: "TOTAL VISITS 4 / Reservations 2 / Walk-ins 2 / Invites 0 / Cancellations 0 / No Shows 0 / Notifies 0" and for a second guest "TOTAL VISITS 66 / Reservations 66 / Walk-ins 0 / Cancellations 1 / Notifies 9"
- A **`TAGS`** row of chips with a `+` affordance
- A **`NOTES`** section with a `+` affordance, each note carrying an author-initials badge
- A **`CONTACT INFO`** block: **`Mobile Number`**, **`Email`**, **`Address`**

Guide text confirms the stats definition: "New guest stats include Total Visits (Reservations + Walk-Ins + Invites), Invites and Notifies." (same PDF)

Tabs across the profile: **`Guests`**, **`Reservation`**, **`Messages`**, **`History`**. The History tab carries guest-side feedback: "Guest added star rating and comments are accessible in each guest's reservation history." (same PDF)

**Alert bar.** A persistent icon strip flags what exists on the record: "Icons display the following items when present: Guest Notes / Vist Notes [sic] / Tags / Message / ResyPay* / Cancellation fee" and "Tapping on these icons will jump you to the relevant section of the guest profile." (same PDF)

**Tag taxonomy — partly fixed, mostly free-form.** Venues create their own tags, but Resy ships some and category is a real, semantically-loaded field. From the 2017 guide: "Tags can be visit specific or guest specific and they are shared amongst your restaurant group." / "Guest tags can have the following attributes. • Allergy: appear with a red outline. • Channel: only guests with a channeled tag will have access to reservations in that channel (an allergy tag cannot be a channel)." / "Visit tags can have an Occasion attribute." / "Tags are sorted alphabetically with allergies first." (same PDF)

The **Create Tag** modal fields, read off the screenshot: `Tag Name`, `Type` (segmented `Guest` | `Visit`), `Allergy` (toggle), `Channel` (toggle), `Save`. The tag settings list in that same screenshot shows a real venue's guest-tag vocabulary: **`Gluten`**, **`Peanuts`**, **`FO Chef`**, **`FO employee`**, **`Neighbor`**, **`Regular`**, plus an **`Add New`** tile. (same PDF)

Live tag chips on the two example profiles: **`Booth Requested`**, **`ResyPay`**, **`FO Chef`**, **`Regular`** on one; **`Peanuts`**, **`Neighbor`** on the other. (same PDF)

**Current tag doc** — <https://helpdesk.resy.com/how-to-add-guest-and-visit-tags-to-a-reservation-in-resy-os-r14ZzPXL_>:
- "Tags are shorthand and visual cues to the door team about the guest. Birthday, Nut Allergy, Regular, Friend of Chef are examples of common tags."
- "Visit Tags: Live on a particular reservation only. For example: Birthday, anniversary, graduation, etc."
- "Guest Tags: Live on a guest profile indefinitely. For example: Regular, VIP, friend of house, Nut Allergy, etc."
- **The governing categorisation, and the single most important design detail:** "Allergy, Dietary Restrictions, Dietary Preferences, and Identification tags will be shared with your Venue Group." and "Relationship and General tags will be venue specific."
- "Toggle on 'Notable Tag' if you want the tag you're creating to be highlighted on the reservation list when applied to visits and to be printed on your chit."
- "You are not able to delete or edit a tag created by Resy." — i.e. a Resy-owned system vocabulary sits beneath the venue's custom one.

So the ResyOS tag category enum in current product is effectively: **Allergy, Dietary Restrictions, Dietary Preferences, Identification, Relationship, General** — and *category determines blast radius*. Allergy/dietary/identity propagate across the group; relationship/general stay local.

**VIP is a separate axis from tags.** "VIP names are limited to four characters so they fit within the red circle which indicates VIP." and "All VIP tags are channels. If you edit the channel of a reservation, only the guests in that channel will have access to that reservation." (2017 PDF). Current flow — <https://helpdesk.resy.com/create-and-add-vip-tags-Hk2sfzryi>: VIP tags are created "Under 'Group Settings,' tap 'VIP'" with a "VIP Tag Name" field, and applied via "Tap 'Change VIP Status'. Tap the appropriate VIP tag for the guest and add a note if desired." VIP is thus a *group-level*, four-character, access-controlling label — not a free note.

**Guestbook as a reporting object** — <https://helpdesk.resy.com/guest-info-guestbook-Hk8FkHeh6>: "The Guest Info: Guestbook is your restaurant's full guestbook." with filters including "Completed Reservations >=1 shows all guests who have dined with you at least once", "The Is Marketable (Yes / No)* field is defaulted to Yes and indicates if the guest has opted-in to receiving marketing communications from your restaurant", and tag/VIP filters: "To sort for guests based on Tags, click into that field and start typing whatever tag you're interested in" / "To sort VIPs, select Yes to see only VIPs". Resy explicitly recommends exfiltrating it: "We recommend you pull this guestbook monthly and review it with marketing managers to import into CRM software."

**Auto-tagging exists.** "Auto-tagging — Automatically identify VIPs, regulars, and special-occasion guests." (<https://resy.com/join/guest-data/>). The paid tier is sold on it: "Platform 360 — Everything in Platform, plus more advanced analytics powering automated guest insights." (<https://resy.com/join/plans-pricing/>)

#### 3. What staff-facing notes actually look like

Resy models **two note objects**, and the distinction is scope-of-life, not format — <https://helpdesk.resy.com/how-to-add-visit-notes-and-guest-notes-in-resyos-BkmZfvmI_>:
- "Visit Notes: Live on a particular reservation only. Examples include Birthday, Anniversary, requested a booth if available, high-chair request, bringing a cake, going to a show after dinner, etc."
- "Guest Notes: Live on a guest profile indefinitely. Examples include regular, nut allergy, friend of house, etc."

**Sharing scope is category-driven, same as tags** (same URL):
- "Visit Notes can only be viewed at the specific venue the guest is booked at, even if you are in a venue group."
- "Food and Beverage Guest Notes will default to sharing with your venue group."
- "Hospitality or General Guest Notes are only seen within your venue."
- "For any category Guest Note you can choose whether it's shared at venue or group level."
- "Tip: For Guest Notes, you can toggle on 'Share With Group' if you are in a venue group and want all your venues to see the note on the guest's profile."

So Resy's note categories are at minimum **Food and Beverage / Hospitality / General**, with F&B defaulting *open* to the group and hospitality/general defaulting *closed*.

**Attribution is mandatory and first-class.** "Beneath 'Added by' select your name or initials. If your name or initials aren't on the list, scroll down to the bottom and tap 'Add New Name'." (same URL). And from the 2017 guide: "Notes are tracked using the user's name and date/time added. This information can be found by single tapping on the user's name to the right of the note." / "When a note is edited, the original creator and date/time created will be listed along with the user name and date/time of the last edit." (<https://blog.resy.com/wp-content/uploads/2017/01/ResyOS-User-Guide-2.0-1.pdf>)

**Priority/pinning and surfacing:** "For high priority Guest and Visit Notes, you can click 'Pin' to pin the note. Pinned notes appear first if the guest has a list of notes." and a floorplan toggle "Show reservation Visit Notes on Reservation list". (<https://helpdesk.resy.com/how-to-add-visit-notes-and-guest-notes-in-resyos-BkmZfvmI_>)

**REAL example note text**, transcribed verbatim from the guest-profile screenshots in the official user guide (<https://blog.resy.com/wp-content/uploads/2017/01/ResyOS-User-Guide-2.0-1.pdf>):

| Note text (verbatim) | Attribution shown |
|---|---|
| "Can't get enough bourbon and BBQ.  Birthday: 10/29/1990" | — |
| "Please make 10/27 reservation very special!" | badge `DC` |
| "Owner of a vegan bakery in LA. Vegan." | — |
| "Sent vegan cupcakes after last visit." | "Added by LG on 10/27/16 at 1:21 PM / Edited by LG on 10/27/16 at 1:22 PM" |

**Observed voice and length.** One line. Sentence fragments or a single imperative. Telegraphic, present-tense, second-hand-readable in under two seconds at a host stand. Three recognisable genres: (a) **preference/consumption** — "Can't get enough bourbon and BBQ."; (b) **identity/standing** — "Owner of a vegan bakery in LA. Vegan."; (c) **service memory / what we already did** — "Sent vegan cupcakes after last visit." Category (c) is notable: the note records the *house's* prior action, not the guest's trait, so the next shift can avoid repeating a gesture. Typical length in these real samples is roughly 4–10 words; the longest is 9. Notes stack chronologically ("when you add a new Guest Note or Visit Note it consistently appears underneath an existing Guest Note or Visit Note" — same PDF), so a long-tenured guest accretes a *list* of one-liners rather than a paragraph.

Also worth knowing for an arrival-brief product: guest-supplied text lands in the same channel. A logged 2017 bug reads "Special Requests and Occasions input on the Resy app appeared as Guest Notes within ResyOS." (same PDF) — i.e. guest-authored and staff-authored text can collide in one field unless deliberately separated.

#### 4. Pricing

**Live published pricing** — <https://resy.com/join/plans-pricing/> (fetched 2026-09-03). One page now sells both stacks:

| Tier | Price | Prepayment fee | Positioning (verbatim) |
|---|---|---|---|
| **Platform** (Resy) | "$289 /month" | — | "Reservation and table management for businesses who want to take a simple approach, plus POS integrations." |
| **Essential** (Tock) | "$289 /month" | "3% fee on prepayments" | "Essential reservation and table management, plus advanced customization and robust event ticketing tools." |
| **Platform 360** (Resy) | "$459 /month" | — | "Everything in Platform, plus more advanced analytics powering automated guest insights." |
| **Premium** (Tock) | "$459 /month" | "2% fee on prepayments" | "Everything in Essential, plus lower prepayment fees, POS integrations, premium support, and robust experience tools." |

Footnote: "Standard payment processing fees will apply." (same URL)

**No cover fees, stated explicitly:** "Does Resy have cover fees or any other hidden fees? No. Resy pricing is transparent with no per-cover fees. We do not charge any fees on a per reservation basis." and "Each month, you pay one monthly fee, providing stability and predictability that can help your business thrive." (same URL)

Guest-data features are tier-gated. "Advanced analytics dashboard — Personalize hospitality and make more informed decisions with a comprehensive view of demand, guest insights, and revenue." and "Exclusive booking groups — Give your best guests the ability to book first." appear in the plan-comparison matrix (same URL). Chargeback coverage is quantified: "Tock offers Chargeback Coverage on contested chargebacks—up to an annual, aggregate coverage amount of $25,000—per business." (same URL)

*Price trajectory:* the same four tiers were cheaper five months earlier — see the Tock section below for the archived April 2026 figures ($249/$269/$399/$399). Both stacks rose to $289/$459.

#### 5. The attentive-vs-creepy line

**a) There is no published rule about what staff may not write.** I searched the Resy Merchant Terms of Service, the guest-notes help article, the tags help article, the VIP article and the 2017 user guide. None contains any content restriction, prohibited-topic list, sensitivity warning, or drafting guidance for note text. **UNVERIFIED / apparently absent: Resy publishes no operator guidance on what NOT to write in a guest note.** The nearest thing is a generic warranty that the restaurant will not use the service for acts "reasonably considered fraudulent, threatening, malicious, defamatory, or otherwise objectionable" (<https://cloud.send.resy.com/terms>) — aimed at conduct, not at note content.

**b) The contract pushes all of it onto the operator.** Resy Merchant Terms of Service §4, "END USER PRIVACY & MARKETING COMPLIANCE" — <https://cloud.send.resy.com/terms>:

> "With respect to end user data Restaurant obtains through the Resy Services, Restaurant will comply with Resy's privacy policy and all applicable privacy laws and regulations, including those applying to personal information that Restaurant may have access to by virtue of the Resy Services or that Resy may supply to Restaurant at the direction of the end user (e.g., phone number, email, allergy information, etc.)."

And, defining the guestbook as a legal object the operator owns the risk on:

> "Restaurant is fully responsible for actions taken in connection with the use and maintenance of the content of any guest index or similar catalog (collectively and individually, 'Guestbook'), in any format, including but not limited to CSV file format, once Resy provides a Guestbook to Restaurant or when Restaurant downloads a Guestbook from the Resy Services." (<https://cloud.send.resy.com/terms>)

**c) The sharpest finding — Resy ingests staff-written notes back into its own controller-side profile.** Resy Global Privacy Policy, Effective Date April 15, 2025, "Other Sources of Information" — <https://resy.com/privacy>:

> "information provided about you from restaurants who partner with us, including notes, tags, and other metadata about your dining habits and experiences."

And, on onboarding a new venue:

> "when a new restaurant joins us, if you have been a prior guest with that restaurant, we may collect information that restaurant has about you and import it into the restaurant's guestbook on our platform" (<https://resy.com/privacy>)

That is the creepy-line crux for a members-club brief: a note a captain types about a member is not a private house record. It flows to the platform, and Resy states it "may combine this other information with the online information we have collected about you" and "We also may obtain information about other American Express products and services you use." (<https://resy.com/privacy>)

**d) Restaurant is the controller; guest must chase each venue.** "When we disclose your information to a restaurant for the purposes of facilitating your dining request, the restaurant is collecting and processing your personal information as a controller and your personal information is subject to the restaurant's privacy policy and practices." — and the payload is enumerated: "we will provide the restaurant certain categories of your information including: your name, dining profile, date and time of visit, your contact details, dining preferences, party size and any other information you provide at the time of your reservation or feedback." (<https://resy.com/privacy>)

Group-wide propagation is blessed in the policy text: "We or the restaurant may share your information with their affiliates (e.g., other restaurants in the same restaurant group) to enhance the hospitality such restaurant group provides you when you dine with them to provide you with customized service and to improve the restaurant's table and shift planning." (<https://resy.com/privacy>)

**e) Sensitive-category data is consent-gated in policy.** "Please note that – with your consent – we may also collect special categories of personal information or sensitive personal information, such as dietary information, in some instances. We'll use this information only as permitted or required by law, or where provided by you with your explicit consent." (<https://resy.com/privacy>). Note the asymmetry: this covers *guest-supplied* dietary data. A staff-typed allergy tag is not obviously covered by that consent, yet ResyOS auto-propagates Allergy/Dietary tags group-wide by design (§2 above).

**f) Amex ownership brings financial-privacy law into a restaurant CRM.** "RESY NETWORK, INC. ... is committed to safeguarding your privacy. Resy is owned by American Express." and, for US residents: "you are provided with the following rights under the Gramm-Leach-Bliley Act, a federal financial privacy law", including "Opting out of sharing with affiliates: If you do not want your personal information/personal data shared with our affiliates, such as the American Express Family of Companies, who may use such information for direct marketing purposes..." (<https://resy.com/privacy>). Resy also lists "companies within the American Express Family of Companies" among sharing recipients (same URL).

**g) Guest data reaches the table via POS.** "Resy's partnership with Toast enables you to know your guests better than ever with access to dining history, preferences, and more—right at the table where relationships are made." (<https://resy.com/join/guest-data/>)

**h) Security posture (the counterweight Resy does publish).** "We use administrative, organizational, technical, and physical security measures to protect the confidentiality, integrity, and availability of personal information. This includes technological safeguards and appropriate access controls to data and facilities. We also take reasonable steps to securely destroy or de-identify personal information when we no longer need it." (<https://resy.com/join/platform-security/>). Note this is about *security*, not about restraint in what gets recorded.

---

### Tock

#### 1. What it actually does

Tock is a reservation, deposit/prepayment, ticketed-experience and event platform, strongest in wineries, tasting menus and prepaid formats, with table/service management and a guest CRM. Its differentiator versus classic reservation books is that money and structured guest questionnaires are native: prepayments and deposits carry a percentage fee, and **pre-visit questions** collect guest-declared dietary/occasion/mobility data that auto-materialises as tags and notes on the reservation. Product framing from its own help center: "Guest profiles in Tock provide valuable information about guests. From visit history to past spend data, guest profiles allow for the recognition of repeat guests and their preferences." (<https://tock.zendesk.com/hc/en-us/articles/36511532364436-Understanding-Guest-Profiles-in-Tock>)

#### 2. Shape of the guest profile artifact

Tock is the more legible of the two because it publishes a **complete public API schema**. All field names below are verbatim from <https://api.exploretock.com/docs/latest/guest_profile.html>.

**`GuestProfile`** (identity + platform-level, guest-declared):
`id`, `patron`, `nickName` ("Nickname given by the business"), `company` ("Guest's employer if known"), `jobTitle` ("Job title at company if known"), `spouseName` ("Spouse's name if known"), `spouse`, `address`, `phone[]`, `day[]`, `link[]`, `patronProfileDietaryRestriction[]`, `patronProfileHospitalityPreference[]`, `patronProfileAversions`, `businessGroupId`, `importedProfile`, `businessGuestProfile[]`, `businessGroupGuestProfile`, `tag[]`, `attribute[]`, `canEdit`, `isArchived`, `updatedBy`, `loyaltyProgramCardNumber`, `loyaltyProgramMembershipLevel`, `loyaltyProgramAccountId`, `optInSource`, `optIn`, `versionId`, `createdAtTimestamp`, `updatedAtTimestamp`, `isTockVerified`, `dateOptedIn`.

The three guest-declared preference fields are explicitly *guest-authored and global*:
- `patronProfileDietaryRestriction` — "Notes that the guest has given to all businesses indicating dietary restrictions"
- `patronProfileHospitalityPreference` — "Notes the guest has given to all businesses indicating preferences"
- `patronProfileAversions` — "Notes the guest has given to all businesses indicating aversions"

**Two-level venue annotation.** `BusinessGuestProfile`: `note` (AuditedNote[]) — "Notes attached to the guest for just this business"; `tag[]` — "Tags attached to this guest for just this business"; `spend`. `BusinessGroupGuestProfile`: `note` — "Notes attached to this guest for the business group shared with all businesses"; `tag[]` — "Tags attached to this guest for the business group shared with all businesses"; `spend`. So venue-private vs group-shared is a *structural* split in the data model, not a per-note toggle as in Resy.

**`AuditedNote`**: `note` ("Text of the note"), `lastUpdatedBy` ("Tock account that last updated note"), `lastUpdatedAtTimestampMs`, `previousVersionId`, `noteType` ("Type of note this represents"). Authorship and version history are baked into the type — the name *AuditedNote* is itself the design statement.

**Enumerations (fixed vocabularies) — the only fixed vocabularies in the model:**
- `NoteType`: **GENERAL, DIETARY**
- `DayType`: **BIRTHDAY, OTHER_BIRTHDAY, ANNIVERSARY, PARTNER_BIRTHDAY**
- `LinkType`: **IMAGE, TWITTER, FACEBOOK, LINKEDIN, INSTAGRAM, IMAGE_BACKUP**
- `OptInSource`: **PURCHASE, WAITLIST, NEWSLETTER, IMPORTED, NO_OPT_IN, OPTED_OUT**
- `PhoneType`: MOBILE, HOME, WORK, PAGER, FAX, HOTEL, OTHER

`link` is described as "External links to public information" — a first-class, typed field for pinning a guest's Twitter/Facebook/LinkedIn/Instagram and a photo to their dossier. This is the most explicitly surveillance-shaped field either vendor ships.

**Spend is a typed money object, not a vibe.** `BusinessSpend`: `totalSpendCents` ("Total amount in cents the guest has spent at the business"), `averageSpendPerVisitCents` ("Average amount in cents per visit at the business"), `spendInLastYearCents` ("Total amount in cents in the last year (12 months)"). `BusinessGroupSpend` adds `totalSpendCents` "spent at any business in the business group".

**Reservation-level annotation** — <https://api.exploretock.com/docs/latest/reservation.html>:
- `note` — "A note that has been attached to this reservation or guest through actions in the Tock Dashboard. Imported reservations may also have notes."
- Reservation-level `NoteType` enum: **BOOKING_GENERAL_NOTE** ("A note about the reservation that is not related to any dietary restrictions of the party"), **BOOKING_DIETARY_NOTE** ("A note about the reservation that is related to dietary restrictions of the party"), **GUEST_PROVIDED_NOTE** ("A note provided by the guest to the business after checkout")
- `visitTag[]` — "Any tags applied to the reservation in the Tock Dashboard specific to this reservation and not to the guest as a whole"
- `question[]` — "Any questions answered by the party about this reservation prior to the service date"; `visitFeedback[]` — "The results of answering any questions about the reservation after the party has visited"

Note the important separation Tock makes and Resy does not: **guest-authored text has its own type** (`GUEST_PROVIDED_NOTE`), so it never masquerades as a staff observation.

**UI walkthrough** — <https://tock.zendesk.com/hc/en-us/articles/36511532364436-Understanding-Guest-Profiles-in-Tock>. Three entry points: "From any page in the Tock dashboard, click the search icon in the top-right corner of the screen" then "Search for a guest using their name, email address, or phone number"; "From the Guests tab"; or from a reservation — "click the diagonal arrows to the right of the guest's name to expand the reservation details" then "Click the Profile tab". Profile sections, verbatim:
- **Basic Information**: "Guest name", "Contact details (email and phone number)", "Notes and tags", "Upcoming reservations"
- **Visit History**: "Total number of visits", "Dates of past visits", "Reservation details for each visit (party size, time, experience booked, visit tags and notes, answers to pre-visit questions, and payment information)", "No-shows and cancellations", "Past Notify requests"
- **Guest Activity (Business Group)**: "Total visits across all locations in a group", "Which locations the guest has visited", "Frequency of visits at each location"
- **Advanced: Guest Spend Data**: "Total Spend", "Average Spend Per Visit", "Spend Past Year", "Linked POS checks: Access to detailed check information from the guest's previous visits"

**Tags are entirely free-form.** <https://tock.zendesk.com/hc/en-us/articles/360034799971-Configuring-Guest-and-Visit-Tags>: "Tags prominently display visit and guest information during service. A guest tag is associated with the guest and a visit tag is associated with a specific reservation." Creation is: "Click the blue Add tag button in the top-right. / Enter a name. / Choose guest or visit tag. / Assign an optional icon." with "Note: Tags that are important can be given an icon. These icons will populate more prominently throughout Timeline and Service." There is **no preset tag vocabulary and no allergy/dietary tag category** — unlike ResyOS, Tock does not classify tags, so nothing propagates or restricts by category. (Interesting signal: this article carries a public vote score of −26.)

**Guest-declared auto-tagging is the notable pattern** — <https://tock.zendesk.com/hc/en-us/articles/360030879572-Setting-Up-Pre-visit-Questions>: "Pre-visit questions can be used to gather information about a guest's upcoming visit, such as dietary restrictions, table preferences, and special occasions. Visit tags and notes will automatically appear on the reservation based on the question type and guest responses." Four question types, each with a defined destination: "Free-form text box: the guest may include a longer response that will automatically appear as a visit note on the reservation." / "Single line text box: ... short, one line response that will automatically appear as a visit note" / "Multiple select: the guest may select multiple options from a list that automatically appear as visit tags on the reservation." / "Single select: ... automatically appears as a visit tag". The shipped library is three templates: "choose Create from question library to start with one of three pre-built question templates: **Dietary Restrictions, Occasion, and Mobility**. Use as is, or edit to fit the restaurant's needs."

**Segmentation** — <https://tock.zendesk.com/hc/en-us/articles/360039948571-Creating-Guest-Groups>: "Choose Smart to create a list based on tags, opt-in status, or membership status and/or contact type." Guests can be filtered and exported: "Click the Filter icon to apply any desired filters (VIP, dietary restrictions, etc.). / Click Download." (<https://tock.zendesk.com/hc/en-us/articles/36511532364436-Understanding-Guest-Profiles-in-Tock>)

**Staff-side display control** — <https://tock.zendesk.com/hc/en-us/articles/360034424972-Customizable-User-Settings>: "**Display notes**: Show or hide guest and visit notes on guest cards." plus "Always show Service Tags: Show or hide icon service tags within the reservation panel" and "View as read-only (Observation mode): By enabling Observation mode, the Service screen is switched into read-only mode so no changes to parties or tables can be made." Settings "can be saved per user, per device". This is a per-user visibility switch on the dossier — directly relevant to an arrival-brief design, though it is a convenience toggle, not a permission.

#### 3. What staff-facing notes look like

Tock's help center is markedly thinner on note practice than Resy's, and **I could not find a single verbatim example of real staff note text in Tock's own documentation, blog, or case studies. UNVERIFIED: Tock publishes no sample guest-note text.** What is documented is structure, not prose:

- Notes are typed at both levels — `NoteType` GENERAL / DIETARY on the profile, and BOOKING_GENERAL_NOTE / BOOKING_DIETARY_NOTE / GUEST_PROVIDED_NOTE on the reservation (<https://api.exploretock.com/docs/latest/reservation.html>). Dietary content is therefore *separable* from general commentary at the schema level — a materially better privacy primitive than a single free-text blob.
- Every note is an `AuditedNote` with `lastUpdatedBy`, `lastUpdatedAtTimestampMs` and `previousVersionId` (<https://api.exploretock.com/docs/latest/guest_profile.html>) — full authorship and revision lineage.
- Notes render on guest cards during service and can be suppressed per user ("Display notes: Show or hide guest and visit notes on guest cards", <https://tock.zendesk.com/hc/en-us/articles/360034424972-Customizable-User-Settings>).
- Long guest-authored answers land as visit notes verbatim ("the guest may include a longer response that will automatically appear as a visit note on the reservation", <https://tock.zendesk.com/hc/en-us/articles/360030879572-Setting-Up-Pre-visit-Questions>), so in practice a Tock visit note is often *the guest's own sentence*, not a staffer's paraphrase — a meaningfully different voice from Resy's clipped house shorthand.
- The only usage guidance offered is aspirational, not editorial: "Review notes from previous visits to anticipate needs." / "Check if the current visit is a special occasion." / "Reference past preferences to enhance the current experience." and, under Understand Guest Value, "Identify high-value guests who contribute significantly to revenue." / "Understand spending patterns to provide appropriate service levels." (<https://tock.zendesk.com/hc/en-us/articles/36511532364436-Understanding-Guest-Profiles-in-Tock>). That last line — tiering service by spend — is the closest Tock comes to stating a philosophy, and it points the opposite way from restraint.

#### 4. Pricing

Tock's live pricing page (<https://www.exploretock.com/join/pricing/>) is Cloudflare-protected against direct fetching. The **archived capture of 2026-04-06** reads verbatim (<http://web.archive.org/web/20260406164746/https://www.exploretock.com/join/pricing/>) — and already showed the merged four-tier lineup:

| Tier | Badge | Price | Prepayment fee | Description (verbatim) |
|---|---|---|---|---|
| **Essential** | "Powered by Tock" | "$269 /month *" | "3% fee on prepayments" | "Get up and running with essential reservation and table management tools." |
| **Premium** | "Powered by Tock" | "$399 /month *" | "2% fee on prepayments" | "All the essentials plus lower prepayment fees, POS integrations, premium support, and more." |
| **Platform** | "Powered by Resy" | "$249 /month *" | — | "The tools to manage reservations, reduce no-shows, and keep your restaurant running smoothly." |
| **Platform 360** | "Powered by Resy" | "$399 /month *" | — | "Everything in Platform plus more powerful reservations tools, event management, and guest insights." |

Header: "Choose the plan that's right for you — Flexible features, no hidden fees, and high touch support." Footnote: "* Standard payment processing fees will apply." (same archived URL)

**These four tiers have since risen to $289 / $459 across the board** — see the Resy pricing table above, from <https://resy.com/join/plans-pricing/> fetched 2026-09-03. That is roughly a 7–16% increase in five months, and the two brands' tiers are now priced at exact parity ($289 entry, $459 upper), which is the clearest commercial evidence of the merger.

**Commission structure:** Tock's model is subscription + a percentage on *prepaid* money only, not per cover — 3% (Essential) / 2% (Premium) "fee on prepayments", plus card processing. Card rates are held at a separate URL referenced in the contract: "The credit card fees listed at https://www.exploretock.com/rates (or a successor url) (the 'Credit Card Fees') shall apply to all monies received for deposits, prepaid reservations, add-ons, and all other payments processed through the Services." (<https://www.exploretock.com/merchant-terms>). **UNVERIFIED: exact card-processing percentages at /rates — not fetched (Cloudflare).**

Guest-data capability is explicitly plan-gated, and the gate is now administered by Resy: "Note: Guest spend data is not available on all plans. Please contact hospitality@resy.com to learn more about plan offerings." (<https://tock.zendesk.com/hc/en-us/articles/36511532364436-Understanding-Guest-Profiles-in-Tock>) and, for pre-visit questions, "Note: This feature is not available on all plans. Please contact hospitality@resy.com to learn more about plan offerings." (<https://tock.zendesk.com/hc/en-us/articles/360030879572-Setting-Up-Pre-visit-Questions>). Spend visibility is described as "For Premium plan users with POS integration" (first URL).

#### 5. The attentive-vs-creepy line

**a) Tock draws the cleanest legal line of the two — and it is a disclaimer, not a restraint.** Tock's Privacy Policy splits the world into Tock-controlled and Merchant-controlled data — <https://www.exploretock.com/privacy>:

> "'Merchant Controlled PI' means personal information for which a Merchant determines the purposes and means of processing. For Merchant Controlled PI, Tock acts as a data processor, service provider or similar term under applicable law. Merchant Controlled PI includes Guest Booking Information (as defined below) and any data or notes entered by a Merchant into the Services about a Guest or their partner or other dining companions, Merchant personnel or other individuals. We use Merchant Controlled PI at the direction of our Merchants, and our Merchants are responsible for ensuring that their collection and processing of Merchant Controlled PI complies with applicable law and their respective privacy policy."

Three things matter here. (i) **Staff notes are named explicitly** as Merchant Controlled PI. (ii) The scope reaches **"their partner or other dining companions"** — Tock's own lawyers anticipate that operators write about people who never booked and never consented. (iii) Responsibility is assigned wholesale to the venue. Tock adds: "To learn about a Merchant's data practices with respect to Merchant Controlled PI, please visit the applicable Merchant's privacy policy." (same URL)

This is a materially *better* posture than Resy's on one axis — Tock positions itself as a processor and does not claim to harvest merchant notes into its own controller-side profile, whereas Resy's policy expressly does ("including notes, tags, and other metadata about your dining habits and experiences", <https://resy.com/privacy>).

**b) The same split appears in the merchant contract.** Tock Merchant Terms of Service — <https://www.exploretock.com/merchant-terms>:

> "'Merchant Data' means any information about Merchant's Guests or prospective Guests or their partner or other dining companions, Merchant personnel or other individuals which: (A) Merchant uploads to or collects through the Services; or (B) is Tock Data ... Tock acknowledges and agrees that as between Tock and Merchant, Merchant shall be the sole and exclusive owner of all right, title and interest in and to the Merchant Data."

The venue owns the dossier outright and indemnifies Tock for it: the indemnity covers "any Merchant Content or Merchant Data entered into the Services by or on behalf of Merchant or Guests" (same URL). A Data Processing Addendum is incorporated by reference: "The parties agree to comply with the Data Processing Addendum posted to https://www.exploretock.com/merchant-dpa (the 'DPA')." (same URL). **UNVERIFIED: contents of the DPA — not fetched.**

**c) Sensitive-category data is acknowledged as such.** "Guest Diner Profile Information includes a photograph, birthday or anniversary details for the Guest and/or their partner and the Guest's hospitality preferences or dietary restrictions, some of which may be considered special categories of personal information or sensistive personal information." [typo "sensistive" is in the original] (<https://www.exploretock.com/privacy>). Note again the *partner* reach: a guest's profile carries their partner's birthday.

**d) The deletion asymmetry — the single most operationally important line for a members club.** <https://www.exploretock.com/privacy>:

> "You will need to reach out to any Merchants with whom you have made a Booking in order to request they delete any Merchant Controlled PI they hold about you."

Tock will not delete staff notes on a guest's behalf. Correspondingly, the burden lands on the operator's console: "If you are a Merchant, you can access, correct, or delete Merchant Controlled PI of your Guests directly in your Account." (same URL). A guest who wants a note about them erased must know it exists, know which venue wrote it, and ask that venue.

**e) Amex affiliate sharing, GDPR/UK machinery, retention.** "Tock is owned by American Express." and "We share personal information with our affiliates within the American Express family of companies." (<https://www.exploretock.com/privacy>). GDPR transfer mechanisms are named — "Standard data protection clauses. We transfer, in accordance with Article 46 of the GDPR, personal information to recipients with whom we have entered into the European Commission approved Standard Contractual Clauses" — with UK supervisory-authority complaint rights and contact at `privacy@tockhq.com`. Retention: "We retain personal information about you for as long as your Account is active or for as long as needed to provide you or our Merchants with the Services." with the caveat "while providing the Services, we collect and maintain aggregated and anonymized information which we may retain indefinitely." (all same URL)

**f) No content restrictions on notes, and no operator guidance. UNVERIFIED / apparently absent:** neither the Tock help center, the merchant terms, nor the API docs state any prohibited note content, sensitivity warning, or drafting guidance. The merchant terms restrict *conduct and legality* — "Merchant's use of the Services and listing and sale of Offerings will comply with all applicable laws and regulations, including without limitation laws and regulations related to privacy, intellectual property, consumer protection, obscenity or defamation" (<https://www.exploretock.com/merchant-terms>) — and require the merchant to post its own policy: "each website which directs to a page containing or utilizing the Services ... will contain a conspicuous privacy policy that discloses Merchant's privacy and data practices in compliance with applicable law." (same URL). Nothing addresses what a captain types.

**g) The dossier is portable across vendors.** Tock's onboarding doc instructs new venues to export their guest and reservation history out of OpenTable, Yelp and others and hand it over: "Prior to your Go Live date, pull or request past and future reservations and guest data from your current booking platform" and "Tock's Imports Team will transfer your data into your new Tock dashboard so it will be ready for your launch." (<https://tock.zendesk.com/hc/en-us/articles/34628828437140-Data-Transfer-Instructions>). Guest dossiers therefore survive platform switches — a note written years ago on another system can arrive in the new one.

**h) Corporate chain of custody.** Squarespace acquired Tock, then sold it: "American Express (NYSE: AXP) today announced that it has completed the previously announced acquisition of Tock, a reservation, table, and event management technology provider, from Squarespace (NYSE: SQSP)", dated October 15, 2024 (<https://www.squarespace.com/press-releases/2024/10/15/american-express-completes-acquisition-of-tock>); widely reported at $400M cash. Amex/Resy's own restaurant-facing FAQ, "As of June 21, 2024", promised only: "We will seek to enhance and expand the technology, tools, and value proposition of both brands with the intention of creating a world-class digital experience platform" and "Nothing changes for Tock restaurants today. Tock and Resy remain separate businesses and will continue to operate independently until the transaction closes." (<https://helpdesk.resy.com/en_us/to-enhance-dining-platform-american-express-enters-agreement-to-acquire-tock-from-squarespace-also-agrees-to-acquire-rooam-rkruQxXLC>). **Notably, that FAQ says nothing whatsoever about whether Tock and Resy guest data would be combined — the question is not asked or answered.** As of Sept 2026 the platforms share a pricing page, a support email and a login footer, but I found **no published statement on guestbook data merging. UNVERIFIED.**

---

### Cross-cutting: what the trade press says about the line

The best on-point trade-press treatment is Restaurant Business's advice column, framed by an operator's own question — <https://www.restaurantbusinessonline.com/advice-guy/googling-your-guests-accommodating-or-creepy> (Jonathan Deutsch, Ph.D., Jan. 11, 2018). The questioner writes: "We Google most of our guests if they have a reservation ... Where is the line between good service and creepy?"

Deutsch names the structural change: "Managers can now conduct instantaneous research before a guest arrives, or even after their arrival, via the web, and multiple employees from multiple operations can share and update guest notes across a company." He offers a concrete example of the wrong side of the line — a server volunteering "I was just looking at your vacation photos from Cancun" — against the right side, an unattributed recommendation. Industry practitioner Ben Fileccia is quoted advising concealment of method: "I don't think it [needs to be] obvious that you have done research on the guests." Deutsch's own recommendation is a training-and-ritual one: "include protecting guest privacy as well as using guest notes to improve hospitality and increase sales in your training programs," and "Make it a practice during preservice meetings to discuss strategies that might be successful with a particular guest."

That is the operative norm in the trade: **the line is drawn at disclosure of method, not at collection.** Neither Resy nor Tock encodes it.

**Adjacent, and the live controversy — but note it is OpenTable, not Resy/Tock.** Fox News reported on AI-generated diner tags spotted by a Michelin-starred restaurant host posting as "Eating Out Austin" — <https://www.foxnews.com/tech/how-restaurant-reservation-platform-opentable-tracks-customer-dining-habits>. The tags reportedly summarise "drink patterns, spending levels, review habits and last-minute cancellations" drawn from reservation and POS data across visits to different restaurants. The host's accuracy critique is the sharpest design warning available: "A single business dinner can mark someone as a high spender. Eating with friends who order cocktails can make a person look like a cocktail lover." OpenTable's response frames it as hospitality — "Guest insights are the engine of personalization, allowing restaurants to optimize their service and deliver the kind of thoughtful hospitality that both benefits the business and offers a special experience for the diner" — and points to a guest-side control, an account setting to toggle off "Allow OpenTable to use Point of Sale information."

**UNVERIFIED:** I found **no journalism specifically criticising Resy or Tock guest dossiers or their data sharing**, and no reporting on what Amex does with Resy/Tock guestbook contents beyond the companies' own statements. Resy does ship the analogous automated-inference feature — "Auto-tagging — Automatically identify VIPs, regulars, and special-occasion guests." (<https://resy.com/join/guest-data/>) and "automated guest insights" as the Platform 360 upsell (<https://resy.com/join/plans-pricing/>) — but I could not confirm whether it uses cross-restaurant POS data the way the OpenTable feature is reported to.

---

### Implications for an arrival brief at a private members club

1. **Category-scoped sharing is the proven primitive, and Resy already ships it.** "Allergy, Dietary Restrictions, Dietary Preferences, and Identification tags will be shared with your Venue Group" vs "Relationship and General tags will be venue specific" (<https://helpdesk.resy.com/how-to-add-guest-and-visit-tags-to-a-reservation-in-resy-os-r14ZzPXL_>), mirrored in notes by "Food and Beverage Guest Notes will default to sharing with your venue group" vs "Hospitality or General Guest Notes are only seen within your venue" (<https://helpdesk.resy.com/how-to-add-visit-notes-and-guest-notes-in-resyos-BkmZfvmI_>). Safety-critical facts travel; social commentary stays put. Copy this.
2. **Separate guest-authored from staff-authored text at the type level.** Tock does (`GUEST_PROVIDED_NOTE`, <https://api.exploretock.com/docs/latest/reservation.html>); Resy historically did not, and shipped a bug where "Special Requests and Occasions input on the Resy app appeared as Guest Notes within ResyOS" (<https://blog.resy.com/wp-content/uploads/2017/01/ResyOS-User-Guide-2.0-1.pdf>).
3. **Prefer guest-declared to staff-inferred.** Tock's pre-visit question library — "Dietary Restrictions, Occasion, and Mobility" auto-materialising into tags and notes (<https://tock.zendesk.com/hc/en-us/articles/360030879572-Setting-Up-Pre-visit-Questions>) — gets the same operational payload with consent attached.
4. **Mandatory attribution and revision history are table stakes, not differentiators.** Both ship it: Resy's "Added by" picker and edit trail, Tock's `AuditedNote`. A note nobody signed is a note nobody owns.
5. **The genuine white space is editorial governance.** Neither vendor publishes a single word on what not to write, no prohibited-content list, no review or expiry of notes, and no guest-facing visibility. Both contractually push the whole question onto the operator ("Restaurant is fully responsible ... 'Guestbook'", <https://cloud.send.resy.com/terms>; "our Merchants are responsible for ensuring that their collection and processing ... complies with applicable law", <https://www.exploretock.com/privacy>). For a members club — where the "guest" is a member with a durable relationship and a plausible expectation of being able to ask what the house records about them — that gap is the product.
6. **Beware spend-tiered service as a default.** Tock states it plainly: "Understand spending patterns to provide appropriate service levels." (<https://tock.zendesk.com/hc/en-us/articles/36511532364436-Understanding-Guest-Profiles-in-Tock>). And beware inferred tags: "A single business dinner can mark someone as a high spender." (<https://www.foxnews.com/tech/how-restaurant-reservation-platform-opentable-tracks-customer-dining-habits>)
7. **Notes about non-members are a live exposure.** Both vendors' legal text reaches "their partner or other dining companions" (<https://www.exploretock.com/privacy>, <https://www.exploretock.com/merchant-terms>) — people with no account, no consent and no way to ask.

### OpenTable GuestCenter — **GAP, NOT AUDITED**

This section was in scope and was **not completed** before the audit closed. A partial note-capture
exists covering: pricing plans, relationship management, "Manage reservations on OpenTable",
Guest Merge, Pro features, custom tags, an "obscures sensitive info" behaviour, shift overview,
and "Export your Guestbook". None of it reached the evidence standard used elsewhere in this
document, so none of it is reproduced here.

**Treat OpenTable GuestCenter as UNVERIFIED in its entirety.** It is the highest-value remaining
gap in section 1: OpenTable is the largest guest-profile installed base in the category, and it is
also the source of the 31%-find-it-creepy survey used in §A. The custom-tags and
"obscures-sensitive-info" behaviours in particular should be confirmed before any design decision
leans on them.

### Oracle OPERA Cloud PMS

**What it does.** OPERA Cloud is Oracle Hospitality's cloud property-management system and the de facto enterprise standard for large hotel chains. Its guest-recognition surface is the *Profile* — a chain-wide record that the docs describe as central to nearly everything in the system: "Information about the guests, contacts, companies, agents and booking source your property does business with - known as profiles- plays a part in almost all the activities you perform in OPERA Cloud. The OPERA Cloud solution relies on current and accurate profile data, that includes not only names and contact information, but a variety of other details such as language, preferences, loyalty memberships, negotiated rates, and much more. When the Shared Profiles is enabled in Chain setup all profiles are shared across all properties." — https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/ch_profiles_intro.htm

Profiles are typed. Verbatim: "A profile is a collection of data about any of the following entities, each of which is a separate profile 'type'" — **Guests**, **Contacts**, **Sales Accounts** (subdivided into **Companies**, **Travel Agents**, **Sources**), and **Groups**. Same URL.

**SHAPE of the artifact — Profile Presentation panels.** The profile screen is a set of "detail links" / panels; the docs say "All Profile detail links are available to view and update related profile details" and that you can "Click View to select a different presentation style or Customise View to select the detail panels to display." Enumerated panel names on the Managing Guest or Contact Profiles page (https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/t_create_manage_viewing_and_editing_a_profile.htm):

- Under **Profile**: Additional Information; Accounts Receivable; Channel Negotiated Rates; Financials; Communications; Negotiated Rates; Correspondence; Delivery Types; e-Certificates; Identification; **Keywords**; **Membership**; Owner Referrals; Owner Records; Profile Flexible Dynamic Fields; Sales Information; **Service Requests**; Subscriptions; Scheduled Activities
- Under **Stays**: **Attachments**; **Future and Past Stays**; **Notes**; Future and Past Blocks; Emails
- Related actions: **Anonymize Profile**; Merge Profiles; **View Stay Statistics**; View Change Log; Managing Profile Image

Note the presence of a **profile image**: "You can upload an image of guests and contacts to display in the profile business card." — https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/ch_profiles_intro.htm

**Preferences (the structured taste layer).** Preferences are the closest analogue to an arrival brief's "how they like it" block. "You can add preferences to a guest profile to personalize or enhance your guest services." The UI is a two-column picker: "Click the preference group [+] to expand the list." then "Select one or preferences in the Available column, click > to move selection to the Selected panel." — https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/t_create_manage_adding_guest_preferences_to_profiles.htm

Preference *groups* are configurable, and the configuration doc gives the real example vocabulary: "Code. Enter a code to identify the preference group (for example, newspaper, flowers, pillows, and so on)." Each group carries a "Quantity. Enter the maximum number of items that may be selected when choosing preferences from the preference group." and a "Reservation" flag: "Select to have this Preference Group and its preferences available when selecting the Preferences field on the Reservation screen. If any preferences with this selection are attached to a reservation, the user is prompted with the option to attach the preference to the profile." — https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.1/ocsuh/t_admin_client_relations_configuring_preference_groups.htm

That last clause is a notable design pattern for an arrival brief: a one-off request made on a single reservation gets *promoted* to a durable profile preference only via an explicit user prompt, not silently.

UNVERIFIED: the specific out-of-the-box preference groups shipped with OPERA Cloud (search snippets suggested "room features, smoking, floor, specials, and (room) Key Options" but the fetched configuration page does not enumerate them; the fetched page's own examples are only newspaper, flowers, pillows).

**Notes.** Free text, typed, and length-capped. Verbatim from https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/t_create_manage_adding_notes_to_a_profile.htm:

- "You can add multiple notes of varying note types to profiles. Notes that are marked as internal can be excluded on reports and stationery. When the Copy Profile Reservation Notes To Reservation OPERA Control is active, notes of type Reservation are copied to new reservations. In multi property operations you can specify the note applies to all properties or is specific to selected properties."
- Fields on the New Note form: **Type** ("Select a note type from the list"); **Internal** ("Select this check box if the comment is to be treated as internal."); **Title** ("Enter a summary title for the note (default is based on the note type but it can be updated)."); **Available In** → **Global** ("Select check box if this note is available in all properties") or **Property**; **Comment** ("Enter or paste the note details; a maximum of 2000 characters (single byte) is supported.")

The 2,000-character cap is the concrete answer to "how long is a staff-facing note" in enterprise hotel software.

The Internal flag is a real, enforced field-level guardrail: "Internal notes are not output on stationery or on reports unless the report explicitly allows display of Internal Notes. You can uncheck this check box when Override Internal check box is selected in the note type configuration. Internal notes do not trigger business events ... to external systems." — same URL.

Note types are administratively configured, and the admin can lock the internal flag so line staff cannot un-hide a note. Verbatim from https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/t_admin_configuring_note_types.htm: "If Internal is selected and Override Internal is not selected, a note of this note type will be designated as internal and a user cannot update the designation. If Internal is selected and Override Internal is also selected, a note of this note type will, by default, be designated as internal, but a user may update the check box to remove the internal designation. If Override Internal is selected and Internal is not selected, the note of this type will not be designated as internal, but the Internal checkbox will be available for the user to update."

The same page shows OPERA supports **Default Note Text** — pre-canned note bodies per note type: "Default Note Text: Select check box to setup a default note text to populate to the comments field when adding a note." with a per-property or Global "Note Text: Enter the note text to default to new note." This is a template mechanism for standardizing note voice. Same URL.

Note *groups* named in the docs: "This applies to AR Account Notes, Business Block Notes, Profile Notes, Event Notes, Contract Notes and Property Notes". Same URL. UNVERIFIED: a shipped list of default note type codes.

**Traces — the action-note primitive.** Distinct from notes, OPERA has *traces*, which are the closest existing thing to "a task fired at a department on a date." Verbatim from https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/t_managing_reservations_adding_traces_to_reservations.htm:

- "Traces are actionable instructions for a selected department for a specific date and time; once actioned the trace is updated as resolved. You can view and manage all reservation traces using Reservation Workspace or generate a reservation trace report."
- Fields: **Department** ("Select a department(s) to receive the trace."); **Frequency** (options: "Arrival Date Only: Adds trace for selected reservations on their individual arrival dates.", "Departure Date Only", "Stay Dates", "Date Range"); **From Date**; **To Date** ("Enter an end date for the trace; one trace per day is created."); **Time**; **Trace Text**; **Quick Insert** ("Click to select from pre-configured trace text for the selected department.")
- Retention: "Reservation traces are purged 30 days after reservation check out, no-show or cancellation."

The only literal example trace text in the doc is a system-generated one: "The trace message reads: 'Insufficient quantity available for item <item code>'." Same URL. UNVERIFIED: real hospitality-flavoured example trace text in Oracle's own docs.

Design point worth stealing: **Quick Insert** = a per-department library of canned trace text, i.e. Oracle's answer to note-voice consistency is a phrase palette, not free typing.

**Alerts — the interruptive layer.** Verbatim from https://docs.oracle.com/en/industries/hospitality/opera-cloud/23.5/ocsuh/t_managing_reservation_alerts.htm:

- "Alerts are messages for hotel staff that are displayed as a notification when the reservation is accessed at a specific time (status) in the reservation life cycle. When the Popup Alerts OPERA Control is active, alerts appear as a pop-up page, which the user must close to continue. When the Popup Alerts OPERA Control is inactive, alerts are indicated as a notifications link."
- Alerts are triggerable by lifecycle *area*: "**Reservation:** Alert is triggered when opening reservation presentation (manage reservation) for future date reservation. **Inhouse:** ... for in house reservation. **Check-In:** Alert is triggered at the time the reservation checks in, prior to opening Check in Reservation. **Check-Out:** Alert is triggered at the time the reservation checks out, prior to opening Billing."
- Fields: **Code** ("Select the Alert message."), **Area**, **Description** ("The text of the alert. Based on the alert code selected, default text is populated and can be edited if required."), **Display Alert**, **Print Alert** with **Printer** and **Report**.
- Alerts can physically print: "Reservation alerts can also be setup to print to an (email addressable) printer, such a printer in In-room Dining or Concierge and generating a 'chit' in the selected alert template format." Same URL. This is essentially a paper arrival brief.

**Stay statistics (the "how much of a regular is this" block).** From https://docs.oracle.com/en/industries/hospitality/opera-cloud/23.4/ocsuh/t_application_client_relations_profiles_guest_stay_statistics.htm — the Reservation Statistics tab covers number of nights, arrivals, cancels, no shows, day use, and revenue; the Stay Records tab (active with the Stay Records OPERA Control) shows **Nights, Cancels, No Shows, Total Booked, Total Stays, Revenue**. The Revenue Statistics tab is "Available when the Profile Revenue Statistics OPERA Control is active."

**Pricing.** UNVERIFIED as a published figure. Oracle does not publish an OPERA Cloud price on the documentation or product pages reached here; OPERA Cloud is sold as a quoted enterprise subscription. Do not cite a number without a fetched Oracle price list.

**The attentive-vs-creepy line — OPERA Cloud is by far the most explicit of any product in this scan.** It handles the line with *mechanism*, not exhortation. Four distinct guardrails, all in primary docs:

1. **Internal flag** (above) — a per-note, admin-lockable switch controlling whether a note can ever leave the building, including whether it "trigger[s] business events ... to external systems."

2. **Incognito / alias identity.** "When the Incognito OPERA Control is active, guests can provide a fictitious name to use while staying at your property, hiding the guest's true identity from the hotel personnel (on reports etc), unless permission has been granted to view it in the profile. This functionality is commonly used for celebrities to maintain anonymity while staying at your property." — https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/ch_profiles_intro.htm  This is the inverse of an arrival brief: a documented, first-class way for a high-value guest to be deliberately *un*-recognized by staff.

3. **Subject-access + anonymization (GDPR machinery).** "To protect the personal information of guests and contacts the profile details can be anonymized. The Profile Anonymization feature masks or removes personal information from the profile record so the guest or contact can remain anonymous." and, on subject access: "Guests or contacts requesting a copy of their details 'on file' can be provided the Profile Details Report. ... Generating this report is tracked in the Changes Log with the Profile Data Report activity type." — https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/ch_profiles_intro.htm

   The anonymization page is stricter still: "The Anonymize Profile action is irreversible and the profile can no longer be updated." — https://docs.oracle.com/en/industries/hospitality/opera-cloud/24.4/ocsuh/c_create_manage_profiles_profile_anonymization.htm

   Its field-by-field table is the single most useful artifact in this whole scan for thinking about what a guest record actually contains. Elements listed as anonymized: Name (including "the Profile, Reservation Name, Credit Card Names, Membership Card Name, and Room Key Card Name"), Salutation, Envelope Greeting, Alternate Name, Alternate Salutation, Alternate Envelope Greeting, **Alias/Incognito**, Address (excluding State and Country), Communication (Email, Phone), **Identification (that is, Driver's License, Passport Number)**, Birth Date, Birth Place, Birth Country, **Gender**, **Photographic Images (attachments of any type)**, Tax ID, **Comments/Notes**, Membership Card Number, Change Log, Profile Links/Relationships, Web Accounts, **Keywords**, Client ID, Credit Card Number. Names/addresses/IDs are masked to a pattern ("AXXXXXXXXZ", identification to "XXXXXXXX99"); crucially **Comments/Notes, Gender, Birth Date, photographic attachments, Keywords, and the Change Log are marked as fully removed from the database**, not masked. Same URL.

   Post-anonymization the record is visibly quarantined: "Profile is listed in search result, but the data is anonymized. The Profile Overview panel is shaded red. The Edit and I Want To. . . actions are suppressed. You no longer have access to the folio history ... User log entries are removed ... Updates to the Profile by external systems are no longer accepted, and a new profile is created. Profile cannot be merged with other profiles." Same URL.

4. **Automatic decay.** Data minimization is the default, not an opt-in: "In order to ensure data quality, dormant or incomplete profiles are automatically purged based on various OPERA Controls." — https://docs.oracle.com/en/industries/hospitality/opera-cloud/25.4/ocsuh/ch_profiles_intro.htm  Traces expire 30 days post-checkout (trace URL above); inactive note types "will be purged after 7 days by the purge process" (note-types URL above); and "The profile changes log is purged when the profile is deleted."

UNVERIFIED: any Oracle guidance telling staff *what not to write* in a note. OPERA's posture is entirely structural — retention, masking, visibility scoping, and a locked internal flag. There is no fetched Oracle text about tone, taste, or the substance of a note.

### Mews

**What it does.** Mews is a cloud PMS aimed at independent and boutique/lifestyle hotels and hostels. Its guest-recognition surface is the *Customer profile*, reached from the Customer module.

**SHAPE of the artifact.** The Mews Connector API's Customer object is the cleanest enumeration of real field names, since it is the contract the product exposes. Fields and their documented descriptions, from https://docs.mews.com/connector-api/operations/customers:

Id; ChainId; Number ("Unique number of the customer (max 19 digits)."); Title; CustomTitleName ("Name of the customer's custom title, as configured in the chain's guest titles."); **Sex**; FirstName; LastName; SecondLastName; NationalityCode; PreferredLanguageCode; LanguageCode ("Language and culture code based on multiple sources including previous bookings."); **BirthDate**; BirthCountryCode; BirthCountrySubdivisionCode; BirthPlace; **Occupation** ("Occupation of the customer."); Email; HasOtaEmail; Phone; TaxIdentificationNumber; **LoyaltyCode**; AccountingCode; BillingCode; **Notes** ("Internal notes about the customer."); **CarRegistrationNumber**; **DietaryRequirements** ("Customer's dietary requirements, e.g. Vegan, Halal."); CreatedUtc; UpdatedUtc; AddressId; **Classifications** ("Classifications of the customer."); **Options**; ItalianDestinationCode; ItalianFiscalCode; ItalianLotteryCode; CompanyId; MergeTargetId; IsActive; **PreferredSpaceFeatures** ("A list of room preferences, such as view type, bed type, and amenities."); CreatorProfileId; UpdaterProfileId.

Two things stand out for an arrival brief: `Notes` is explicitly typed as *internal*, and `DietaryRequirements` is a first-class structured field with worked examples ("e.g. Vegan, Halal") rather than being buried in free text.

**Classifications — a fixed, shipped tag vocabulary.** This is the most transferable finding for a members-club product, because Mews ships an opinionated list rather than letting staff invent tags. The full preset list, verbatim from https://help.mews.com/s/article/Classifying-guests-in-Mews-Operations?language=en_US:

Airline; **Blocklist**; Cashlist; **Disabled person**; Friends and family; Health compliant; **Important**; In room; Loyalty program; **Media**; Military; **Opt out of email communication**; Paymaster account; **Previous complaint**; **Problematic**; **Returning**; Staff; Student; Top management; **Very important**; Waiting for room.

Workflow, verbatim from the same page: "Click on any customer profile, or enter the customer's name in the Mews Dashboard search bar. Go to the **Internals** tab. Under **Classifications**, select one or more options from the drop-down list. Click **Save**."

That vocabulary is worth reading closely as a design specimen. It mixes four incompatible things in one flat dropdown: service-relevant accommodation ("Disabled person"), commercial standing ("Very important", "Top management"), relationship history ("Previous complaint", "Returning"), and what is effectively a staff-safety/character judgement ("Problematic", "Blocklist"). "Problematic" is a durable, unexplained, profile-level label attached to a named human — exactly the failure mode an arrival brief has to design against.

**Customer profile UI layout — six tabs.** Verified from https://help.mews.com/s/article/what-is-the-customer-module-and-what-does-it-contain?language=en_US :

- **Dashboard** — current/future reservations, closed bills, past reservations, orders
- **Profile** — editable guest information (email, name, nationality, contact details), loyalty program data, identity documents, addresses, related guests, attached files, profile merge
- **Internals** — classification assignments, invoice preferences, marketing opt-in settings, **preferred space features**, accounting/loyalty/billing codes, and **guest notes**
- **Payments** — payment methods, historical transactions, preauthorizations, scheduled payments, payment requests
- **Billing** — unpaid items, deposits, open bills
- **Action log** — "Tracks all modifications users make to the customer profile."

So notes, classifications, room preferences and marketing consent all live together on **Internals** — Mews' single "things staff know about you" tab. The free-text field is labelled **"Guest profile notes"**.

Note visibility is deliberately scoped, and the scoping is counter-intuitive: the note follows the *room*, not the booking. Verbatim from the same page: "Mews displays the notes that you add on the **Internals** tab in your Space Status report and doesn't display them in the reservation itself." Per the same source the notes also surface in the Reservation report, Reservation overview, and Guests in house report. An **Action log** tab means every edit to the profile is attributable — a real accountability guardrail, and the thing most restaurant systems in this scan lack.

**Staff-facing note format/voice.** UNVERIFIED. No fetched Mews page shows a real example note body, a length cap, or house-style guidance — only the field label ("Guest profile notes") and where it renders.

**Pricing.** Mews publishes tier names but no numbers. From https://www.mews.com/en/pricing: three tiers — **Essentials**, **Advanced**, **Enterprise** — each fronted by a "Get Pricing" form rather than a price. Essentials includes "Mews PMS," "Easy-to-use booking engine," "Guest portal," "Automated payments platform," "Exportable reports," "Automated front office operations," "8 Mews Marketplace integrations," "24/7 chat bot support," "Ready-to-use business intelligence dashboards." Advanced is "Everything in Essentials, plus" items including "Easy-to-read, AI-driven summaries," "Customizable booking engine," "Custom domain email," "Automated SMS check-in reminders," "Digital Key for contactless check-in." Enterprise is "Everything in Advanced, plus" Mews Business Intelligence, "Mews Open API access", and "Unlimited Mews Marketplace" with "1000+ integrations."

Note for our purposes: "Easy-to-read, AI-driven summaries" sitting in the *Advanced* tier is the closest thing in this scan to a shipping competitor for an auto-generated arrival brief. UNVERIFIED what that feature actually summarizes — no fetched page describes it in detail.

Numeric per-room pricing (commonly reported around $8–$15/room/month for core PMS) appears only in third-party resellers and comparison blogs, not in a Mews primary source. Treat as UNVERIFIED.

**Attentive-vs-creepy line.** Mews' visible guardrails are the `Notes` field being defined as internal, an "Opt out of email communication" classification, and a "Blocklist" classification. UNVERIFIED: any Mews policy text, staff-training language, or written guidance about what not to record in a guest note. Notably, the shipped classification vocabulary points the *opposite* way — "Problematic" is a sanctioned, one-click character label.

### Cloudbeds

**What it does.** Cloudbeds is a cloud PMS/booking-engine/channel-manager suite for independent properties, hostels and small groups.

**SHAPE of the artifact.** Cloudbeds' own help center (myfrontdesk.cloudbeds.com) returned **HTTP 403 Forbidden** to every fetch attempt, so the UI walkthrough is UNVERIFIED. However Cloudbeds publishes its API reference in agent-readable form at https://developers.cloudbeds.com/llms.txt, which yields the literal wire schema.

Guest object fields, verbatim with their documented descriptions, from https://developers.cloudbeds.com/reference/get_getguest-2.md :

firstName ("First Name"); lastName; **gender** (enum: M, F, N/A); email; phone; cellPhone; country ("Country (2 digit code)"); address; address2; city; zip; state; **birthDate**; documentType; documentNumber; documentIssueDate ("Document Issue Date, can be null"); documentIssuingCountry; documentExpirationDate; **customFields** ("Custom field name/value pairs"); **guestRequirements** ("Guest requirements data. Only included if `includeGuestRequirements=true`"); **specialRequests** ("Special requests made by the guest at the time of the booking"); taxID; companyTaxID; companyName; guestNationality ("Guest nationality (citizenship), ISO 3166-1 alpha-2. Empty string when none is stored"); **isAnonymized** ("Flag indicating the guest data was removed upon request"); **guestOptIn** ("If guest has opted-in to marketing communication or not"); isMerged ("Flag indicating that guest was merged"); newGuestID.

Two observations. First, the identity half of this schema is heavily travel-document-shaped (four passport/ID fields) while the *hospitality* half is thin — there is no dietary field, no preferences model, no tag or classification vocabulary at the guest level. `specialRequests` is explicitly scoped to what the guest typed at booking time, not what staff learned. Everything discretionary is pushed into `customFields`, i.e. whatever the property invents. Compared with Mews (`DietaryRequirements`, `Classifications`, `PreferredSpaceFeatures`) Cloudbeds has almost no structured taste layer.

Second, privacy state is a *field on the record*: `isAnonymized` and `guestOptIn` travel with every API read, so downstream consumers cannot fail to see them.

**Notes.** Notes are a separate, first-class collection rather than a string on the guest, and every note is attributed and timestamped. Fields verbatim from https://developers.cloudbeds.com/reference/get_getguestnotes-2.md : **guestNoteID** ("Guest note ID"); **userName** ("User Name"); **dateCreated** ("Creation datetime"); **dateModified** ("Last modification datetime"); **guestNote** ("Note content"). Full CRUD exists (postGuestNote / getGuestNotes / putGuestNote / deleteGuestNote per https://developers.cloudbeds.com/llms.txt).

The sharp contrast with OPERA Cloud: Cloudbeds notes carry **no note type and no internal/visibility flag**. Same source: "The documentation does not specify separate note type or visibility fields within the guest notes object." So a Cloudbeds guest note is an undifferentiated, unclassified free-text blob — but one permanently stamped with the name of the employee who wrote it and when. That is the opposite trade-off from most restaurant systems in this scan, which offer note *types* but weak authorship. Authorship is the cheaper and probably more effective guardrail: a note signed with your name is a note you write more carefully.

UNVERIFIED (blocked by the 403, recorded as leads only, NOT as claims): the "Guest Profile Drawer" UI; the distinction between Guest Profile Notes ("apply to the guest and can be used across multiple stays") and Reservation Notes ("apply to one specific booking"); the Notes Report; profile labels/tags; revenue and night totals; "Guest Statuses / Disallowed guests"; and whether a profile surfaces "information from other properties in the same Organization" — that cross-property visibility question is the interesting one and is worth another attempt. Article URLs to retry with a non-blocked fetcher:
- https://myfrontdesk.cloudbeds.com/hc/en-us/articles/35040987194011-Guest-Profile-Everything-you-need-to-know
- https://myfrontdesk.cloudbeds.com/hc/en-us/articles/25915443531675-Notes-Report
- https://myfrontdesk.cloudbeds.com/hc/en-us/articles/219621188-Managing-guest-statuses-disallowed-guests-and-duplicate-profiles

**Pricing.** Four tiers, no published numbers. From https://www.cloudbeds.com/pricing/ : **Flex** ("Build your own tech stack"), **One** ("The original unified platform"), **Experience** ("Unify your guest experience"), **Enterprise** ("Custom packages available"). "No dollar figures are published on this page. All four plans display 'Request a quote' buttons rather than listed prices." The page says "Cloudbeds pricing plans are tiered so you can select the one that best fits the unique needs of your business." Third-party reported figures (~$15/room/month entry) are UNVERIFIED against a primary source.

**Attentive-vs-creepy line.** No policy text or note-writing guidance was reachable (help center 403). What IS verified is mechanical and, for its size of product, decent: a right-to-erasure flag exposed on every guest read (`isAnonymized` — "Flag indicating the guest data was removed upon request"), a marketing consent flag (`guestOptIn`), and mandatory per-note authorship and timestamps (`userName`, `dateCreated`, `dateModified`). UNVERIFIED: any Cloudbeds guidance on what staff should not record.

### Salto (access control — profile check)

**Verdict: Salto is access control, and its "guest profile" is a credential record, not a hospitality guest record.** Confirmed by fetching Salto's own operator documentation.

From https://support.saltosystems.com/space/user-guide/operator/hotel/guests/, the Guest information screen displays by default only: guest name; guest name for check-in groups; partition (if enabled in the installation's license options); and an extended opening time option. Everything beyond that is generic: up to five **general purpose fields** can be activated on the Guest information screen, configured under **System > General options > Hotel** via "Enable field" checkboxes, with the administrator naming each field for whatever they want to capture — the documentation's own example is "special requirements."

The record's real purpose is authorization, not recognition: guests must be associated with a **guest access level**, which ties to access points such as the room door or communal doors (main door, swimming pool). Same URL.

So: Salto has no dietary field, no preferences model, no tag vocabulary, no notes model, no stay statistics. The one crossover idea is the "extended opening time" flag — a durable accessibility accommodation attached to a person and enforced by hardware, which is a rare example of a preference that *executes* rather than merely being read by staff. UNVERIFIED: any Salto guest-data privacy or retention policy text.


### Ritz-Carlton "Mystique" + Gold Standards

*Source tiers used below: **T1** = Ritz-Carlton/Marriott primary; **T2** = reputable journalism or trade press; **T3** = consultant/business-blog retelling (heavily mythologized on this topic — treat as folklore, not fact).*

**What it is/was.** Mystique is the Ritz-Carlton's guest-recognition database — the system of record for guest preferences, visit frequency and past service failures, shared across properties. The important correction to the popular telling is that the *named* system in the primary trade record is **CLASS**, not Mystique.

T2, fetched from https://www.destinationcrm.com/Articles/CRM-News/CRM-Featured-Articles/For-Ritz-Carlton-It-All-Begins-with-Customer-Knowledge-47424.aspx: the CRM system is "CLASS" — "Customer Loyalty Anticipation and Satisfaction System" — implemented in 1998 and designed by Cambridge Technology Partners. Nadia Kyzer, then corporate manager of guest recognition, is quoted: "We needed to bring more consistency and ease of usage to the process and CLASS was our answer." The same article notes CLASS integrates with "the Ritz-Carlton's property management system" and that the company was then investigating "portable technology, such as handheld devices."

"Mystique" as a *system name* appears mostly in T3 retellings. Where Ritz-Carlton uses the word itself in primary text, it means the brand quality, not the database — see the Gold Standards below, where "The Ritz-Carlton Mystique" is an outcome employees strengthen, and is listed as a component of "The 6th Diamond." A T2 Gallup piece describes it the same way: "The Ritz-Carlton Mystique" is "a way of conceptualizing the brand's image and the ambience of each of the company's more than 70 worldwide locations." — https://news.gallup.com/businessjournal/112906/how-ritzcarlton-manages-mystique.aspx

UNVERIFIED: that Mystique was built on IBM/Lotus technology; that Mystique is a distinct successor product to CLASS rather than the internal nickname for the same guest-recognition capability. No fetched source establishes either.

**The preference pad — the capture device.** This is the most directly transferable mechanic, and it *is* verifiable at T2. From the destinationCRM article above: a "guest preference pad" is "part of each employee's uniform." Staff note guest preferences on the pads and route them to the guest recognition office, or "call a hotline to share the information."

The pipeline has a human editor in the middle, which matters enormously for an arrival-brief design. Same source: at each of Ritz-Carlton's 32 hotels (at the time of writing), a **guest recognition manager** serves as the repeat-guest "expert"; that department reviews guest profiles before arrivals and prepares reports distributed throughout the hotel. So the shape is: *line staff observe → write on paper → a dedicated recognition role curates and enters → a pre-arrival report is distributed back out.* Nobody's raw observation goes straight into the guest record.

**Fields / what gets recorded.** Only loosely enumerated in reachable sources. T2 examples from destinationCRM: "smoking and bed-type preferences," plus which restaurant table guests prefer and which room they like. T2, Gallup (URL above), gives one worked anecdote: a guest, Joanne Hanna, received a scented candle, which was recorded such that "whenever I check into a Ritz-Carlton, there's a candle waiting for me."

UNVERIFIED: an actual field list or schema for a Ritz-Carlton preference record. No primary or reputable secondary source reached here enumerates field names. Claims circulating at T3 about temperature settings, food and drink choices, room arrangement and amenity selection are plausible but were not confirmed on a fetched page — do not cite them as fact.

Worth noting the brand's own origin myth frames the artifact as *memory*, not data. T2, https://www.fundinguniverse.com/company-histories/the-ritz-carlton-hotel-company-l-l-c-history/, on César Ritz: "Ritz remembered who preferred Turkish cigarettes, who loved gardenias in their room, and who ate chutney during breakfast."

**The Gold Standards (T1-equivalent; fetched in full from the Ritz-Carlton Leadership Center).** All quotes verbatim from https://ritzcarltonleadershipcenter.com/about-us/about-us-foundations-of-our-brand/

*The Credo:* "The Ritz-Carlton is a place where the genuine care and comfort of our guests is our highest mission. We pledge to provide the finest personal service and facilities for our guests who will always enjoy a warm, relaxed, yet refined ambiance. The Ritz-Carlton experience enlivens the senses, instills well-being, and fulfills even the unexpressed wishes and needs of our guests."

*Motto:* "We are Ladies and Gentlemen serving Ladies and Gentlemen."

*Three Steps of Service:* 1. "A warm and sincere greeting. Use the guest's name." 2. "Anticipation and fulfillment of each guest's needs." 3. "Fond farewell. Give a warm good-bye and use the guest's name."

*Service Values — "I Am Proud To Be Ritz-Carlton"* (all twelve, verbatim):
1. "I build strong relationships and create Ritz-Carlton guests for life."
2. "I am always responsive to the expressed and unexpressed wishes and needs of our guests."
3. "I am empowered to create unique, memorable and personal experiences for our guests, strengthening The Ritz-Carlton Mystique."
4. "I understand my role in championing The Ritz-Carlton Community Footprints."
5. "I continuously seek opportunities to innovate and improve The Ritz-Carlton experience."
6. "I own and immediately resolve guest problems."
7. "I create a work environment of teamwork and lateral service, so that the needs of our guests and each other are met."
8. "I have the opportunity to continuously learn and grow."
9. "I am involved in the planning of the work that affects me."
10. "I am proud of my professional appearance, language, and behavior."
11. "I protect the privacy and security of our guests, my fellow employees, and the company's confidential information and assets."
12. "I am responsible for uncompromising levels of cleanliness, and creating a safe and accident-free environment."

*The 6th Diamond:* "Mystique, Emotional Engagement, Functional"

*The Employee Promise:* "At The Ritz-Carlton, our Ladies & Gentlemen are the most important resource in our service commitment to each other and our guests. By applying the principles of trust, honesty, respect, integrity, and commitment, we empower and nurture talent to the benefit of each individual and the company. The Ritz-Carlton fosters a culture where all are valued, quality of life is enhanced, individual aspirations are fulfilled, and The Ritz-Carlton Mystique is strengthened."

**Marriott acquisition.** T2, https://www.fundinguniverse.com/company-histories/the-ritz-carlton-hotel-company-l-l-c-history/: "In 1995 the sprawling hotel chain Marriott International, Inc. bought a 49 percent stake in Ritz-Carlton." and "The partnership was solidified in 1998 when Marriott boosted its interest in Ritz-Carlton to 99 percent." Reported consideration ~$200m for the 1995 stake. UNVERIFIED at the required standard: the $290m figure for the remaining interest, and any specific consequence of the acquisition for the guest-recognition system.

**"Lightning Strikes" — UNVERIFIED.** No fetched source confirms this as a Ritz-Carlton internal term for a preference-capture practice. Do not use it as an attributed Ritz-Carlton term without a primary citation. The verified daily-cadence ritual is the **line-up**: T2, https://www.nist.gov/blogs/blogrige/ritz-carlton-practices-building-world-class-service-culture, describes "daily 15- to 20-minute hotel line-ups consisting of all Ritz-Carlton employees around the world." (The same NIST article quotes Service Values 1 and 6.) The often-repeated claim that new Mystique entries are read out at line-up appears only at T3 and is UNVERIFIED.

**"Joshie the giraffe."** The origin is a first-person HuffPost piece by Chris Hurn (2012) about the Ritz-Carlton Amelia Island returning a child's lost stuffed giraffe with a photo binder documenting its "extended stay." The canonical URL https://www.huffingtonpost.com/chris-hurn/stuffed-giraffe-shows-wha_b_1524038.html 301-redirects to https://www.huffpost.com/chris-hurn/stuffed-giraffe-shows-wha_b_1524038.html?guccounter=1, which was NOT successfully fetched here — so the story's details are **UNVERIFIED at this evidence standard** despite being genuinely widely reported. A follow-up by the same author exists at https://www.huffingtonpost.com/chris-hurn/great-customer-service-ne_b_8340954.html (also unfetched). Flag: nearly every business-book version of this story adds embellishments; go to the Hurn original before citing.

Likewise UNVERIFIED here: the widely-repeated "$2,000 per guest per incident" employee spending discretion. It is real Ritz-Carlton lore but was not confirmed on a fetched page in this pass.

**The attentive-vs-creepy line.** Ritz-Carlton's written doctrine handles this in exactly one place, and it is worth noticing how it is framed: **privacy is a Service Value, not a compliance policy.** Service Value 11 — "I protect the privacy and security of our guests, my fellow employees, and the company's confidential information and assets." — sits in the same numbered first-person list as "I am empowered to create unique, memorable and personal experiences." Discretion and personalization are presented as two halves of one professional identity rather than as a constraint bolted onto a growth feature. For a members-club arrival brief that is the single most useful structural idea in this section.

The second structural guardrail is the **guest recognition office** described above: a curation checkpoint between raw staff observation and the durable guest record. Nothing in the reachable sources says its purpose is taste-filtering, but that is functionally what a human editor between the preference pad and the database provides.

UNVERIFIED and worth further hunting: explicit Ritz-Carlton or Marriott executive statements about *not* being intrusive; any staff-training language drawing the line; Marriott's privacy-statement language specifically on preference data; and the Marriott/Starwood 2018 breach and the UK ICO fine as they bear on guest-data trust. None of these were confirmed on a fetched page in this pass. The breach is real and well documented but is not evidenced here.


### Cross-cutting: the "diner dossier" press record and the creepy line

This section is not a product. It is the evidence base for what staff-facing notes *actually say* when nobody is writing documentation — the closest thing available to a corpus of real arrival-brief prose — plus the public record on where the line sits.

**The real note format is coded shorthand, not prose.** This is the single most important practical finding for an arrival-brief product. Working restaurant guest notes are dominated by two-to-four-letter codes appended to a name, not by sentences.

Verified codes, with sources:

- **PX** — *personne extraordinaire*. From Bianca Bosker's *Cork Dork*, as reported at https://sunset.com/syndication/restaurants-secret-code-cork-dork: PX is reserved for "big spenders, owners' friends, high-rolling regulars, and special guests," and of them the book says: "They are to be coddled, spoiled, humored and upsold at all costs." Bosker observed the system at Marea, a two-Michelin-starred New York restaurant.
- **HWC** — "handle with care," applied to guests requiring special attention, such as those with behavioral issues. Same URL.
- **PPX** — *"particulièrement extraordinaire"*, "a step above PX." And **WTW** — the elite tier, signaling these select few are to be given "whatever their hearts desire." Both from https://www.tastingtable.com/1273460/the-secret-codes-restaurants-use-for-their-most-important-guests/, which also covers **VIP**, **PDR** (private dining room), and **86'd** ("used to indicate a patron has been kicked out and banned from the restaurant").
- **FOM** — "friend of the manager"; **WW** — "Wine Whale." From https://www.huffpost.com/entry/restaurants-googling-patrons_n_5132535, which notes restaurants record traits including "allergies, favorite foods and even if a customer likes to linger at the table."
- **f.t.d.** (first-time diner), **H.B.** (Happy Birthday), **S.O.E.** ("sense of entitlement"), **L.O.L.** ("lots of love" — a difficult guest needing staff attention), and **"o"** (a plump guest). From https://vinepair.com/articles/yes-restaurants-keep-notes-on-guests-and-you-should-be-glad/

That list is the design brief in miniature. Roughly half the vocabulary is service-relevant (allergies, first visit, birthday, private room). The other half is a compressed, deniable, un-appealable judgement about a person's body, character or wallet — "o", "S.O.E.", "L.O.L.", "Wine Whale". The codes exist *because* they are deniable: shorthand is what you write when you would not want the sentence version read aloud.

**Longer-form note content.** Where notes are prose, they are single-clause factual observations tied to service actions. Verbatim examples reported by Adam Reiner, a veteran front-of-house manager, at https://www.tastingtable.com/691511/restaurants-google-diners-hospitality-technology-social-media-opentable-resy-app/ : "Guest notes kept in OpenTable might indicate that Mr. So-and-so tends to order from a particular wine region." Other documented note contents in the same piece: whether a diner "likes his fish with fra diavolo rather than the listed sauce"; that he received "a special gift from the kitchen last time he dined"; and "codes indicating that on the last few visits, he was a high-maintenance guest who sent his entrée back three times."

Note the pattern: preference → past gesture (so you don't repeat it) → behavioral history. That triad is close to what an arrival brief needs, and the third element is where the danger lives.

**Pre-arrival research is standard practice at the top end.** From https://abcnews.com/Lifestyle/restaurants-google-arrive/story?id=23291307 (ABC News): maîtres d's comb reservation books and search Facebook, LinkedIn and Google. Named practice:
- **Eleven Madison Park** pairs diners with servers by shared origin. Maître d' Justin Roller, quoted at https://www.huffpost.com/entry/restaurants-googling-patrons_n_5132535 : "If I find out a guest is from Montana, and I know we have a server from there, we'll put them together." The same piece notes that "If, for example, Roller discovers it's a couple's anniversary, he'll then try to figure out which anniversary."
- **Daniel** — staff use Google daily to research diners, checking "if they're in the business, maybe if they're a chef or work in the industry." (ABC News URL above.)
- **The Elm**, Brooklyn — GM Jay Poblador: "We definitely want to know who's in the dining room," searching LinkedIn to manage seating and keep people with "volatile relationships" apart. (ABC News URL above.)
- **Babbo** — staff Google to identify entertainers and TV personalities so they can be seated in private areas. (ABC News URL above.)
- Chicago: "Chicago establishements like Alinea, Next, Moto and iNG all admit to googling their customers." (HuffPost URL above.)

**The creepy line — the best quotes in the whole scan.** No vendor in this audit has policy language as sharp as what practitioners say off the cuff.

1. The operator who declines the practice outright. Dan Martin, manager at Sarabeth's in Manhattan, at https://abcnews.com/Lifestyle/restaurants-google-arrive/story?id=23291307 : "It's a fine line because it's hit and miss with which clientele will like that you know something about them." He added that he wouldn't encourage servers to research customers: "I wouldn't want that."

2. The discoverability test — the most useful single heuristic found anywhere in this research. Maître d' John Winterman, at https://www.tastingtable.com/691511/restaurants-google-diners-hospitality-technology-social-media-opentable-resy-app/ : "You want to be careful what you put in the notes. It could be very embarrassing if it got out." The same piece notes he "questions its actual value."

   That is the operative rule the trade actually uses, and it is a *leak* test, not a *consent* test: write nothing you would not want the guest to read. It is a far better design constraint for a members-club arrival brief than any GDPR clause, because it is checkable at write time by the person writing.

3. The honest statement of what the system is for. A managing partner at Danny Meyer's Union Square Hospitality Group, to the New York Times in 2012, quoted at https://vice.com/en_us/article/evjgpm/restaurants-google-you-regularly-to-figure-out-what-you-want-and-maybe-even-judge-you : "Data just gives us an opportunity to understand someone better."

4. The counter-case: research as a gate, not a service. The same Vice piece reports that at Fleming by Le Bilboquet, hostesses "pull up each unknown guest on Google" under an internal document called the **"Fleming Hostess Reservation Protocol"**, with a server alleging the purpose was to "keep the restaurant for special people only," maintaining a "certain environment" for wealthy patrons. The restaurant's representative denied class-based exclusion but acknowledged conducting online research on guests. The article also raises that Google searches "could enable discrimination based on online presence." Same URL.

   This is the failure mode a members-club arrival brief must be architecturally unable to become: recognition tooling repurposed as an admission filter.

5. Guests are not sold on it. Two survey datapoints, both from fetched pages. From HuffPost (URL above), on a 2010 survey: "Almost 40 percent of people were okay with restaurants googling them if it meant special treatment, and about 4 percent hoped restaurants would research them. Sixteen percent thought it was a little strange but could live with it, and 15 percent thought it was creepy." And from Vice (URL above): an OpenTable survey found that as of 2015, more diners considered the practice "creepy" than considered it "a good thing."

   So the public verdict moved the wrong way between 2010 and 2015. Any product in this space should assume the guest's default posture is suspicion, not delight.

6. The spending-tier critique. VinePair (URL above) reports RedFarm owner Ed Schoenfeld saying the quiet part plainly: "We try to take good care of everyone, and we take better care of some people." The same article describes a PX who was repeatedly welcomed back despite vomiting in the dining room and behaving inappropriately toward female servers, solely because of his spending — i.e. the tagging system actively overrode staff welfare. Sommelier Victoria James (Marea), in the same piece: "I got into hospitality because I want to make people happy."

**Will Guidara / *Unreasonable Hospitality* — describes our exact use case, verbatim.** From the EconTalk interview transcript, https://www.econtalk.org/will-guidara-on-unreasonable-hospitality/ :

> "We went to--and hence the word--_unreasonable_ lengths to achieve these small moments...The person that greeted you would have Googled you before you came in, such that if you ever put your picture online and you still looked even remotely like that picture, that we'd be able to greet you by name."

That is an arrival brief, described by the most celebrated practitioner of the form: pre-arrival research, resolved to a face, delivered as a name at the door. It is the strongest available evidence that the product category is real and desired at the top of the market.

He also names the dedicated role that owns it — the same curation-checkpoint pattern Ritz-Carlton uses with its guest recognition office. Same URL: "There was a person--we called them Dream Weavers--that was the name of the position. All the bus boy has to do is go to the Dream Weaver and say, 'We need sleds.'" And on the underlying philosophy: "Nothing we did was hard. We were just willing to try harder."

**The most significant thing in the Guidara transcript is what is missing.** Across a long-form interview devoted entirely to researching and surprising guests, there is **no discussion whatsoever** of the boundary between attentive personalization and intrusion. He frames pre-arrival Googling as an unambiguous good — an investment of effort, not a question of consent. The canonical text of the genre does not contain a creepy-line doctrine at all.

Still unfetched and worth chasing: https://www.theworlds50best.com/stories/News/will-guidara-eleven-madison-park-exclusive-book-extracts-unreasonable-hospitality.html (book extracts). The Ben Leventhal (Resy co-founder) essay "Why the Best Restaurants Are Obsessed with Knowing Their Guests" returned HTTP 403 at https://medium.com/the-21st-century-restaurant/why-the-best-restaurants-are-obsessed-with-knowing-their-guests-c0e802c2445e — worth retrying, as it is a vendor founder arguing the case directly.

**Operator-forum evidence (Reddit).** UNVERIFIED. Searches did not surface fetchable r/TalesFromYourServer, r/serverlife or r/KitchenConfidential threads containing quotable reservation-note text. If pursued, use old.reddit.com URLs, and label anything found as anecdotal, unverifiable operator report — not evidence of vendor behavior.




---


# 2. Private members clubs

## Private members clubs

Source-grounded audit for a staff-facing "arrival brief" product. Every claim below carries a verbatim quote from a page actually fetched, plus the URL. Anything not confirmed by a fetched page is marked **UNVERIFIED**.

**Headline:** the sharpest comparable is **Soho House** — the only club in scope that has publicly admitted, on the record, to algorithmic member-to-member matching, while also publishing the consent language for holding a member photo in its membership database. **Chief** is the sharpest comparable for the *introduction* half of the product (it sells curated introductions as the product itself, and its algorithm carries a published fairness constraint). **Park House (Dallas/Houston)** is the sharpest comparable for the *dossier* half, and the best Texas comparable: it runs Peoplevine and publishes, in its own rules, that it keeps interview notes on members which members may not see. **San Vicente Bungalows** and **Casa Cipriani** are the sharpest counter-examples: their published rules make *not* recognising or approaching people the house norm.

**Prior art already exists and is published.** Soho House runs a capitalised **"Member Recognition"** program — check-in flags from Reception flow through to OpenTable, with introductions named as a step (§1). PeopleVine — the platform behind Casa Cipriani, Zero Bond, San Vicente, Aman Club and Park House — ships a door app that **prints a paper arrival brief** with birthday, tier, recent visits, 90-day purchases and priority notes, and sells **face-scan check-in** (§2). The category question is not whether an arrival brief is acceptable; it is who is allowed to hold one, and whether the member is told.

**The core finding for positioning:** across every verified member quote, the grievance is *"nobody knows me and the vetting is fake"* — not *"they know too much about me."* Privacy anxiety, where it exists, is **lateral** (other members, the press, the club reading the subreddit), not **vertical** (the house holding a profile). No verified source found a member objecting to staff holding a dossier on them. See §5.

---

### 1. Which clubs PUBLISH how they do member recognition / introductions?

> Full job-posting and vendor-documentation detail (≈40 fetched pages, all with verbatim quotes) lives alongside this file in **`A_jobs_software.md`**. The highest-value findings are merged below.

#### Soho House — yes: a capitalised "Member Recognition" program, published in a job description

This is the single most important find in the audit. Soho House's Member Relations Manager posting for **Austin** describes the exact arrival-to-introduction chain the product would automate:

> "Oversee and ensure the successful implementation of **Member Recognition**, allowing in person, real time follow through with **check in flags from Reception (table touches, introductions, etc.) through to Open Table** and members seated in restaurants."
> — Member Relations Manager, Soho House Austin, https://job-boards.eu.greenhouse.io/sohohouseco/jobs/4961616101

Adjacent duties in the same posting show where the note is written and how the loop closes:

> "Update members Open Table notes with anything pertaining to service preference."

> "Have a strong member facing presence on the floor to support all departments, rotating themselves around the House on an hourly basis, taking time in each area to check on and speak to members in person."

> "Ensure there is a major focus on member bedroom experience / relationships daily, ensuring arrivals are checked for special arrivals, requests, PWH/FHM requests are met and welcome notes are written daily."

> "Create and maintain clear behaviour notes following an incident in the House so that the Head of Membership/Membership Manager can follow up the next day."

> "Take the initiative to create memorable personal outreach moments for special occasions (wedding, births, promotions, new movie, etc.)"
> — same URL

**The recognition note lives in OpenTable, not the CRM.** That is a concrete, citable seam.

**"Welcomed by name" is a company-wide standard — and it is hedged.** The phrase recurs near-verbatim across at least six live postings:

> "Ensure every member is welcomed by name **(if local)** and guest is welcomed with open arms and in a hospitable manner"
> — Club Receptionist, Soho House Nashville, https://job-boards.eu.greenhouse.io/sohohouseco/jobs/4945639101

> "Welcome members by name and greet new guests warmly to set a positive tone."
> — Club Reception, Soho House Portland, https://job-boards.eu.greenhouse.io/sohohouseco/jobs/4912262101

> "Greet all guests, patrons and members in a professional, appreciative and approachable way; addressing the guest by name **(when applicable/possible)**"
> — Bell Attendant, Soho House New York, https://job-boards.eu.greenhouse.io/sohohouseco/jobs/4928924101

The hedge is the product opportunity: Soho House explicitly does *not* claim its staff can name every member — recognition is scoped to the locally-known.

**Introductions are a scheduled, tracked, calendared workflow with a Salesforce attendance record:**

> "Maintain and manage the House's member introduction calendar, ensuring all new members are properly introduced to the House, its community, and facilities."

> "In partnership with Member Relations, host and lead member introductions, ensuring that all members have a warm and personal welcome and understand our rules and values."

> "Ensure accurate recording of attendance on Salesforce and coordinate follow-up for members who missed group sessions."
> — Membership Manager, Soho Beach House Miami, https://job-boards.eu.greenhouse.io/sohohouseco/jobs/4961611101

> "Work regular weekly floor shifts, producing a nightly report detailing the profile and atmosphere of the club and observations"

> "Introduce members to the key people and line staff within the House"
> — Membership Manager, Barcelona, https://www.themuse.com/jobs/sohohouse/membership-manager-913a57

> "Support in building and maintaining detailed and personalised member profiles to increase engagement and spend. Maintaining accurate records of member activity and service interactions in CRM systems."
> — Member Liaison (Cities Without Houses), Detroit, https://job-boards.eu.greenhouse.io/sohohouseco/jobs/4951572101

#### Soho House — the app and the algorithm

The most direct statement in the entire audit, attributed to a named executive on Soho House's own editorial site:

> "These connections are not created by chance, but crafted with intentionality, according to Dhawan. 'Members are matched to other members using a proprietary algorithm,' he explains. 'More recently we introduced interest-based and House-based groups where members contribute and share in a digital community.'"
> — https://www.sohohouse.com/en-us/house-notes/issue-006/house-tips/connect-through-groups

The speaker is identified on the same page as **Rajat Dhawan, Soho House's Global Chief Technology Officer**, who also says:

> "'…nded members, socially or professionally, has always been central to our membership,' says Rajat Dhawan, Soho House's Global Chief Technology Officer. 'Connect features on the member app enables these meeting moments digitally – more instantaneously and globally.'"

> "'Members can connect to other members and be part of sub-communities. Once connected, they can message each other, share recommendations, find work and meet in the Houses,' says Dhawan."
> — same URL

A member is quoted on the same page:

> "'I like using the Soho House app to connect with new members both locally and when I travel,' says Vinson. 'It makes it easy to meet other members socially, as well as for collaborative purposes.'"
> — same URL (member Malcolm Vinson, Soho Warehouse)

**Presence/visibility is opt-in.** Soho House's own app-update note describes location-aware check-in and who you can see:

> "Your experience on the app will now be based on where you are. When you're in one of the Houses, what appears on your homepage will be specific to the House you have 'checked in' to."

and, when checked in, you can see "the other members who are in the House, **if they have opted in to this**."
> — https://www.sohohouse.com/en-us/house-notes/issue-006/house-tips/all-the-soho-house-app-updates-you-need-to-know-about

This is the single most load-bearing design precedent for an arrival brief: Soho House gates member-to-member visibility behind an explicit opt-in, but does **not** describe any equivalent gate on what *staff* can see. (Staff-side visibility: **UNVERIFIED** — no fetched Soho House source describes what a host sees.)

#### Soho House — published consent to hold a photo in the member database

From the public House Rules (this is the clause that matters most for a recognition product):

> "4. Membership database — It is important for us to have your current details, plus a photograph of you in our membership database. By becoming a member of Soho House, you agree that we can hold your personal details and a photograph to use in connection with your membership."
> — https://www.sohohouse.com/en-us/terms-and-policies/house-rules

And the membership process, published:

> "The Membership Committee meets quarterly and makes the final decision on who shall become a member of Soho House."

> "Membership is for a minimum period of one year and renewable thereafter on an annual basis. Membership renewals are not automatic and are reviewed by our Membership Behaviour Committee on an annual basis. Their decision is final and without appeal."

> "Members are welcome to propose new applicants to join a House." … "members can click on the 'Propose a new member' function in the app."
> — same URL

Counterweight rule — members may not identify each other outside the House:

> "2. Disclosing member and guest identity — Each House operates a strict non-disclosure policy of sharing details of any other member, guest, private hire or member event in the public domain. This includes press and all social media platforms including Facebook, Twitter, Instagram, TikTok and personal blogs. Members will be held accountable if they or their guests are found breaking this policy."
> — same URL

What the application itself collects, per Soho House's membership page:

> "A recent picture for your profile, Credit or debit card details, Information about your interests and occupation."
> — https://www.sohohouse.com/membership

#### San Vicente Bungalows — publishes the *opposite* norm, and the PDF is hosted on Peoplevine

SVB's full club rules are a public PDF served from **Peoplevine's** own blob storage (see §2 — this doubles as a software fingerprint):

> "Privacy and anonymity are essential to the purpose and existence of San Vicente Clubs. Many members and guests are public figures who visit the San Vicente Clubs premises for a place to socialize outside the purview of the public eye. Without the club's ability to maintain the privacy and anonymity of its members and guests, the very existence of San Vicente Clubs would be compromised."

The anti-approach rule — directly contrary to a host-brokered introduction:

> "Members and their guests should exercise great respect and care if approaching another Member or guest of a Member that may or may not be personally known to the Member or their guest, as respecting privacy is an important policy of San Vicente Clubs."

> "Unless otherwise approved by the Club, there is no photography or videography of any kind permitted on the San Vicente Clubs premises."

> "No cameras, video or recording devices may be used while at San Vicente Clubs. … San Vicente Clubs has a strict no press policy."

Identification is by scan code, not by face:

> "The Club may issue a digital membership card with a scan code to each Member. If issued, membership cards will include the Member's name and account number. Cards may be necessary for entry into the San Vicente Clubs premises and/or to open and close tabs as determined by the Club from time to time."
> — all quotes: https://peoplevine.blob.core.windows.net/media/1114/4b00b588-6860-40b5-a4ca-67dc450b0990/SV_CLUB_RULES_December_2024.pdf ("CLUB RULES December 2024")

#### Casa Cipriani — publishes bylaws; committee identity is deliberately secret

> "Candidates for membership must be either: Proposed and seconded by existing members of the Club and/or appointed by the Proprietor in its discretion."

> "The Proprietor may, in its sole discretion, establish an admissions advisory committee (the 'Committee')."

> "Neither the Club nor the Proprietor are under any requirement to disclose who the members of the Committee are at any time."

> "Photography on Club premises is strictly forbidden in all areas. Taking photos or posting on social media is also prohibited while on Club premises."

Members must not discuss each other:

> members "shall not make any mention of or comment on the Club, its members, their guests or any of the activities" to press or media, and should "refrain from referring to the private activities of other members."
> — https://www.casaciprianinewyork.com/membership/membership-bylaws

Guest limits: "up to three guests with them to the Club at any one time" (individual members), "up to four guests" (couple members). Same URL.

#### Park House (Dallas / Houston) — publishes that it keeps interview notes members cannot see

Full treatment in §7. The headline clause, from its public Club Rules PDF:

> "Member information statements and membership agreements, interview notes, and all discussions and proceedings of the Membership Committee shall be confidential and not subject to review by anyone other than Club Management."
> — https://cdn.prod.website-files.com/684f2ff94ca7b759611c7ef2/685ef06b4a5a8b5c6ab6f814_e85441f912a1078a283f51d7064a72ae_Park_House_Houston_Club_Rules_1-12-24.pdf

Screening is published as including "credit and background checks as well as reference checks" (same source). No other club in scope publishes this.

#### Chief — the introduction *is* the product (see §3)

#### NeueHouse — explicitly positions against algorithms

> "Independent thinkers across industries and ages, connected by shared desire to create and discover off-algorithm. NeueHouse brings people together in physical space to play, talk face-to-face, riff on ideas, experience the best of what you didn't already know, and be a part of the future of business, society and culture."

> "We accept members on a rolling basis, only as spaces become available"
> — https://neuehouse.com/membership

Note the direct tension with Soho House: NeueHouse sells "off-algorithm"; Soho House sells "a proprietary algorithm."

#### Zero Bond — application is a form plus a headshot

Secondary source (Luxe Digital, which states it took figures "from the club's live application"):

> "Applications are submitted through Zero Bond's membership portal and reviewed on a rolling basis. In practice, a recommendation from a current member is the most reliable route in, alongside the application form and a recent headshot."
> — https://luxe.digital/scene/zero-bond-membership-cost/

**Caveat:** this is a third-party aggregator, not Zero Bond's own page. Zero Bond's own published recognition/introduction model: **UNVERIFIED**.

#### The Battery (San Francisco) — publishes a Charter that explicitly forbids surveilling other members

**This is the most directly on-point governance text found anywhere in the audit.** The Battery runs a member network called **Sonato** with presence/check-in features, and its public Charter regulates them:

> "Social Network Conduct applies to all Members and their Guests when using The Battery's sanctioned online platform(s), including but not limited to Sonato-enabled social features (posts, messages, comments, groups, media uploads, **profiles, check-ins**, and other interactions)."

> "**Members shall not use Presence or check-in features to monitor, pressure, or surveil other Members without consent. Guest integrity must be maintained online as it is in person.**"
> — Club Charter, The Battery, https://www.thebatterysf.com/charter

The same Charter pre-authorises biometric identification:

> "Access to the Club and its Premises is granted through secure, digital credentials issued to each Member via the Club's authorized mobile application or other electronic access systems designated by the Club from time to time."

> "The Club reserves the right to require additional identity verification at any time and to modify access technologies as operational or security needs evolve. Members agree to use other forms of identity verification at the Club as technological advances occur and the Club takes advantage of them (**example, fingerprint recognition**)."

> "Guests shall register with the front desk upon arrival at the Premises."
> — same URL

Note the asymmetry, and it is the central design lesson of this audit: The Battery forbids **member-on-member** surveillance while simultaneously reserving the right to add **club-on-member** biometrics. Same document, same club. The published norm is that the house may watch; members may not watch each other.

The Battery's own Membership Concierge job description is **UNVERIFIED** — the posting exists ("Membership Concierge / Membership · Manager / We are hiring for a Membership Concierge!", https://www.thebatterysf.com/careers) but its text sits behind a JavaScript-only ADP WorkforceNow iframe that never renders. Dues of $2,400, nomination-plus-council-vote and a 1,400 cap remain **UNVERIFIED** (search-result level only).

#### Zero Bond — "welcomed by name", stated with no hedge

> "As the club receptionist / Member Liaison of Zero Bond you will be the first point of contact between members and Zero Bond, acting as a gracious host while maintaining the standards of a curated membership experience."

> "**Ensure every member is welcomed by name** and members are greeted in a hospitable manner"

> "Develop meaningful relationships with returning members and their guests"

> "Fully trained in CRM and POS applications"
> — Zero Bond Club Receptionist, https://www.wayup.com/i-j-Zero-Bond-868809543087701/

Zero Bond commits to naming *every* member; Soho House hedges with "(if local)". Zero Bond never names its CRM in the posting.

#### San Vicente Clubs — the only club that names its exact recognition stack in a job ad

> "• Work quickly with **Seven Rooms and Peoplevine** systems"
> "• Welcome members and guests to the club with a positive and warm attitude"
> "• Acknowledge and anticipates guests' needs and always responds promptly to maintain positive guest relations at all times"
> — Front Desk Host, San Vicente Bungalows Santa Monica, https://culinaryagents.com/jobs/674125-Front-Desk-Host

> "Maintain accurate member profiles, notes, and preferences within club systems."
> — Front Desk Agent, San Vicente West Village, https://culinaryagents.com/jobs/714791-Front-Desk-Agent

> "Escort members and guests to their tables, ensuring comfort and awareness of preferences whenever possible."
> — Restaurant Host, San Vicente West Village, https://culinaryagents.com/jobs/714784-Restaurant-Host

Note the tension with SVB's own published rules (above), which tell *members* to "exercise great respect and care if approaching another Member." Staff are instructed to know preferences; members are instructed not to presume acquaintance.

#### Aman Club — publishes a Club Manual, and staff maintain preference profiles

The member handbook is a public PDF (hosted, tellingly, on PeopleVine's Azure blob):

> "Our Aman Club Ambassadors are dedicated on-property team members at Aman New York who are responsible for fulfilling membership requests."

> "Aman Club will provide each Founder with access credentials and a digital Aman Club Card compatible with iOS or Android. Founders are required to present their Aman Club Card upon arrival to gain access to Aman New York."

> "Founders are given a key to their own Spirit Cabinet, engraved with their initials, and provided access to their favorite bottles upon request."
> — Club Manual, Aman Club at Aman New York, Founding Membership, https://peoplevine.blob.core.windows.net/media/1255/Aman-New_York-Club-Manual-3.22.23.pdf

Job postings make profile maintenance an explicit duty:

> "Maintain an accurate and high-quality database of guest profiles and preferences."
> "Ensure all guest interactions are properly documented to support personalized service."
> — Concierge, Aman New York, https://aman.wd103.myworkdayjobs.com/AmanGroupExternal/job/Aman-New-York---New-York-City-United-States/Concierge---Aman-New-York_JR104135

> "Handle and personally ensure detailed recording of guest preferences in appropriate profile maintenance technologies."
> — Aman Customer Engagement Specialist, https://aman.wd103.myworkdayjobs.com/AmanGroupExternal/job/Aman-New-York---New-York-City-United-States/Aman-Customer-Engagement-Specialist---Aman-New-York_JR104744

#### CORE: Club — publishes a member photo directory in its own app

> "We have a full member photo directory as well as a partner directory. With a touch of a button, you can request a table, a trainer or a suite."
> — CORE: Club app, App Store (seller: CORE CLUB 55TH STREET LLC), https://apps.apple.com/us/app/core-club/id1356324735

This is the only club in scope publishing a **member-facing photo directory** — i.e. members can put a face to a name themselves, with no opt-in language published. CORE:'s staff-side workflow and CRM remain **UNVERIFIED** (Indeed and ZipRecruiter both 403).

---

### 2. Software stack

#### Peoplevine — Park House Dallas/Houston (confirmed) and San Vicente Bungalows (strong fingerprint)

**Park House Dallas — confirmed.** Its member portal at https://member.dallas.parkhouse.com/ returns, in the fetched HTML:

> `<title>Member Portal | Powered by Peoplevine</title>`

with `<body id="ppv">` and every icon served from `https://peoplevine.blob.core.windows.net/media/811/Park_House_Primary_Mark_white.png`.

**San Vicente Bungalows — strong fingerprint.** SVB's official club rules PDF is served from the same Peoplevine Azure storage account, under an adjacent tenant number (`media/1114` vs Park House's `media/811`):

`https://peoplevine.blob.core.windows.net/media/1114/4b00b588-6860-40b5-a4ca-67dc450b0990/SV_CLUB_RULES_December_2024.pdf`

Peoplevine's own homepage self-describes as:

> "The Guest & Member Experience CRM for Hospitality Brands"
> — https://www.peoplevine.com/

peoplevine.com/features returned no body content to WebFetch (JS-rendered), so Peoplevine's published member-profile **field list** is **UNVERIFIED** in this pass.

#### SevenRooms — publishes exactly the arrival-brief workflow

SevenRooms' membership-clubs product page is the closest published description of the workflow this product automates:

> "Bring your guests into the inner circle using details and dining preferences in automated guest profiles, like preferred cocktails or favorite bites."

> "Upgrade the member experience with standard, custom and automated guest tags like 'VIP' or 'Martini lover.'"

> "Ensure guests get the same personal experience at any club location by hosting guests profiles in a shared CRM database."

The software "automatically collects data to prepare your staff with details about every member, so they can focus on hospitality and incredible guest experiences."

> "Tap into our POS integration to see real-time member spend across club areas or locations."
> — https://sevenrooms.com/membership-clubs/

Named club customers on that page: **UNVERIFIED** (none surfaced in the fetched content).

#### Petroleum Club of Houston — Clubessential (confirmed)

Fetched HTML of https://www.pcoh.com/ contains Clubessential's markup signature repeatedly, e.g.:

> `<span class="http://www.clubessential.com"></span>Membership`
> `<span class="http://www.clubessential.com"></span>Join PCOH`

and the member portal URL follows Clubessential's ASP.NET pattern:

> `https://www.pcoh.com/Default.aspx?p=dynamicmodule&pageid=401648&ssid=328274&vnf=1`
> — https://www.pcoh.com/

#### Headliners Club (Austin) — Northstar / Sibisoft (confirmed)

Fetched HTML of https://www.headlinersclub.com/ contains Northstar's Liferay portlet identifiers:

> `com_sibisoft_northstar_htmlgenerator_HTMLGeneratorPortlet_INSTANCE_S1Ow5IG5uVr3`
> `com_sibisoft_northstar_navigation_DropDownNavigationPortlet`
> — https://www.headlinersclub.com/

Sibisoft is the vendor behind Northstar Club Management.

#### PeopleVine's arrival "chit" — a printed arrival brief that already exists

**This is the closest published prior art to the product.** PeopleVine's own operator guidebook documents a front-of-house app called **POX ("Point of eXperience")**, audience "Front of the House Staff, Door Staff, Management, Check-In", which prints a physical brief when a member walks in:

> "Member Check-In and Live View of Visitors — On the CRM Dashboard you can see who's in your space, check-in people by scanning their digital ID, swiping their card or searching by name."

> "Connect to a Printer and Print a Chit on Entry — Get text messages to your watch when someone arrives or print a chit with detailed preferences to personalize their experience."

The published field list of that chit:

> "Once a member is checked-in or when viewing their profile, the POX app can print a chit containing information related to the member's prior experiences at your establishment. Some of the data that's included on the chit includes:
> • Birthday and Anniversary dates
> • Membership Tier
> • Recent Visits
> • Most Frequent eCommerce Purchases over Past 90 Days
> • General and Priority Notes"

The profile schema is open-ended, not fixed:

> "Customer attributes are the best way to segment your list, add new custom fields to their profile and automate campaigns. They allow you to capture any type of data and automatically attach it to a customer's profile."

And PeopleVine publishes **biometric** check-in as supported:

> "For the most flexibility in hardware and experience, you can use the PeopleVine Control Panel to check people in using 2D Barcode Readers (similar to Target or Starbucks), using a key fob reader, swiping a card and even more advanced technologies like **face scan or fingerprint**."
> — all quotes: PeopleVine Guidebook for Operators, https://peoplevine.blob.core.windows.net/media/72/PeopleVine_Guidebook_for_Operators.pdf

> "PeopleVine is the only platform to capture 35 touchpoints in real-time allowing you to enable action based marketing through your customer's journey. Behind it all is a CRM capturing every interaction back to a single profile."
> — https://peoplevine.blob.core.windows.net/media/72/pdf/PeopleVine_Memberships_-_Digital_ID_for_your_Members_-_PeopleVine.pdf

**Note the gap between vendor capability and club disclosure:** PeopleVine sells face-scan check-in and a printed dossier. Not one of its club customers' published member-facing documents mentions either. Members of Casa Cipriani, Zero Bond, San Vicente, Aman and Park House are not told this tooling exists.

#### PeopleVine — confirmed at Casa Cipriani, Zero Bond, San Vicente, Aman Club, Park House

Beyond the Park House and SVB fingerprints above, three independent proofs:

(1) Portal footers:
> "© Casa Cipriani New York 2026. Powered by PeopleVine." — https://casa-app.clients.peoplevine.com/page/login
> "Member Portal | Powered by Peoplevine" — https://members.aman.com/ (the exact URL the Aman Club Manual tells Founders to visit)

(2) The clubs' iOS apps are published under **PeopleVine's own Apple developer account** (artistId 1548245069, which returns 155 apps):
> Casa Cipriani — seller: "PeopleVine, Inc." — https://apps.apple.com/us/app/casa-cipriani/id1596326498
> Zero Bond — seller: "PeopleVine, Inc." — https://apps.apple.com/us/app/zero-bond/id1486235163
> San Vicente Clubs — seller: "PeopleVine, Inc." — https://apps.apple.com/us/app/san-vicente-clubs/id1590924404
> Aman Club — seller: "PeopleVine, Inc." — https://apps.apple.com/us/app/aman-club/id6443803190

The same developer account carries ZZ's Club, Chez Margaux, Faena Rose, Fitler Club, The Twenty Two, The Groucho Club, Home House, Park House Members, The Bird Streets Club, Casa Tua Members, Tramp Members, plus PeopleVine's own "Check-In App by Peoplevine".

(3) The San Vicente job ad names it outright (above).

#### The Battery — Sonato

The Battery's member login resolves to `https://sonato.com/account/auth/login/location/thebattery-sf`, and its Charter governs Sonato by name (§1). Sonato's own positioning:

> "Sonato ensures every interaction between a private club and its members is smooth, elevated, and personalized — making membership feel truly exceptional."
> "Sonato connects you directly to your private club, making check-ins effortless, messaging seamless, and elevating every interaction."
> — https://sonato.com/

#### Clubessential — member photo pushed into the POS

> "Personalize Member Experiences — Advanced POS systems not only empower your staff to quickly complete transactions but also display members' preferences, enabling servers and personnel to personalize every interaction."
> — https://www.clubessential.com/club-management-software/

> "Members can also easily update their profile picture. The profile picture automatically display in the website directory, POS, and other Clubessential tools."
> — https://clubessential.atlassian.net/wiki/spaces/OF/pages/3473675/Mobile+-+Managing+the+Mobile+App

No club on the target list was confirmed as a Clubessential customer (Petroleum Club of Houston, above, is the one Texas confirmation).

#### SevenRooms — recognition as an alert, not as sight

> "Build rich customer profiles automatically with over 100 data points per guest, from dining preferences and order history to real-time point-of-sale spend."
> "Add unlimited tags and Auto-tags like 'positive reviewer' or 'steak lover' to customer profiles to optimize personalized service for every guest."
> — https://sevenrooms.com/platform/crm/

> "**4. VIP notifications** — You already treat every member like a VIP, but when a true VIP walks in, it's critically important to recognize them as quickly as possible. Look for a membership CRM system that alerts staff when an important guest checks in. With SevenRooms, key team members can get **Apple Watch alerts** when a VIP arrives…"
> "A member shouldn't have to tell staff at the poolside bar that they're avoiding dairy and then repeat this information at your fine dining venue."
> — https://sevenrooms.com/blog/12-features-to-look-for-in-a-membership-club-crm/

No facial or photo recognition appears anywhere in SevenRooms' published material — recognition is triggered by check-in or booking, never by sight. Confirmed in use at San Vicente Clubs; no other target-list club is named as a SevenRooms customer on any SevenRooms page.

#### Soho House — Salesforce + OpenTable + Opera Cloud + MICROS (no club-vendor CRM)

The 10-K names the app as proprietary and treats member data as a first-party asset and a first-party risk:

> "We enhance our member experience through our digital channels, including the Soho House App and our website. Our vision for the Soho House App has always been for it to be like having a House in your pocket. It's our central destination for members to make bookings, invite guests, make payments, and connect with each other."
> — Soho House & Co Inc. FY2024 Form 10-K, https://www.sec.gov/Archives/edgar/data/1846510/000095017025047906/shco-20241229.htm

> "…relating to data privacy and security, or any compromise of security, including in connection with the Soho House App, that results in the theft, unauthorized access, acquisition, use, disclosure, or misappropriation of PII or other member data, could result in significant awards, fines, civil and/or criminal penalties or judgments…"
> — same filing

> "They also may impose further restrictions on our processing, sharing, transmission, collection, disclosure and use of PII in connection with the Soho House App or that are housed in one or more databases maintained by us or our third-party service providers."
> — same filing

The filing also confirms an ERP programme and a named owner:

> "hiring a Chief Transformation Officer (November 2024) to lead the ERP system implementation"
> — same filing

**Salesforce is confirmed as Soho House's member system of record**, established from a pull of all 410 live postings on Soho House's public Greenhouse board API (`https://boards-api.greenhouse.io/v1/boards/sohohouseco/jobs?content=true`). Word-boundary counts across the corpus: MICROS 38, Opera 34, OpenTable 26, Salesforce 24, Tripleseat 3. **Zero mentions of SevenRooms, Peoplevine, Clubessential, Jonas, MembersFirst, Northstar, Resy, Toast or Lightspeed anywhere in 410 postings.**

> "Daily evaluation of membership applications; competent on Salesforce platform where applications are held"
> — Membership Manager, Barcelona, https://www.themuse.com/jobs/sohohouse/membership-manager-913a57

> "Monitor and record member behaviour, keeping detailed logs on Salesforce for future reference and updating on action that has been taken."
> "Maintain accurate and up-to-date member records on Salesforce and other systems, ensuring that all member behaviour and feedback is logged."
> — Membership Manager, Soho Beach House Miami, https://job-boards.eu.greenhouse.io/sohohouseco/jobs/4961611101

> "Quick learner or have OpenTable, Salesforce, Google Sheets and/or Opera"
> — Front Desk Agent, Soho House Chicago, https://careers.sohohouse.com/careers/4879923101

> "Extensive knowledge of Opera, Salesforce, Open Table and Google Sheets is a must"
> — Front Office Manager, Soho House Los Cabos, https://job-boards.eu.greenhouse.io/sohohouseco/jobs/4924279101

So the Soho House stack is **Salesforce (member CRM, applications, behaviour logs) + OpenTable (service notes and seating) + Opera Cloud (PMS) + MICROS (POS)** — a general-purpose enterprise stack, not a club-vertical product. Notably, the *member behaviour log* and the *service-preference note* live in two different systems.

#### Austin Club, Park House Dallas, The Houstonian, River Oaks CC

Vendor fingerprint scan of fetched HTML found no Clubessential / MembersFirst / Northstar / Jonas / Peoplevine / SevenRooms markers on austinclub.com, parkhousedallas.com or houstonian.com; riveroakscountryclub.com did not respond. **UNVERIFIED**.

#### Vendors with no evidence at any target club

Northstar Technologies, Jonas Club Software, MembersFirst, Golfmanager, Lightspeed — **no relationship found** at any club in scope (Northstar is confirmed only at Headliners Club Austin, §7; Jonas and MembersFirst nowhere). Resy and Toast appear only as "or similar" alternatives in one San Vicente host posting.

#### NeueHouse — **UNVERIFIED**

NeueHouse's ATS is Workable (slug `neuehouse`) and it is empty: the widget API returns `{"name":"NeueHouse", …, "jobs":[]}` (https://apply.workable.com/api/v1/widget/accounts/neuehouse); neuehouse.com/careers returns 404. Archived "Member Experience Associate" postings on TheLadders / ZipRecruiter / The Muse all returned 403/404. **No NeueHouse recognition text or tooling was obtained.**

---

### 3. Chief — how it describes and presents curated introductions

Chief sells the introduction itself, and uses the word "curated" as a product term.

From Chief's own site:

> "Core Groups are small, curated cohorts of senior executives who meet regularly to share challenges, exchange advice, and hold each other accountable."
> — https://chief.com/core-groups

> "Core Groups are curated based on your professional goals and how they align with the following four journeys"

(the four journeys being C-Suite, Executive Leader, Builder, Navigator), with matching considering "professional goals, role, company size, scope of responsibility, and life stage to ensure the best possible fit."
> — https://chief.com/coaching-membership

The literal phrase, on Chief's coaching page:

> "A curated introduction designed to confirm alignment and set the foundation for impactful work."

> "Chief matches you based on career goals, experience, and preferred coaching style."

> "Intentional pairing with the Chief-vetted Coach who's best for you"

> "2 compatibility sessions to ensure chemistry with your selected coach"
> — https://chief.com/coaching-membership

The human-in-the-loop role is published:

The Chief Guide "facilitate[s] each Core meeting, promoting an open and inclusive group environment," and their role is to "guide the conversation toward insights; address the issues that matter most; bring in themes, resources, and learnings; and help drive connections within the group."
> — https://chief.com/core-groups

Cadence: "6 scheduled group meetings per year" with "90-minute sessions held about every two months." Same URL.

Chief's homepage frames the whole thing as vetting:

> "Grow your circle and your influence. Join the largest vetted community of multihyphenate women leaders maximizing their impact by doing business together."
> — https://chief.com/

**Press — the algorithm is on the record, and so is the human review step.** Fortune's investigation is the most useful single paragraph in this whole audit for an arrival-brief product, because it describes an *explicit fairness constraint* inside the matching:

> "In 2022, the company started using an algorithm to match women into Core groups, factoring in industry and job title and ensuring no individual woman was the 'only' in her group—the only woman of color, or the only woman who is married or has children. A human manually reviews each group before it's launched, the company says."
> — https://fortune.com/2023/03/16/chief-womens-network-startup-price-valuation-waitlist-members/

Wikipedia corroborates the vetting framing and the criticism:

> "Chief membership grants access to its 'vetted network' of peers"

> "Fortune magazine reported criticism from some members; Chief acknowledged 'growing pains' in pivoting to a fully digital model"
> — https://en.wikipedia.org/wiki/Chief_(women%27s_network)

Membership growth per Wikipedia: 400 (March 2019), 2,000 (a year later), 12,000 (2021), 20,000 (October 2022), 20,000 listed as of 2026. Eligibility widened: "As of October 2025, membership criteria has expanded to include senior leaders in fractional and consulting roles, as well as founders and solopreneurs and those in career transition." Same URL.

Forbes' June 2024 piece on Chief's post-scrutiny platform returned HTTP 403 — **UNVERIFIED**.

---

### 4. Soho House specifically

**Scale and the app, from the 10-K:**

> "As of December 29, 2024, we have approximately 271,500 members (including approximately 212,400 Soho House members) who engage with SHCO through our global portfolio of 45 Soho Houses, 8 Soho Works, Scorpios Beach Club in Mykonos and Bodrum, Soho Home, our interiors and lifestyle retail brand, and our digital channels."
> — https://www.sec.gov/Archives/edgar/data/1846510/000095017025047906/shco-20241229.htm

**How membership is assembled, per the 10-K:**

> "The membership of each House is assembled by a select committee of influential creatives and innovators that represent the local area in which the membership is founded."
> — same filing

For scale comparison, the FY2021 filing (then Membership Collective Group) reported:

> "As of January 2, 2022, we are a community of more than 155,800 creative and loyal individuals, each of whom pays an annual membership fee"
> — https://www.sec.gov/Archives/edgar/data/1846510/000095017022003837/mcg-20220102.htm

**The app store listing** (developer: Soho House Limited; 4.9 out of 5, 18K ratings):

> "Book tables, events, screenings, fitness classes, and bedrooms in the Houses. Get updates on the latest news from the Houses and connect with fellow members. Your membership - all in one place."

App Privacy — Data Linked to You: Identifiers (User ID); Usage Data (Product Interaction); Diagnostics (Crash Data, Performance Data, Other Diagnostic Data). No "Data Used to Track You" categories disclosed.
> — https://apps.apple.com/us/app/soho-house/id670256744

Note the gap worth flagging internally: the App Store privacy label discloses only identifiers/usage/diagnostics, while the House Rules disclose a **photograph** held in the membership database and the app itself surfaces member-to-member matching. These are not obviously contradictory (the label covers app-collected data), but the member-facing picture of "what does Soho House hold about me" is split across three documents that do not cross-reference each other.

**The documented member-data incident.** This is the closest thing in scope to a club whose data handling became a story:

> Sharma wrote: "Your address and other sensitive details are leaked and [the club] is trying to cover this [up]" and warned members their "personal safety, security and family has been breached."

The data involved: "addresses, bank and payment card details." He threatened to leak personal information of "more than 50,000 members," though he "only obtained the details of a small number of members but claimed to have tens of thousands of their details to use as a bargaining chip," and demanded "no less than seven figures." He was ordered to repay £50,000 to his employer, Espire Infolabs. Soho House declined to comment.
> — https://www.cityam.com/it-consultant-ordered-to-pay-50000-after-being-accused-of-stealing-soho-house-members-personal-details/

The relevant lesson for an arrival-brief product: the breach vector was **an IT contractor with legitimate access**, not an external attacker. Any staff-facing member dossier inherits exactly this risk shape.

**Agency case studies on the app** (useful for how weakly the social layer actually lands):

> "A feature had previously been introduced in the app to encourage members to interact and engage with each other."

> "awareness and usage of this member connections feature was very low."

> "Members primarily used the app to book club restaurants, leisure facilities, and accommodation."

> "most members primarily used the app for transactions and bookings, with browsing content being a secondary activity."
> — https://www.elsewhen.com/work/customer-centric-app/

The d.DOBS design-sprint case study on Soho House's social features returned HTTP 403 — **UNVERIFIED**.

**The "scouted/screened" tension.** Air Mail's "Soho House I.P.O.s—And Loses Its Cool" is paywalled; the fetched excerpt contains only the framing that Soho House was meant to be "a 'home for creative people to come together'" but "stopped being that a long time ago" (https://airmail.news/issues/2021-5-1/burning-down-the-house). The specific member complaints about screening/scouting reported to exist in that piece are **UNVERIFIED** — I could not read them. The member-voice evidence I *could* verify is in §5.

---

### 5. What members say publicly — known vs. surveilled

**Method note and limitation, stated plainly:** reddit.com and old.reddit.com are both blocked from this environment (WebFetch refuses; direct curl to old.reddit returned zero bytes; the r.jina.ai reader returned `AuthenticationRequiredError`). Reddit content below was retrieved through the public Redlib mirror **safereddit.com**, which proxies the same threads; each quote carries the canonical reddit.com permalink for verification. Quotes are reproduced as written, typos included.

#### The single best quote on vetting-as-theatre

> "The membership requirement for most of these places is deep pockets and a pulse. I've spent quite a bit of time at a couple of the places mentioned, and they are basically just people head down on laptops and zoom calls, chatting with the friend groups they came with, and blowing $80 on lunch and Aperol spritzes. **The notion that these places are somehow vetting for the best and brightest members, and that those people are showing up every day to network and make friends is false.**"
> — r/AskNYC, "NY Private Clubs: worth it or just another expensive membership?", https://www.reddit.com/r/AskNYC/comments/1rutqiw/ny_private_clubs_worth_it_or_just_another/

From the same thread, on whether the introduction promise pays off:

> "overwhelming consensus among my friends who have had memberships is that they're not worth it"
> — same URL

#### Members describing the screening from the inside

An ex-staffer describes the actual review workflow:

> "They do interviews sometimes! I used to work in membership and the local membership managers review application with the head of membership at the house. They sometimes have a higher up reviewing. If for any reason they think that you might not 'fit' they usually schedule a quick zoom call!"
> — r/sohohouse, "Applied but how do they 'vet people'", https://www.reddit.com/r/sohohouse/comments/1v84vkv/applied_but_how_do_they_vet_people/

The applicant's own framing of what they can't see:

> "I submitted my application over the weekend but I'm curious how they 'vet' people if they only asked for social media links and website."
> — same URL

> "Adding to this - they also zoom all Founder applicants as part of the first member cohorts. They want to make sure that group is ultra curated - so expect that if applying to a house that's opening soon."
> — same URL

> "This must be by city or maybe based on how many applications they have but otherwise who knows if they even read them, in Chicago they accept everyone from whatr I can see."
> — same URL

The rubric, as reported by someone who went through it:

> "They will ask you what you do, why you are applying, where you live and what you can bring to the community."
> — r/sohohouse, "Got an interview what should I expect", https://www.reddit.com/r/sohohouse/comments/1vacdfv/got_an_interview_what_should_i_expect/

And the coaching that follows — members openly advise each other on how to perform for the screen:

> "The interview is easy. just dont say your an investment banker lol stay creative and you love community and you travel alot and spend money lol"
> — same URL

A committee member describes their own role, which includes reading applications:

> "Mix of things but mainly feedback on the house, shape events, membership feedback and application review."
> and, on how they got there: "It was a nomination and then interview"
> — r/sohohouse, "Sharing committee member perks", https://www.reddit.com/r/sohohouse/comments/1v2heeo/sharing_committee_member_perks/

#### The surveillance instinct, in members' own words

The clearest "am I being watched by the club" moment found — a member warning another member that the club reads the subreddit:

> "FWIW - I wouldn't put it past Soho to monitor this subreddit. You left in the name of the email sender in your image."

answered by:

> "soho can't even monitor the TP levels in their bathrooms — I doubt they are monitoring this subreddit."

and, notably, a third member arguing the *disclosure itself* is a disqualifying offence:

> "Indicates OP isn't particularly intelligent and has zero discretion - any members club would likely ban him/her."
> — r/sohohouse, https://www.reddit.com/r/sohohouse/comments/1vacdfv/got_an_interview_what_should_i_expect/

That exchange is the audit's best single illustration of the known/surveilled tension: within one thread, members assume the club is monitoring them, mock the idea, and then police each other on the club's behalf.

#### "Known" failing in the other direction — members feel *un*-recognised

The dominant complaint is not surveillance; it is anonymity and indifferent service. This matters: it is the demand-side case for an arrival brief.

> "the service standards are seriously lacking and far too inconsistent across the group. For what we pay, you would think there would be more effort to make the experience feel special. Instead, the service often feels indifferent, almost like Abercrombie staff from twenty years ago, where acting slightly aloof seems to be part of the brand. I don't expect overly formal service, but I do expect **staff to anticipate needs a little, make an effort to build some rapport**, and check in regularly rather than requiring me to constantly flag someone down to order another drink."
> — r/sohohouse, "Is it just me, or has the Soho House experience become a bit stagnant?", https://www.reddit.com/r/sohohouse/comments/1ts1yvq/is_it_just_me_or_has_the_soho_house_experience/

> "I ended up canceling my every house membership because of this - the service was so awful I didn't know why I was paying to be there. Also members are pretty standoffish, which is fine I guess, but it just made for an overall whatever experience."
> — same URL

> "Part of me wonders if they are aiming for the aloof vibe, as if it makes the experience more prestigious, because they execute on it quite excellently in every one of the houses I've been to."
> — same URL

On the club's stated purpose (connection) failing in practice:

> "There seems to be a mix review on this. How many of members here on this post actually have come away with saying they had a good experience their first year and made long term connections and events they will remember?"
> — same URL

Austin specifically:

> "Every time I've gone with them I've encountered the most pretentious people austin probably holds. I stopped going because I can't stand the crowd there."

> "**You won't make friends there, that's for sure.**"
> — r/Austin, "Is a membership at the Soho House worth it?", https://www.reddit.com/r/Austin/comments/11zsjoc/is_a_membership_at_the_soho_house_worth_it/

A dissenting Austin member:

> "I think it's worth it, I'm a member and when you join one of them you can get a worldwide membership as well and can go to all of the other houses. … Totally love going, there are not as many douchebags as you'd think and it seems like a lot of people hate it because they only hear about the douchebags."
> — same URL

#### "We're not members, we're customers" — the 2025–26 repricing and cull

The most quoted-worthy line in the whole audit on the membership relationship, from a member who met the membership manager in person:

> "You're definitely not alone, I had an in person meeting with the membership manager at 180, and they all but admitted that they're trying to reduce membership numbers and bring up all legacy member rates in line with new joining members. **The only protest it seems is to leave, which just goes to prove we're not members, we're customers…**"
> — r/sohohouse, "Membership Price Increase by 50%!", https://www.reddit.com/r/sohohouse/comments/1skerqj/membership_price_increase_by_50/

The demand-side case for a recognition product, stated by a departing member:

> "I left after 1 year. They wanted to increase me another 30%. The service is honestly not great. The food average. And **the vibes with everyone on laptops and phones is like an airport lounge**. It's a bummer. **If it was more social I might have stayed**."
> — same URL

On being priced out of the creative identity the club sells:

> "Yeah, the thing that shocked me is that they would strategise to remove members based on pricing them out, removing Artists, Creatives, and those who work in a creative field. Thus making their product something entirely different."
> — same URL

On the club not recognising tenure:

> "I just received my renewal e-mail. 35% increase! I have been a everyhouse member for 18 years. I have just submitted my cancellation e-mail to the membership team"

> "I have received a 30% increase. I've complained but not sure anyone cares. **I've been treated as though I'm the only one upset.**"

> "I joined in 1996 and we were told it would remain at the same fee. Mines just increased by 65%."

> "It stopped feeling like a members' club and leaned more towards a busy overpopulated public space."
> — all same URL

#### Chief members on matching quality

> "It took almost four months for the company to match her with a Core group" — Jessica Clifton, former LA member

> "Ultimately, most people I knew in Chief two years ago have canceled their memberships due to lack of value" — Jessica Clifton

> "I really walked away with such a great experience" — Dolores Estrada, COO at PEAK Grantmaking

> "Chief is not a done-for-you experience (and I don't know any community that is)" — Osnat Benari, product management consultant
> — all: https://fortune.com/2023/03/16/chief-womens-network-startup-price-valuation-waitlist-members/

#### The one club that legislated the surveillance question

No member said it, but a club did — The Battery wrote the fear into its Charter as a rule binding members:

> "**Members shall not use Presence or check-in features to monitor, pressure, or surveil other Members without consent.** Guest integrity must be maintained online as it is in person."
> — Club Charter, The Battery, https://www.thebatterysf.com/charter

The same document reserves the club's own right to add "fingerprint recognition" (§1). Read together, it is the clearest published statement of the operative norm in this category: **the house may watch; members may not watch each other.**

#### Summary of the sentiment axis

Across every verified source, the complaint is overwhelmingly **"nobody knows me and the vetting is fake"**, not "they know too much about me." The surveillance anxiety that does exist is (a) about the club watching members' *speech* (the subreddit-monitoring exchange), and (b) about **member-to-member** exposure — which Soho House answers with an opt-in and The Battery answers with a Charter rule. **No verified source found a member objecting to staff holding a profile on them.**

That asymmetry is consistent across the clubs' own documents too: Park House keeps interview notes members may not read; PeopleVine prints a preferences chit at the door; Clubessential pushes the member's photo into the POS; SevenRooms buzzes an Apple Watch on VIP arrival. None of this is disclosed in any member-facing document found in this audit, and none of it has drawn public member complaint. The published privacy fear is **lateral** (other members, the press), not **vertical** (the house).

Two caveats against over-reading this: Reddit search coverage here was weak (see §8), and absence of complaint may reflect absence of *awareness* rather than absence of objection — members are not told the door tool prints a dossier.

---

### 6. Pricing

| Club | Initiation | Annual dues | Source |
|---|---|---|---|
| **Soho House** (US, Every House) | — | "approximately $5,200" | 10-K: "With a current US Every House annual membership fee of approximately $5,200, providing access to all of our Houses globally" — https://www.sec.gov/Archives/edgar/data/1846510/000095017025047906/shco-20241229.htm |
| **Soho House** (joining fee, Balham, UK) | "£550" | — | Committee member: "waiving the joining fee of £550" — https://www.reddit.com/r/sohohouse/comments/1v2heeo/sharing_committee_member_perks/ |
| **Chief** | — | "$5,800 annually for VP-level members; $7,900 for C-suite members" | https://fortune.com/2023/03/16/chief-womens-network-startup-price-valuation-waitlist-members/ (as of March 2023) |
| **Zero Bond** (30 and under) | "$750 initiation" | "$2,750 annual dues" | https://luxe.digital/scene/zero-bond-membership-cost/ |
| **Zero Bond** (30–45) | "$1,000 initiation" | "$3,850 annual dues" | same |
| **Zero Bond** (over 45) | "$5,000 initiation" | "$4,400 annual dues" | same |
| **Aman Club, New York** | "it costs US$200,000 just to join" | "US$15,000 per year to be a member" | https://www.scmp.com/magazines/style/lifestyle/travel-hotels/article/3261125/inside-aman-club-nycs-most-expensive-private-members-club-it-costs-us200000-just-join-you-may-find |
| **Founder's Room Speakeasy** (Austin) | "$25,000 membership" (described as "the priciest") | — | https://www.austinmonthly.com/inside-the-trend-of-austins-private-social-clubs/ |
| **Park House Dallas** (Resident, 30+) | "Individual Member: $7,500" (+Spouse $4,000) | "Individual Member: $292/monthly" (+Spouse $146/monthly) | https://www.parkhousedallas.com/membership |
| **Park House Dallas** (Junior, 23–30) | "Individual Member: $2,800" (+Spouse $1,000) | "Individual Member: $146/monthly" (+Spouse $71/monthly) | same |
| **Park House Dallas** (Non-Resident) | "Individual Member: $4,800" (+Spouse $2,750) | "Individual Member: $146/monthly" | same |
| **Park House Dallas** (Culture) | "Primary Member: Waived" | "Primary Member: $500" | same |
| **Park House Plus** (Houston access add-on) | "Waived" | "$1,000/annually" | same |
| The Battery (SF) | UNVERIFIED | reported $2,400 — **not fetched** | UNVERIFIED |
| Casa Cipriani | UNVERIFIED | UNVERIFIED | Bylaws state fees "shall be established by the Proprietor and are subject to change at the Proprietor's sole discretion" and give no figures — https://www.casaciprianinewyork.com/membership/membership-bylaws |
| Core Club | UNVERIFIED | UNVERIFIED | CNBC returned 403 |
| NeueHouse | UNVERIFIED | UNVERIFIED | neuehouse.com/membership publishes no prices |
| San Vicente Bungalows | UNVERIFIED | UNVERIFIED | Rules PDF describes billing mechanics, not amounts |

Chief's scale metrics, same Fortune source: waitlist of "60,000 women"; valuation "$1.1 billion (as of Series B in March 2022)."

Soho House Chicago-area anecdote on price movement, from a member: **UNVERIFIED** beyond thread titles ("Membership price increase by 50%", "What's the justification for increasing the…") which were not opened.

---

### 7. Texas

Coverage here is thinner than the rest and is honestly reported as such.

- **The Cathedral (Austin)** — is **not** a private social club. Its own site describes a coworking product: "From communal co-working memberships to private studios/offices and dedicated desks, our space has all to offer to keep you inspired and help you succeed" — https://www.thecathedralatx.com/. Its membership page is https://thecathedralatx.com/pages/memberships. No member-recognition model published.
- **Headliners Club (Austin)** — runs **Northstar (Sibisoft)**, confirmed by portlet identifiers in fetched HTML (§2). Published dues/recognition model: **UNVERIFIED** (the membership pages were not reachable in this pass; the root returned 403 to WebFetch but 200 to curl).
- **Petroleum Club of Houston** — runs **Clubessential**, confirmed by markup and portal URL pattern (§2). "The page includes a 'Join PCOH' link" but no published dues or initiation figures — https://www.pcoh.com/.
- **The Austin Club** — publishes only an interest form: "Complete the form below to express your interest in becoming a member of The Austin Club. Our team will review your information and follow up with next steps." No dues, no committee, no sponsor requirement published; member area at https://austinclub.com/members-area/ — https://austinclub.com/membership. No vendor fingerprint detected.
- **Austin's club scene generally** — Austin Monthly's survey names Founder's Room Speakeasy, The Malin, Soho House, Pershing, and Highbrow/Lowbrow, and quotes only Chelsea Lavin, brand director for The Malin: "Austin has always been on our radar. It has a thriving VC and tech hub." The piece contains **no** information on vetting or on how staff recognise members — https://www.austinmonthly.com/inside-the-trend-of-austins-private-social-clubs/.
- **Soho House Austin** — member sentiment quoted in §5.
- **Park House (Dallas and Houston)** — the strongest Texas comparable by a wide margin, and the only club in the entire audit that publishes, in its own rules, that it keeps interview notes on members and denies members access to them.

  **Runs Peoplevine** (confirmed, §2). Publishes full pricing and a Club Rules PDF.

  Screening is published explicitly:

  > "The Club's Membership Committee, which shall be appointed by Club Management, will review each prospective Member, including credit and background checks as well as reference checks to verify that the prospective Member satisfies the criteria established by Club Management from time-to-time. However, no individual shall be discriminated against by reason of race, color, religion, sex, ancestry, national origin, age, disability, medical condition, sexual orientation, gender identity, or marital status."

  > "Prospective Members must complete a prospective member information statement, provide letters of reference, if requested, and participate in interviews, as requested by the Membership Committee."

  And then the dossier clause — the single most on-point sentence in this audit:

  > "**Member information statements and membership agreements, interview notes, and all discussions and proceedings of the Membership Committee shall be confidential and not subject to review by anyone other than Club Management.**"

  Likeness capture is opt-out, not opt-in:

  > "From time-to-time, Club-appointed Staff and Photographers/Videographers may be capturing photographically key events. Should you prefer to remain anonymous, please let the Manager on duty know and please position yourself away from the camera. We will do everything we can to respect your privacy and to accommodate your concerns. Park House has the right to film, video or photograph member events and/or activities for use in our membership programming, promotions, public relations, and any other commercial/business purposes."

  Members may not identify each other:

  > "the Club has a strict no-press policy for Members. Members will be held accountable if they disclose or identify any other Members or guests, who visit the Club to any media written communication, radio, television or online news media. This also includes social media platforms such as Facebook, Instagram, Twitter, LinkedIn, Snapchat, YouTube, Vimeo and on personal blogs."

  > "the Club has a no-photo policy on the Premises. No cameras or video recording devices may be used by Members or guests while at the Club. However, we have created a fun, dedicated photo booth for our Members to take personal photos."

  > "Mobile phone etiquette is extremely important to our Members. In the interest of respect of our Members' dining experience, mobile phone usage in the Main Dining Room is not permitted."
  > — all quotes: Park House Houston Club Rules (1-12-24), https://cdn.prod.website-files.com/684f2ff94ca7b759611c7ef2/685ef06b4a5a8b5c6ab6f814_e85441f912a1078a283f51d7064a72ae_Park_House_Houston_Club_Rules_1-12-24.pdf (linked from https://www.parkhousedallas.com/membership)

  Published positioning and pricing, verbatim from https://www.parkhousedallas.com/membership:

  > "Our inclusive, diverse membership stretches across epicureans, creatives, entrepreneurs, philanthropists and beyond."

  > "If accepted, Initiation Fee and Annual dues will be due upon membership approval."

  | Tier | Initiation | Dues |
  |---|---|---|
  | Resident (over 30) | Individual $7,500 / +Spouse $4,000 | $292/monthly / +Spouse $146/monthly |
  | Junior (23–30) | Individual $2,800 / +Spouse $1,000 | $146/monthly / +Spouse $71/monthly |
  | Non-Resident (>100 miles) | Individual $4,800 / +Spouse $2,750 | $146/monthly / +Spouse $0/monthly |
  | Culture | "Primary Member: Waived" | "Primary Member: $500" |
  | Parkhouse Plus (Houston access) | "Waived" | "$1,000/annually" |

  The Culture tier is a published, capped diversity subsidy — a notable design choice:

  > "Culture Members are individuals who have applied and been selected by the Membership Team to enjoy a discounted membership at Park House in order to enhance the cultural experience and diversity of our membership base and to elevate the Club's artistic and creative community."

  > "*We encourage individuals working in these sectors with an income under $70k per year to apply for this special rate."

  > "*Please note - This Membership level will be limited and capped at 4 members each year."

- **The Post Oak, Commodore Perry Estate, The Grove (Houston), Bungalow/Austin Proper, Yellow Rose / LINE Austin, Dallas Petroleum Club, The Houstonian, River Oaks CC** — **UNVERIFIED**. commodoreperryestate.com/club returned HTTP 402. Vendor-fingerprint scans of thegrovehouston.com, thepostoak.com and austinproper.com found no Clubessential / MembersFirst / Northstar / Jonas / Peoplevine / SevenRooms markers. No primary page describing member recognition, introductions, or published pricing was successfully fetched for any of these. Commodore Perry and Hotel Saint Cecilia surface in r/Austin as pool-access alternatives ("Maybe look at the commodore Perry if you are interested in private club with a pool"; "Hotel Saint Celia offers a membership at a better value IMO") — https://www.reddit.com/r/Austin/comments/11zsjoc/is_a_membership_at_the_soho_house_worth_it/ — but neither publishes a recognition model that was verifiable here.

Note: the LINE hotels are relevant to Soho House's corporate perimeter — the FY2024 10-K records "impairment on four LINE and Saguaro hotel management contracts during the fiscal year ended December 29, 2024" (https://www.sec.gov/Archives/edgar/data/1846510/000095017025047906/shco-20241229.htm) — but no Yellow Rose / LINE Austin members club with a published recognition model was verified.

---

### 8. What could not be verified (explicit gap list)

- Reddit is unreachable directly from this environment; all Reddit evidence was proxied via safereddit.com. r/sohohouse searches for "creepy", "dating app", "messaged me", "privacy" and "recognised" returned **zero** results — an absence of evidence, not evidence of absence, given the mirror's weak search.
- Air Mail (paywall), CNBC Core Club (403), Forbes Chief (403), d.DOBS Soho House design sprint (403), sanvicentebungalows.com/page/club-policies (connection refused), thebatterysf.com/membership (404).
- Peoplevine's and Clubessential's published **member-profile field lists** — not retrieved; both sites are JS-rendered or were not reached in this pass.
- The session's WebSearch budget (200 calls) was exhausted before Commodore Perry, The Post Oak and The Grove could be searched; only direct URL guesses were possible after that point.
- **Resolved since first draft** (via the job-postings lane): the staff-facing view is now partly documented — PeopleVine's POX arrival chit field list, Soho House's "Member Recognition" hand-off into OpenTable, and Clubessential's photo-in-POS. What remains **UNVERIFIED** is any club's own *member-facing* disclosure that these staff tools exist.
- Members' reaction to staff-side profiling: no data. Every verified member quote is about service quality, price and vetting credibility. Whether members would object to an arrival brief is **untested** by this audit — treat it as an open research question, not a settled one.
- Remaining hard blocks: Air Mail (paywall), CNBC Core Club (403), Forbes Chief (403), d.DOBS (403), Clubessential.com (403 to automated fetchers), The Battery's Membership Concierge JD (ADP iframe), Casa Cipriani job descriptions, CORE:'s CRM, NeueHouse entirely, commodoreperryestate.com/club (402).
- Job-posting evidence for recognition workflows and named tooling: a parallel lane was dispatched; results pending and deliberately not asserted here.


---


# 3. Relationship intelligence / personal CRM

## Relationship intelligence / personal CRM

Source-grounded audit. Every claim below carries a verbatim quote + the exact URL fetched. Search snippets were not accepted as sources. Items that could not be confirmed against a fetched page are marked **UNVERIFIED**.

### TL;DR for the arrival brief

| Product | Score exposed? | Form | Reasoning shown? |
|---|---|---|---|
| **Affinity** | **Yes** | `10`–`100` in UI + green/orange/gray bars; `0.0`–`1.0` in API | **No** factor breakdown. Warm Intro Agent renders a short "Why:" evidence string |
| **Attio** | **Yes** | 6 named bands: `No Connection` → `Very Strong` | No |
| **Clay → Mesh** | **Yes** ("Network Strength") | Banded **signal bars**, *relative to your other relationships* | No |
| **folk** | **Yes** ("Strongest Connection") | Names a **person**, not a level | Factors documented, not shown per-contact |
| **4Degrees** | Yes (claimed) | **UNVERIFIED** — no scale published | No |
| **Introhive** | Yes (claimed) | **UNVERIFIED** — no scale published | No |
| **Nexl** | Yes (claimed) | **UNVERIFIED** — no scale published | No |
| **Dex** | **No** — user-dragged tiers only | n/a | n/a (nothing to explain) |
| **Monica** | **No** — manual cadence field | n/a | n/a |
| **Nat** | **No** | n/a | n/a |

**The gap:** every product that scores hides the arithmetic. Affinity states this is deliberate. Nobody ships a per-person "here is why this number" breakdown — which is precisely the arrival brief's differentiator.

---

### Affinity (affinity.co)

Relationship-intelligence CRM for private capital. Auto-captures the firm's whole email/calendar corpus and turns it into a ranked intro graph.

> "Affinity captures every email, meeting, and calendar interaction automatically, then turns it into the warmest path to your next deal."
> — https://www.affinity.co/product

> "Affinity's relationship graph has been compounding since 2014: 500M+ structured relationships across 3,300+ firms, built from 22B+ captured emails and calendar events."
> — https://www.affinity.co/product

**Person page sections** — https://support.affinity.co/s/article/Navigating-profile-pages-in-Affinity.md
Action bar: "Log Interactions, Set Reminders, Upload Files, Edit Name/Email/Domain, Export Notes, Merge Duplicates, or Delete Entity". Then "Overview - General data (enriched and global fields)", "Overview - Opportunities data (list-specific fields)", "Overview - Lists data (list-specific fields)", and tabs "Connections, Introductions, Notes, Reminders, and Files".

Activity Timeline: "Ability to see a chronological timeline of **Sent/Received emails**, **Meetings**, **Phone calls**, **List activity**, **Files**, **Notes**, and **Reminders**."

**Person object, API v1** — https://api-docs.affinity.co/
`id`, `type`, `first_name`, `last_name`, `emails`, `primary_email`, `organization_ids`, `opportunity_ids`, `current_organization_ids`, `list_entries`, plus:

> "An object with seven string date fields representing the most recent and upcoming interactions with this person: first_email_date , last_email_date , last_event_date , last_chat_message_date , last_interaction_date , first_event_date and next_event_date ."

Note: the base v1 Person object has **no** strength field — strength is a separate resource.

**Enriched person fields** — https://developer.affinity.co/pages/data-share/persons_v1_0.md
`affinity_data_job_titles`, `affinity_data_industry`, `affinity_data_location`, `source_of_introduction` ("How this person was introduced/sourced"), `affinity_data_phone_number`, `affinity_data_linkedin_url`, `affinity_data_birthday`, `eventbrite_rsvp`, `eventbrite_attended`, `mailchimp_opened`, `mailchimp_clicked`, `mailchimp_bounced`, `affinity_data_current_job_title`, `affinity_data_linkedin_profile_headline`, `affinity_data_keywords`, `affinity_data_current_organization_headcount`, `affinity_data_education`, `affinity_data_years_of_experience`, `affinity_data_current_job_functions`, `affinity_data_current_job_seniorities`, `affinity_data_current_job_start_date`, `affinity_data_normalized_job_titles`.

#### THE SCORE — three published scales, mutually unreconciled

**(a) In-app UI: 10–100 plus a 3-color band** — https://support.affinity.co/s/article/Leveraging-your-Connections-and-Relationship-Strengths.md

> "A relationship strength is a numerical score given to your connections that ranges from 10 (weak) - 100 (strong). Relationship strengths are calculated based on the recency and frequency of interactions between two individuals. The scores are also ranked by different colored bars."

> "1. Green bars represent strong connections
> 2. Orange bars represent average connections
> 3. Gray bars represent weak connections"

Band cutoffs are **UNVERIFIED** — not published.

**(b) API v1: float 0–1** — https://api-docs.affinity.co/

> "Affinity calculates relationship strengths between internal and external people based on previous interactions (emails, logged calls, calendar events)."

> "A higher numeric value means that the relationship strength between the two people is higher. Emails, calls, and meetings don't tell the whole story of a relationship, so treat the strength as an estimate."

> "Relationship strengths are usually recalculated daily."

Schema: `strength` | `float` | "The actual relationship strength. This is currently a number between 0 and 1, but may change in the future." Resource is `{internal_id, external_id, strength}` — **no evidence fields**.

**(c) API v2 `interactionScore`: 0.0–1.0 with published bands** — the most explicit statement anywhere — https://developer.affinity.co/api-reference/2026-07-15/persons/get-relationships-for-a-person.md

> "The `interactionScore` is a value between `0.0` and `1.0` that reflects how frequently the two persons interact across email, calendar events, and chat messages. The more interactions, the higher the score. Recent interactions are weighted slightly higher than older ones. As rough guidance, scores at or above `0.7` typically indicate two persons that communicate regularly, scores between `0.4` and `0.7` indicate occasional communication, and scores below `0.4` indicate only sporadic communication."

Response is `{person1, person2, interactionScore, linkedIn}`, `minimum: 0`, `maximum: 1`, `example: 0.72`. Default sort `-interactionScore`.

#### Is the reasoning shown? No — and deliberately so

No "based on 47 emails and 3 meetings" exists in any fetched source. Data Share `relationship_strengths` columns are only `internal_person_id`, `external_person_id`, `strength`, `id`, `is_deleted`, `last_updated_at` (https://developer.affinity.co/pages/data-share/relationship_strengths_v1_0.md).

The user is sent to the timeline to reconstruct evidence by hand:

> "Click on the team member with the strongest connection to see their activity timeline with this contact — emails, meetings, and notes. This gives you context before you ask."
> — https://support.affinity.co/s/article/Find-warm-introductions-to-a-target.md

And Affinity states the opacity is by design:

> "**You won't see a confidence number** — it works quietly in the background, **the same way relationship strength does for your explicit relationships**."
> — https://support.affinity.co/s/article/Understanding-inferred-connections.md

> "**Do I see a confidence score?** No. Confidence scoring runs in the background to rank what surfaces, but it isn't shown in the product."
> — same URL

**The one place a "why" is rendered** — Warm Intro Agent, https://support.affinity.co/s/article/Warm-Intro-Agent.md:

```
Best path to Greenfield Systems (founder)
  Jordan Lee — strongest relationship
  Why: emailed last month · shared board seat
  Alternate: Priya Shah (met at conference, weaker)
[ Use Jordan ]   [ Use alternate ]
```

> "Each suggested path shows *why* it's a strong route (the relationship evidence)."
> "**How does it rank the paths?** Relationship strength across your firm's interaction data — and it shows that evidence."

Caveat: this is an illustrative doc code block, not a screenshot. Exact production wording **UNVERIFIED**.

Inferred-connection cards do carry reasoning strings — https://support.affinity.co/s/article/Understanding-inferred-connections.md:
> "**Work-history row** — e.g. *"5 teammates have overlapping work history."*"
> "**Funding row** — e.g. *"Carol Channing was a Partner at Greenleaf Investing when it funded Potluck under CTO John Smith."*"
> "*"Carol Channing was an investor at Greenleaf Investing 8 months ago when Potluck raised its Series B on March 25, 2025."*"

Note the design stance: "no invented strength score; the basis *is* the value" (same URL).

**Connection taxonomy** — https://support.affinity.co/s/article/Leveraging-your-Connections-and-Relationship-Strengths.md
> "**People You Know** - These are the people you have directly communicated with."
> "**People Your Allies Know** - These are the people that your allies have directly communicated with"
> "**Inferred Connections** - These are the people that you/your team can potentially get introduced to based on previous shared work experience."
> "**1st Degree** - Someone you directly know and have communicated with." / "**2nd Degree** - Someone who knows one of your 1st degree connections, but you don't directly know."

Not exportable: "Connections and Relationship Strengths can **not** be exported directly from the Affinity CRM." (same URL)

#### Data sourcing

> "Affinity syncs Gmail, Outlook (Microsoft 365), and Exchange. The sync is one-way: Affinity reads your inbox metadata (sender, recipient, subject, timestamp) and optionally message bodies." / "By default, Affinity syncs everything."
> — https://support.affinity.co/s/article/Tutorial-0-2-connect-inbox-and-calendar.md

Three consent scopes, Affinity's own words — https://support.affinity.co/s/article/Syncing-data-into-Affinity.md: "1. **View your email messages and settings**", "2. **Send emails on your behalf**", "3. **Access your calendar**". Same page:

> "Affinity will scan for phone numbers and job titles within the email signatures of contacts to auto-populate the **Phone Number** and **Current Job Title** fields as contacts get auto-created."

> "Any email interaction that gets synced into Affinity will remain in your Affinity CRM, regardless of whether it gets deleted/archived from your inbox."

> "Affinity will also sync/surface meetings that are marked private. If there are external contacts involved, these private meetings will appear on the external contacts' respective profile pages."

Enrichment vendors, named: "Enriched with Affinity's proprietary data and 40+ sources, including Pitchbook, Preqin, and Grata." (https://www.affinity.co/product); "Advanced enrichment from PitchBook, Dealroom, and Crunchbase" (https://www.affinity.co/pricing).

#### Privacy

Three per-user sharing settings, default is most private — https://support.affinity.co/s/article/Setting-up-your-privacy-preferences-in-Affinity.md:

> "**Share All** - All of your email subjects, email content, meeting titles, and meeting details will be shared with your organization."
> "**Share Subjects Only** - Only your email subjects and meeting titles will be shared. Your email content and meeting details will be hidden from your organization but will still be visible to you."
> "**Hide All (Default)** - All of your email content and meeting details will be hidden from your organization, but will still be visible to you. Your team will only see the participants associated with the interaction, followed by the date and time the interaction took place."

Critical gotcha, same URL:
> "If you and your team members have different personal privacy preferences, but are all involved in an interaction with an external contact, **the privacy preference that is most revealing out of all users will take precedence.**"

Blocklist: hides "Their email address", "All interactions associated with them", "Connections and Relationship Strengths" — for "(e.g. spouse, doctor, accountant, etc.)".

Human-reading clause — https://www.affinity.co/legal/privacy-policy:
> "This data will be read by humans only in the following cases:
> As part of the app's user interface, as controlled by your Affinity privacy settings
> If we obtain your affirmative agreement to view specific data from your account
> If it is necessary for security purposes (such as investigating a bug or abuse)
> If it is necessary to comply with applicable law
> As necessary for internal operations, provided that the data have been aggregated and anonymized"

> "This data will not be used for serving advertisements."

Security — https://www.affinity.co/enterprise-grade-security: "SOC 2 Type II — Audited annually for security, availability, and confidentiality.", "ISO 27001 — Certified against the global standard for information security.", "Sensitive data is encrypted at rest and in transit." (Note: this page and /product carry visible unfinished CMS placeholder "Lorem ipsum dolor sit amet" blocks.)

#### Alliances — cross-firm intro network

https://support.affinity.co/s/article/Getting-started-with-Affinity-Alliances.md
> "Affinity Alliances will enable you to share your network with your close colleagues and friends so that you can prospect better and mutually benefit from warm introductions."
> "Your allies will **not be able to see your email or calendar data**. In the same way, you will not be able to see their email or calendar data. Your allies will only be able to see your relationship strength with people you know."
> "1. Who you know (Full name of your connections) 2. How well you know them (Relationship strength you have with your connections)"
> "If you are **not** paying for the Affinity CRM, you can still use Affinity Alliances as a standalone platform for **free**"

**Design note for arena-hall:** what crosses the trust boundary is *the score plus the name* — never the underlying evidence. That is a clean precedent for sharing a rating without leaking the corpus behind it.

#### Pricing — https://www.affinity.co/pricing

| Tier | Price (verbatim) | ≈ per user/month |
|---|---|---|
| Essential | "$2,000" / "USER / YEAR" | ~$167 |
| Scale | "$2,300" / "USER / YEAR" | ~$192 |
| Advanced | "$2,700" / "USER / YEAR" | ~$225 |
| Enterprise | "Custom Pricing" | — |

Every tier's button reads "Contact sales"; no self-serve checkout. Minimum seat count **UNVERIFIED**. Essential includes "Relationship scoring: see the warmest path to any contact". Named line items on the comparison table: "Relationship Graph", "Relationship Strength Score", "Warm Intro Path", "LinkedIn Importer", "Alliances".

---

### Clay (clay.earth) — now **Mesh** (me.sh)

**Status change:** `https://clay.earth/` returns `301 Moved Permanently` → `https://me.sh/`. Clay was acquired by Automattic and rebranded to Mesh. Footer of https://me.sh/: "© 2026 Automattic Inc." Help center is now `library.me.sh`.

> "Every relationship, remembered." / "Mesh brings together everyone you've ever met. Automatically organized, intelligently searchable, always up to date."
> — https://me.sh/

**The person page is a "Card"** — https://library.me.sh/knowledge-base/about-cards/

> "Cards are at the heart of Mesh. They provide an overview of how you know someone, the last time you interacted, and what platforms you're connected on. Any notes you take are gathered in a person's card, and you'll be able to view related people. Cards also summarize how long you've known each other and how much you interact and present a timeline of your first, most recent, and upcoming interactions."

Sections (verbatim headings, same URL): **Timeline**, **About**, **Starred**, **Contact**, **Reconnect Cadence**, **Group**, **Edit**, **Merge**, **Network Strength**, **Properties**, **Related People**, **Sources**.

- Timeline: "Timeline brings together Moments — your first, last, and upcoming calendar events, emails, and text messages — with your notes about a person."
- About: "their bio, work experience, and education which we pull from their LinkedIn profile"; "their most recent social updates like changes in their Twitter bio or location"; "interests determined by their activity on Twitter, LinkedIn, and Facebook"
- Related People: "Whenever you mention another person in a note using @, Mesh shows that they're related. Since relationships are bidirectional, each person will show up under the other's Related People."
- Sources: "Mesh uses your integrations to display how you're connected to people."

#### THE SCORE — "Network Strength", banded, relative

> "Network Strength shows the strength of your relationship with a given person relative to your other relationships. It's entirely personalized to you and leverages all of your moments from all of your accounts to understand whether you're losing touch with someone."
> — https://library.me.sh/knowledge-base/about-cards/

> "Network strength indicators appear on a contact's profile and also in Search so you can quickly see how well you know particular people as you browse."
> — same URL

Rendered as **signal bars** ("the **signal bars** appear inline"), i.e. banded, and explicitly **relative/percentile-like**, not absolute.

Team-wide variant — the closest analogue to "who else here should you meet":
> "On a profile, the Network Strength section shows every member of your team and how well they know a given contact. In Search, the signal bars appear inline and show you the person on your team who best knows that contact, so it's easy to see who on your team manages the relationship and who you should reach out to."
> — same URL

A second score drives Starred: "Mesh analyzes your relationship strength by using the context and frequency with which you interact with someone to show certain people more often." And sorting: "**By Relevance**: We identify your closest and least close contacts based on your interactions." (https://library.me.sh/knowledge-base/people/)

**Reasoning shown: no.** Inputs are named; no per-contact factor breakdown exists in any fetched doc. **UNVERIFIED** that any explanation UI exists.

#### Surfacing — "Home" and "Reconnect"

> "In Home, Mesh presents a real-time, high-level view of what's happening in your network and who you should be thinking about today."
> — https://library.me.sh/knowledge-base/home/

Home components (verbatim headings): **News**, **New Members**, **Birthdays**, **Reconnect**, **Reminders**, **Events**, **Social Changes**, **Posts**.

> "Reconnect is a simple and extremely powerful way to be thoughtful with people over time. When Mesh notices you haven't spoken to someone in a while, we will surface their card in Home."
> "By default, Mesh will remind you about 3 people we think you should reflect on each day. Say hi if you want, read your notes to remember your previous conversation, or just dismiss the reminder if there's nothing to say."
> — same URL

Reconnect is recency-anchored, not calendar-anchored — https://library.me.sh/knowledge-base/reconnect/:
> "When you set a Reconnect cadence, Mesh doesn't just count from when you created the reminder—it updates based on your actual conversations."
> "Let's say you set a weekly reminder for Jane on June 1st. Normally, you'd get reminded on June 8th. But if you happen to text Jane on June 5th, Mesh detects this interaction and automatically moves your next reminder to June 12th"

Cadences: "**Weekly** (7 days) / **Monthly** (1 month) / **Quarterly** (3 months) / **Yearly** (1 year)", plus "**Automatic**" and "**Disable**".

Design philosophy worth stealing — https://library.me.sh/knowledge-base/the-mesh-method/ names four principles: "Remember the important things. / Embrace serendipity. / Do your research. / Show up." They deliberately inject noise: "Mesh's incredibly powerful Search returns the right person or people but intentionally introduces some serendipity into search results… (sorted by relevance and how well you know someone)".

#### Data sourcing — the most restrictive in this cohort

All from https://library.me.sh/knowledge-base/security-and-privacy/:

> "Mesh asks for the most restricted access that each integration allows, which is read-only." / "Connected calendars are only used to create contacts, show your meeting history with someone, and remind you to take notes after meetings."

> "Mesh asks for the most restricted access that each integration allows, which is 'email headers only'. This means Mesh can only read the recipients and subject line of the message — not the body of the message"

> "Message data is never read directly—Mesh computes aggregate statistics like how often you've texted someone, but never accesses message text."

> "Connected social media accounts are only used to create contacts based on the people you've connected with directly (i.e. 'first-degree connections')."

Enrichment vendors are **not named** — **UNVERIFIED** who they are:
> "Please keep in mind that the data you see on contact cards is provided through our data partners and will vary based on what is available to them for each person. The stricter someone is with their online data privacy settings, the less information we'll have for them."
> — https://library.me.sh/knowledge-base/about-cards/

#### Privacy — best-in-cohort framing

> "Privacy and security are too important for legalese."
> "Mesh does not own your data, nor do we sell it to others or use it for advertising. It's your data, period."
> "Mesh is SOC 2 certified, and all data is encrypted in transit and at rest."
> "AI features are entirely opt-in. You choose whether to use them."
> "Nexus and Mesh do not use your data to train our models."
> "We do not allow any partners or third parties to use your data to train their models or any other purpose."
> "Contact information (i.e. an email address or telephone number) is only accessible to a user who explicitly added that information… This information isolation is reinforced with software safeguards"
> — all https://library.me.sh/knowledge-base/security-and-privacy/

Disclosed caveat (which then happened — Automattic): "In the future, we may sell to, buy, merge with, or partner with other businesses. In such transactions, user information may be among the transferred assets."

**On the "is this creepy?" question — UNVERIFIED / does not exist.** Their own help-center search `https://library.me.sh/?s=creepy` returns "No results found." The word appears on none of the security/privacy, Mesh Method, or home pages. **Do not cite a Clay creepiness post as existing.** The nearest artifact is the Public Profiles FAQ, which handles the "you have a page about me and I never signed up" objection — https://library.me.sh/knowledge-base/what-are-public-profiles-can-i-remove-them/:

> "Each public profile only shows publicly available data that we collect through data partners, so there's no need to worry that Mesh is sharing sensitive information."
> "If you'd prefer we remove your public profile, send us a message at care@me.sh and we'd be happy to do so!"

#### Pricing — https://me.sh/pricing

| Tier | Published |
|---|---|
| Personal | "Free" / "Up to 1000 contacts" |
| Pro | "$10 / month" (annual rate) |
| Team | "$40 per seat / month" |
| Enterprise | "Let's Chat" |

Help center gives the monthly/annual split — https://library.me.sh/knowledge-base/subscription-plans/: "Monthly, for $20 per month" and "Annual, for $120 per year, which comes out to $10 per month". **Discrepancy:** that same page says "Mesh for Teams starts at just $49/seat/month" vs $40 on the pricing page.

Card required for trial: "Requiring a valid credit card to access the platform allows us to filter out illegitimate users and prevent nasty stuff like spam and bots" (https://me.sh/pricing).

---

### Dex (getdex.com)

> "Dex is short for 'rolodex' (remember those?) and serves as a digital rolodex for the 21st century. Dex provides a single source of truth to organize your connections across phone/email contacts, Facebook, LinkedIn, and 15+ other sources."
> — https://getdex.com/docs/faq/aboutdex

**Contact Card sections** — https://getdex.com/docs/workflows/manage-your-contacts: **Map View 🌎**, **Related Contacts 🔗**, **Group Map 🗺️**, **Priority Map 🎯**, **Enhance ✨**, **Custom Fields 😎**, **Contact Timeline 📜**.

> "Every contact in Dex has a timeline that brings your notes, calendar events, emails, and reminders together in one place."

Enhance pulls exactly: "LinkedIn Bio / Experience / Education / Location / Profile Photo / Title".

#### NO SCORE — the clean negative

No computed relationship score, strength meter, percentile, or ranking exists anywhere in Dex's docs. What Dex ships instead is **user-declared priority** — the human ranks, not the model:

> "Rank your relationships by how much you want to invest in them, so you always know who to focus on. There's no wrong answer — the tiers are yours."
> — https://getdex.com/docs/workflows/manage-your-contacts

> "**Drag contacts into a tier** to rank who matters most. / **Click to rename tiers** to fit your life. / **Set a priority** on any contact to mark how much they matter."
> — same URL

"There's no wrong answer — the tiers are yours" is the load-bearing philosophical opposite of Affinity/Mesh.

#### Surfacing — Keep-in-Touch (KIT)

> "Keep-in-touch reminders so relationships never go cold" — https://getdex.com/

> "**Standard reminders** — These are one-time or recurring follow-up reminders you set for a specific task, event, or action (e.g., 'Follow up about proposal on May 10'). They trigger based on a fixed date/time you choose"
> "**Keep-in-Touch** (KIT) reminders — KIT reminders are relationship cadence reminders automatically calculated based on the last interaction with a contact plus a frequency interval you set (e.g., every 3 months)."
> — https://getdex.com/docs/workflows/reminders

Anti-fatigue cap: Dex limits notifications to a maximum of 5 per day; overdue contacts "display in red text" (https://getdex.com/docs/workflows/keep-in-touch).

Daily Digest — https://getdex.com/docs/ai/messaging-dex:
> "📅 Get Your Daily Digest — Start each day informed. Dex sends you a morning text with: Today's birthdays 🎂 / People you should reconnect with / Calendar events and who you're meeting / Keep-in-touch reminders / Any title changes in your network (when LinkedIn is connected)"

**Resurface Connections** — a strong precedent for a 90-second digest:
> "Dex intelligently reminds you about people you talked with in the past. Like a 'this day in history' for your relationships. You might get a text like: '30 days ago, you connected with Alex Thompson about their startup idea. Might be worth checking in!'"
> — same URL

#### Data sourcing — reads email bodies

Google OAuth scopes, verbatim — https://getdex.com/privacy/:
> "(d) Gmail data (message metadata such as sender, recipients, subject and date, **and message content**), which we read for two features… matching subject, participants and body text and showing a short snippet of each result."

**Contradiction worth noting:** the marketing docs claim "The sync displays metadata only, revealing the subject and date/time of the email" (https://getdex.com/docs/workflows/stay-informed) — which conflicts with the privacy policy's "and message content".

LinkedIn is credential-based, not OAuth — https://getdex.com/docs/integrationsandfeatures/syncfeatures/sync-linkedin: "A LinkedIn sign-in window opens inside the app. Enter your LinkedIn credentials and complete any two-factor prompt."

**Named enrichment/AI vendors** (Dex names them; Mesh does not) — all https://getdex.com/privacy/: "**EnrichLayer** supplies publicly available professional profile information used to enrich contact records."; "**Bright Data** provides the network infrastructure used to retrieve publicly available professional profile information."; "**Groq**"; "**CloudSponge** powers our address-book import"; "**OpenRouter**"; "**OpenAI**"; "**Deepgram**"; "**SendGrid**".

#### Privacy

> "We understand what you put into Dex is private. These are birthdays, friends, and anniversaries."
> "We're committed to handling data with respect for your privacy. This is why Dex is supported by subscriptions, not anything else. We never sell your data to third parties."
> "When users add data from third-party sources, any data we receive is never sold or used for advertising purposes."
> — https://getdex.com/security/

Careful wording: "All of our servers and databases are hosted in the US with SOC 2 and ISO 27001 certified providers" — that is Dex's *hosts*, not Dex. Dex's own "SOC 2 report" appears only under Enterprise on https://getdex.com/pricing.

**Tension to flag:** the no-sale claim covers contact data, but the same privacy policy discloses a marketing ad stack: "These providers may set cookies or similar technologies and may receive information about your visit for their own purposes, **including cross-context behavioural advertising**." Named: Meta, Reddit, TikTok, Google Ads, X, Dub, and:
> "**RB2B** (GetEmails, LLC) is a business-intelligence provider that we enable on a limited number of marketing pages to identify the companies, and in some cases the individuals, visiting those pages."
> — https://getdex.com/privacy/

#### Pricing — https://getdex.com/pricing

| Tier | Annual | Quarterly | Monthly |
|---|---|---|---|
| Premium | "$12/mo" | "$16/mo" | "$20/mo" |
| Professional | "$20/mo" | "$27/mo" | "$34/mo" |
| Enterprise | "Talk to us at kevin@getdex.com" | | |

"Premium and Professional start with a 7-day free trial. No credit card required".

---

### Attio (attio.com)

General-purpose modern CRM, but ships relationship strength as a **first-class standard enriched attribute** — the cleanest banded-score precedent found.

**People standard attributes** — verbatim from https://attio.com/help/reference/managing-your-data/objects/manage-standard-objects:

| Attribute | Description |
|---|---|
| Record ID | "Unique ID generated when a record is created" |
| Email addresses | "Email address(es) for the person" |
| Company | "Person's primary place of employment" |
| Job title | "Person's job title" |
| Phone numbers | "Person's phone number(s)" |
| Description | "Brief summary about the person" |
| Primary location | "Person's location" |
| Social media URLs | "Facebook, LinkedIn, Twitter, AngelList, Instagram" |
| Twitter follower count | "Approximate number of followers on Twitter (X)" |
| First interaction | "Earliest interaction date/time (when) or workspace member" |
| Last interaction | "Most recent interaction date/time (when) or workspace member" |
| Next interaction | "Soonest upcoming interaction date/time (when) or workspace member" |
| **Connection strength** | "Workspace's connection strength with the company" |
| **Strongest connection** | "Workspace member with the strongest connection" |
| Associated deals | "Relationship to deal records" |
| List Entries | "Lists the person is in" |
| Next due task | "Due date of the next upcoming task linked" |

#### THE SCORE — 6 named bands

Verbatim from https://attio.com/help/reference/managing-your-data/enriched-data (section "Communication intelligence" under "Enriched object attributes"):

> "Connection strength": The strength of your connection with the record, "No Connection", "Very Weak", "Weak", "Good", "Strong", or "Very Strong", based on all workspace members' interactions with the record, and factors like response frequency and recency

> "Strongest connection": The workspace member with the strongest connection with the record based on all interactions

Calculation — https://attio.com/help/reference/attio-101/productivity/communications-intelligence:
> "Attio also automatically calculates your `Connection strength` with a particular company or person by weighting the recency and frequency of the communication."

**Reasoning shown: no.** No factor breakdown documented.

#### Data sourcing & privacy — three-level email permission

> "By default, Attio restricts email permissions to 'Subject line and metadata.' However, you can adjust this to 'Metadata only' or grant 'Full Access' to everyone in your workspace."
> — https://attio.com/help/reference/attio-101/productivity/communications-intelligence

Auto-enriched attributes — https://attio.com/help/reference/managing-your-data/enriched-data:
> "**Name**, **Profile picture**, **Description**, **Location** (**City**, **State**, and **Country**), **Social media** (**Facebook** and **Twitter**), **Company**, **Job title**, **Twitter Follower Count**"

Enrichment vendors are **not named** — **UNVERIFIED**.

#### Pricing — https://attio.com/pricing

| Tier | Monthly | Annual |
|---|---|---|
| Free | "$0/user/month" (up to 3 seats) | — |
| Plus | "$44/user/month" | "$35/user/month" |
| Pro | "$99/user/month" | "$79/user/month" |
| Enterprise | "Custom pricing, billed annually" | — |

Free tier includes "Real-time contact syncing" and "Automatic data enrichment".

---

### folk (folk.app)

**Contact profile sections** — https://help.folk.app/en/articles/5007276-contact-profile:
1. **Details** — "Contact details will display all the fields linked to your contacts"
2. **Team interactions** — "display all the interactions synchronized from your email sync (emails & calendar events), and the interactions added manually"
3. **Notes** — "display all the notes added to the person"
4. **Reminders** — "display all the upcoming reminders created on the person"

On a company profile: "For each person, you can see their name, job title, last interaction date and strongest connection."

**Contact fields** — https://help.folk.app/en/articles/4991006-contact-fields:
- Native (People): "First name, Last name, Emails, Phone numbers, Job title, Companies, URLs, Birthday, Gender, Addresses"
- Metadata: "Created at, Created by, Added to group at, Added to group by"
- **Smart Fields (People)**: "My Last interaction, My total interactions, Team Last interaction, Last interaction by, **Strongest connection** and Groups"

#### THE SCORE — "Strongest Connection" names a person, not a level

folk's smart field resolves to *which teammate* knows the contact best — the same shape as Attio's "Strongest connection" and Mesh's team Network Strength, and directly analogous to "who else here should you meet". It is a **ranking output, not a displayed magnitude**. Whether folk also surfaces a magnitude is **UNVERIFIED**.

Documented inputs (per folk's help center, surfaced via search — **the underlying article was not fetched directly, so treat the factor list as UNVERIFIED**): number of interactions, days since first interaction, type of interaction (1:1 vs group emails), bilateral vs one-way, days since last interaction.

**Reasoning shown: no** per-contact breakdown.

#### Surfacing

Homepage feature names — https://www.folk.app/:
- "**Follow-up Assistant**" — "Scans your conversations to identify optimal follow-up timing and draft emails"
- "**Recap Assistant**" — "Automatically summarizes notes and interactions and shares a short brief"
- "**Research Assistant**", "**Workflow Assistant**"
- "**1-click Enrichment**" — "Find missing contact details with waterfall enrichment"

#### Data sourcing — reads email bodies, names its vendors

> "Apollo.io, People Data Labs, Clearbit, Datagma, Prospeo & DropContact"
> — https://help.folk.app/en/articles/6804416-data-enrichment

Enrichable fields: "Email, Phone number, Company name, Job Title, Contact URLs". "Each field that is successfully enriched will be deducted from your monthly allowance."

#### Privacy — https://help.folk.app/en/articles/5007534-security-privacy

> "folk reads and stores email message data — including message bodies — so that interactions appear alongside your contacts."
> "This data is **encrypted at rest**, and all email data is **deleted when you remove the source or delete the workspace**."
> "We **never sell** your personal data, and we **never use it to train AI models**."
> "Data used by our AI features is processed through OpenAI's APIs and is **never used to train models**."

#### Pricing — https://www.folk.app/pricing

| Tier | Annual | Monthly |
|---|---|---|
| Standard | "$24/member/month" | "$30/member" |
| Premium | "$48/member/month" | "$60/member" |
| Enterprise | "$80/member/month" | "$100/member" |

Enrichment credits: 500/mo (Standard), 1,000/mo (Premium).

---

### 4Degrees (4degrees.ai)

> "Your relationship network is your firm's most valuable asset."
> "Find your best intro to a company, investor, or industry expert with relationship strength scoring."
> — https://www.4degrees.ai/

> "No more asking, 'who knows the CEO of this company and can make an introduction.'"
> — https://www.4degrees.ai/

> "Instantly see your clearest path to a company or person through your team's network with our relationship strength scoring"
> — https://www.4degrees.ai/why-4degrees

**THE SCORE:** claimed but **the form and scale are UNVERIFIED.** No fetched 4Degrees page states whether the score is numeric, banded, or a percentile, nor any range. From https://www.4degrees.ai/relationship-intelligence:

> "assign a relationship strength score, helping you quickly identify your strongest connections."
> "analyzes how frequently and recently you've interacted with a contact through emails, meetings, and shared calendar events"
> "updates in real-time, so you always know who is engaged and who might be going cold"

**Reasoning shown:** no description of any user-facing explanation. **UNVERIFIED.**

**Data sourcing** — https://www.4degrees.ai/privacy-policy:
> "email header information (the date a file was created, the email address of a recipient, IP addresses) and calendar meeting information (e.g. times, places, attendees and contacts)"

Bodies are opt-in — a notable middle position between Mesh (headers only) and folk/Dex (bodies):
> "Our access to the body of emails and calendar items is controlled by you through your settings"
> "You have choices about the information on your profile and the extent to which we have access to your email messages."

Enrichment: contact data is combined "with information from other 4Degrees users…as well as public data, other publicly available information and information we receive from third parties." Vendors not named — **UNVERIFIED**.

**Pricing** — contact-sales only, https://www.4degrees.ai/pricing:
> "At 4Degrees, we charge on a per-user per-month model. The exact pricing depends on a few factors specific to your organization and team, so we will need to get in touch to give you the most accurate pricing information."

---

### Introhive (introhive.com)

> "Your AI Doesn't Know Who Knows Whom"
> "Clear picture of who knows who, and the strength of those connections"
> — https://www.introhive.com/

**THE SCORE:** claimed, but **no scale is published on any page I fetched — UNVERIFIED.** Both https://www.introhive.com/relationship-intelligence/ and https://www.introhive.com/contact-management/ describe strength qualitatively and never state a range, band set, or percentile. The blog https://www.introhive.com/blog/what-is-customer-relationship-score/ says only:

> "A customer relationship score is calculated automatically using the communication data your firm already generates every day."
> "It looks at the frequency, recency, and depth of communication, factoring in both volume and quality indicators."

No numeric scale, no formula, no statement about user-facing explanation. **Reasoning shown: UNVERIFIED.**

**Data sourcing — metadata only, per the privacy policy.** Section 4.5 enumerates personal data types verbatim:
> "Marketing data, Address book data, Email meta data, Calendar meta data, CRM data"
> — https://www.introhive.com/privacy-policy/

Notably **absent**: any employee-level opt-out, personal-email carve-out, or consent requirement. The only opt-out language is generic (§6.4): "If personal data is to be used in a way not previously disclosed or shared with external parties not covered in this Privacy Policy, you will be provided the opportunity to opt-out." Given the product scans an entire firm's mail, this is a thin privacy posture relative to Affinity's per-user Hide-All default.

**Pricing:** not published; contact-sales. Third-party per-seat estimates exist but are **UNVERIFIED** and not cited here.

---

### Nexl (nexl.cloud — `nexl.io` 301-redirects here)

Legal-sector relationship/CRM platform.

> "See who-knows-who across the firm, without manual data entry"
> "Unified relationship intelligence across the firm"
> — https://nexl.cloud/

> "Nexl maps your firm's strongest ties to any person or company, so partners pitch always warm"
> "Open any contact to see the firm's full history: emails, meetings, event engagement and colleague notes."
> — https://nexl.cloud/platform/crm

**THE SCORE:** claimed, form **UNVERIFIED**:
> "Nexl analyzes emails, meetings, and activity trends to surface relationship strength in real-time, so lawyers and BD teams know which relationships are thriving, which are fading, and where to act next."
> — https://nexl.cloud/platform/crm

> "Scores the depth and recency of each relationship across the firm" / "Helps prioritize where to invest BD time and who to include in pitches."
> — https://nexl.cloud/resources/what-is-relationship-intelligence-a-guide-for-law-firms

No numeric scale, band set, or percentile is published. **Reasoning shown: UNVERIFIED.**

**Privacy — the strongest metadata-only claim in the cohort:**
> "Platforms like Nexl use header-only capture, meaning only the metadata of communications is processed: sender, recipient, and timestamp. The content of emails is never stored."
> — https://nexl.cloud/resources/what-is-relationship-intelligence-a-guide-for-law-firms

> "every email, meeting and calendar interaction, analyzing metadata only and never reading email content."
> — https://nexl.cloud/platform/crm

Trust center at https://trust.nexl.cloud/. **Pricing: not published — UNVERIFIED.**

---

### Monica CRM (open source)

The public data model is the most useful artifact here — real field names for a "how do you know this person" schema, all manually entered.

Repo: https://github.com/monicahq/monica — "Personal CRM. Remember everything about your friends, family and business relationships." License **AGPL-3.0**, ~25.2k stars (https://api.github.com/repos/monicahq/monica).

> "Monica helps you keep track of the people in your life—the things they tell you, the moments you share, and the promises you definitely intended to remember."
> — https://www.monicahq.com/

#### The contact schema — actual field names

**v4 branch** (`app/Models/Contact/Contact.php`, branch `4.x`) — richest for relationship intelligence. `$fillable` verbatim:

```
'uuid', 'first_name', 'middle_name', 'last_name', 'nickname', 'gender_id',
'description', 'account_id', 'is_partial', 'job', 'company',
'food_preferences', 'birthday_reminder_id', 'birthday_special_date_id',
'is_dead', 'last_consulted_at', 'created_at', 'first_met_additional_info',
'address_book_id', 'vcard', 'avatar_gravatar_url', 'avatar_source'
```
— https://raw.githubusercontent.com/monicahq/monica/4.x/app/Models/Contact/Contact.php

Additional columns on the same model, extracted from the source:
`first_met`, `first_met_additional_info`, `first_met_special_date_id`, **`first_met_through_contact_id`**, `last_talked_to`, **`stay_in_touch_frequency`** (cast `integer`), **`stay_in_touch_trigger_date`**, `deceased`, `deceased_date`, `deceased_special_date_id`, `is_starred`, `is_active`, `has_avatar`.

Two are directly load-bearing for an arrival brief:

> ```php
> /**
>  * Gets the contact who introduced this person to the user.
>  */
> ```
> — the `first_met_through_contact_id` accessor, same URL

> ```php
> /**
>  * Indicates whether the contact has information about how they first met.
>  */
> public function hasFirstMetInformation()
> {
>     return ! is_null($this->first_met_additional_info) || ! is_null($this->firstMetDate) || ! is_null($this->first_met_through_contact_id);
> }
> ```
> — same URL

`$dates` verbatim: `'last_talked_to', 'last_consulted_at', 'stay_in_touch_trigger_date', 'created_at', 'updated_at'`.

**v5 branch** (`main`, a rewrite) — `app/Models/Contact.php` `$fillable` verbatim:
```
'vault_id', 'gender_id', 'pronoun_id', 'first_name', 'last_name', 'middle_name',
'nickname', 'maiden_name', 'can_be_deleted', 'show_quick_facts', 'template_id',
'last_updated_at', 'company_id', 'job_position', 'listed', 'file_id',
'religion_id', 'vcard', 'distant_uuid', 'distant_etag', 'distant_uri',
'prefix', 'suffix'
```
— https://raw.githubusercontent.com/monicahq/monica/main/app/Models/Contact.php

v5 surrounding models show the full person-page surface (https://api.github.com/repos/monicahq/monica/git/trees/main?recursive=1): `ContactImportantDate`, `ContactImportantDateType`, `ContactInformation`, `ContactReminder`, `ContactTask`, `ContactFeedItem`, `LifeEvent`, `LifeEventCategory`, `LifeEventType`, `LifeMetric`, `Relationship*`, `Note`, `Journal`, `SliceOfLife`, `MoodTrackingEvent`, `Goal`, `Streak`, `Pet`, `Gift*`, `Loan`, `Call`, `CallReason`, `QuickFact`, `Group`, `GroupType`, `GroupTypeRole`, `Post`, `Template`, `TimelineEvent`, `Vault`.

Note `QuickFact` / `show_quick_facts` and `VaultQuickFactsTemplate` — Monica has an explicit first-class notion of *the few things you should recall about this person*, which is exactly an arrival-brief primitive.

#### Surfacing & score

Feature framing — https://www.monicahq.com/: "Relationships", "Notes and journal entries", "Reminders" ("call your mother, congratulate friends"), "Activities", "Custom information"; "Follow up when it matters".

**NO SCORE.** Monica has no computed relationship strength. Cadence is a **user-set integer** (`stay_in_touch_frequency`) with a derived trigger date (`stay_in_touch_trigger_date`) — declared, not inferred. Same philosophical camp as Dex.

#### Data sourcing & privacy

Manual entry plus CardDAV sync — there is no email/calendar scraping and no enrichment pipeline. Privacy posture, verbatim from https://www.monicahq.com/:

> "Private by design. Open source. Self-hostable. No ads, no data resale"
> "Your data is never sold, never used for advertising, and never used to train a model"
> "Your data stays yours"

Self-hosting — https://www.monicahq.com/#pricing:
> "You can run it on your own server without paying anything."
> "The hosted version is a paid subscription, because servers and backups are not free."

Hosted-tier dollar figures: **UNVERIFIED** (`/pricing` returns 404; the anchor section publishes no numbers).

---

### Nat (nat.app)

Live as of this audit — no shutdown or acquisition notice found on the site.

> "Personal CRM for relationship building"
> "Stay in touch with the customers that matter to your business"
> — https://nat.app/

Sources it pulls: "Interaction data (Gmail and Google Calendar imports)", "Contact data (contact book imports)", "Business information (Stripe and Segment integrations)". Features named: "Unlimited follow-ups with one-click capability", "Take notes within Gmail", "Smart AI-powered contact categorization", "Snooze system for managing contacts".

**NO SCORE.** Nat surfaces contacts you are "losing touch with" via automatic categorization, but exposes no numeric or banded relationship metric. Person-page field enumeration and pricing: **UNVERIFIED** (no docs/help center or pricing page fetched).

---

### Cross-cutting findings for the arrival brief

1. **Exposed score is table stakes; exposed *reasoning* is not.** Affinity, Attio, Mesh and folk all ship a strength signal. None ships a per-person factor breakdown. Affinity says so outright: "You won't see a confidence number — it works quietly in the background, the same way relationship strength does for your explicit relationships." An arrival brief that shows *why* is differentiated against the entire category.

2. **Banded beats numeric for human-facing surfaces.** Every product that puts strength in front of a person uses bands or bars (Attio's 6 levels, Affinity's green/orange/gray, Mesh's signal bars). Raw numbers survive only in APIs (Affinity `0.0`–`1.0`). Affinity runs *three* incompatible scales across UI/v1/v2 — a cautionary tale for committing to one representation.

3. **"Who on our side knows them best" is a solved, named pattern** — Attio "Strongest connection", folk "Strongest connection", Mesh team Network Strength, Affinity Warm Intro Path. This is the closest existing analogue to "who else here should you meet", and all four render it as *a named person*, not a number.

4. **Email-body access is the privacy fault line.** Headers-only: Mesh, Nexl, Introhive. Opt-in bodies: 4Degrees, Affinity ("optionally message bodies", default Hide All). Bodies read by default: folk, Dex. The defensible position — and the one with the best published language — is headers/metadata only.

5. **Affinity Alliances is the precedent for sharing a score across a trust boundary:** allies see "Who you know" + "How well you know them" and explicitly "will **not** be able to see your email or calendar data". A score can travel where its evidence cannot.

6. **Nobody in this cohort has published a "is this creepy" rebuttal.** The brief's premise that Clay did so is **not supported** — Mesh's own site search for "creepy" returns "No results found." The substantive privacy answers exist (headers-only, opt-in AI, no training, opt-out public profiles) but are never framed as a creepiness defense. That framing is unoccupied territory.

### Bonus: the one documented "score + rationale" UI pattern

Not from this cohort, but the closest published design precedent, from **Salesforce** patent US11645321B2, "Calculating relationship strength using an activity-based distributed graph" (filed 2017-11-03) — https://patents.google.com/patent/US11645321B2/en:

> "The closeness scores may be normalized to values between 0 and 10, where 10 represents the strongest connection and 0 represents no connection."

> "three dots may correspond to the top ranked 85-100% of connections (i.e., a 'high' connectivity), two dots may indicate 60-85% (i.e., an 'average' connectivity), one dot may indicate 30-60% (i.e., a 'low' connectivity), and zero dots may indicate 0-30% (i.e., 'no' or 'minimal' connectivity)."

> "the connection rationale 425 may give a brief, plain language description explaining the ranking for the connected user 410."

Inputs: "emails, calendar events, service tickets, text messages, voice calls, social media messages, documents, activities, or any combination of these." Example rationale string given: "Higher volume of meetings and email exchange".

This is a **percentile-banded score paired with a generated plain-language rationale** — i.e. exactly the arrival-brief shape, documented but not shipped by any product audited above. Note this is a patent, not a released feature; treat as design precedent only.


---


# 4. Sales / contact enrichment

## Sales / contact enrichment

**Scope.** Clearbit (now HubSpot Breeze Intelligence / "Data Enrichment"), Apollo.io, ZoomInfo, People Data Labs (PDL), Clay, plus Lusha, Seamless.ai, Hunter.io, LinkedIn Sales Navigator. This category sets the market baseline for *what is technically easy to know about a named person from an email address alone*, and the reputational/legal price attached to knowing it.

**Bottom line for an arrival brief.** Everything a host would plausibly want in a 90-second digest — employer, title, seniority, tenure, city, timezone, education, social handles, follower counts, a photo — is a single paid API call away, at roughly **$0.02–$0.30 per person**. The differentiator is not access. It is *provenance and consent*, and this category has repeatedly and expensively failed on exactly that.

---

### 1. What a person-enrichment payload actually contains

#### 1a. Clearbit Enrichment API — Person object (the canonical "digest" shape)

Clearbit's public docs are now behind a login (`dashboard.clearbit.com/docs` → 302 to `app.clearbit.com/auth/login`, fetched 2026-09-03). Recovered from the Internet Archive snapshot of the live docs:

**Source:** `https://web.archive.org/web/20190820100931id_/https://clearbit.com/docs?shell` (fetched 2026-09-03)

Clearbit's own framing, verbatim:

> "The Person API lets you retrieve social information associated with an email address, such as a person's name, location and Twitter handle."

Verbatim example JSON response (`GET https://person.clearbit.com/v1/people/email/:email`):

```json
{
  "id": "d54c54ad-40be-4305-8a34-0ab44710b90d",
  "name": {
    "fullName": "Alex MacCaw",
    "givenName": "Alex",
    "familyName": "MacCaw"
  },
  "email": "alex@alexmaccaw.com",
  "location": "San Francisco, CA, US",
  "timeZone": "America/Los_Angeles",
  "utcOffset": -8,
  "geo": {
    "city": "San Francisco",
    "state": "California",
    "stateCode": "CA",
    "country": "United States",
    "countryCode": "US",
    "lat": 37.7749295,
    "lng": -122.4194155
  },
  "bio": "O'Reilly author, software engineer & traveller. Founder of https://clearbit.com",
  "site": "http://alexmaccaw.com",
  "avatar": "https://d1ts43dypk8bqh.cloudfront.net/v1/avatars/d54c54ad-40be-4305-8a34-0ab44710b90d",
  "employment": {
    "domain": "clearbit.com",
    "name": "Clearbit",
    "title": "Co-founder, CEO",
    "role": "leadership",
    "subRole": "ceo",
    "seniority": "executive"
  },
  "facebook": {
    "handle": "amaccaw"
  },
  "github": {
    "handle": "maccman",
    "avatar": "https://avatars.githubusercontent.com/u/2142?v=2",
    "company": "Clearbit",
    "blog": "http://alexmaccaw.com",
    "followers": 2932,
    "following": 94
  },
  "twitter": {
    "handle": "maccaw",
    "id": "2006261",
    "bio": "O'Reilly author, software engineer & traveller. Founder of https://clearbit.com",
    "followers": 15248,
    "following": 1711,
    "location": "San Francisco",
    "site": "http://alexmaccaw.com",
    "avatar": "https://pbs.twimg.com/profile_images/1826201101/297606_10150904890650705_570400704_21211347_1883468370_n.jpeg"
  },
  "linkedin": {
    "handle": "pub/alex-maccaw/78/929/ab5"
  },
  "googleplus": {
    "handle": null
  },
  "gravatar": {
    "handle": "maccman",
    "urls": [
      {
        "value": "http://alexmaccaw.com",
        "title": "Personal Website"
      }
    ],
    "avatar": "http://2.gravatar.com/avatar/994909da96d3afaf4daaf54973914b64",
    "avatars": [
      {
        "url": "http://2.gravatar.com/avatar/994909da96d3afaf4daaf54973914b64",
        "type": "thumbnail"
      }
    ]
  },
  "fuzzy": false,
  "emailProvider": false,
  "indexedAt": "2016-11-07T00:00:00.000Z"
}
```

Full attribute list, verbatim from the same docs page (attribute — description):

```
id                  string Internal ID
name.givenName      string First name of person (if found)
name.familyName     string Last name of person (if found)
name.fullName       string Full formatted name of person. Sometimes this will be present even if the givenName or familyName aren't available
location            string The most accurate location we have
timeZone            string The timezone for the person's location
utcOffset           integer The offset from UTC in hours in the person's location
geo.city            string Normalized city based on location
geo.state           string Normalized state based on location
geo.country         string Normalized two letter country code based on location
geo.lat             float General latitude based on location
geo.lng             float General longitude based on location
bio                 string The most accurate bio we have
site                string The person's website
avatar              string The best avatar url we have
employment.name     string Company name
employment.title    string Title at Company
employment.role     string Role at Company
employment.subRole  string Sub-role at Company
employment.seniority string Seniority at Company
employment.domain   string Company domain
facebook.handle     string Facebook ID or screen name
github.handle       string GitHub handle
github.id           integer GitHub ID
github.avatar       string GitHub avatar
github.company      string GitHub company
github.blog         string GitHub blog url
github.followers    string Count of GitHub followers
github.following    string Count of GitHub following
twitter.handle      string Twitter screen name
twitter.id          integer Twitter ID
twitter.followers   integer Count of Twitter followers
twitter.following   integer Count of Twitter friends
twitter.location    string Twitter location
twitter.site        string Twitter site
twitter.statuses    integer Tweet count
twitter.favorites   integer Favorite count
twitter.avatar      string HTTP Twitter avatar
linkedin.handle     string LinkedIn url (i.e. /pub/alex-maccaw/78/929/ab5)
googleplus.handle   string Google Plus handle
gravatar.handle     string Gravatar handle
gravatar.urls       array Array of URLs from Gravatar
gravatar.avatar     string Gravatar main avatar url.
gravatar.avatars    string Array of objects containing a avatar url, and a type (i.e. thumbnail)
fuzzy               boolean Indicating whether or not the lookup is a fuzzy or exact search
emailProvider       boolean is the email domain associated with a free email provider (i.e. Gmail)?
indexedAt           string date The time at which we indexed this data
```

Request parameters accepted alongside the email (verbatim from same page) — note these are the *inputs* a caller may already hold, and they widen the match:

```
email           string (required) The email address to look up.
webhook_url     string A webhook URL that results will be sent to.
given_name      string First name of person.
family_name     string Last name of person. If you have this, passing this is strongly recommended to improve match rates.
ip_address      string IP address of the person. If you have this, passing this is strongly recommended to improve match rates.
location        string The city or country where the person resides.
company         string The name of the person's employer.
company_domain  string The domain for the person's employer.
linkedin        string The LinkedIn URL for the person.
twitter         string The Twitter handle for the person.
facebook        string The Facebook URL for the person.
suppression     string Set to eu to exclude person records with country data in the EU. Set to eu_strict to exclude person records with country data in the EU or with null country data.
```

> Note the `suppression` parameter: Clearbit shipped a documented switch whose entire purpose is to **exclude EU-resident records** so the caller does not have to deal with GDPR. That is an admission, in the API surface itself, that the legal basis is shaky.

#### 1b. People Data Labs — full published Person Schema

**Source:** `https://docs.peopledatalabs.com/docs/fields` (fetched 2026-09-03). PDL publishes the most complete schema in the category, and it is materially more invasive than Clearbit's — it includes `birth_date`, `sex`, `inferred_salary`, `street_addresses`, `mobile_phone`, and a "Lower Confidence Data" block of *guesses* (`possible_birth_dates`, `possible_street_addresses`, `possible_phones`).

Verbatim field names, grouped as PDL groups them:

```
# Identifiers
first_name, full_name, id, last_initial, last_name, middle_initial, middle_name, name_aliases

# Contact Information
emails, emails.address, emails.first_seen, emails.last_seen, emails.num_sources,
emails.md5_hash, emails.sha_256_hash, emails.type,
mobile_phone, personal_emails, phone_numbers,
phones, phones.first_seen, phones.last_seen, phones.num_sources, phones.number,
recommended_personal_email, work_email

# Current Company
job_company_12mo_employee_growth_rate, job_company_facebook_url, job_company_founded,
job_company_employee_count, job_company_id, job_company_industry, job_company_industry_v2,
job_company_inferred_revenue, job_company_linkedin_id, job_company_linkedin_url,
job_company_location_address_line_2, job_company_location_continent, job_company_location_country,
job_company_location_geo, job_company_location_locality, job_company_location_metro,
job_company_location_name, job_company_location_postal_code, job_company_location_region,
job_company_location_street_address, job_company_name, job_company_size, job_company_ticker,
job_company_total_funding_raised, job_company_twitter_url, job_company_type, job_company_website

# Current Job
inferred_salary, job_last_changed, job_last_verified, job_onet_code, job_onet_major_group,
job_onet_minor_group, job_onet_broad_occupation, job_onet_specific_occupation,
job_onet_specific_occupation_detail, job_start_date, job_summary, job_title,
job_title_class, job_title_levels, job_title_role, job_title_sub_role

# Demographics
birth_date, birth_year, sex, languages, languages.name, languages.proficiency

# Education
education, education.degrees, education.end_date, education.gpa, education.majors,
education.minors, education.raw, education.school, education.school.domain,
education.school.facebook_url, education.school.id, education.school.linkedin_id,
education.school.linkedin_url, education.school.location, education.school.location.continent,
education.school.location.country, education.school.location.locality,
education.school.location.name, education.school.location.region, education.school.name,
education.school.raw, education.school.twitter_url, education.school.type,
education.school.website, education.start_date, education.summary

# Location
countries, location_address_line_2, location_continent, location_country, location_geo,
location_last_updated, location_locality, location_metro, location_name, location_names,
location_postal_code, location_region, location_street_address, regions,
street_addresses, street_addresses.name, street_addresses.locality, street_addresses.metro,
street_addresses.region, street_addresses.country, street_addresses.continent,
street_addresses.street_address, street_addresses.address_line_2, street_addresses.postal_code,
street_addresses.geo, street_addresses.first_seen, street_addresses.last_seen,
street_addresses.num_sources

# Lower Confidence Data
possible_birth_dates,
possible_emails, possible_emails.address, possible_emails.type, possible_emails.first_seen,
possible_emails.last_seen, possible_emails.num_sources,
possible_location_names,
possible_phones, possible_phones.number, possible_phones.first_seen, possible_phones.last_seen,
possible_phones.num_sources,
possible_profiles, possible_profiles.network, possible_profiles.id, possible_profiles.url,
possible_profiles.username, possible_profiles.first_seen, possible_profiles.last_seen,
possible_profiles.num_sources,
possible_street_addresses, possible_street_addresses.name, possible_street_addresses.locality,
possible_street_addresses.metro, possible_street_addresses.region,
possible_street_addresses.country, possible_street_addresses.continent,
possible_street_addresses.street_address, possible_street_addresses.address_line_2,
possible_street_addresses.postal_code, possible_street_addresses.geo,
possible_street_addresses.first_seen, possible_street_addresses.last_seen,
possible_street_addresses.num_sources

# Social Presence
facebook_friends, facebook_id, facebook_url, facebook_username,
github_url, github_username,
linkedin_connections, linkedin_id, linkedin_url, linkedin_username,
profiles, profiles.id, profiles.first_seen, profiles.last_seen, profiles.network,
profiles.num_sources, profiles.url, profiles.username,
twitter_url, twitter_username

# PDLScores(TM)
profile_score, profile_score_factors, profile_score_factors.attribute_fill_rate,
profile_score_factors.profile_age_months, profile_score_factors.has_valid_url,
profile_score_factors.meets_connection_threshold,
activity_score, activity_score_factors, activity_score_factors.connection_change,
activity_score_factors.profile_change, activity_score_factors.months_since_last_end_resume
```

Two things to flag for our own design:
- `first_seen` / `last_seen` / `num_sources` on every contact datum is a **provenance-and-corroboration model**. That pattern is worth stealing even if the fields are not.
- `inferred_salary`, `possible_birth_dates`, `possible_street_addresses` are *inferences presented as record fields*. A host reading a brief cannot tell an inference from a fact. That is precisely the failure mode we must avoid.

#### 1c. ZoomInfo — Contact Enrich output fields

**Source:** `https://docs.zoominfo.com/reference/enrichinterface_enrichcontact` (fetched 2026-09-03). (`api-docs.zoominfo.com` is the legacy API and is being deprecated; the marketing site itself is bot-walled — `zoominfo.com/trust-center/*` returned 403 / "Press & Hold to confirm you are a human" on 2026-09-03.)

Verbatim output field names:

```
# Contact-level
city, continent, country, email, firstName, hasCanadianEmail, id, lastName, middleName,
phone, region, salutation, state, street, suffix, zipCode, metroArea

# Contact detail
jobTitle, jobFunction, education, managementLevel, yearsOfExperience, positionStartDate,
employmentHistory, techSkills, picture, externalUrls

# Contact communication
supplementalEmail, directPhoneDoNotCall, mobilePhone, mobilePhoneDoNotCall, directPhoneAlt,
mobilePhoneAlt, emailAlt, hashedEmails

# Contact status / validation
personHasMoved, validDate, lastUpdatedDate, noticeProvidedDate, contactAccuracyScore,
withinEu, withinCalifornia, withinCanada, isDefunct, engagements

# Company-level
companyName, companyId, companyPhone, companyFax, companyWebsite, companyStreet, companyCity,
companyState, companyZipCode, companyCountry, companyContinent

# Company detail
companyDescription, companyLogo, companyAlternateLogos, companyType, companyTicker,
companyRevenue, companyRevenueNumeric, companyRevenueRange, companyEmployeeCount,
companyEmployeeRange, companyEmployeeGrowth, companyRanking, companyDivision

# Company industry / classification
companyPrimaryIndustry, companyPrimaryIndustryCode, companyPrimarySubIndustryCode,
companyIndustries, companyIndustryCodes, companySicCodes, companyNaicsCodes

# Company social
companySocialMediaUrls, locationCompanyId
```

The compliance-shaped fields are the tell: `withinEu`, `withinCalifornia`, `withinCanada`, `noticeProvidedDate`, `directPhoneDoNotCall`, `mobilePhoneDoNotCall`, `personHasMoved`. ZoomInfo ships **jurisdiction flags and a notice-served timestamp as first-class record fields** — the data model has litigation baked into it.

#### 1d. Apollo.io — People Enrichment response

**Source:** `https://docs.apollo.io/reference/people-enrichment` (fetched 2026-09-03)

Verbatim response field names:

```
request_id, person, id, first_name, last_name, name, linkedin_url, title, email_status,
photo_url, twitter_url, github_url, facebook_url, extrapolated_email_confidence, headline,
email, organization_id, employment_history, state, city, country, contact_id, contact,
revealed_for_current_team, organization, is_likely_to_engage, show_intent, departments,
subdepartments, functions, seniority, waterfall, status, message
```

Verbatim example response body from the docs:

```json
{
  "person": {
    "id": "64a7ff0cc4dfae00013df1a5",
    "first_name": "Tim",
    "last_name": "Zheng",
    "email": "tim@apollo.io",
    "title": "Founder & CEO"
  },
  "request_id": 1039995589705121900
}
```

Note `is_likely_to_engage` and `show_intent` — behavioural scoring, not facts about the person.

#### 1e. The composite baseline

Union of the four schemas — this is what "the market can already do" means when we scope our own brief:

| Category | Fields available today |
|---|---|
| Identity | full/given/family name, aliases, internal ID, salutation, suffix |
| Photo | `avatar` (Clearbit), `photo_url` (Apollo), `picture` (ZoomInfo) |
| Employer & role | company name, domain, title, role, subRole, seniority, managementLevel, department, function, `job_start_date`, `yearsOfExperience`, full `employmentHistory` |
| Geography & time | city / state / country, lat-lng, **`timeZone` and `utcOffset`**, metro, postal code, street address (PDL, ZoomInfo) |
| Free text | `bio` (Clearbit), `headline` (Apollo), `job_summary` (PDL), `companyDescription` |
| Social graph | LinkedIn / Twitter / Facebook / GitHub handles **plus follower and connection counts** (`github.followers`, `twitter.followers`, `linkedin_connections`, `facebook_friends`) |
| Education | school, degrees, majors, minors, **GPA**, dates (PDL); `education` (ZoomInfo) |
| Demographics | `birth_date`, `birth_year`, `sex`, `languages` (PDL only) |
| Inferences | `inferred_salary`, `possible_*` (PDL); `is_likely_to_engage`, `show_intent` (Apollo); `contactAccuracyScore` (ZoomInfo) |
| Contactability | work/personal email, mobile, direct dial, DNC flags |
| Provenance | `first_seen`, `last_seen`, `num_sources` (PDL); `indexedAt` (Clearbit); `validDate`, `lastUpdatedDate`, `noticeProvidedDate` (ZoomInfo) |

---

### 2. Pricing

#### Apollo.io — published
**Source:** `https://www.apollo.io/pricing` (rendered and read 2026-09-03)

> "Free … $0 … 900 credits per seat per year, granted monthly"
> "Basic … $49 Per seat per month, billed annually … 30,000 credits per seat per year, granted upfront"
> "Professional … $79 Per seat per month, billed annually … 48,000 credits per seat per year, granted upfront"
> "Organization … $119 Per seat per month, (min 3 seats) billed annually … 72,000 credits per seat per year, granted upfront"

Credit mechanics, verbatim from the same page:

> "Accessing a contact's emails uses 1 credit."
> "Accessing a contact's phone number uses 8 credits."
> "Data enrichment uses up to 9 credits per record."
> "1 Power-up run uses 1 credit."

And the stated credit unit price:

> "Paid accounts receive either $0.025 per credit or 1 million credits annually, with custom plans available."

**Effective cost: $0.025 for an email, $0.20 for a mobile number, up to $0.225 for a full enrichment.**

#### People Data Labs — published
**Source:** `https://www.peopledatalabs.com/pricing` (rendered and read 2026-09-03)

> "Free … Up to 100 credits/mo … Easy sign up … No commitment"
> "Free plan: emails, phone, & address data is obfuscated. Unlock with Pro."
> "Pro … Starting at $98/mo … Start with as few as 350 credits/mo … Contact data included … Access to premium fields"
> "Enterprise … Custom pricing … Annual contracts … Access to all APIs … Data License Feeds"
> "Save 20% and access all of the data upfront with annual commitments."

**Effective entry cost: $98 / 350 ≈ $0.28 per enriched person**, falling with volume ("With volume-based pricing, discounts trigger as your usage grows.").

#### Clay — published
**Source:** `https://www.clay.com/pricing` (rendered and read 2026-09-03)

> "Free — … Comes with 100 Data Credits and 500 Actions/mo."
> "Launch (starting at $185/mo) — … Includes 2,500 Data Credits and 15,000 Actions/mo."
> "Growth (starting at $495/mo) — … Includes 6,000 Data Credits and 40,000 Actions/mo."
> "Enterprise (custom pricing with annual commitment) — … Includes 100,000+ Data Credits and 200,000+ Actions/mo."

> "Data Credits are used when you purchase data from Clay's marketplace — finding emails, phone numbers, company data across our 150+ data partners."

**Effective: $185 / 2,500 = $0.074 per data credit at Launch; $495 / 6,000 = $0.0825 at Growth.** Clay is a broker-of-brokers — "150+ data partners" — which means provenance is aggregated and, from the buyer's seat, opaque.

#### Hunter.io — published
**Source:** `https://hunter.io/pricing` (rendered and read 2026-09-03)

> "Free … $0 … 50 credits per month"
> "Starter … $34 /month … $588 $408 billed yearly … 24,000 credits per year"
> "Growth … $104 /month … $1,788 $1,248 billed yearly … 120,000 credits per year"
> "Scale … $209 /month … $3,588 $2,508 billed yearly … 300,000 credits per year"

Credits are "Used for Email Finder, Email Verifier, and Domain Search". **Effective: $408 / 24,000 = $0.017 per credit at Starter; $2,508 / 300,000 = $0.0084 at Scale.** Cheapest in the set, and correspondingly the thinnest payload (email discovery/verification, not a person profile).

#### LinkedIn Sales Navigator — published
**Source:** `https://business.linkedin.com/sales-solutions/compare-plans` (FAQ, fetched 2026-09-03)

> "The Sales Navigator Core plan pricing starts at US$119.99 per month/license or US$1,079.88 per year/license (a 25% savings with annual billing), while the Advanced plan starts at US$159.99 per month/license or US$1,799.88 per year/license (a 6% savings with annual billing)."

Seat-based, no per-record credit — and, critically, **no bulk export**: the data stays inside LinkedIn's UI. This is the one vendor in the set whose subjects actually created their own records.

#### ZoomInfo — not published; reported figures only
ZoomInfo publishes no list price. Reported, from Vendr's aggregated contract data:

**Source:** `https://www.vendr.com/buyer-guides/zoominfo` (rendered and read 2026-09-03)

> "$33,500 Avg Contract Value"
> "1012 Deals handled"
> "21.81% Avg Savings"
> "Median buyer pays $33,500 per year … Based on data from 1,571 purchases, with buyers saving 22% on average. Median: $33,500 … $7,200 Low … $156,000 High"

And Vendr's own characterisation, verbatim:

> "ZoomInfo does not publish transparent list pricing. Instead, pricing is customized based on several variables: the number of user licenses, which platform(s) you select (SalesOS, MarketingOS, TalentOS, OperationsOS), the volume of data credits or contact exports you require, contract term length…"

*Treat as reported third-party aggregate, not a vendor-published price.*

#### Seamless.ai — not published
**Source:** `https://seamless.ai/pricing` (rendered and read 2026-09-03). Only the Free tier carries a number:

> "Free … 1 User … 50 Credits"
> "Pro … Per User … Unlimited Exports … Annual Credit Packages … 1 Credits = Phone + Email … Contact sales"
> "Enterprise … Unlimited Users … Unlimited Exports … Custom Packages … Contact sales"

No Pro/Enterprise dollar figure is published. **UNVERIFIED** beyond the free tier.

#### Clearbit / HubSpot Breeze Intelligence — restructured, not directly comparable
Clearbit's standalone pricing page is gone post-acquisition. Breeze Intelligence Credits have been folded into a general "HubSpot Credits" pool.

**Source:** `https://knowledge.hubspot.com/…/manage-hubspot-credits` (rendered 2026-09-03; page states "Last updated: July 29, 2026")

> "HubSpot Credits are required for certain usage-based features, such as Customer Agent, Prospecting Agent, Data Agent, and Data Studio syncs."
> "HubSpot Credits reset every month, aligned with the start date of your usage period."
> "Unused credits expire at the end of each usage period and do not roll over to the next month."
> "If you've previously had Breeze Intelligence Credits, review the conversion rate between Breeze Intelligence Credits and HubSpot Credits."

**A standalone per-enrichment dollar price for Breeze Intelligence is UNVERIFIED** — HubSpot now routes it through a bundled credit pool priced against the subscription tier rather than as a per-record rate.

#### Lusha
`https://www.lusha.com/pricing/` rendered without its pricing table on 2026-09-03. **UNVERIFIED.**

---

### 3. The reputational cost

#### 3a. ZoomInfo — a $29.6M right-of-publicity settlement, and jurisdiction flags in the schema

The single sharpest artefact in this entire category. *Ramos et al. v. ZoomInfo Technologies, LLC*, No. 1:21-cv-02032 (N.D. Ill.).

**Source:** `https://www.classaction.org/media/ramos-v-zoominfo-technologies-inc-et-al-motion-and-memo-preliminary-approval.pdf` (fetched and text-extracted 2026-09-03)

The mechanism the court was asked to look at, verbatim from the memorandum:

> "To market access to the database, the website allows users to perform a free search for an individual by typing that individual's name into a search bar. Defendant then provides a 'free preview' of the data that it maintains on that individual, which includes unique identifying information about that individual, including location, work history, job title, and partial phone number and email address. Not only does this free preview contain specific identifying information about the searched-for individual, but it also includes an offer for a trial subscription—which converts to a paid membership—to access Defendant's entire database. Plaintiffs allege that using individuals' identifying information to market Defendant's subscription service without first obtaining their written consent violates the right of publicity laws in California, Illinois, Indiana, and Nevada."

The number, verbatim:

> "If approved, the Settlement would resolve right of publicity claims for Settlement Classes in four states, amounting to the largest aggregate settlement fund ever secured for these alleged violations—totaling $29,557,612.50."

Per-state allocation, verbatim:

> "Defendant will establish non-reversionary State-Specific Settlement Funds for each of the Settlement Classes in the following amounts, based on the size of the respective Settlement Class and the statutory damages available under each state's right of publicity law: California, $14,228,617.50; Illinois, $11,695,860; Indiana, $2,302,080; and Nevada, $1,331,055."

The companion California case, verbatim from the same filing:

> "After this case was initiated, another action was filed against Defendant in California on behalf of a class of Californians pursuant to the California Right of Publicity Statute, Cal. Civ. Code § 3344, et seq. Martinez v. ZoomInfo Techs. Inc., C21-5725 MJP (W.D. Wash.)"

*(The "Kim v. ZoomInfo" referenced colloquially is this case — the named plaintiff is **Kim Carter Martinez**; the Ninth Circuit appeal is captioned* Kim Martinez v. ZoomInfo Technologies, Inc.*, No. 22-35305. The 9th Cir. opinion page at law.justia.com returned 403 on 2026-09-03, so the holding text is **UNVERIFIED by direct fetch**; the docket cite above is verified from the Ramos filing.)*

Class definition and payouts, from the official settlement site —
**Source:** `https://zoominforightofpublicitysettlement.com/` (fetched 2026-09-03):

> "Ramos et al. v. ZoomInfo Technologies, LLC"
> "United States District Court Northern District of Illinois, Eastern Division"

Estimated per-claimant payments listed there: California $108.43–$216.86, Illinois $145.93–$291.85, Indiana $740.77–$1,481.54, Nevada $971.24–$1,942.47.

**ZoomInfo's own privacy policy**, which is the gap:
**Source:** `https://www.zoominfo.com/legal/privacy-policy` (fetched 2026-09-03)

> "Name, Email address, including business and/or other email addresses, such as 'freemails' like Gmail, Yahoo, Hotmail, etc., Job title and department, Phone number, including general or direct business numbers, faxes, and/or mobile numbers"

On sourcing:

> "Search technology scans the web and gathers publicly available information"

On removal:

> "If you wish to remove your existing Professional Profile from the Directory, please [click here]" → **opt-out URL: `https://www.zoominfo.com/update/remove`**

Additional opt-out surfaces located but **not directly fetchable** (Akamai bot wall returned "Access to this page has been denied" / "Press & Hold to confirm you are a human" for `zoominfo.com/trust-center/*` and `zoominfo.com/business/privacy` on 2026-09-03, via both WebFetch and a browser session): `https://privacyrequest.zoominfo.com/remove/verify`, `https://www.zoominfo.com/privacy-center/update/remove`, `https://privacy.zoominfo.com/`.

> **The gap.** ZoomInfo relies on "publicly available information" scanned by "search technology" and, per the policy, on legitimate-interest rather than consent. A federal court's preliminary-approval record describes the same practice as using people's identities to advertise a subscription "without first obtaining their written consent," and ZoomInfo paid $29,557,612.50 rather than litigate it. Its own API schema carries `withinEu`, `withinCalifornia`, `withinCanada` and `noticeProvidedDate` fields — the company is tracking, per record, which legal regime each human falls under.

**Complaint volume for removals: UNVERIFIED.** BBB's ZoomInfo complaints page did not resolve (bbb.org redirected to an unrelated business profile on 2026-09-03) and reddit.com is not fetchable from this environment. Do not assert a number.

#### 3b. Clearbit — "de-anonymizing traffic on your website," in its own docs

Clearbit did not merely enrich people who handed over an email. It sold a product for identifying people who never did.

**Source:** `https://web.archive.org/web/20190820100931id_/https://clearbit.com/docs?shell` (fetched 2026-09-03). Clearbit's own words:

> "Our Reveal API takes an IP address, and returns the company associated with that IP. This is especially useful for de-anonymizing traffic on your website, analytics, and customizing landing pages for specific company verticals."

> "Powering Reveal is a unique dataset that combines both public and proprietary sources to give you an insight into the companies visiting your website whatever their size, even if they don't have their own public ASN block."

The developer reaction, verbatim from Hacker News —
**Source:** `https://news.ycombinator.com/item?id=23364836` ("Ask HN: How does Clearbit Reveal know who I am?"):

> [rahimnathwani] "When I visit https://clearbit.com/reveal there is a screenshot of a web page. I've visited the page a few times from my home internet connection, and the image has been either: A) My personal blog (on my own domain) B) My company's web site. It's pretty impressive (or creepy, depending on your viewpoint) that they can map my IP address to a company and/or individual identity."

> [sergiotapia] "even with ublock origin it showed my company's website. how?"

> [whalesalad] "your IP and all the other little atoms of data that are collected on you by various third parties are traded back and forth to form a rich web. Over time the value of any given data point (like your ephemeral DHCP lease) becomes less significant to the integrity of the picture that has been created of you."

**The acquisition and repositioning.**
**Source:** `https://ir.hubspot.com/news-releases/news-release-details/hubspot-completes-acquisition-b2b-intelligence-leader-clearbit` (fetched 2026-09-03; release dated **December 04, 2023**)

HubSpot describes Clearbit as "a top B2B data provider" bringing "rich third-party company data," making "HubSpot the central source of truth for go-to-market professionals," and adds:

> "HubSpot remains committed to maintaining high standards of responsible data sourcing, transparency, privacy, and security."

Note the framing shift: HubSpot's language is consistently **"company data"** and **"third-party company data."** The person-level `bio` / `github.followers` / `twitter.followers` payload documented in §1a is not what is being marketed post-acquisition. Clearbit's brand was retired into "Breeze Intelligence" and then into generic "Data Enrichment"/"HubSpot Credits" (see §2).

> **The gap.** Clearbit shipped an API whose documented purpose was "de-anonymizing traffic on your website," plus a `suppression=eu` parameter for skipping EU residents. The acquirer's public language is "responsible data sourcing" and "company data." Same pipes, quieter branding.

#### 3c. Apollo.io — 125,929,660 records, left open with no password (2018)

**Source:** `https://haveibeenpwned.com/api/v3/breach/Apollo` (fetched 2026-09-03). Verbatim from the HIBP record:

> **BreachDate:** "2018-07-23" · **PwnCount:** 125929660 · **IsVerified:** true

> "In July 2018, the sales engagement startup Apollo left a database containing billions of data points publicly exposed without a password. The data was discovered by security researcher Vinny Troia who subsequently sent a subset of the data containing 126 million unique email addresses to Have I Been Pwned. The data left exposed by Apollo was used in their 'revenue acceleration platform' and included personal information such as names and email addresses as well as professional information including places of employment, the roles people hold and where they're located. Apollo stressed that the exposed data did not include sensitive information such as passwords, social security numbers or financial data."

Verbatim `DataClasses`:

> "Email addresses", "Employers", "Geographic locations", "Job titles", "Names", "Phone numbers", "Salutations", "Social media profiles"

That list is **the arrival-brief payload, verbatim** — which is the point. The breach did not leak credentials. It leaked exactly the digest.

**Apollo's stated position today.**
**Source:** `https://www.apollo.io/privacy-policy` (fetched 2026-09-03). Apollo says it obtains business contact information from "publicly accessible websites, professional directories, public regulatory and government sources, and vetted third-party data providers," and relies on "legitimate interests" to "create, verify, enrich, and maintain business contact and firmographic information." Deletion:

> "Right to Delete. You may request that Apollo delete your personal information from its records"

Opt-out surface: `https://www.apollo.io/company/privacy-center`.

#### 3d. People Data Labs — 1.2 billion people on an open Elasticsearch server (2019)

**Sources:** `https://nightlion.com/blog/2019/pdl-data-exposure-billion-people/` (Vinny Troia's own writeup) and `https://www.securityweek.com/data-12-billion-users-found-exposed-elasticsearch-server/` — both fetched 2026-09-03. *(Wired's coverage at wired.com and ZDNet's are not fetchable from this environment; the two above are the primary researcher writeup and contemporaneous trade press respectively.)*

Verbatim, from Troia's writeup:

> "an unprecedented 4 billion user accounts spanning more than 4 terabytes of data"
> "more than 1.2 billion people"
> "names, email addresses, phone numbers, LinkedIn and Facebook profile information"
> "No password or authentication of any kind" was required; the server was "unprotected and accessible via web browser"

On the source of the data, verbatim: the majority of records were labelled with PDL as their source, and PDL's own marketing at the time claimed profiles on "Over 1.5 Billion unique people". The secondary dataset, from OxyData.io, was "an almost complete scrape of LinkedIN data".

From SecurityWeek, verbatim:

> "An exposed Elasticsearch server was found to contain data on more than 1.2 billion people"
> "The server was accessible without authentication and it contained 4 billion user accounts, spanning more than 4 terabytes of data"
> "The company told the researchers that the exposed server, which resided on Google Cloud, did not belong to it. The data, however, was clearly coming from People Data Labs."
> The researchers noted "the data returned by the PDL also contained education histories"

Discovery: Bob Diachenko and Vinny Troia of Data Viper, October 2019. Troia found his own decade-old landline number in the dump.

**PDL's stated position today.**
**Source:** `https://docs.peopledatalabs.com/docs/data-sources` (fetched 2026-09-03):

> "Sources of our proprietary data warrant their data is fully compliant with applicable data privacy regulations."
> "Our public data sources include open-sourced datasets, publicly available data, governmental public records and others as defined by various state and national laws."
> "Upon receiving an opt-out request, it is fulfilled."

PDL states it does not collect health data, race/ethnicity, sexual orientation, biometric identifiers, precise location, or financial information.

> **The gap.** PDL's compliance posture is *warranty-by-supplier* — "sources … warrant their data is fully compliant." It does not claim consent from the data subject, because there is none. And in 2019 a customer's unsecured copy of that warranted-compliant data put 1.2 billion people on the open internet, while PDL's position was that the server was not theirs. When the business model is licensing bulk copies of person records, every customer is a breach surface you do not control.

#### 3e. The regulatory ceiling

**FTC v. Kochava** (data broker, geolocation) —
**Source:** `https://www.ftc.gov/news-events/news/press-releases/2022/08/ftc-sues-kochava-selling-data-tracks-people-reproductive-health-clinics-places-worship-other` (fetched 2026-09-03):

> "Kochava purchases vast troves of location information derived from hundreds of millions of mobile devices. The information is packaged into customized data feeds that match unique mobile device identification numbers with timestamped latitude and longitude locations."
> "People are often unaware that their location data is being purchased and shared by Kochava and have no control over its sale or use."
> "Kochava's customized data feeds allow purchasers to identify and track specific mobile device users."
> "Kochava fails to adequately protect its data from public exposure. Until at least June 2022, Kochava allowed anyone with little effort to obtain a large sample of sensitive data and use it without restriction."

**FTC order against Mobilewalla** (Dec 2024) —
**Source:** `https://www.ftc.gov/news-events/news/press-releases/2024/12/ftc-takes-action-against-mobilewalla-collecting-selling-sensitive-location-data` (fetched 2026-09-03):

> "From January 2018 to June 2020, Mobilewalla collected more than 500 million unique consumer advertising identifiers paired with consumers' precise location data."
> Sold sensitive location information "without taking reasonable steps to verify consumers' consent."
> "When Mobilewalla bid to place an ad for its clients on a real-time advertising bidding exchange, it unfairly collected and retained the information in the bid request, even when it didn't have a winning bid."
> "The raw location data Mobilewalla collected was not anonymized and the company doesn't have policies to remove sensitive locations from the data set."

The order bans Mobilewalla from misrepresenting how it "collects, maintains, uses, deletes or discloses consumers' personal information."

**CNIL (France) — the data-broker chain doctrine.** This is the most directly transferable European precedent, because it holds the *downstream user* of broker data responsible for consent obtained upstream.
**Source:** `https://www.cnil.fr/en/data-brokers-solocal-marketing-services-fined-eu900000` (fetched 2026-09-03):

> "On 15 May 2025, the French Data Protection Authority (CNIL) fined SOLOCAL MARKETING SERVICES 900,000 euros"
> "SOLOCAL MARKETING SERVICES uses data collected by data brokers. Consequently, it must ensure that individuals have expressed valid consent before carrying out its prospecting campaigns."
> "the misleading appearance of the forms used by data brokers made it impossible to obtain free and unambiguous consent, in compliance with the requirements of the GDPR"

Related CNIL decisions in the same line (surfaced via cnil.fr search, **individual decision pages not separately fetched — UNVERIFIED beyond the fine amount and date**): FORIOU €310,000 (31 Jan 2024), HUBSIDE.STORE €525,000, CALOGA €80,000 (15 May 2025), TotalEnergies €1,000,000.

> **The transferable rule:** under CNIL's reasoning, buying enriched person data does not launder the consent defect. If the broker's consent was invalid, *your* processing is unlawful. A club that enriches its own members from a broker inherits the broker's consent problem.

---

### 4. Stated privacy stance vs. the record — summary table

| Vendor | What they say | What the record shows |
|---|---|---|
| ZoomInfo | Data is "publicly available information" gathered by "search technology"; opt-out at `/update/remove`; legitimate interest, not consent | $29,557,612.50 right-of-publicity settlement across CA/IL/IN/NV for using people's identities in "free preview" ads "without first obtaining their written consent"; `withinEu`/`withinCalifornia`/`noticeProvidedDate` flags in its own schema; trust-center pages bot-walled against inspection |
| Clearbit / HubSpot | HubSpot: "committed to maintaining high standards of responsible data sourcing, transparency, privacy, and security"; positioned as **company** data | Clearbit's own docs sold Reveal for "de-anonymizing traffic on your website"; a `suppression=eu` flag to skip EU residents; HN users describing it as "creepy" and unblockable by uBlock Origin; person payload included `bio`, `github.followers`, `twitter.followers`, `gravatar.avatars` |
| Apollo.io | Sources "publicly accessible websites, professional directories… vetted third-party data providers"; legal basis "legitimate interests"; "Right to Delete" | 2018: 125,929,660 records exposed with no password — leaked classes were exactly names, employers, job titles, locations, phone numbers, social profiles |
| People Data Labs | "Sources of our proprietary data warrant their data is fully compliant"; "Upon receiving an opt-out request, it is fulfilled"; no health/biometric/precise-location data | 2019: 1.2 billion people, 4TB, open Elasticsearch, no authentication; PDL said the server wasn't theirs but "the data… was clearly coming from People Data Labs"; ships `birth_date`, `sex`, `inferred_salary`, `possible_street_addresses` |
| Clay | "SOC 2 Type II", "GDPR — let us handle compliance with local laws", "CCPA — Support your customer base with opt out and DNC support" | Resells across "150+ data partners" — compliance is asserted at the aggregator layer while provenance for any given field is invisible to the buyer; CNIL's SOLOCAL reasoning would put the consent burden back on the buyer regardless |
| Lusha | Publishes "Data Sources", "Opt Out", "Do Not Sell My Info", "TIA", "Vendor Code of Conduct", "Community Terms of Use" links in its footer | Not assessed — pricing and policy pages did not render on 2026-09-03. **UNVERIFIED** |
| Seamless.ai | — | Not assessed. **UNVERIFIED** |
| Hunter.io | — | Not assessed. **UNVERIFIED** — narrower product (email discovery/verification), lower exposure |
| LinkedIn Sales Nav | — | Structurally different: subjects authored their own profiles, and there is no bulk export. The only vendor here where the data subject participated |

---

### 5. Implications for the arrival brief

1. **Capability is not the moat.** Every field a host could want — employer, title, seniority, tenure, city, timezone, education, photo, social handles — is one call and ~$0.03–$0.28 away. Building "we can find out about this person" is building a commodity.
2. **Consent is the moat.** Every vendor above sources without asking the subject, and every one of them has paid for it: $29.6M (ZoomInfo), 126M records (Apollo), 1.2B people (PDL), or reputational damage (Clearbit Reveal). A members club has something none of them do — **the member handed us the data, and can see and edit what the host sees.** That is a categorical difference, not a degree.
3. **Never ship an inference as a fact.** `inferred_salary`, `possible_street_addresses`, `is_likely_to_engage`, `contactAccuracyScore` — none of these are legible as guesses to a host reading a card in 90 seconds. Anything not member-provided or first-party-observed must be visually distinct or absent.
4. **Steal the provenance model, not the fields.** PDL's `first_seen` / `last_seen` / `num_sources` per datum, and ZoomInfo's `validDate` / `lastUpdatedDate`, are the right primitive. Every line on an arrival brief should know where it came from and when.
5. **The `suppression=eu` tell.** When a vendor ships an API flag whose purpose is to route around a jurisdiction's residents, that is the vendor's own assessment of its legal basis. Design so we would never need that flag.
6. **CNIL's SOLOCAL rule caps any "just buy it" shortcut.** If we ever enrich a member from a broker, we inherit the broker's consent defect. There is no clean purchase.

---

### UNVERIFIED / could not confirm

- **Lusha** pricing and privacy positions — `lusha.com/pricing/` rendered without its pricing table on 2026-09-03.
- **Seamless.ai** Pro/Enterprise pricing — "Contact sales" only; no published figure.
- **HubSpot Breeze Intelligence** standalone per-credit / per-enrichment dollar price — now bundled into "HubSpot Credits" against subscription tier.
- **ZoomInfo removal-complaint volume** — no figure asserted. bbb.org did not resolve to the ZoomInfo profile; reddit.com is not fetchable from this environment.
- **ZoomInfo Trust Center text** (`/trust-center/misconceptions`, `/trust-center/your-privacy`, `/business/privacy`) — Akamai bot wall, 403 / "Press & Hold to confirm you are a human", 2026-09-03, via both WebFetch and browser. Privacy-policy quotes above come from `zoominfo.com/legal/privacy-policy`, which did resolve.
- **Kim Martinez v. ZoomInfo, 9th Cir. No. 22-35305** holding text — law.justia.com returned 403 on 2026-09-03. The docket cite and posture are verified from the Ramos preliminary-approval memorandum; the appellate holding itself is not directly quoted here.
- **Wired's** "1.2 Billion Records Found Exposed Online in a Single Server" — wired.com is not fetchable from this environment. PDL exposure is sourced instead to Troia's own nightlion.com writeup and SecurityWeek.
- **FTC action specifically against a B2B contact-enrichment vendor** — none found. Kochava and Mobilewalla are geolocation brokers, cited as the legal ceiling by analogy, not as direct precedent for this category.
- **CNIL FORIOU / HUBSIDE.STORE / CALOGA / TotalEnergies** decisions — amounts and dates surfaced via cnil.fr search listings; only the SOLOCAL decision page was directly fetched and quoted.
- **Clearbit docs** are quoted from an Internet Archive snapshot (2019-08-20), not the live site, which is now behind authentication. Field names may have drifted before the HubSpot acquisition.


---


# 5. Conference / event matchmaking

## Conference / event matchmaking

**Scope of this section.** The closest existing art for "who else present should this arriving member meet, with an exposed score and reasoning." Every claim below is a verbatim quote from a page that was actually fetched; the URL fetched follows each quote. Anything not confirmed against a fetched page is marked **UNVERIFIED**.

### Headline finding

Across every platform audited, **no vendor exposes a numeric match score to the person being matched.** The category converged on *ranked lists plus categorical reasoning* — shared-interest tags, "what you have in common", commonality groupings. Numeric scores exist in this category only on the **exhibitor/lead side** (a lead's "interaction score"), never attendee-to-attendee. Grip appears to have shown a percentile in a ~2016 build, but that is not confirmable in any current Grip document.

The second axis — **declared vs. inferred input** — splits the field cleanly:

| Product | Numeric score to user | Reasoning shown | Input |
|---|---|---|---|
| Brella | No (not found) | Yes — shared-interest "pink tags" | **Declared** (registration-selected interests + intents) |
| Swapcard | No (attendee side) | **Yes — explicit "explanations"** | Hybrid: declared interests + in-app behavior |
| Grip | UNVERIFIED (percentile in old build only) | "Reasons To Meet" (third-party sources only) | Hybrid: registration data + swipe/click behavior |
| Whova | No | Yes — grouped by commonality | **Inferred/enriched** ("SmartProfiles are pre-populated") |
| Bizzabo | Not found | Not found | Registration + content engagement + interests |
| Hopin / RingCentral | No | No | **Random** (+ optional ticket-type rules) |
| twine | No | No | **Declared** tags, or host-defined rules |
| Attendify | UNVERIFIED | Tag-based discovery only | **Declared** interest tags |
| Web Summit / Collision | No | Basis stated at system level only | **Declared** interests/industry/goals + "activity" |
| SXSW | No | No | Declared profile + **heavily inferred** (others' favourites, GPS, Bluetooth beacons) |
| CES | No — binary selected/not | Criteria published in aggregate only | **Fully declared**, double opt-in |

---

### Brella — the purest "declared interests" model

Brella is the clearest example of matchmaking built entirely on what the attendee *states*, not what is inferred about them.

**What the attendee declares.** Three nested components chosen during registration/onboarding — category, then interest, then *intent*:

> "The Matchmaking is based on Artificial Intelligence (AI) recommendations that help organizers facilitate meaningful connections for participants at an event."
> — https://help-organizers.brella.io/en/articles/177659-introduction

Per that same article, participants pick a broad category (e.g. "Accounting, Finance & Insurance"), then specific interests within it (e.g. "Accounts Payable/Receivable"), then an intent for each interest from a fixed list — "networking, trading, investing, recruiting, or mentoring" — and the article notes these intents "are not customizable." After selection, "After selecting the intents, Brella will suggest connections to them accordingly."
— https://help-organizers.brella.io/en/articles/177659-introduction

The onboarding UI strings are plain and declarative:

> "Select the topics you are interested in networking with."
>
> "Complete your profile by writing a personal introduction and choosing the countries you operate in."
>
> "Brella will match you with people with similar interests that you can see on each individual's profile."
> — https://help-attendees.brella.io/en/articles/180488-create-an-event-profile

**The artifact: a "Your matches" tab, gated on declared interests.** This is the single most important Brella quote for our purposes — matching is a *hard filter on declared overlap*, not a soft score:

> "this tab displays only participants with at least one similar interest based on the categories a participant chose during the registration process."
> — https://help-organizers.brella.io/en/articles/182807-the-people-tab-is-for-networking

The other two tabs on the same People page:

> "this tab displays all attendees, including those who haven't enabled networking yet or haven't completed their profiles."
>
> "this tab shows the attendee profiles that you bookmarked during the event."
> — https://help-organizers.brella.io/en/articles/182807-the-people-tab-is-for-networking

**Reasoning is shown — as colored interest tags, not sentences.** The attendee-side help describes Your Matches as showing:

> "people who have common interests as you (pink tags)"
> — https://help-attendees.brella.io/en/articles/180805-start-networking-in-the-people-tab

So the "why" is rendered as the literal overlapping interest chips on the card. There is **no** "you both are interested in X" sentence, and **no percentage** — neither the organizer nor attendee help articles fetched mention any score, percentage, or star rating.

**The tab does not exist until you declare.**

> "Until you enable the networking profile, the 'Your matches' tab will not be visible on the people tab."
> — https://help-attendees.brella.io/en/articles/180482-fast-onboarding-an-event-on-brella

> "'Your matches' tab in the people tab will get activated only after the networking profile has been set up after matchmaking selections."
> — https://help-organizers.brella.io/en/articles/177082-onboarding-modes

**Marketing framing** leans on intent as the differentiator:

> "The algorithm is engineered to find and connect top networking matches in seconds based on their matching interests and goals."
>
> "Attendees come to your event with important goals in mind (e.g. finding investors, a solution to bolster their business, taking the next step in their career, and so forth)."
>
> "ATTENDEE INTENTS: this helps you discover which portion of your attendee base comes for investments, business, jobs, and more"
>
> "intent-based matchmaking is proven to boost ticket retention by up to 4x!"
> — https://www.brella.io/event-networking

There is a behavioral-learning layer on top, but it is described as improving the algorithm over time rather than as the primary input:

> "AI-powered matchmaking can understand this complex phenomenon by going beyond keywords or titles and focusing on a deeper level – intents based on user's past behavior."
> — https://www.brella.io/blog/ai-matchmaking-future-of-events

**Pricing:** not published. The pricing page "does not display pricing tiers or plans, cost figures, feature allocation by tier" and directs visitors to contact sales. — https://www.brella.io/pricing

---

### Swapcard — the only platform that ships an explicit *explanation* feature

Swapcard is the closest existing art to an exposed-reasoning arrival brief. It has a shipped, named feature for explaining recommendations, and it published the design rationale.

**The feature announcement** opens by quoting IBM on explainability:

> "In general, we don't blindly trust those who can't explain their reasoning."
> — https://release.swapcard.com/explanation-of-peoples-recommendations-3kKj16

The release states the problem and the feature in the platform's own words:

> "One of the key reasons attendees go to an event is to network."
>
> "However, it can be daunting to find the right people to talk to or kick-start conversations with strangers."
>
> "Our AI recommends matches based on profile similarities."
>
> "With this new feature, attendees can see why they were matched with a particular person!"
>
> "This helps them break the ice and provides them with topics of conversation."
> — https://release.swapcard.com/explanation-of-peoples-recommendations-3kKj16

It then describes a **two-level disclosure pattern** that maps almost exactly onto the arrival-brief problem:

> "For personalized people recommendations, the first level of explanations is displayed."
>
> "It provides the attendee with general information on what people have in common."
>
> "Then, after clicking on the user profile, high-level explanations will be displayed with details."
>
> "Attendees will find the events they have in common, interests, jobs, and so on."
> — https://release.swapcard.com/explanation-of-peoples-recommendations-3kKj16

And it states plainly where the explanations come from — they are a *byproduct of the graph*, not post-hoc copy:

> "The recommendations are based on your data, this includes your profile and the interactions that you have using the app."
>
> "With this data, we create a Machine Learning model that highlights the links between your data and other data."
>
> "A large graph is then created that links all the available data between each user according to similarities or associations found by the algorithm."
>
> "These similarities or associations are the **explanations**."
> — https://release.swapcard.com/explanation-of-peoples-recommendations-3kKj16

**Confirmed in the organizer help center**, with the stated purpose being conversational, not evaluative:

> "'Personalized recommendations': you can encourage attendees to complete their profile and use the app to gather even more accurate recommendations. Explanations are available of people's recommendations in order to give attendees topics of conversation. AI recommends matches based on profile similarities such as events they have in common, interests, jobs, and so on."
> — https://help.swapcard.com/en/articles/8158937-people-creating-and-managing-the-participants-page (same text at .../8158937-creating-and-managing-the-participants-page-enhancing-networking-opportunities)

**And on the platform AI page:**

> "Every recommendation includes an explanation, so participants understand why a connection or session was suggested"
> — https://www.swapcard.com/platform/artificial-intelligence

**The blog states the goal explicitly** — note that the stated purpose is *knowing what to talk about*:

> "AI-driven attendee recommendations appear within carousels and include brief texts in user profiles, highlighting shared interests with matched users."
>
> "The goal is to match people and highlight shared interests so that they meet and know what to talk about."
>
> "Once registered, Swapcard's AI pairs individuals based on shared goals, interests, and expertise, fostering meaningful connections."
> — https://www.swapcard.com/blog/swapcard-ai-features

**How it scores — internal weights are published, but never surfaced as a number.** The organizer help center gives the actual feature weights:

> "The graph creates links between people and their interests to predict new connections."
>
> People: "Biography (0.3), network, jobs, custom field knowledge, custom field interest (5.0), events (0.3)"
> — https://help.swapcard.com/en/articles/9449143-maximize-your-event-impact-using-the-power-of-ai

Note the weighting: **declared interest fields are weighted 5.0 versus 0.3 for biography and events** — i.e. an order of magnitude more weight on what the attendee explicitly declared than on ambient profile text. The same article gives a worked example of the asymmetric interest→knowledge match, which is exactly the "who should meet whom" shape:

> "Sustainability in User A's interest, User B's knowledge: high chance that User B recommended to User A."
>
> "An exhibitor with expertise in Camping Equipment will be highly recommended to a user interested in Camping Equipment."
> — https://help.swapcard.com/en/articles/9449143-maximize-your-event-impact-using-the-power-of-ai

**A privacy boundary worth copying.** Private behavior is used for *your* recommendations but never leaks into what others see:

> Private data (searches, filters, streams): "never used to compute the recommendations sent to other users"
> — https://help.swapcard.com/en/articles/9449143-maximize-your-event-impact-using-the-power-of-ai

**Inputs are hybrid — declared plus observed:**

> "Swapcard uses visible profile fields, attendee interests, job roles, and in-app behavior (like booth visits or session views) to suggest matches."
>
> "Customize profiles with goals, focus areas, and interests beyond job titles."
>
> "Refine matches in real-time as attendees engage and AI learns from their actions."
>
> "Matchmaking uses AI to recommend meaningful connections based on profile data and activities."
> — https://www.swapcard.com/features/event-networking

**A number does exist — but only on the exhibitor side, about leads, not about people you should meet.** The "AI Recommended Leads" feature scores attendees for exhibitors:

> "our lead score is dynamic, growing with new interactions and fading when interest drops."
> — https://www.swapcard.com/blog/swapcard-launches-ai-recommended-leads-event-exhibitor-roi

That page describes exhibitors viewing "potential leads along with their interaction scores, detailed interaction history, and profile information", scored on "attendee actions, timing, and event-specific behaviors."
— https://www.swapcard.com/blog/swapcard-launches-ai-recommended-leads-event-exhibitor-roi

This is the key asymmetry for our product: **the score is shown to the party doing the selling, the explanation is shown to the party doing the meeting.**

**Pricing:** tiers published, figures not. Starter "200/year", Professional "1,000/year", Enterprise "Unlimited" attendees; add-on pricing shows only "$" symbols with no figures. "AI Recommended Leads" is Enterprise-only, described as "Provide exhibitors with an AI-driven list of potential leads, spotlighting attendees who've shown interest in their booth."
— https://www.swapcard.com/pricing

---

### Grip — behavior-learning model, swipe-based, score UNVERIFIED

Grip is the contrast case to Brella: the algorithm is explicitly framed as *learning from behavior*, and the attendee trains it through a Tinder-style interested/skip loop.

**The artifact is well documented** thanks to an RSNA-published Grip reference guide, which enumerates the card fields exactly:

> "Connections will be displayed in a Person Content block. Each Person Content Block on the display is collapsed upon initial entry and contains the Individual's Image, Name, Profile type and Title along with buttons providing actions for the user."
>
> "The expanded block contains Additional profile information depending on the configuration."
>
> "Actions available within the Person Content Block include Meet, Interested, Skip and Chat."
> — https://www.rsna.org/-/media/Files/RSNA/Annual-meeting/Exhibitors-and-sponsors/Planning-your-exhibit/Exhibitor-best-practices/Grip-Quick-Reference-Guide.ashx (PDF, text extracted)

**Card fields, enumerated:** image, name, profile type, title, plus Meet / Interested / Skip / Chat buttons. **No match percentage, no shared-tag list, no "why matched" string appears in this enumeration.**

The reasoning given for the list is generic and sits above the list, not on the card:

> "Based on information provided, the system has determined connections within the event who have common interests and with which you may want to meet."
> — same RSNA PDF

**The list is called "Recommended for You"** and is capped:

> "Recommended for You" — "suggests up to 10 participants"
> — https://support.grip.events/how-do-i-request-a-meeting

**Every swipe is training data** — this is the explicit behavior-learning loop:

> "Interested: When selected, the attendee is removed from the current list (Recommended for you) and can now be found in the My 'Interested' list. By selecting this button, Grip will update the user's profile to provide better recommendations for other participants to meet."
>
> "Skip: When selected, the attendee is removed from the current list (Recommended for you) and can now be found in the My 'Skip' list. By selecting this button, Grip will update the user's profile to provide better recommendations for other participants to meet."
> — same RSNA PDF

**Matching is mutual and anonymous** (a "handshake"), per Grip's own App Store listing:

> "Anonymously swipe later or interested on members. When the other person also swipes interested on you, it's a handshake!"
>
> "Every action you take influences the strength of your Grip, the stronger it is, the more handshakes you get!"
> — https://apps.apple.com/us/app/grip-event-networking-app/id864239776

**Inputs — declared seed, behavioral refinement.** Grip's own product page states the two-stage model plainly:

> "Grip's advanced AI algorithms do the work of finding the perfect matches for your participants. Starting with simple matching-facts (you want this, you sell this), with every click, expression of interest or session added to a personal schedule, Grip's recommendations improve for everyone. With 15 strategies running simultaneously, Grip's match-making is unrivaled in B2B exhibitions."
> — https://www.grip.events/solutions/trade-show-software

The matchmaking product page lists both signal families:

> "answers provided by participants at various stages (e.g. at registration and/or onboarding)"
>
> "data from actions and behaviors that participants - and people like them - take in the platform (e.g. searching for a company or adding a session to their schedule)"
>
> "behavioral data from the app (e.g. sessions or participants viewed)"
> — https://www.grip.events/products/event-matchmaking

Note the collaborative-filtering phrasing: **"and people like them"** — Grip infers from cohort behavior, not only from your own.

The same page claims "16 different strategies" including "machine learning, content filtering" over "70 million data points" — note this conflicts with the "15 strategies" figure on the trade-show page and the "Over 15 different strategies" on the networking-features page. The scale claim is marketing, not a documented mechanism.
— https://www.grip.events/products/event-matchmaking

Profile seeding is automatic from registration, not self-declared:

> "An attendees profile typically gets imported straight from the registration data so it's very easy for attendees to get started."
>
> "The app will automatically make recommendations of relevant people each attendee may want to connect with."
>
> "The more a user interacts with the app, the better and more relevant matches they'll receive."
> — https://www.grip.events/news/how-to-improve-your-event-networking-with-ai-matchmaking

The RSNA guide also documents optional social-graph import:

> "Linking with Facebook and/or LinkedIn will allow the networking tool to work more efficiently with presenting connections."
> — same RSNA PDF

Grip's homepage framing:

> "By analyzing attendee data, behaviors, and preferences, our platform automatically generates highly relevant, mutual matches."
> — https://www.grip.events/

> "Grip generates recommendations for users thanks to our powerful AI and machine learning technologies. Over 15 different strategies are used to create these recommendations."
> — https://www.grip.events/features-categories/networking

**Does Grip show a number? UNVERIFIED.** No fetched Grip document — product pages, support.grip.events articles, or the RSNA reference guide — mentions a match percentage, score, or star rating. The only evidence for a percentage is a **2016 user review** on Grip's own App Store listing praising the "swiping interface for the percentile matches" as useful for finding leads at conferences (— https://apps.apple.com/us/app/grip-event-networking-app/id864239776). Treat as: **plausibly true of a ~2016 build, not confirmable in the current product.**

**"Reasons To Meet" — reasoning feature, third-party sourced only.** An independent 2017 product review states Grip shows attendees "not just who, but also _why_ they should meet someone, in the form of Reasons To Meet."
— https://marcabraham.com/2017/05/19/app-review-grip/

The same review confirms the NLP basis and organizer-configurable rules:

> "natural language processing to connect event attendees based on interest, needs and other things they've got in common"
>
> users can "tailor the real-time recommendations they get by setting their own matchmaking rules"
> — https://marcabraham.com/2017/05/19/app-review-grip/

**"Reasons To Meet" does not appear on any current Grip page fetched.** Explicitly checked and confirmed absent on: /products/event-matchmaking, /features-categories/networking, /products/mobile-event-app, /solutions/trade-show-software, /news/how-to-improve-your-event-networking-with-ai-matchmaking, /blog/7-secrets-of-game-changing-event-networking, /blog/b2b-event-matchmaking-tool-for-your-exhibitors (returned "NOT PRESENT"), and /blog/networking-solution-guide-for-tradeshows-meetups-and-conferences (returned "NOT PRESENT"). Mark the feature name as **UNVERIFIED for the current product** — it is attested only in 2017 third-party review coverage.

The exhibitor-side swipe vocabulary is confirmed on a current page — swipe right is a "Handshake", left is "Later", and exhibitors establish profiles with "areas of interest" against which the system recommends "aligned interests".
— https://www.grip.events/blog/b2b-event-matchmaking-tool-for-your-exhibitors

> the platform "learns from every interaction attendees make, and improves its recommendations, in real time."
> — https://www.grip.events/blog/networking-solution-guide-for-tradeshows-meetups-and-conferences

**Feedback loop after the meeting:**

> "Participants can instantly rate meetings with a simple thumbs up or thumbs down"
> — https://www.grip.events/products/event-matchmaking

**Pricing:** not published. A third-party review notes "Contact for pricing" for all tiers and "No published pricing, no self-serve tier, no free trial", listing "Opaque Enterprise Pricing" as a limitation. — https://youreventkit.com/tools/grip/ (third-party). grip.events/pricing returns 404.

---

### Whova — inferred/enriched profiles, reasoning by *grouping*

Whova is the strongest contrast on the input axis: it explicitly **does not rely on the attendee declaring anything**, and pre-fills profiles itself.

**The pre-population claim, stated as a selling point:**

> "Attendees' SmartProfiles are pre-populated by Whova and attendees can just edit or input additional information (e.g. interests) for better matchmaking."
>
> "Whova's SmartProfiles are pre-populated for **rich profiles** without relying on attendees' manual inputs."
> — https://whova.com/blog/attendee-matchmaking-event-networking/

> Whova uses "SmartProfiles" which "can help them automatically fill in information based on registration." … "If they feel like changing anything or adding more in-depth information, they can always return to edit or add more, like listing their interests!"
> — https://whova.com/blog/whova-event-matchmaking/

**The artifact is a "Recommended" tab that groups people by the commonality that produced them** — the reasoning *is* the group heading:

> "Click the 'Recommended' tab on the top of the Attendees list"
>
> The Recommended feature identifies "attendees who came from the same city or have the same affiliations, educational background, or interests as you."
>
> "At the top of each group list, you will see a link to join or organize a Meet-up with the recommended attendees."
>
> "Make sure that your profile has enough information to match with other attendees."
> — https://whova.com/resources/how-to-guide/whova-app-faq/

> "In the recommended tab, Whova automatically gathers attendees with similar interests based on the information you filled into your own personal profile."
>
> "View attendees with similar backgrounds and interests, find attendees in your physical location, and find others who graduated from your school."
> — https://whova.com/pages/attendee-networking-guide/

**The commonality dimensions, from Whova's own marketing:**

> "Instantly provide **personalized match suggestions** based on shared interests, locations, affiliations and education."
>
> "Attendees can instantly find the most relevant people to achieve their networking goals. Whova's matchmaking feature uses attendee profiles to suggest curated connections that truly matter."
>
> "Help attendees **discover the right people** by filtering categories such as exhibitors, speakers, sponsors, and more."
>
> "Quickly **start conversations** with built-in introductions that make connecting less intimidating."
>
> "Effortlessly **gather similar attendees** into conversation groups for in-person or virtual meetups."
> — https://whova.com/event-management-software/event-networking-software/

> "Whova recommends people with commonalities including professional and educational background, location, interests, and industry."
>
> "Attendees see **quality matches** recommended by the app, based on their professional backgrounds, location, and interests"
>
> An attendee might "add 'machine learning', 'software', and 'startup', to his profile as interests."
> — https://whova.com/blog/attendee-matchmaking-event-networking/

> "Whova Matchmaking takes attendee's customized profiles and uses them to create matches based on interests, backgrounds, company affiliations, and much more."
> — https://whova.com/blog/whova-event-matchmaking/

**Card fields verified:** photo/name/title via the attendee list, a "View Profile" button, bookmark, and direct message — "send a message directly from the matchmaking feature" — plus meet-up invitation tools. — https://whova.com/blog/whova-event-matchmaking/

The two card actions are labelled **"Say Hi"** and **"Message"**, the tabs are **"Attendees"** and **"Recommended"**, and profiles support taking notes and requesting contact information.
— https://whova.com/pages/attendee-guide/ and https://whova.com/resources/how-to-guide/user-tutorial/

**No score.** None of the Whova pages fetched mentions a percentage, score, or star rating. The reasoning is carried entirely by *which group a person appears under*, not by per-card explanation text. Exact group heading strings (e.g. whether the UI literally reads "Same city") could not be confirmed — the Whova attendee PDF guides are image-based screenshots with no extractable text. **UNVERIFIED: exact group label strings.**

**Pricing:** not published. The pricing page shows only a "Price Quote Request" form and a "Book a 20 min 1:1 demo to get a trial" CTA, with no tiers or figures. — https://whova.com/pricing/

---

### Bizzabo — matchmaking claimed, artifact undocumented

Bizzabo relaunched a networking suite in 2025. The marketing describes a goal-aware matchmaker but publishes nothing about the card, the score, or the explanation.

> "Our AI-powered engine looks at each attendee's interests, event activity, and preferences to recommend the most relevant people to meet."
>
> "Instead of browsing aimlessly or relying on chance encounters, attendees get personalized suggestions that align with their goals — whether they're looking for collaborators, prospects, or peers."
> — https://www.bizzabo.com/blog/event-networking-suite

> "With AI-powered event matchmaking software, attendees can identify relevant connections, view enhanced profiles, and initiate conversations and meeting requests."
>
> "Backed by hundreds of data points, ranging from registration to content engagement to interests, Bizzabo's matchmaking engine is designed to help attendees make the right connections at the right time."
> — https://www.bizzabo.com/event-management-software/event-networking-platform

The launch press release gives a lower number for the same claim ("dozens" vs "hundreds"):

> "It leverages dozens of data points, from registration to content engagement to people's interests, making its matchmaking more accurate."
> — https://www.prnewswire.com/news-releases/bizzabo-launches-integrated-networking-suite-to-transform-event-connections-302429906.html

**Score: not found. Reasoning: not found.** No fetched Bizzabo page describes a match score, percentage, or any "why matched" string. A targeted check of https://www.bizzabo.com/blog/bizzabo-event-networking-suite-2025 returned "NOT PRESENT" for all four of: score/percentage display, "why matched" reasoning, recommended-person card contents, and matchmaking inputs. Bizzabo has no reachable public help centre (help.bizzabo.com does not resolve — `ENOTFOUND`), so the attendee-facing artifact is undocumented. **UNVERIFIED** on card fields, score, and reasoning.

**Inputs:** registration data + content engagement + stated interests — i.e. hybrid, leaning behavioral. Goal-awareness ("collaborators, prospects, or peers") is asserted but the mechanism for capturing the goal is not documented.

**Pricing — the only vendor in this section publishing real figures:**

> "$499/user Per month, billed annually (3 user minimum)"
>
> "Starting at $17,999 Per year, billed annually, 3 user minimum"
> — https://www.bizzabo.com/pricing

Base tier networking includes "Access to event community", "1:1 messaging", "Community search". Smart matchmaking is a paid add-on:

> "Networking - Elevate networking to a strategic advantage with 1:1 meeting scheduling, smart matchmaking, and native reporting."
> — https://www.bizzabo.com/pricing

---

### Hopin / RingCentral Events — deliberately *random*, the anti-matchmaker

Worth including precisely because it is the null hypothesis: a major platform whose flagship networking feature does no scoring at all.

Hopin's Networking area pairs whoever presses Ready, at random. Verified from an event organizer's step-by-step Hopin guide:

> "You click on the 'ready' button in the networking area and our random matchmaking will select a first available random person for a call."
>
> "You invite directly someone specific in the 'People' section which is on the very right side in the networking area by clicking the 'Invite to video call' button."
> — https://www.0100conferences.com/news/how-does-it-work--step-by-step-guideline-how-to-use-hopin

Corroborated by an attendee walkthrough:

> "The networking feature lets you match up randomly with other attendees for quick virtual networking sessions. When you're ready, click the ready button to be randomly matched with someone else who's also waiting."
>
> "If I click connect, the system will exchange our contact information, just like a business card."
> — https://gotranscript.com/public/navigating-your-hopin-event-a-comprehensive-guide-for-attendees

So: random pairing is the default, and an attendee who wants a *specific* person must bypass Networking entirely and invite them from the People tab. Hopin's own "Networking FAQs" support article additionally describes organizer-set ticket-type constraints (e.g. matching "job seekers" with "Employers") — **UNVERIFIED**, as the canonical URLs (support.hopin.to; support.hopin.com/hc/en-us/articles/360056527831-Networking-FAQs) are now dead or redirect to events-support.ringcentral.com, which returns **HTTP 403** to fetching.

What *was* verified from a live RingCentral page is only the generic claim:

> "Enable your audience to create meaningful and personalized connections within your event with 1:1 and group video networking."
> — https://www.ringcentral.com/rc-events/solutions/virtual-event-platform.html

**Score: no. Reasoning: no. Input: neither declared nor inferred — random, with optional organizer-set ticket-type rules.**

---

### twine (twine.us) — declared tags, rotation not ranking

Note on identity — both domains were checked, as instructed. **twine.nyc 301-redirects to try.twine.nyc, which 301-redirects to https://www.twine.us/** — same company, and this is the events/networking tool. **twine.ai 302-redirects to https://twine.net/ai**, an entirely different company whose headline reads "AI Training Data: Collection & Labeling Services at Scale" — AI training-data collection and labelling, with no relation to event networking or conference matchmaking. Out of scope.
— https://twine.net/ai

twine is speed-networking/breakout rotation, not a recommender. There is no recommended-person card at all — the product moves people into timed conversations.

> "Beautiful virtual networking experiences for Web and Zoom."
>
> "Match attendees for back-to-back Breakout Sessions based on custom rules, without leaving Zoom."
>
> "Choose from various matchmaking modes including Speed Networking, Visual, A/B, and Multi-Tag to connect your people for timed conversations."
> — https://www.twine.us/

The modes, verbatim:

> **Speed Networking:** "sort participants into randomly assigned, back-to-back Breakout conversations that automatically rotate to a new match after a given amount of time"
>
> **A/B:** "host can create custom sorting rules. Hosts can match mentors with mentees, job-seekers with employers, teaching assistants with students"
>
> **Multi-Tag:** "participants self-identify who they are" and "participants also select who _they_ want to match with– _and_ they can select more than one identifier"
>
> **Visual Breakout:** "create themed Breakout Rooms that participants can join and leave at any time"
> — https://www.twine.us/blog/speed-networking-on-zoom-mode-is-right-for-you

**Score: no — no scores in any mode. Reasoning: no. Input: fully DECLARED** in Multi-Tag (self-identify + select desired counterpart types), **host-declared** in A/B, **random** in Speed Networking.

**Pricing — published in full** (from the pricing page, which supersedes the homepage summary):

> **Starter** — "For teams looking to try something new." "Participants: up to 6". Includes "twine for Zoom," "All modes," "Self-guided support"
>
> **Pro** — "For individuals, SMBs, education, training, accelerators, nonprofits, & communities." "$99/mo. per host" "Participants: up to 100 per month"
>
> **Business** — "For distributed teams & companies with 100+ employees" "Participants: unlimited" — "Everything from Pro," "Dedicated support," "Analytics / Reporting"
>
> **Events** — "For event professionals" "$5 per attendee, billed annually" "Participants: Up to 10k" — "Up to 10k concurrent users," "Embed code," "Parameterized URLs," "Custom branding available," "White glove support available"
> — https://www.twine.us/pricing

Note: "All modes" is a **Starter-tier** inclusion — the matching logic is not paywalled; scale and support are.

---

### Attendify — declared interest tags, no verifiable score

Attendify's networking was tag-based discovery, not scored recommendation. Attendees add tags to their profile so others with the same tags can find them via a filter; tags span hobbies (Sports, Photography, Cycling) and event roles (Planner, Speaker, Investor, Sponsor); the feature was branded-app-only and unavailable in the shared Attendify App.
— Attributed to https://help.attendify.com/managing-an-event-app/social-management/interest-tags. **UNVERIFIED — this URL failed to fetch (SSL handshake error, `TLSV1_ALERT_INTERNAL_ERROR`); text above is from search-result summary only and was not confirmed against a fetched page.**

Third-party claims that Attendify "pairs people by similarity score" with "a percentage score to rank the top matches" appear in aggregator content. **UNVERIFIED — could not be confirmed against any Attendify-controlled page, and a fetch of the LineUpr comparison article that supposedly carried the claim returned no mention of Attendify at all** (https://lineupr.com/en/blog/best-event-apps-for-attendee-networking). Do not cite this as evidence that anyone ships a visible percentage.

Attendify was acquired/wound down; there is no live product page. **Pricing: UNVERIFIED / n/a.**

---

### Web Summit — "we don't leave meeting the right people to chance"

Web Summit is the most rhetorically confident matchmaker in the category and still shows no number.

**Sourcing note:** support.websummit.com serves 403/404 to non-browser clients; those quotes come from dated Wayback captures, flagged inline.

**Mingle** — the three-minute video-roulette surface:

> "Mingle is an opportunity for you to connect with the right people, based on the locations, interests and backgrounds shared on your event profile. Our software will match you with people we think you should meet, network with, teach or learn from."
>
> "From there, you engage with attendees in three-minute time-boxed video calls. These quick interactions should get you talking about things you have in common (such as a recent workshop you both attended). After the end of your call, you can view your conversation partner's profile information and connect with them further, online or off."
>
> "Web Summit is all about meaningful connections – that's why we don't leave meeting the right people to chance."
> — https://web.archive.org/web/20200928164116/https://support.websummit.com/support/solutions/articles/44002027333-what-is-mingle-

**Meetups** — the productized matchmaking surface:

> "Finding real connections among 70,000+ attendees at Web Summit is easy. Our recommendation system helps you find the right people based on your shared interests, industries and goals."
>
> "Our software seamlessly matches you with relevant communities based on your exact goals and passions, ensuring every conversation you have is actually worth your time."
>
> "AI-powered meetups" … "Our recommendation system helps you find the people who matter most to you, based on shared interests, industries, and goals."
> — https://websummit.com/meetups/

**Input is declared, with one behavioural signal.** The declared basis is stated repeatedly — "based on the locations, interests and backgrounds shared on your event profile" (Mingle FAQ URL above), and:

> "We've selected these events based on your background, interests, industry, and the community you specified."
> — https://web.archive.org/web/20250524062621/https://support.websummit.com/support/solutions/articles/44002562245-what-are-meetups-

The only inferred signal found anywhere is the word "activity":

> "Discover what's happening in real time through a personalised feed, with recommended talks, speakers, companies, and experiences based on your interests and activity."
> — https://play.google.com/store/apps/details?id=com.summitengine.attendee&hl=en_US

Profile fields are self-entered and enumerated: "Your profile will showcase essential personal information, such as your profile picture, name, job title, the company you work for, the industry you belong to, and the country you are joining from."
— https://web.archive.org/web/20250211090300/https://support.websummit.com/support/solutions/articles/44002505834-will-my-email-address-be-visible-to-other-attendees-

**No LinkedIn ingestion or third-party enrichment language appears on any fetched Web Summit page. UNVERIFIED whether any exists.**

**Score: none found. Reasoning: system-level only.** The closest thing to a per-match explanation is the Mingle line about "things you have in common (such as a recent workshop you both attended)" — a prompt for the conversation, not a rendered explanation on a card. **UNVERIFIED: no fetched source shows a per-person "you both are interested in X" string.**

**A consent gate worth noting** — contact details are withheld until the connection is mutual:

> "Your email address will remain hidden unless you accept a connection request from another attendee."
> — https://web.archive.org/web/20250211090300/https://support.websummit.com/support/solutions/articles/44002505834-will-my-email-address-be-visible-to-other-attendees-

> "Please note that by connecting with someone on the app, you are agreeing to share your email address."
> — https://web.archive.org/web/20260416175132/https://support.websummit.com/support/solutions/articles/44002271805-chatting-with-other-attendees-on-the-app

**Startup↔investor matchmaking is a separate, human-curated portal** — "startup-to-investor matchmaking portal, in which investors get to select the startups they'd most like to meet" — https://websummit.com/blog/startups-investors/startups-success-networking-investment-pitch/

Notably, an organizer-published testimonial concedes the curated portal underperformed brute-force self-serve outreach:

> "We initially applied through the startup-to-investor matchmaking portal...I think we met three investors that way. But the other 40 investor meetings came about through us reaching out directly to everybody that had registered as an investor through the app."
> — https://websummit.com/blog/startups-investors/startups-success-networking-investment-pitch/ (organizer-published; treat as marketing-selected testimony)

**Attendee sentiment — the complaint is reliability, not creepiness:**

> "While the UI is nicer in new version, the overall app experience is frustrating. It frequently breaks, networking is hard to manage, search and navigation are unreliable, and the UX isn't intuitive."
>
> "One of the worst event apps I've ever used. The Web Summit 2026 app is unbelievably laggy and unstable... Trying to connect with people barely works, and when it does, it takes multiple attempts or just fails entirely."
> — https://play.google.com/store/apps/details?id=com.summitengine.attendee&hl=en_US

**Pricing** (Lisbon, Nov 9–12 2026) — https://websummit.com/tickets/attendees/

> General attendee: "€ 1,595" struck through → "€ 950" → "€ 772 Excl. sales tax"
> VIP: "€ 1,950" → "€ 1,585 Excl. sales tax"
> Chairperson: "€ 24,950" → "€ 20,285 Excl. sales tax"

General-attendee benefits are listed verbatim as including "Tailored networking recommendations", "Invites to curated Meetups", "Downloadable file of contacts", "Searchable attendee list" — i.e. **the attendee directory is itself a priced, exportable feature.**

---

### Collision — no longer a separate event

**Structural finding: Collision has been absorbed into Web Summit Vancouver.** `collisionconf.com` returns `HTTP/2 301` with `location: https://vancouver.websummit.com/`, and the served page title is "Web Summit Vancouver | May 25-28, 2027".
— https://collisionconf.com/ → https://vancouver.websummit.com/

It therefore runs the same stack and the same app (`com.summitengine.attendee`), so every Web Summit finding above applies. Its own copy:

> "AI-powered meetups" — "Our recommendation system helps you find the people who matter most to you. Use it to connect with like-minded leaders and thinkers."
>
> "Meet your peers" — "Are you an artist innovating with tech? A space enthusiast? From entrepreneurs sharing books they love, to founders confronting imposter syndrome, each meetup helps you find the connections that resonate most."
> — https://vancouver.websummit.com/meetups/

**Score: none. Reasoning: none per-match. Input: declared** — "Fill out an event profile with your personal information and interests. You can then begin browsing talks, building out your event calendar and connecting with attendees." — https://websummit.com/app/

**Sentiment: UNVERIFIED** — no standalone Collision app exists, so there is no separate review corpus; Web Summit app reviews are the applicable proxy.

**Pricing: UNVERIFIED.** The tickets page publishes no face value, only a 2-for-1 pre-registration capture ("Unlock 2-for-1 tickets before they're gone. Sign up now.") and a countdown reading "Save CA$100 before prices increase in". — https://vancouver.websummit.com/tickets/attendees/

---

### SXSW — the most inference-heavy program in the audit

**Naming correction: "SXSW Connect" does not appear on any page fetched.** The real brands are **SXSW GO** (the app) and **SXSW Recommends** (the engine). Treat "SXSW Connect" as **UNVERIFIED / no evidence it exists.**

**Sourcing note:** SXSW rebuilt sxsw.com for 2027; `/mobile/` and `/networking/` now 404 and are absent from the sitemap. Quotes below are from the 2026-07-13 Wayback capture describing SXSW 2026.

> "Networking – Search the directory for other SXSW attendees and send direct messages. Boost your networking with personalized recommendations from SXSW Recommends. Opt-in to location services to see who's around you."
>
> "SXSW Recommends - The SXSW Recommends algorithm has been optimized for SXSW with machine learning! Get personalized recommendations and opt-in to notifications for real-time recommendations."
>
> "You'll be able to boost your networking this SXSW season even further by receiving personalized recommendations from SXSW Recommends on the best people to connect with."
> — https://web.archive.org/web/20260713045345/https://sxsw.com/mobile/

**The vendor (Eventbase, who builds SXSW GO) describes collaborative filtering explicitly:**

> "Last year, it was attendee matching and the largest beacon deployment for more relevant and efficient networking. New in 2016's SXSW GO app: an advanced recommendation engine that tailors the experience to individual attendees—serving up on-demand recommendations based on users' own profiles and preferences as well as what others have favorited."
>
> "Tapping into our knowledge of beacons, these alerts will be based on attendees' location as well as gaps in their schedules."
> — https://www.eventbase.com/news/personalizing-attendee-journey-sxsw-gos-new-recommendations-engine

**This is the inference frontier of the category.** Declared inputs exist ("Upload your profile photo" / "Update Your Bio" / "All this will help you get the most out of our networking capabilities"), but they are joined by three inferred channels:

- **Others' behaviour:** "what others have favorited" (Eventbase URL above)
- **Continuous location:** "Opt-in to location services to see who's around you" and "'Always' will allow access to your location even when the app is in the background"
- **Bluetooth beacons:** "Enable Bluetooth to ensure that you are able to receive our personalized recommendations."
— https://web.archive.org/web/20260713045345/https://sxsw.com/mobile/

**Consent is nonetheless explicit and revocable**, which is the mitigating design:

> "You can verify if you've opted into the Attendee List by going to the SXSW GO App > Settings > to make sure you're opted-in to the attendee list and direct messages from other attendees."
> — https://web.archive.org/web/20260713045345/https://sxsw.com/mobile/

Linking a credential lets you "Adjust your profile visibility to align with your goals" and "Receive personalized Recommendations" — same URL.

**Score: none found. Reasoning: none per-match.** The only reason-shaped surface is temporal/spatial, not interpersonal: "Events Nearby uses your current location along with the SXSW Schedule's current Event Status to show a real-time list of events happening near you." — same URL.

**Attendee sentiment** (Apple review feed, https://itunes.apple.com/us/rss/customerreviews/id=418450665/sortBy=mostRecent/json):

Positive, and notably about a *reason-shaped* feature:
> "Scheduled Gap Recommendations work really well. Great feature." (5★)

Negative, and directly relevant — a user preferring their *declared* intent over the algorithm's suggestions:
> "The suggestions versus opening to your personal schedule is irritating. I'd rather see my favorites and SXSW recommendations." (2★)

> "Does not save things I update in the app — Spent 30 minutes saving events I wanted to attend **and people I wanted to meet** and it didn't save any of it" (1★)

> "App crashes every 20 seconds... For a tech driven conference, you expect much better." (1★)

**Creepiness: UNVERIFIED — none found.** The nearest adjacent complaint is about *under*-use of collected data: "there are workers scanning people's badges and wristbands when we enter the venues... they're collecting the attendance data but the app isn't using it." (2★, same feed).

**Pricing:** "a wristband gets you into that universe for the early rate of $149" and a local discount, "Buy your badge with an Austin zip code and you'll unlock better badge rates, insider perks" — https://sxsw.com/2026/everything-you-need-to-know-about-sxsw-2027/. **2027 badge rates: UNVERIFIED (not published).**

---

### CES — no attendee matchmaking at all

**Structural finding: CES has no algorithmic attendee↔attendee matchmaking.** Its attendee networking is manual QR contact exchange. `ces.tech/sitemap.xml` contains no matchmaking page other than archived 2017/2018 "International Matchmaking Reception" event pages.

The entirety of CES attendee networking:

> "Attendee Connect (available on-site) — Attendees can share contact information via a secure QR code."
>
> "Attendee Connect delivers a seamless networking experience for users looking to make connections and exchange contact information at CES. This feature is built using a secure, dynamic QR code known as MagicBadge™."
>
> "Configure your contact card with the information you would like to share with other attendees." / "Connect with other attendees by opening your Digital Badge to scan or scanning theirs." / "Accept or decline invitations to view one another's contact cards."
> — https://www.ces.tech/attendee-guides/ces-app/

The only AI in the CES app is a Q&A bot, not a matcher: "Ask AI — also available on the CES.tech website, the Ask AI chatbot provides answers to attendee questions related to CES." — same URL.

**The only CES matchmaking is CTA Match — human-curated, application-gated, investor-selects-startup.** (Live cta.tech 404s to non-browser clients; Wayback used.)

> "CTA Match brings together startup founders and some of the most influential investors and corporations in the world for curated, one-on-one matchmaking events."
>
> "The matching process considers several criteria, including industry category, company focus, stage of development, and alignment with the investment thesis of participating investors and corporations. This tailored approach maximizes the chances of successful connections."
>
> "Please note that completing the application form for CTA Match does not guarantee that you will be selected for a match."
>
> "If selected, your contact information will be exchanged with your investor matches."
> — https://web.archive.org/web/20250402222809/https://www.cta.tech/membership/cta-match/

**Score: none — the outcome is binary (selected / not selected), decided by a human.** **Reasoning: criteria published in aggregate, never per-match.** **Input: fully declared and field-level attendee-controlled**, with double opt-in on every exchange. No inferred, behavioural, or LinkedIn matchmaking signal is described anywhere on CES pages fetched.

**Sentiment — and this is the most instructive finding in the whole section: CES attendees complain about the *absence* of matchmaking.** (Apple review feed, https://itunes.apple.com/us/rss/customerreviews/id=6443741077/sortBy=mostRecent/json):

> "No added value — The all is basically a giant database of information with no automation and doesn't make the attendee experience any better or easier." (1★)

> "Get a PC App, for cry eye! — Scrolling through the CES haystack looking for connection needles in a phone networking app is ridiculous." (1★)

> "So I thought the app would be smart considering the CES show hype, but to set up my pre-arranged meetings with venders, I found that it is not capable of." (1★)

**Creepiness: none found**, consistent with a design that is explicit, double-opt-in and attendee-configured. **UNVERIFIED** that any such complaint exists elsewhere.

One review indicates LinkedIn URLs are *displayed* on CES profiles — "The LinkedIn buttons are freaking useless... when you tap on it, it takes you to the sign in page of an in app browser" (1★) — but there is **no evidence they feed matching. UNVERIFIED.**

**Pricing** — https://www.ces.tech/attendee-guides/registration-information/

> Standard Pass: "$149 through Nov. 30" / "$349 Dec. 1 - Jan. 9"
> Premium Pass: "$1450 through Nov. 30" / "$1750 Dec. 1 - Jan. 9"
> "Customer Invitation codes offer $149 off the cost of registration."

CTA Match itself is free to apply to: "There is no fee to participate, although attendance at CES 2026 is required." — Wayback CTA Match URL above.

---

### Evidence limits across the event-program section

- **In-app UI strings are UNVERIFIED for all four programs.** No fetched source shows an actual rendered match card. The "no score / no reasoning" conclusion rests on the *absence* of any such claim across all official copy, not on inspection of a live UI.
- **Sentiment coverage is app-store-only.** Reddit returns 403 to automated fetch, DuckDuckGo served a CAPTCHA, Mojeek 403'd, Bing served a JS shell, and the session WebSearch budget was exhausted. Press/Medium/Reddit sentiment was not swept. Quotes above come from Apple/Google review feeds (primary, verbatim) plus one organizer blog.
- support.websummit.com and cta.tech block non-browser clients; those quotes come from dated Wayback captures.

---

### What this means for an arrival brief with an exposed score

1. **Nobody in this category shows the matched person a number.** That is a genuine white space, but the uniformity of the convention is itself evidence — twelve products and four flagship event programs, one shipped explanation feature, zero attendee-facing percentages. Swapcard, the most explainability-forward vendor, deliberately shows *categorical* overlap ("events in common, interests, and jobs") and keeps its numeric weights (interest 5.0, biography 0.3) internal. The strongest positive claim we could source for a visible number is a 2016 App Store review of Grip mentioning "percentile matches" — one user, one build, ten years ago.

2. **The one place a number does appear is where the viewer is transacting, not meeting** — Swapcard's exhibitor-facing "interaction scores" for leads. The implied norm: score a prospect, explain a peer.

3. **Swapcard's two-level disclosure is the pattern to steal**: commonality summary on the card, detailed explanation on click-through, with explanations derived from the graph edges themselves rather than written after the fact — "These similarities or associations are the explanations."

4. **Declared beats inferred for defensibility.** Brella's model is a hard filter on registration-declared interests, which makes every match trivially explainable and non-creepy — but requires onboarding friction, and the matches tab literally does not exist until the attendee declares. Whova takes the opposite bet ("without relying on attendees' manual inputs") and buys coverage at the cost of explainability. Grip sits in the middle and is the only one that trains on *cohort* behavior ("people like them"), which is the hardest to explain to a member.

5. **Swapcard's privacy boundary is worth adopting verbatim as a design rule:** your searches and filters shape *your* recommendations but are "never used to compute the recommendations sent to other users."

6. **The observed public complaint is never "too creepy" — it is "too dumb" or "too broken."** Across three app review corpora (Web Summit, SXSW GO, CES), no creepiness or privacy complaint surfaced on any fetched page. CES attendees actively demand *more* automation ("a giant database of information with no automation"). This weakens the assumed constraint that an exposed score would read as invasive — but note the caveat: Reddit and press sentiment could not be swept, so this is **absence of evidence from app stores, not evidence of absence.** The one attitudinal signal against algorithmic suggestion is a SXSW reviewer preferring their own declared intent: "I'd rather see my favorites."

7. **Every program that does match gates contact details behind mutual consent** — Web Summit ("Your email address will remain hidden unless you accept a connection request"), CES ("Accept or decline invitations to view one another's contact cards"), Grip's mutual "handshake". A staff-facing arrival brief inverts this: staff see the reasoning about a member who never opted into being explained. That asymmetry is the real design risk in this product, and **nothing in this category is precedent for it** — every comparable shows the explanation to one of the two people being matched.


---


# Synthesis

## A. The seen-vs-dossiered line, with evidence

Every item below was fetched, not snippet-read. Quotes are short and attributed; URLs are the
page actually retrieved. Each is tagged on four axes:

- **(a) Holder** — who held the fact: the person's own counterparty, or a third party / broker.
- **(b) Valence** — would the subject be *pleased* or *embarrassed* to learn what was known.
- **(c) Provenance** — did the subject *volunteer* the fact, or was it *inferred*.
- **(d) Subject** — is the fact about *them*, or about their *family / intimates*.

---

### A.1 Delighted

#### Ritz-Carlton, Amelia Island — "Joshie the giraffe" (2012)

A guest's son left a stuffed giraffe at the hotel. The father asked Loss Prevention for one
photo of the toy by the pool to back up a story he had told his son. The hotel sent back a
binder documenting an invented extended stay — the giraffe "wearing shades by the pool", in the
spa, "driving a golf cart on the beach" — plus an ID badge making the toy an honorary member of
the Loss Prevention Team.

- Source: Chris Hurn, HuffPost — https://www.huffpost.com/entry/stuffed-giraffe-shows-wha_b_1524038
  (fetched successfully at this `/entry/` URL. Note: the canonical `/chris-hurn/` path
  301-redirects and did not resolve for the hospitality sweep, which marked the story
  UNVERIFIED — see §1. It is verified here. Caveat retained from that sweep: most business-book
  retellings embellish; cite Hurn's original, not a secondary version.)

**Axes:** (a) the hotel itself, acting on a fact the guest handed it by phone. (b) delighted —
he published it. (c) fully volunteered; the hotel inferred nothing. (d) about the guest's child,
but the *parent* supplied it and was the audience.

**What the axes show:** the entire payload originated in the guest's own request. The hotel's
contribution was effort, not knowledge.

#### Eleven Madison Park — the hot dog (2010), and the "Dream Weaver" role

Will Guidara overheard a table of visiting diners saying they had not managed to eat a New York
street hot dog. He bought one from a cart outside and had it plated. He later created a
full-time role whose "only responsibility was to help everyone else on the team bring their
ideas to life."

The load-bearing line, in his own words, about where the raw material came from:

> "It was what the service staff heard or saw that led to the gestures"

- Source: Nation's Restaurant News — https://www.nrn.com/casual-dining/how-will-guidara-wove-dreams-into-restaurant-hospitality
- Corroboration of the hot dog story and the Dream Weaver role: same URL.
- The TED talk itself (transcript not retrievable through this tooling — **UNVERIFIED** as a
  direct quote source): https://www.ted.com/talks/will_guidara_the_secret_ingredients_of_great_hospitality

**Axes:** (a) the restaurant, from its own room. (b) delighted. (c) volunteered — said out loud
at the table, in earshot, minutes earlier. (d) about the guests themselves.

**What the axes show:** the canonical delight story in modern hospitality is sourced from
*in-room observation in the last hour*, not from a database. This is the single most important
provenance finding in this section.

#### …but Guidara also describes our exact product, and endorses the database half

In a long-form interview he describes the pre-arrival research pipeline without hedging:

> "The person that greeted you would have Googled you before you came in, such that if you ever
> put your picture online and you still looked even remotely like that picture, that we'd be able
> to greet you by name."

He also names the dedicated role that owns the gestures — the same curation-checkpoint pattern
Ritz-Carlton runs through its guest recognition office:

> "There was a person--we called them Dream Weavers--that was the name of the position."

- Source: EconTalk transcript — https://www.econtalk.org/will-guidara-on-unreasonable-hospitality/

**The most significant thing here is an absence.** Across an interview devoted entirely to
researching and surprising guests, there is **no discussion of the boundary** between attentive
personalization and intrusion. The canonical text of the genre contains no creepy-line doctrine
at all. We are not refining an existing standard; there isn't one.

#### Restaurants that get it right — the diner-side view

OpenTable's own 2015 research (n > 6,000 diners across ten US metros, all with a reservation in
the prior year) found a strong *appetite* for being known:

- **64%** "wish establishments knew their seating preferences upon arrival"

- Source: OpenTable press release via PR Newswire — https://www.prnewswire.com/news-releases/opentable-research-reveals-what-diners-actually-want-from-technology-300114080.html

**Axes:** (a) the restaurant. (b) pleased. (c) volunteered / observed across prior visits with
the same counterparty. (d) about the diner.

---

### A.2 Backfired

#### Target's pregnancy prediction (2012) — the definitive case

Target's statistician described inferring pregnancy from purchase patterns and mailing
maternity coupons. A father in Minneapolis complained to a store manager about coupons sent to
his high-school daughter; days later he called back:

> "I had a talk with my daughter. It turns out there's been some activities in my house I
> haven't been completely aware of. She's due in August. I owe you an apology."

The remedy Target adopted is the most instructive part of the whole story. Rather than stop
inferring, they *hid* the inference by padding the mailer with irrelevant offers:

> "We'd put an ad for a lawn mower next to diapers. We'd put a coupon for wineglasses next to
> infant clothes."

> "as long as a pregnant woman thinks she hasn't been spied on, she'll use the coupons...
> As long as we don't spook her, it works."

And the internal test they applied, in the same voice:

> "even if you're following the law, you can do things where people get queasy."

- Original: Charles Duhigg, "How Companies Learn Your Secrets", *The New York Times Magazine*,
  19 Feb 2012. nytimes.com is not fetchable by this tooling.
- Retrieved from a full reprint of Kashmir Hill's Forbes write-up of the same reporting:
  https://huguesrey.wordpress.com/2012/09/20/how-target-figured-out-a-teen-girl-was-pregnant-before-her-father-did-forbes/
- **Attribution caveat:** the NYT piece attributes the "mixing in ads" passage to an unnamed
  Target executive; this reprint attributes it to statistician Andrew Pole. The wording is
  consistent across sources; the speaker's identity is **UNVERIFIED**.

**Axes:** (a) the retailer — nominally her counterparty, but acting on data she did not know was
being read that way. (b) mortified, and it detonated inside her family. (c) **inferred**, from
unscented lotion and supplement purchases. (d) the harm landed on the *family*, not the subject:
the system disclosed a daughter's pregnancy to her father.

**What the axes show:** the failure was not accuracy. Target was *right*. The failure was that a
correct inference, delivered by the wrong party at the wrong moment, functioned as an outing.

#### Facebook "Year in Review" — Eric Meyer, "Inadvertent Algorithmic Cruelty" (2014)

Facebook auto-generated a year-in-review card for Meyer, illustrated with a photo of his
daughter, who had died that year.

> "Algorithms are essentially thoughtless. They model certain decision flows, but once you run
> them, no more thought occurs."

His concrete design ask:

> "don't pre-fill a picture until you're sure the user actually wants to see pictures from
> their year"

- Source: https://meyerweb.com/eric/thoughts/2014/12/24/inadvertent-algorithmic-cruelty/

**Axes:** (a) the platform. (b) devastated. (c) volunteered — he uploaded the photo himself.
(d) about his family.

**What the axes show:** *provenance is not sufficient.* Every fact here was volunteered by the
subject. It still caused harm, because the system re-presented it in a frame the subject had not
chosen and could not anticipate. Volunteered-ness licenses *knowing*, not *saying*.

#### Clearview AI — scraping the public web (ICO enforcement, 2022)

The UK ICO fined Clearview AI **£7,552,800** over a database of **more than 20 billion** facial
images scraped from the web and social media. Among the breaches the ICO found:

> "Failing to use information fairly and transparently, as individuals were unaware their data
> would be used this way"

and, notably, that Clearview asked objectors for *more* photos in order to process their
objection — which "discouraged them from exercising their rights."

- Source: ICO newsroom — https://ico-newsroom.prgloo.com/news/ico-fines-facial-recognition-database-company-clearview-ai-inc-more-than-gbp-7-5m-and-orders-uk-data-to-be-deleted
- The ICO's own action page returned HTTP 403 to this tooling: https://ico.org.uk/action-weve-taken/enforcement/clearview-ai-inc-mpn/ — **UNVERIFIED** as a direct source.
- Clearview subsequently won a jurisdictional appeal against this penalty (per its own press
  room, https://www.clearview.ai/press-room/clearview-ai-wins-appeal-against-uk-information-commissioner-office-ico-fine) — **UNVERIFIED**, not fetched. The *finding of harm* is what matters here, not
  the enforcement outcome.

**Axes:** (a) a **third party with no relationship to the subject**. (b) alarmed. (c) volunteered
publicly — every image was posted by the subject or a friend. (d) about the subject.

**What the axes show:** "it was public" is the weakest defence in the set. Every Clearview image
was public. The regulator's objection was to *aggregation by a stranger*, and to the subject's
inability to anticipate the use.

#### Uber — "Rides of Glory" (2012) and "God View"

Uber published a blog post analysing riders it labelled "RoGers", defined as:

> "anyone who took a ride between 10pm and 4am on a Friday or Saturday night, and then took a
> second ride from within 1/10th of a mile of the previous nights' drop-off point 4-6 hours later"

The post broke the pattern down by city and by neighbourhood. It was later deleted. Separately,
the FTC found in 2017 that Uber

> "failed to monitor its employees' access to personal information about users and drivers"

and that it had misrepresented that data was "securely stored within our databases".

- Deleted post, archived: http://whosdrivingyou.weebly.com/blog/ubers-deleted-rides-of-glory-blog-post
- FTC press release: https://www.ftc.gov/news-events/news/press-releases/2017/08/uber-settles-ftc-allegations-it-made-deceptive-privacy-data-security-claims

**Axes:** (a) the counterparty. (b) humiliated. (c) inferred — from two timestamps and a
geofence. (d) about the subject, and implicitly about a second person who never contracted with
Uber at all.

**What the axes show:** two innocuous facts (two ride records) composed into an intimate one.
The inference was cheap, correct, and unforgivable. Also: the company *published* it, which is
the tell — they could not see the line from inside.

#### Bay Area fine dining — the guest dossier, 2025

The closest live analogue to our product. At Lazy Bear (San Francisco), guest services
coordinator and operations manager Catie Kirk compiles a "notable guest report" each week. She
sends questionnaires to every reservation asking about dietary restrictions and occasions, and
supplements with public social media:

> "Kirk also has a gigantic database of each guest — about 115,000 people"

The output artifact is exactly the shape of the thing we are specifying:

> a "color-coded Google document that every member of the team, front and back of house, studies"

And a staff quote that names the discomfort from the *inside*:

> "We get hundreds of emails a day, and the intimate details that some people are willing to
> share, sometimes we're like 'Holy crap. I can't believe you told us that,'"

paired with an appeal to "the literal joy, our team feels when they get to make these special
touches."

- Original: SFGate, "Bay Area restaurants are vetting your social media before you even walk in" —
  https://www.sfgate.com/food/article/data-deep-dives-bay-area-fine-dining-restaurants-20404434.php
  (returned an error page to this tooling; **the article body itself is UNVERIFIED by direct fetch**)
- Quotes above retrieved from a page reproducing them:
  https://sites.psu.edu/digitalshred/2025/07/31/the-best-bay-area-restaurants-are-vetting-your-social-media-before-you-even-walk-in-sf-gate/
- Slashdot summary (fetched, corroborates the 115,000 figure and the color-coded document):
  https://tech.slashdot.org/story/25/07/14/1413234/bay-area-restaurants-are-vetting-your-social-media-before-you-even-walk-in

**Axes:** (a) the restaurant. (b) mixed — the practice was reported *as an exposé*, which is
itself the finding. (c) **hybrid**: a questionnaire (volunteered, to this counterparty, for this
purpose) plus social media (volunteered publicly, for another purpose). (d) both.

**What the axes show:** the questionnaire half is uncontroversial. The social-media half is what
made it a story. Same restaurant, same guest, same file — the *provenance of the individual
field* is what flips it.

#### The note-code corpus — what staff actually write when nobody is watching

The closest thing to a real corpus of arrival-brief prose. Working restaurant guest notes are
dominated by two-to-four-letter codes, not sentences. Verified examples:

| Code | Meaning | Source |
|---|---|---|
| `PX` | *personne extraordinaire* — big spenders, owners' friends, high-rolling regulars | sunset.com |
| `PPX` | "a step above PX" | tastingtable.com |
| `WTW` | elite tier — "whatever their hearts desire" | tastingtable.com |
| `HWC` | "handle with care" | sunset.com |
| `86'd` | "a patron has been kicked out and banned" | tastingtable.com |
| `FOM` | "friend of the manager" | huffpost.com |
| `WW` | "Wine Whale" | huffpost.com |
| `f.t.d.` | first-time diner | vinepair.com |
| `H.B.` | Happy Birthday | vinepair.com |
| `S.O.E.` | "sense of entitlement" | vinepair.com |
| `L.O.L.` | "lots of love" — a difficult guest | vinepair.com |
| `o` | a plump guest | vinepair.com |

- https://sunset.com/syndication/restaurants-secret-code-cork-dork (reporting Bianca Bosker's
  *Cork Dork*, observed at Marea, New York)
- https://www.tastingtable.com/1273460/the-secret-codes-restaurants-use-for-their-most-important-guests/
- https://www.huffpost.com/entry/restaurants-googling-patrons_n_5132535
- https://vinepair.com/articles/yes-restaurants-keep-notes-on-guests-and-you-should-be-glad/

**Axes:** (a) the restaurant. (b) **`S.O.E.`, `L.O.L.`, `WW` and `o` are pure
embarrassment** — a judgement about a person's character, wallet or body. (c) inferred by staff.
(d) about the subject.

**What the axes show — and this is the sharpest structural finding in the audit:** roughly half
this vocabulary is service-relevant (allergies, first visit, birthday, private room). The other
half is a compressed, deniable, un-appealable judgement. **The codes exist *because* they are
deniable.** Shorthand is what you write when you would not want the sentence version read aloud.
Any brief that renders judgements in full prose will either become more honest or become codes.

#### The operator's own test — the "leak test"

The single most useful heuristic found anywhere in this research, from a working maître d':

> "You want to be careful what you put in the notes. It could be very embarrassing if it got out."

— John Winterman, at https://www.tastingtable.com/691511/restaurants-google-diners-hospitality-technology-social-media-opentable-resy-app/
(the same piece reports he "questions its actual value")

Note what kind of test this is: a **leak test, not a consent test**. Write nothing you would not
want the guest to read. It is checkable at write time, by the person writing, with no policy
lookup — which is why it survives in practice where GDPR language does not.

The same piece documents the actual prose shape of longer notes: preference → past gesture →
behavioural history. E.g. that a guest "likes his fish with fra diavolo rather than the listed
sauce"; that he received "a special gift from the kitchen last time he dined"; and "codes
indicating that on the last few visits, he was a high-maintenance guest who sent his entrée back
three times." The first two are hospitality. The third is a file.

#### The failure mode: recognition tooling repurposed as an admission filter

At Fleming by Le Bilboquet, hostesses reportedly researched each unknown guest under an internal
document called the **"Fleming Hostess Reservation Protocol"**. A server alleged the purpose was
to "keep the restaurant for special people only" and maintain a "certain environment" for
wealthy patrons. The restaurant denied class-based exclusion but acknowledged researching guests.
The piece also raises that such searches "could enable discrimination based on online presence."

- Source: https://vice.com/en_us/article/evjgpm/restaurants-google-you-regularly-to-figure-out-what-you-want-and-maybe-even-judge-you

Contrast the operator who declines the practice outright — Dan Martin of Sarabeth's:

> "It's a fine line because it's hit and miss with which clientele will like that you know
> something about them."

adding that he would not encourage servers to research customers: "I wouldn't want that."

- Source: https://abcnews.com/Lifestyle/restaurants-google-arrive/story?id=23291307

**Axes:** (a) the venue. (b) humiliating, and invisible to the person being filtered. (c) inferred
from public search results. (d) about the subject.

**What the axes show:** identical inputs, identical UI, opposite product. The difference is
whether the output feeds *service* or *selection*. This is the failure mode a members-club
arrival brief must be architecturally unable to become.

And the tagging system can override staff welfare: VinePair reports a `PX` repeatedly welcomed
back despite vomiting in the dining room and behaving inappropriately toward female servers,
solely because of his spending. RedFarm's Ed Schoenfeld, in the same piece, says the quiet part
plainly: "We try to take good care of everyone, and we take better care of some people."

#### The diner-side number: 31% say it is creepy

The same OpenTable study that found 64% want to be recognised also found:

- **31%** believe it is creepy for restaurants to research them beforehand
- **18%** prefer restaurants know "absolutely nothing" about them

- Source: https://www.prnewswire.com/news-releases/opentable-research-reveals-what-diners-actually-want-from-technology-300114080.html

**What this shows:** these are not different populations answering different questions. The same
survey shows a large majority wanting recognition and roughly a third finding pre-arrival
research creepy. Recognition and research are separate things to the public, even when they
produce the same greeting.

**And the trend runs against us.** A 2010 survey, reported at
https://www.huffpost.com/entry/restaurants-googling-patrons_n_5132535, found "Almost 40 percent
of people were okay with restaurants googling them if it meant special treatment," about 4%
hoped for it, 16% "thought it was a little strange but could live with it," and **15% thought it
was creepy**. By OpenTable's 2015 study the creepy share had roughly doubled to 31%, and Vice
reports that by then more diners considered the practice "creepy" than "a good thing"
(https://vice.com/en_us/article/evjgpm/restaurants-google-you-regularly-to-figure-out-what-you-want-and-maybe-even-judge-you).

Public tolerance for pre-arrival research **declined** over the five years in which the practice
became standard. Assume the member's default posture is suspicion, not delight.

---

### A.3 Observed principles

These are extracted from the cases above. Each is tied to the evidence that produced it — none is
an intuition. Ordered by how much design weight each one carries.

> **Context for all of them:** the canonical practitioner text of this genre contains no
> creepy-line doctrine at all (see Guidara, above). There is no existing standard to adopt. The
> principles below are reverse-engineered from failures, because nobody has written the
> forward version.

**1. Provenance beats accuracy.** Target's inference was correct and still catastrophic. Uber's
inference was correct and still indefensible. Nothing in either failure would have been fixed by
being *more* right. → *Target, Uber*

**2. The strongest fact is one the subject said out loud, recently, in the room.** The canonical
delight story in the industry is sourced from a sentence overheard at a table minutes earlier
("It was what the service staff heard or saw that led to the gestures"). The canonical horror
story is sourced from a purchase-history model. → *Guidara, Target*

**3. "It was public" is the weakest defence available.** Every Clearview image was public.
Every Year in Review photo was uploaded by the subject. Public provenance licenses *holding* a
fact; it does not license *aggregating* it or *reciting* it. → *Clearview/ICO, Meyer*

**4. Who holds it matters more than what it is.** The same fact is hospitality from your
counterparty and surveillance from a stranger. Ritz-Carlton knew about a child's toy because the
father phoned; Clearview knew your face because nobody asked you. → *Ritz-Carlton vs Clearview*

**5. Composition is the danger, not collection.** Two ride timestamps are boring. Composed, they
are a one-night stand. Lotion plus supplements is boring. Composed, it is a pregnancy. The
creepiness lives in the *join*, not in any field. → *Uber, Target*

**6. Facts about family are a different class of object.** The Target harm landed on a father and
daughter. The Meyer harm landed on a dead child. In both, the subject-of-record was not the
person hurt. A fact about someone's spouse, child, or bereavement is not a fact about them. →
*Target, Meyer*

**7. The operative test is the embarrassment test, applied to the moment of disclosure, not the
moment of collection.** Target's own executive articulated it better than any policy document:
"even if you're following the law, you can do things where people get queasy." Legality is not
the constraint; the subject's face on hearing it is. → *Target*

**8. If you have to disguise the personalization, you have already lost.** Target's remedy was to
pad the mailer with lawn mowers and wineglasses so the inference would not be legible. A system
whose output must be camouflaged to be tolerated is a system producing intolerable output. This
is the single sharpest diagnostic in the entire evidence set. → *Target*

**9. Recognition and research are different products to the public.** 64% want to be recognised;
31% find pre-arrival research creepy; 18% want you to know nothing. Being greeted by name from
last visit's record is *not* the same act as being Googled, even when the greeting is identical.
→ *OpenTable*

**10. Volunteered-ness licenses knowing, not saying.** Meyer uploaded the photo himself. The
system's error was re-surfacing it, unprompted, in a celebratory frame. What may be *stored* and
what may be *said out loud by a stranger* are two different permission sets. → *Meyer*

**11. Practitioners inside the practice can feel the line and cannot articulate it.** Lazy Bear's
own coordinator says "I can't believe you told us that" about volunteered data, in the same
breath as defending the practice. The discomfort is real and pre-verbal; a product that ships
this should make the line explicit rather than leave it to each host's instinct. → *SFGate/Lazy Bear*

**12. A human editor between observation and record is the industry's actual guardrail.**
The one operator with a fifty-year track record at this does not let line-staff observations
flow into the guest record. Ritz-Carlton's documented pipeline runs: staff note a preference on
a paper pad that is "part of each employee's uniform" → it goes to a **guest recognition
manager**, a dedicated role → that office curates it into the profile and prepares the
pre-arrival report distributed back to the hotel. Nobody's raw observation reaches the durable
record unmediated. → *destinationCRM on Ritz-Carlton CLASS; see §1 for the full citation*

**13. Frame discretion as craft, not compliance.** Ritz-Carlton's Service Value 11 — "I protect
the privacy and security of our guests, my fellow employees, and the company's confidential
information and assets" — sits in the same numbered first-person list as Service Value 3, "I am
empowered to create unique, memorable and personal experiences." Restraint and personalization
are presented as two halves of one professional identity, not as a legal constraint bolted onto
a growth feature. → *https://ritzcarltonleadershipcenter.com/about-us/about-us-foundations-of-our-brand/*

**14. The operative test the trade actually uses is a leak test, not a consent test.** "It could
be very embarrassing if it got out." Write nothing on the card you would not want the member to
read over the host's shoulder. It is checkable at write time by the person writing, with no
policy lookup — which is why it survives in real kitchens where compliance language does not.
This is the one principle to ship. → *Winterman*

**15. If a fact has to be abbreviated to be writable, it should not be written.** Half the real
restaurant note vocabulary — `S.O.E.`, `L.O.L.`, `WW`, `o` — encodes judgements about character,
wallet and body. The shorthand exists precisely because the sentence version is indefensible.
Coded fields are a symptom, not a feature: they are principle 14 being routed around. → *note-code
corpus*

**16. Recognition tooling becomes a class filter unless it is architecturally prevented.** Same
inputs, same UI, opposite product: Fleming's hostesses ran the identical Google search as Eleven
Madison Park's, to decide who was "special people" rather than how to seat them. The distinguishing
question is whether the output feeds *service* or *selection*. → *Fleming / Vice*

**17. Assume suspicion, not delight — the trend is against us.** The share of diners calling
pre-arrival research creepy roughly doubled (15% → 31%) between 2010 and 2015, i.e. across
exactly the period when the practice became standard. Familiarity did not breed acceptance.
→ *2010 survey via HuffPost; OpenTable 2015*

**18. Buying the fact does not launder it.** France's CNIL fined SOLOCAL €900,000 (15 May 2025)
on the holding that a *purchaser* of data-broker records "must ensure that individuals have
expressed valid consent." The consent defect travels with the data. If we enrich from a broker,
we inherit the broker's provenance problem — and, per principle 3, "it was public" will not
discharge it. → *CNIL/SOLOCAL; see §4 for the citation and the full enrichment-vendor record*

**19. The mature systems answer the line with mechanism, not with policy prose.** Oracle OPERA
Cloud — the most mature guest-profile system in the audit — ships: a hard character cap on note
fields, an admin-lockable "Internal" visibility flag, department-routed Traces, automatic purge
of dormant profiles, an anonymization routine that **deletes** notes outright rather than masking
them, and **Incognito mode** — a first-class, supported way for a guest to be deliberately
*un-recognized*. Compare SevenRooms, whose DPA returns zero matches for "sensitive", "special
categor" or "article 9", never mentions the word "note", and whose AI review panel optimises for
*completeness* — "no critical guest details are missed" — i.e. for the opposite of restraint.
The presence of an opt-out of recognition is the clearest single signal of a system that has
thought about this. → *see §1 for full citations*

**20. Do not put service facts and character judgements in the same field.** Mews ships one flat
tag dropdown mixing accommodation ("Disabled person"), standing ("Very important"), history
("Previous complaint") and character judgement ("Problematic", "Blocklist"). Cloudbeds has no
note types or visibility flags at all, but stamps every note with author and timestamp —
authorship as the cheap guardrail. A single undifferentiated notes box is how principle 15's
coded shorthand gets invented. → *see §1*

**21. In this specific category, the consent that matters is consent to be *approached* — and
the clubs already publish it, in both directions.** Soho House gates member-to-member visibility
behind an explicit opt-in: when checked in you see other members present "if they have opted in
to this", and members separately agree that the club "can hold your personal details and a
photograph to use in connection with your membership." San Vicente Bungalows publishes the
opposite house norm as a rule: members "should exercise great respect and care if approaching
another Member or guest of a Member that may or may not be personally known to the Member…as
respecting privacy is an important policy." Two clubs, two defensible answers, both *published
to members in advance*. Neither leaves it to a host's judgement in the moment.

**A gap worth naming:** Soho House documents the opt-in gate on what *members* can see about
each other, and nothing about what *staff* can see. That asymmetry is unaddressed across the
entire category (**UNVERIFIED** — no fetched source describes a staff-side visibility gate at
any club). It is the exact hole our product sits in. → *see §2 for citations*

**22. The clubs have already legislated the asymmetry: the house may watch, members may not watch
each other.** The Battery's Charter states that "Members shall not use Presence or check-in
features to monitor, pressure, or surveil other Members without consent" — in the same document
that pre-authorises "fingerprint recognition" for the club itself. This is the operative norm in
the category and it points our product the right way: the brief is a *staff* instrument. The
moment its contents become member-visible, it violates a rule the members have already been given.
→ *see §2*

**23. Where introductions are the product, a human reviews every one — and fairness is an explicit
constraint.** Chief sells "A curated introduction designed to confirm alignment", and Fortune
documents two guardrails: "A human manually reviews each group before it's launched", and the
matching ensures "no individual woman was the 'only' in her group." Note the second one: the
matcher carries an affirmative obligation about the *composition* of the room, not merely about
relevance. A score optimised only for pairwise affinity will reliably produce rooms nobody wanted.
→ *see §2*

**24. The counter-example to principle 14, and it is a members club.** Park House (Dallas/Houston)
publishes that it keeps a file the member may not read: "interview notes, and all discussions and
proceedings of the Membership Committee shall be confidential and not subject to review by anyone
other than Club Management." That is the explicit opposite of the leak test — a dossier whose
defence is that it will never get out. It is a real, live, published model in our own category
and our own state. It is also the model this product should refuse. → *see §2*

**25. The member complaint on record is "nobody knows me," not "they know too much" — and that
should not reassure us.** Across the public member commentary gathered, the grievance is
consistently that recognition and vetting are *fake*, not intrusive ("The notion that these places
are somehow vetting for the best and brightest members… is false"; "the vibes with everyone on
laptops and phones is like an airport lounge"). Privacy fear in this category is **lateral** —
of other members and the press — not **vertical**, of the house. But no club discloses these
tools to members, so the absence of vertical complaint may measure absence of *awareness* rather
than presence of consent. Treat it as an untested assumption, not a mandate. → *see §2*

---

### A.4 The one-line version

Every principle above collapses into a single shippable test, and it is not ours — it is the
trade's own, from a working maître d':

> **Would the member be pleased to read this card over the host's shoulder?**

Principles 1–13 explain *why* that test works. Principles 14–18 are the ways systems evade it:
by abbreviating the indefensible into codes (15), by repurposing service data as selection (16),
by disguising the output so the inference is illegible (8), or by buying the fact so the
provenance is someone else's problem (18). Principles 19–20 are what the systems that *pass*
actually ship: separated fields, visibility flags, authorship, expiry, and a supported way to
not be recognised at all.

**The disqualifying question, for our spec specifically.** The brief calls for "at least one fact
that is NOT on the first page of a search result." Principles 1, 3 and 14 together say that is
the highest-risk requirement in the product, because depth-of-retrieval is precisely the axis
along which delight turns into a dossier. The evidence does not say it cannot be done — Guidara
does exactly this and is celebrated for it. It says the *fact's provenance* must carry the load
that its obscurity cannot: something the member told the club, said in the room, or published
under their own name for this kind of audience. Obscure-because-buried fails the leak test.
Obscure-because-nobody-listened-until-now passes it.


---

## B. Register and format of a good staff brief

### B.0 What 90 seconds actually is, in words

This is the one number the whole spec hangs on, so it is sourced to a meta-analysis rather than
to folklore.

Brysbaert (2019), *Journal of Memory and Language* 109, 104047, analysing **190 studies /
18,573 participants**:

> "we estimate that the average silent reading rate for adults in English is 238 words per
> minute (wpm) for non-fiction and 260 wpm for fiction"

> "The average oral reading rate (based on 77 studies and 5965 participants) is 183 wpm."

> "For silent reading of English non-fiction most adults fall in the range of 175–300 wpm"

- Source: https://gwern.net/doc/psychology/linguistics/2019-brysbaert.pdf (Journal of Memory and
  Language 109 (2019) 104047; abstract quoted verbatim from the PDF)
- Publisher record: https://www.sciencedirect.com/science/article/abs/pii/S0749596X19300786

**Derived budget for a 90-second brief:**

| Mode | Rate | 90-second budget |
|---|---|---|
| Silent, non-fiction, average adult | 238 wpm | **357 words** |
| Silent, slow end of normal range | 175 wpm | **263 words** |
| Silent, fast end of normal range | 300 wpm | **450 words** |
| Read aloud | 183 wpm | **274 words** |

The binding constraint is the **slow end under distraction**: a host is reading while standing,
walking, and watching a door. The defensible ceiling is therefore the ~**250–350 word** band, not
the 450-word optimum. Anything above ~350 words is not a 90-second artifact.

A second, independent check: at the Army's prescribed 15-word average sentence (below), 350
words is about **23 sentences**. That is the true size of the thing — roughly two dozen short
sentences, not "a page of prose".

---

### B.1 The Army writing standard (AR 25-50) — the most explicit public rulebook

This is a US Government work, quotable in full, and it is the single most useful artifact found.
AR 25–50, *Preparing and Managing Correspondence*, 10 October 2020.

**¶1–38, Standards for Army writing:**

> "a. Effective Army writing is understood by the reader in a single rapid reading and is clear,
> concise, and well-organized"

> "b. Two essential requirements include putting the main point at the beginning of the
> correspondence (bottom line up front) and using the active voice"

**¶1–39b, Specific techniques** — the entire list, verbatim:

> "(1) Use short words.
> (2) Keep sentences short. The average length of a sentence should be about 15 words.
> (3) Write paragraphs that, with few exceptions, are no more than 10 lines.
> (4) Avoid jargon.
> (5) Use correct spelling, grammar, and punctuation.
> (6) Use "I," "you," and "we" as subjects of sentences instead of this office, this
> headquarters, this command, all individuals, and so forth.
> (7) Write one-page letters and memorandums for most correspondence. Use enclosures for
> additional information.
> (8) Avoid sentences that begin with "It is," "There is," or "There are.""

- Source: https://www.armywriter.com/AR25-50.pdf (PDF fetched and text-extracted; ¶1–38 and
  ¶1–39 as printed on p. 7)
- Official publisher copy: https://armypubs.army.mil/epubs/DR_pubs/DR_a/ARN42124-AR_25-50-007-WEB-13.pdf

**Why this is the right template.** Every one of these rules is a direct answer to a design
question in our brief:

- "understood in a single rapid reading" — the *definition* of a 90-second artifact.
- BLUF — the name and the one-line "why they matter" go first, not the biography.
- 15-word sentences — a host reading while walking cannot parse a subordinate clause.
- ≤10-line paragraphs — forces the card into blocks, not prose.
- "Use I, you, and we" — second person. Not "the member has indicated an interest in".
- Avoid jargon — no internal scoring vocabulary leaking onto the card.
- One page, enclosures for the rest — **the depth belongs behind the card, not on it.**
- No "It is / There is" openers — kills the dead-weight sentence stems that eat the word budget.

---

### B.2 SBAR — the clinical handoff, and why its shape transfers

SBAR is the standard structured verbal handoff in medicine, published by the Institute for
Healthcare Improvement. Its four slots, verbatim:

> "S = Situation: a concise statement of the problem"
> "B = Background: pertinent and brief information related to the situation"
> "A = Assessment: analysis and considerations of options — what you found/think"
> "R = Recommendation: action requested/recommended — what you want"

IHI describes it as "an easy and focused way to set expectations for what will be communicated".

- Source: https://www.ihi.org/resources/tools/sbar-tool-situation-background-assessment-recommendation
- **UNVERIFIED:** IHI publishes no time limit or item cap for an SBAR handoff.

**The transferable structure.** SBAR's discipline is that *three of the four slots are not
information* — they are framing, judgement, and a requested action. Applied to an arrival brief:

| SBAR slot | Arrival-brief equivalent |
|---|---|
| Situation | Who just walked in, and in one line, why now matters |
| Background | The two or three facts that make the introduction possible |
| Assessment | Who else in the room, and the reasoning for the match |
| **Recommendation** | **The line the host can actually say out loud** |

The Recommendation slot is the part most product specs omit and the part clinicians consider
mandatory. A brief that ends with facts and no recommended action is an unfinished SBAR.

---

### B.3 The hospitality precedent: the shape of a real guest brief

The closest live artifact is the pre-service document at Lazy Bear (San Francisco), compiled
weekly by the guest services coordinator as a "notable guest report":

> a "color-coded Google document that every member of the team, front and back of house, studies"

- Quotes retrieved from: https://sites.psu.edu/digitalshred/2025/07/31/the-best-bay-area-restaurants-are-vetting-your-social-media-before-you-even-walk-in-sf-gate/
- Corroborating summary: https://tech.slashdot.org/story/25/07/14/1413234/bay-area-restaurants-are-vetting-your-social-media-before-you-even-walk-in
- Original article body **UNVERIFIED by direct fetch** (SFGate returned an error page):
  https://www.sfgate.com/food/article/data-deep-dives-bay-area-fine-dining-restaurants-20404434.php

Three observations that matter for our format:

1. **It is colour-coded, not prose.** The scanning affordance is visual encoding, not sentence
   quality. Whatever our card's information hierarchy is, it must survive peripheral vision.
2. **It is one shared document, studied before service** — not a per-guest lookup during
   service. The reading happens in the calm minute, not the busy one.
3. **It is compiled by a named human role.** There is an editor in the loop. The artifact is a
   *report*, with an author, not a query result.

**The same pattern, fifty years older, at Ritz-Carlton.** The documented pipeline is: line staff
write an observation on a "guest preference pad" that is "part of each employee's uniform" → it
routes to a **guest recognition manager** → that office reviews profiles before arrivals and
"prepares reports distributed throughout the hotel."

- Source: destinationCRM — https://www.destinationcrm.com/Articles/CRM-News/CRM-Featured-Articles/For-Ritz-Carlton-It-All-Begins-with-Customer-Knowledge-47424.aspx
- (See §1 for the correction that the named system of record is **CLASS**, "Customer Loyalty
  Anticipation and Satisfaction System", not "Mystique".)

And the delivery cadence is a standing meeting, not a lookup. NIST, describing Ritz-Carlton
practice, documents "daily 15- to 20-minute hotel line-ups consisting of all Ritz-Carlton
employees around the world."

- Source: https://www.nist.gov/blogs/blogrige/ritz-carlton-practices-building-world-class-service-culture

**Both operators independently converge on the same three-part shape:** *observe → a named human
curates → a short report is pushed to the floor before service.* Neither is a per-guest query at
the moment of arrival. That is the strongest format finding in this section.

---

### B.4 Observed answer: length, structure, voice

Grounded in the artifacts above and in the appendix that follows. The convergence across six
unrelated traditions — military correspondence, intelligence, clinical handoff, presidential
staff work, and fine dining — is unusually tight.

**LENGTH — ~265 words is the empirical answer. Design for 250–350; hard ceiling one card.**

The strongest single datapoint is not derived, it is measured. The declassified President's
Daily Brief of 3 September 1968 runs **five items in roughly 265 words** of body text. At
Brysbaert's 183 wpm oral rate that is **~87 seconds read aloud** — the PDB is, almost exactly,
a 90-second document, and has been since the 1960s.

Three independent sources agree on the band:

| Source | Says |
|---|---|
| Brysbaert 2019 | 175–300 wpm silent non-fiction → 263–450 words in 90s |
| PDB, 3 Sep 1968 | **265 words**, 5 items, ~87s aloud |
| AR 25-50 ¶1–39b(7) | "Write one-page letters and memorandums for most correspondence" |

Take the slow end, because our reader is standing, walking, and watching a door. **250–350
words, ~20–24 sentences.** Depth goes behind the card, never on it — AR 25-50 is explicit that
the overflow mechanism is an enclosure, and the PDB physically staples its long annex behind its
own separate cover page.

**STRUCTURE — 4–5 labelled items, 2–3 sentences each, ordered by importance, ending in an action.**

The PDB's grammar is the one to copy, because it was built for this exact duration:

- **A bare-noun label, then prose.** The left margin reads `1. Czechoslovakia`, `2. Soviet Union`,
  `3. Rumania`… The label carries no verb, no claim, no news — it is a routing tag telling the
  reader which drawer the next 40 words belong in. For us: `Who arrived`, `Why now`,
  `Who to introduce`, `What to say` — nouns, not headlines.
- **Item length: 1 paragraph, 2–3 sentences, 26–41 words.** Sentences average 12–14 words —
  independently landing within a word of AR 25-50's prescribed 15.
- **5 to 9 items** across the issues sampled 1966–68. Five is the working number.
- **Ordered by importance, not by category.** The Czechoslovakia crisis leads; geography is
  ignored.
- **No transitions, no scene-setting, each item self-contained.**

Two rules come from elsewhere:

- **BLUF** (AR 25-50 ¶1–38b): main point first. Note the PDB does *not* have a summary paragraph
  — the ordering *is* the BLUF.
- **End on a recommendation, not a fact** (SBAR). This is the slot most specs omit and clinicians
  treat as mandatory. Our equivalent is the line the host can actually say out loud.

And the closest published analogue to our artifact — the White House **palm cards**, whose entire
job is to let a principal walk into a room and greet named people correctly — supplies the
per-person unit:

- **Photograph + name + one line.** Nothing else. Hillary Clinton's line said she "was the
  Secretary of State in the Obama-Biden administration."
- **People grouped under a named section header** (one card carried a `"Pritzker Family"` section).
- **Card title is the occasion, not the person**: `"Saturday, January 18 Greets"`.
- Where a superlative is used, **it is borrowed and the source is attached** — Denzel Washington
  was one whom the New York Times called "one of the greatest actors of the 21st century." Note
  what this does: it converts a judgement into a citable, sayable fact. That is directly
  transferable to how a score or a "why you should meet" line should read.
- **A read-receipt stamp**: four of five cards carry `"PRESIDENT HAS SEEN."`

**VOICE — second person for action, third person for people, hedged with one adverb, never a clause.**

The two registers are used for different jobs, and every artifact splits them the same way:

*Addressing the reader — second person, present tense.* The Roosevelt Room cue card, verbatim and
in full, is **three sentences and 13 words**, averaging 4.3 words per sentence:

> "YOU enter the Roosevelt Room and say hello to participants. YOU take YOUR seat. YOU give brief
> comments."

Note it says "YOU enter," not "enter" — declarative, not imperative. It narrates the near future
back to the reader as already true, which is why it reads as choreography rather than instruction.
Nixon's 1969 "President's Scenario" uses the identical construction. AR 25-50 ¶1–39b(6)
independently prescribes it: use "I," "you," and "we" as sentence subjects.

*Describing people — third person, fragmentary.* A relative clause hung off a name, with no verb
of its own.

*Hedging — one verb or adverb, never a disclaimer sentence.* The PDB does this rigorously:
"seem to be trying to avoid provoking the Soviets"; "There were unconfirmed press reports";
"Communist sources said." Attribution is compressed into the subject of the sentence, so sourcing
costs three words rather than a footnote. **The word "we" does not appear in the 1968 issue at
all** — there is no "we believe"; the analytic voice rides on the verbs.

Plus the AR 25-50 mechanics: short words; avoid jargon; no sentence beginning "It is," "There
is," or "There are"; active voice as one of the two "essential requirements."

**And one visual rule.** The Axios-reported event template is "short and simple, with one large
picture of the event space on each page, accompanied with big text such as: 'View from podium,'
and 'View from audience.'" It is organised around *what the principal will see, in the order he
will see it* — and the single most important movement, "Walk to podium," gets two of five pages.
Lazy Bear's colour-coded document makes the same bet. **Scanning is done by layout and image, not
by sentence quality.** A face and a name outrank a well-written paragraph.

---

### B.4b The one-paragraph spec

A 90-second arrival brief, per the observed practice: **~265–350 words on one card.** A photo and
a name at the top. **Four or five bare-noun labels**, each with **2–3 sentences of 12–15 words**,
ordered by importance with no summary paragraph and no transitions. People described in third
person as a name plus one borrowed, attributed line. The host addressed in second person present
tense. Hedges carried by a single adverb. The last block is **not a fact but a sayable line**.
Everything else lives behind the card.

**One further voice constraint, from section A rather than from the format literature:** the
brief must be written so that the *member could read it over the host's shoulder without
embarrassment*. Target's own remedy — padding a mailer so the inference would not be legible —
is the counter-example. If a line on the card would need to be disguised, it does not belong on
the card.

---

### B.5 Gaps

Reached on a second pass (see the appendix below): the declassified PDB, the Roosevelt Room cue
card text, the Axios event template, and the White House palm cards.

Still **UNVERIFIED** — do not cite:

- **NSC five-by-seven-inch cue cards** (Rucker & Leonnig, *A Very Stable Genius*). No reachable
  copy. Do not cite a card size or field list for this. The verified Biden palm cards and the
  CNN-quoted Nixon "President's Scenario" cover the same ground.
- **Protocol "announce card" field lists.** SECNAVINST 1710.12, Army Pam 600-60, and DTIC reports
  ADA168427/ADA172334 all returned bot-walls or HTML error pages in place of the PDF.
- **A political fundraising call sheet** with machine-readable field labels (the one example
  found is an image).
- **A radio/TV talent prep sheet** from a primary broadcast source.
- The exact typography of the palm cards, and the wording of the Axios template pages beyond the
  two captions quoted.

Also note the session's web-search budget was exhausted during this audit; late-stage gaps were
closed by direct fetch and Wayback only, which is why several of the above remain open.


### Additional briefing artifacts

#### President's Daily Brief — 3 September 1968 (CIA, declassified)

**Artifact reached.** Fetched as PDF via the Internet Archive mirror of the CIA reading room copy
(`https://web.archive.org/web/2id_/https://www.cia.gov/readingroom/docs/DOC_0005976337.pdf`,
release marking "Declassified in Part - Sanitized Copy Approved for Release 2015/07/24 :
CIA-RDP79T00936A006400020001-4"). The file is image-only, so it was rendered to PNG and read
visually. US Government work — public domain.

**Length.** The brief proper is **two typed pages carrying five items**, plus a cover sheet. The
readable body text totals **roughly 265 words**. At Brysbaert's 183 wpm oral rate that is
**~87 seconds read aloud** — i.e. the PDB is, almost exactly, a 90-second document. (A separate
annex, "Special Daily Report on North Vietnam," is stapled behind it with its own cover page and
its own numbered contents — the long material lives outside the brief.)

**Structure.**
- Masthead only: `THE PRESIDENT'S / DAILY BRIEF / 3 SEPTEMBER 1968`. No summary, no BLUF paragraph,
  no table of contents.
- A **two-column page**: a left margin holds `1. Czechoslovakia`, `2. Soviet Union`, `3. Rumania`,
  `4. Guatemala`, `5. Mexico`. The right column holds the prose.
- **The heading is a bare noun — a place, not a headline.** It carries no verb, no claim, and no
  news. It is a routing label that tells the reader what drawer the next 40 words belong in.
- Item length: **1 paragraph, 2–3 sentences, ~26–41 words** is the norm. Item 1 is 38 words in
  3 sentences; item 5 is 41 words in 3 sentences; item 4 is 26 visible words. Only item 2 (Soviet
  Union) runs to two paragraphs, ~105 words. **Sentences average 12–14 words.**
- Items are ordered by importance, not geography — the Czechoslovakia crisis leads.

**Item-count range across issues** (checked against OCR text of four more issues on archive.org,
`https://archive.org/download/cia-readingroom-document-0005968145/0005968145_djvu.txt` and
siblings `-0005968811`, `-0005976144`, `-0005976467`): **5 to 9 numbered items**, same
left-margin-noun convention, from 1966 through 1968.

**Voice.**
- Third person, no narrator. **The word "we" does not appear in this issue** — there is no
  "we believe." The analytic voice is carried by the verbs instead.
- Present perfect and simple past for fact; **hedging is done with a single verb or adverb**, not a
  clause: "seem to be trying to avoid provoking the Soviets"; "seemed to be taking some of the
  pressure off"; "There were unconfirmed press reports"; "Communist sources said."
- Negative facts are stated as flatly as positive ones, and take up as much room: "There have been
  no more demonstrations."
- Attribution is compressed into the subject of the sentence — "Embassy Moscow notes that…",
  "Communist sources said…" — so sourcing costs three words, not a footnote.
- No adjectives of judgement, no scene-setting, no transitions between items. Each item is
  self-contained and assumes yesterday's brief was read.

**Why it matters for a 90-second member brief:** a noun-label plus 2–3 sentences, five times over,
is a proven shape for the exact duration in question, and the hedging discipline (one adverb, not a
disclaimer sentence) is the part most worth copying.

#### White House "palm cards" — a photo-plus-one-line-bio card for people the principal will meet

**Artifact described in detail by the outlet that obtained it; card images published but not
machine-readable here — field list is VERIFIED from the reporting, exact typography UNVERIFIED.**
Fetched `https://www.foxnews.com/politics/exclusive-unearthed-biden-note-cards-reveal-he-had-bios-photo-reminders-hillary-clinton-schumer`
(30 Sept 2025) and the Sinclair syndication at
`https://fox17.com/news/nation-world/joe-biden-white-house-created-palm-cards-for-hillary-clinton-chuck-schumer-and-others-auto-pen-denzel-washington`.

This is the closest published analogue to the club-host brief: a card whose entire job is to let a
principal walk into a room and greet named people correctly.

**Length.** Hand-sized. Fox describes them as "hand-sized note cards frequently used by politicians
for quick reminders or talking points during public events" and the syndicated version as "a booklet
of small cards." Five cards were released. Each entry is **a photo plus one sentence**.

**Structure (field list, as reported).**
- **Card title = the occasion**, not the person: `"Presidential Medal of Freedom Recipients"`,
  `"Judicial Confirmations Milestone Speech"`, and one timestamped `"Saturday, January 18 Greets"`.
- **Per person: photograph + name + a one-line identifier.** Hillary Clinton's line said she "was
  the Secretary of State in the Obama-Biden administration."
- For officeholders the line is pure role data — Schumer and Durbin appeared with "the roles in the
  Senate, their party and the states they represent."
- For a public figure, **one borrowed superlative with its source attached**: Denzel Washington was
  described as an actor, director and producer whom the New York Times called "one of the greatest
  actors of the 21st century."
- **People are grouped into named sections** — one card carried a section headed `"Pritzker Family"`
  with the governor plus "photos and explainers on Pritzker's wife, son and daughter."
- **A read-receipt stamp**: four of the five cards carry `"PRESIDENT HAS SEEN."`
- One card is question-prep rather than people-prep: `"Question #3.2024: How do YOU view the path
  forward? How do YOU think about YOUR place in history?"`

**Voice.** Fragmentary and third-person for the bios — a relative clause hung off a name, no verb of
its own. Where the card addresses the principal it switches to **second person with YOU/YOUR set in
capitals**, a convention visible on both this card and the Roosevelt Room card below.

A former Biden staffer's defence, quoted in the same piece, is the clearest statement of the genre:
listing notable attendees and bios "is standard operating procedure for briefing materials."

#### Presidential event / cue cards — the "YOU enter…" script

**Artifact quoted verbatim in the source; card image not reached.** The verbatim text the brief
asked for is in the **CNN** piece, not the Axios one. Fetched via Wayback:
`https://web.archive.org/web/20230428000000id_/https://www.cnn.com/2023/04/27/politics/biden-note-card-white-house-press-conference/index.html`
("The secret of the presidential cue card," Stephen Collinson, 27 April 2023).

**The note card text, verbatim:**

> "YOU enter the Roosevelt Room and say hello to participants. YOU take YOUR seat. YOU give brief
> comments."

**Length.** Three sentences; **13 words.** Averages 4.3 words per sentence.

**Structure.** Pure sequence — arrive, sit, speak. One clause per physical action, in the order the
actions occur. No context, no rationale, no names.

**Voice.** **Second person, present tense, capitalised YOU/YOUR.** Declarative rather than
imperative: the card says "YOU enter," not "enter." It narrates the near future back to the reader
as though already true, which is why it reads as choreography rather than instruction.

**What was on the April 2023 press-conference card** (same URL): the card "shows a head shot of a
reporter on whom Biden would call, a pronunciation guide for her name, and most controversially,
seems to say what she would ask." **Photo + pronunciation + expected topic** — three fields.

**Precedent — Nixon's "President's Scenario," 16 March 1969**, quoted in the same CNN piece:

> "At 10:55 a.m. Mrs. Nixon and Mrs. Evans will be escorted to the East Room. / You and Dr. Evans
> will be escorted to the East ROOM at 11:00 a.m. / You will make brief welcoming remarks, turn the
> Service over to Dr. Evans and take your place in the first row with Mrs. Nixon."

Same shape fifty-four years earlier: **second person, future tense, clock times, one sentence per
movement.** CNN's own judgement: it "reads almost exactly like Biden's minute-by-minute schedule."

#### Presidential event template (Axios, 7 July 2024)

**Artifact described, screenshots published, document itself not reached — page layout VERIFIED from
reporting, wording of the pages UNVERIFIED beyond the two labels quoted.** Fetched via Wayback:
`https://web.archive.org/web/20240708000000id_/https://www.axios.com/2024/07/07/biden-staff-events-prepare`
("Scoop: How Biden's event staffers guide him behind the scenes," Alex Thompson).

**Length.** Five pages, **one image per page** — the document is almost entirely picture.

**Structure.** Axios: the template "is short and simple, with one large picture of the event space
on each page, accompanied with big text such as: 'View from podium,' and 'View from audience.'"
And: "In the five-page document, two pages are separate pictures of, 'Walk to podium.'"
So the page grammar is **one photograph + a two-to-three-word caption**, and the single most
important movement gets **two pages to itself**.

**Voice.** Noun-phrase captions in large type. No sentences at all. The framing sentence in the
piece — staffers "prepare a short document with large print and photos that include his precise
path to a podium" — is the design spec: **large print, photographs, and the route.**

Note the two labels are *points of view*, not places: "View from podium" / "View from audience."
The document is organised around what the principal will see, in the order he will see it.

#### NSC five-by-seven-inch cue cards (Rucker & Leonnig, *A Very Stable Genius*)

**UNVERIFIED — not reached.** No copy of the book text was reachable (no lending copy on
archive.org: `https://archive.org/advancedsearch.php?q=title%3A%28%22very+stable+genius%22%29`
returns only audio and video items), and no published account quoting the five-by-seven-inch detail
could be fetched and verified. Web search quota for this session was exhausted, and the scrapable
engines returned CAPTCHAs or 403s. **Do not cite a card size or field list for this item.**

The Biden-era "palm cards" above cover the same ground with a verified source, and the CNN-quoted
Nixon "President's Scenario" covers the same ground with a verified pre-1970 precedent.

#### Political fundraising call sheet — one donor, one page, ~150 words

**Artifacts reached: three, two of them political.**

**A. Filled-in sample — New Organizing Institute, *Campaigning to Engage and Win* (2012), p. 54.**
Fetched `https://www.influencewatch.org/app/uploads/2022/09/campaigning-to-engage-and-win-new-organizing-institute.pdf`
(text layer intact); the same page also fetched standalone and transcribed visually from
`http://sddemtoolbox.org/wp-content/uploads/2016/08/Sample_Call_Sheet_and_Script.pdf`.

**Length.** **One donor per page.** The entire filled sheet — every label, plus six rows of giving
history — is **150 words**, of which only **52 words are actually written prose**: `Notes` 11 words,
`Pitch` 30 words, `Comments` 11 words. Everything else is label-and-value.

**Field list, verbatim and in page order:**
1. `SAMPLE CALL SHEET` (title), with `01/12/11 (date created)` at left and **`ASK AMOUNT $1,000` at
   right on the same line** — the ask is in the header, not buried
2. Name block — donor name bold, then street / city / state / ZIP as free lines
3. `Work phone:`  4. `Home phone:` `Fax:` `Mobile phone:` `Email:` (right column)
5. `Employer:`  6. `Title:`  7. `Notes:`
8. `Contribution History` — columns `Date | Amount | Cycle | Period | Source`
9. `Pledge History` — columns `Date | Amount | Period | Source | Type | Paid`
10. `Pitch`  11. `Comments`  12. `Follow-up`
13. `Submitted By: ______`  14. `Completed By: ______`

Notably **absent**: no "Occupation" (only `Employer` + `Title`), no spouse field, and **no
disposition checkbox** — outcomes live on a separate `SAMPLE CALL TIME TRACKING SHEET` (p. 56) with
columns `Date | Time of Day | Hours Scheduled | Hours Completed | Connects Made | Messages Left |
Hard Pledge | Soft Pledge | Declines | Total Raised`. Blank fields are simply left blank; the sample
ships with `Fax:`, `Title:` and `Email:` empty.

**Voice — three registers on one page, and this is the interesting part:**
- `Notes` — **imperative fragment, no subject**: "Do not call Zoe until 2012 because of travel in
  December"
- `Pitch` — **full sentences in second person, addressed to the caller**: "Zoe is a previous donor
  who needs to understand the challenge you face this year."
- `Comments` — **third-person fragments, semicolon-joined, articles dropped**: "husband does
  immigration policy"
- Header — pure `Label: value`, no verbs.

**Scripted opening — yes, but on the facing page,** not the sheet (`SAMPLE CALL TIME SCRIPT`, p. 55).
Opening verbatim: "Hi, Zoe, this is Belle Weather. How are you? It's been a long time since we've
spoken." The full sample ask runs **213 words in 5 paragraphs**, closing "do you think you could
contribute another $1,000 this month?" It sits under a 10-step spine: 1 Establish rapport,
2 Explain your strategy, 3 Prove you can win with the right resources, 4 Research and begin
prospecting affiliated network, 5 Get donor invested, 6 ASK AND BE SPECIFIC, 7 Zip it up and listen,
8 Collect, 9 Show appreciation, 10 RESOLICIT.

**Prep cost, stated in the same manual:** "it takes 15 minutes to research each donor and create a
solid call sheet" (p. 40), and sheets "should have a standard and complete set of data about the
donor, a suggested ask, accurate phone numbers" (p. 41).

**B. Blank template — IAFF Political Department, "Fundraising Call Sheet."** Fetched
`https://www.iaff.org/wp-content/uploads/Departments/Political_Department/FRCallSheet.pdf`
(2 pp., text layer). **~70 words of label text, one donor per page.** Fields verbatim, in order:
`Ask For:` · `Source of Prospect/Donor:` · `Date:` · `Staff Contact:` · `Name:` · `Office Phone:` ·
`Company:` · `Office Fax:` · `Address:` · `E-Mail:` · `Home Phone:` · `Home Fax:` · `Cell Phone:` ·
`Pager:` · `Home Address:` · `Donor History:` (5 numbered rows, each `Amount: ___ Date: ___ Event:
___`) · `General Notes:` (3 rules) · `Likes your position on:` (3 rules) · `Issue interest:`
(3 rules) · `Knows you from:` (2 rules) · `Results:` (8 rules, each ending `Date ___`).

The three **prompted-fragment fields** — `Likes your position on:`, `Issue interest:`,
`Knows you from:` — are the mechanism that produces the noun-fragment voice. The form makes the
sentence impossible; you can only write the fragment. `Knows you from:` is the single most
transferable field to a member brief.

**C. Civic/nonprofit corroboration — League of Women Voters, "Fundraising Call Sheet."** Fetched
`https://www.lwv.org/sites/default/files/2019-06/Fundraising%20Call%20Tips_LWV.pdf` (sheet is p. 2).
**Not a candidate campaign — label as nonprofit.** **46 words of label text, one donor per page.**
Fields: `Completed by:` · `Date:` · `Donor/Prospective Donor:` · `Phone:` · `Address:` · `Email:` ·
`City/State:` · `Other Contact:` · `Prospective Donation Amount: $` · `Knows you/LWV from:` ·
`Interests:` · `Contact History:` (`Date | Outcome`) · `Giving History:` (`Date | Contact Method
(call, mail, event, etc.) | Amount`) · `Pledges:` (`Dated | Contact Method | Amount`).
Structurally near-identical to the IAFF political sheet — **including `Knows you/LWV from:`**, which
independently converges on the same field.

**UNVERIFIED — traindems.org.** `https://traindems.org/resources/political-call-sheet-example` was
fetched but holds only a description; the handout is gated. Its `Handout.jpg` was downloaded and
inspected and is a blank decorative gradient, not a call sheet. Usable only for scope: the layout
"provides essential information about potential donors, such as their background, previous
contributions, and contact details."
