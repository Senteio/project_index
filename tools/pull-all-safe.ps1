# Reads repos from versioned list + optional local override
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$versioned = Join-Path $root "repos.list"
$local     = Join-Path $root "repos.local.list"

$repos = @()
if (Test-Path $versioned) { $repos += Get-Content $versioned | Where-Object { $_ -and -not $_.StartsWith("#") } }
if (Test-Path $local)     { $repos += Get-Content $local     | Where-Object { $_ -and -not $_.StartsWith("#") } }
$repos = $repos | Sort-Object -Unique

# --- SETTINGS ---
$useRebase     = $true        # pull with --rebase
$enforceClean  = $true        # require clean tree; if $false, will --autostash
$defaultBranch = $null        # set to "main" to force pulling on main; $null = stay on current branch

function Get-AheadBehind {
  param([string]$repo)
  $u = (git -C $repo rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>$null)
  if (-not $u) { return [pscustomobject]@{ ahead=0; behind=0; diverged=$false; note="(no upstream set)" } }
  $counts = (git -C $repo rev-list --left-right --count "@{u}...HEAD").Trim() -split '\s+'
  if ($counts.Count -ne 2) { return [pscustomobject]@{ ahead=0; behind=0; diverged=$false; note="(unknown)" } }
  $behind = [int]$counts[0]; $ahead = [int]$counts[1]
  [pscustomobject]@{ ahead=$ahead; behind=$behind; diverged=($ahead -gt 0 -and $behind -gt 0); note=$null }
}

function Pull-RepoSafe {
  param([string]$path)

  if (-not (Test-Path $path) -or -not (Test-Path (Join-Path $path ".git"))) {
    Write-Warning "Skipping (missing/not a git repo): $path"; return
  }

  Write-Host "`n=== $path ===" -ForegroundColor Cyan
  $branch = (git -C $path rev-parse --abbrev-ref HEAD).Trim()
  Write-Host "On branch: $branch"

  # 1) FETCH
  git -C $path fetch --all --prune
  if ($LASTEXITCODE -ne 0) { Write-Warning "Fetch failed, skipping."; return }
  Write-Host "Fetched remote refs." -ForegroundColor DarkGray

  # Optional: normalize to a default branch
  if ($defaultBranch) {
    git -C $path rev-parse --verify $defaultBranch 1>$null 2>$null
    if ($LASTEXITCODE -eq 0 -and $branch -ne $defaultBranch) {
      git -C $path checkout $defaultBranch
      $branch = $defaultBranch
      Write-Host "Checked out $defaultBranch."
    } elseif ($LASTEXITCODE -ne 0) {
      Write-Warning "Default branch '$defaultBranch' not found; staying on $branch"
    }
  }

  # 2) SHOW STATUS (local cleanliness + ahead/behind)
  $dirty = (git -C $path status --porcelain)
  if ($dirty) {
    Write-Host "Working tree: DIRTY (local changes present)" -ForegroundColor Yellow
  } else {
    Write-Host "Working tree: CLEAN" -ForegroundColor DarkGray
  }

  $ab = Get-AheadBehind -repo $path
  if ($ab.note) { Write-Host $ab.note -ForegroundColor Yellow }
  Write-Host ("Ahead: {0}  Behind: {1}  Diverged: {2}" -f $ab.ahead, $ab.behind, $ab.diverged) -ForegroundColor DarkGray

  # 3) DECIDE & ACT
  if ($ab.diverged) {
    Write-Warning "Diverged from upstream. Resolve manually (rebase/merge). Skipping."
    return
  }

  if ($ab.behind -gt 0) {
    if ($dirty -and $enforceClean) {
      Write-Warning "Behind but working tree is dirty. Commit/stash first. Skipping."
      return
    }
    Write-Host "Upstream ahead by $($ab.behind). Pulling with $([string]::Join(' ', @('rebase' * $useRebase)))..."
    $pullArgs = @("pull")
    if ($useRebase) { $pullArgs += "--rebase" }
    if (-not $enforceClean) { $pullArgs += "--autostash" }
    git -C $path @pullArgs
  } elseif ($ab.ahead -gt 0) {
    Write-Host "Local is ahead by $($ab.ahead). Nothing to pull (consider pushing)." -ForegroundColor DarkGray
  } else {
    Write-Host "Already up to date." -ForegroundColor DarkGray
  }
}

if (-not $repos) { Write-Warning "No repos found in repos.list / repos.local.list"; exit 1 }
foreach ($r in $repos) { Pull-RepoSafe -path $r }
