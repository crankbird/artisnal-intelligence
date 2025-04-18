---
layout: default
title: Design Philosophy
---

## Design Principles

1. Signal over noise  
2. Transparency  
3. Own your platform  
4. Accessible and adaptable  
5. Composable simplicity  
6. Data dignity  
7. Provenance and attribution

## Security

From an authoring perspective, I rely on what GitHub provides out of the box.
Within that, I operate with a minimal but deliberate trust model — keys are
scoped, labeled, and revocable. In the enterprise world — such as at NetApp or
on GitHub Enterprise — where the stakes and blast radius are exponentially
larger, I strongly advocate for controls like Multi-Admin Verification (MAV).

From an end-user security perspective, I aim to minimize the attack surface by using a read-only static blog platform
(Jekyll) with an absolute minimum of JavaScript. Text decoration is handled via CSS, and state is kept to a bare minimum.

There are no tracking cookies, analytics beacons, or third-party search engine widgets.
