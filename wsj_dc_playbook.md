# 📘 WSJ + Dividend Café Playbook  
**Location:** `project_index/wsj_dc_playbook.md`  
**Purpose:** Operational workflow for capturing, summarizing, and linking WSJ articles and Dividend Café notes into the Knowledge Base.  
_Last updated: {{TODAY}}_

---

## 1️⃣ Create a New Article Summary

### WSJ Articles
```powershell
newwsj "AI Revolution Will Bring Prosperity" -Url "https://www.wsj.com/..." -Authors "Phil Gramm and Michael Solon" -Tags "#Economy #AI #Jobs" -Open
Dividend Café
powershell
Copy code
newdc "Dividends, Rates, and the Shape of the Market" -Date 2025-11-03 -Tags "#Markets #InterestRates #Policy" -Open
✅ Result:

File created under organized/wsj/wsj_articles/YYYY-MM/ or
organized/dividend_cafe/YYYY-MM/

Auto-filled template includes Summary, Reflection, Finance Insight, Key Quote, Data Table, and Retention Booster.

2️⃣ Complete the Summary
Open the file in VS Code and fill in:

## Summary → 3–5 sentences capturing thesis, evidence, and takeaway.

## Reflection → 2–3 sentences linking the piece to your work or policy/finance themes.

## Finance Insight → brief implications for sectors, pricing, or productivity.

Add a Key Quote and any Data Table values or Related Topics.

💡 Tip: Add one sentence connecting to a client, macro theme, or AI/market impact — this builds synthesis memory.

3️⃣ Tag It
Use consistent tag syntax on the **Tags:** line:

less
Copy code
#Economy #AI #Jobs
#Markets #Energy #Policy
#Inflation #Rates
These tags feed the topic index and findtag.ps1.

4️⃣ Build and Refresh Topic Index
After every few articles or weekly:

powershell
Copy code
build_topics_index.ps1
This script:

Scans /organized/wsj/wsj_articles/ and /organized/dividend_cafe/

Updates /topics/_index.md and 00_topics_and_tags.md

Auto-creates new topic files (e.g., /topics/ai_economy.md) if missing

5️⃣ Create or Link Topics Manually (if needed)
If you introduce a new tag not yet defined:

powershell
Copy code
newresearch "AI in Finance"
or manually create /topics/ai_finance.md using topic_template.md.

Then, in the article’s Related Topics section:

markdown
Copy code
## Related Topics
- tag: /topics/ai_finance.md
6️⃣ Update Article Index Pages
Rebuild master index lists (for both WSJ and DC):

powershell
Copy code
kb_markdown.ps1
This generates or refreshes:

bash
Copy code
/organized/wsj/_index.md
/organized/dividend_cafe/_index.md
sorted by date and linked to individual article files.

7️⃣ Commit and Push
Keep version history clean:

powershell
Copy code
save.ps1 "Added WSJ: AI Revolution Will Bring Prosperity"
or to commit across all repos:

powershell
Copy code
saveall.ps1 -m "Weekly WSJ + DC updates"
8️⃣ Weekly Retention Routine
Open 00a_Retention_Booster.md and review:

Summarize in one line what each article’s thesis was.

Recall one stat or quote per piece.

Reflect on one connection to markets or client strategy.

⏱ Time: ~10 minutes each Sunday
🧠 Goal: Reinforce synthesis and pattern recognition.

🧩 Folder Map Reference
Folder	Purpose
/organized/wsj/wsj_articles/	WSJ article summaries by month
/organized/dividend_cafe/	Dividend Café transcripts/summaries
/topics/	Auto-linked thematic index of recurring tags
/scripts/	Automation helpers (newwsj, newdc, build_topics_index, etc.)
/project_index/	Operational guides, playbooks, and repo-level coordination tools

⚙️ Weekly Workflow Snapshot
Day	Task	Command
Mon–Fri	Capture 1–2 articles via newwsj or newdc	newwsj "..." -Tags ...
Sat	Refresh topic + index lists	build_topics_index.ps1 + kb_markdown.ps1
Sun	Retention review & commit	00a_Retention_Booster.md → saveall.ps1

✅ Long-Term Extensions
Planned future playbooks:

books_playbook.md — structured workflow for book highlights

research_playbook.md — workflow for academic/white-paper summaries

audio_notes_playbook.md — workflow for voice transcripts and reflections

End of wsj_dc_playbook.md

yaml
Copy code
