# CKA-PREP

## Introduction
This repository contains hands-on labs aligned with the CKA video playlist:
https://www.youtube.com/watch?v=-rs3AoAVyXE&list=PLkDZsCgo3Isr4NB5cmyqG7OZwYEx5XOjM&index=3

- Question numbers align with the videos.
- Some questions include slight differences (resource names, namespaces, naming, etc.) to better match exam-style wording — read each question carefully.

## Repository structure
Each question has its own folder named `Question-X` (where X is the question number). A typical question folder contains:

- `Question.bash` — The question text and a link to the associated video.
- `LabSetUp.bash` — Executable bash script to prepare the Killercoda lab environment.
- `SolutionNotes.bash` — Supplemental notes and hints to reach the solution.

## How to use in Killercoda
1. Open the CKA playground: https://killercoda.com/playgrounds/scenario/cka
2. Clone this repo:
   ```
   git clone https://github.com/CameronMetcalfe22/CKA-PREP
   ```
3. Make the desired question setup executable (example for Question 1):
   ```
   chmod +x CKA-PREP/Question-1/LabSetUp.bash
   ```
   Change `Question-1` to the question number you want (e.g., `Question-8`).
4. Run the setup script:
   ```
   ./CKA-PREP/Question-1/LabSetUp.bash
   ```
   Change the number to your chosen question (e.g., `./CKA-PREP/Question-8/LabSetUp.bash`).
5. Allow the script to complete — once finished, the Killercoda lab will be set up and ready for you to tackle the question.

## Questions
Each `Question-X` folder contains the lab task under `Question.bash` which includes a link to the corresponding youtube video. Note that the lab files may intentionally vary in names, namespaces, or resource identifiers compared to the video — this is to align more closely with typical exam phrasing. Always treat the question text in the repo as the authoritative task.

## Solution Notes
Solution notes provide supplemental guidance and encourage exam-appropriate approaches (for example, preferring `kubectl patch` over `kubectl edit` when applicable). They are not the only way to reach a solution but can be helpful if you get stuck.

## Recommendations
- Most labs can run concurrently in the same Killercoda session.
- Some labs (for example, `Question-14`) modify or break cluster components; for those it's recommended to start a fresh Killercoda session before running the lab.
- Read each question carefully for small differences from the video (namespaces, resource names, etc.).
