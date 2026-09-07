# Diagramming Standard

Durable convention for how diagrams are drawn across the StudyShield / Open-School docs.
Established 2026-09-05. When drawing any architecture/flow diagram, choose the level that
matches the question being answered and **ask the requester a clarifying question whenever
level or scope is ambiguous.**

## The five diagram types

### 1. System Context Diagram — C4 Level 1

Shows the **system as a single box** surrounded by its users (actors) and its primary
external dependencies (payment gateways, databases-as-service, external APIs, relays).

- **Purpose:** "What is this system, and who/what does it depend on?"
- **Tool:** PlantUML + C4-PlantUML — `diagrams/system-context.puml`.

### 2. Container Diagram — C4 Level 2

Zooms into the system boundary to show its **high-level deployable building blocks**:
mobile app, TV app, web frontend, backend services/microservices, databases.

- **Purpose:** "What are the runnable pieces and how do they talk?"
- **Tool:** PlantUML + C4-PlantUML — `diagrams/container.puml`.

### 3. Component Diagram — C4 Level 3

Zooms into a **single container** to show its internal **modules / controllers / services**
and the connections between them.

- **Purpose:** "How is this one service/container structured internally?"
- **Tool:** PlantUML + C4-PlantUML — `diagrams/backend-component.puml`, `diagrams/mobile-tv-component.puml`.

### 4. Sequence Diagram — UML Behavioral

Shows **how objects/services interact over time** to fulfill a specific use case (e.g.,
user login, running a quiz session).

- **Purpose:** "In what order do the participants call each other for this use case?"
- **Tool:** PlantUML sequence diagrams (or Mermaid `sequenceDiagram` for inline sketches).

### 5. Deployment Diagram — UML Structural

Maps the **physical / cloud infrastructure** where the artifacts run (AWS EC2 / RDS, Docker
containers, Render, LAN devices).

- **Purpose:** "Where does each artifact physically run, and how are the runtime nodes
  connected?"
- **Tool:** PlantUML + C4-PlantUML (`C4_Deployment.puml`) or PlantUML deployment diagrams.

## Guidance

- **Always verify against real code/data** before drawing — do not infer links (e.g. the TV
  app has no backend client; deep-link accordingly).
- **Ask before drawing** when: level is ambiguous, actors/dependencies are uncertain, or a
  use case for a sequence diagram has not been named. State the level you plan to draw and
  confirm with the requester.
- Label edges with transport (HTTPS REST / LAN TCP) and payload names.
- **All C4/architecture diagrams must be rendered with PlantUML + C4-PlantUML**
  (`scripts/diagrams.sh`); commit the rendered SVG/PNG under `docs/images/`. Mermaid is
  acceptable only for throwaway inline sketches. **No AI-art / generated-illustration tools**
  (e.g. illo) for architecture diagrams — rejected 2026-09-05: "doesn't look good."

## Current site pages mapped to levels

| Doc page | Level |
|----------|-------|
| `architecture/system.md` (components & data flow) | Container (C4 L2) |
| `architecture/backend.md` (module map) | Component (C4 L3) |
| `per-repo/mobile-tv.md` | summary (links out) |
