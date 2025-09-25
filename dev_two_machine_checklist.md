Dev Two Machine Checklist
Two-Machine Dev Workflow Checklist
Daily Workflow

Start of session (ThinkPad or Slim 7):

git pull --rebase
git status

End of session:

git add -A
git commit -m "WIP: <summary of work>"
git push

For incomplete work, use a branch like wip/YYYY-MM-DD.

Repo & Storage Setup

Clone each repo separately on each machine (don’t copy from OneDrive).

Keep identical structure:

C:\dev\
  repos\            # GitHub repos
  knowledge_base\   # notes
    project_index\
  journal\          # journal repo

Store the workspace file (project_index.code-workspace) in a repo so both machines pull the same view.

Git Auth & Settings

Choose one auth method on both machines:

HTTPS + Git Credential Manager (easy)

SSH keys (no prompts, add key from each machine to GitHub)

Configure identity:

git config --global user.name  "Steve S"
git config --global user.email "you@example.com"

Normalize line endings:

git config --global core.autocrlf true

(Or add .gitattributes with * text=auto to repos.)

Python Environments

Use per-repo venvs on each machine:

py -3.11 -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt

Record dependencies:

pip freeze > requirements.txt

Commit requirements.txt, never commit .venv/.

VS Code Consistency

Enable Settings Sync (accounts icon → “Turn on Settings Sync”).

Use project_index.code-workspace to open all folders together.

(Optional) Add code CLI to PATH so you can run:

code "C:\dev\project_index.code-workspace"
Branching & Safety

Protect main (PRs or careful merges).

Use short-lived feature branches, delete after merge.

Tag milestones (e.g., phase-iii.1).

Habits

Always pull before starting, push before stopping.

Never leave uncommitted edits when switching machines.

If branches diverge:

git pull --rebase
# resolve conflicts
git push
Avoid

Moving repos with File Explorer or OneDrive.

Sharing venvs between machines.

Editing the same file on both machines without pulling/pushing in between.