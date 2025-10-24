CKA-PREP
Introduction
This repository contains hands-on labs for preparing for the Certified Kubernetes Administrator (CKA) exam. The labs are based on the YouTube playlist by KodeKloud.

Question numbers align with the videos in the playlist.
Note: There are slight differences in some questions (e.g., naming, namespaces, resource definitions) to better reflect real CKA exam-style variations. Always read the Question.bash file carefully.

Structure
Each question has its own folder with the following files:

Question.bash Full question text as it appears in the lab.
LabSetUp.bash Executable bash script to set up the environment in Killercoda.
SolutionNotes.bash Step-by-step notes on solving the question, aligned with exam-style practices (e.g., using patch, create, imperative commands).

CKA-PREP/
Question-1/
Question.bash
LabSetUp.bash
SolutionNotes.bash
Question-2/
...
How to Use in Killercoda

Go to: https://killercoda.com/playgrounds/scenario/cka
Clone the repository:
git clone https://github.com/CameronMetcalfe22/CKA-PREP
Make the setup script executable:
chmod +x CKA-PREP/Question-1/LabSetUp.bash
Replace 1 with your desired question number (e.g., Question-8).
Run the setup script:
./CKA-PREP/Question-1/LabSetUp.bash
Replace 1 with the correct question number.
Wait for the script to complete your lab environment will be fully configured!


Questions
Each question includes:

A direct reference to the corresponding video in the playlist.
Exam-style variations (namespaces, names, constraints).
Full task description in Question.bash.

Important: Always read the Question.bash file do not assume it matches the video exactly.

Solution Notes

Found in SolutionNotes.bash per question.
Focus on exam-efficient methods (imperative commands, kubectl patch, create --dry-run=client, etc.).
Designed to supplement the video, not replace it.
Helpful if you're stuck or want to see alternative approaches.


Recommendations

Most labs can run concurrently in the same Killercoda session.
Some labs (e.g., Question 14) break the cluster intentionally.
Start a fresh Killercoda session for each new question to avoid conflicts.


Good luck with your CKA preparation!