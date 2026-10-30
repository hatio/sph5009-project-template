# sph5009-project-template

A ready-to-use project scaffold for public health data analysis in R. This
repository is a **GitHub template**: use the green "Use this template"
button on GitHub to start a brand-new project with this exact structure,
with a clean Git history.

This README walks you through everything you need to do to get this
project running on your own machine, whether you are the original author
or someone who just cloned/forked it.

## 1. Cloning This Repository

```bash
git clone https://github.com/<your-username>/<your-repo-name>.git
```

Then open the `.Rproj` file in RStudio. If no `.Rproj` file exists yet
(for example, you downloaded a ZIP instead of cloning), create one via
**File → New Project → Existing Directory**, and point it at this folder.

## 2. Setting Up `renv`

This project uses `renv` to lock down exact package versions, as covered
in Week 3. After opening the project in RStudio for the first time:

```r
# If renv isn't installed yet:
install.packages("renv")

# Restore the exact package versions recorded in renv.lock:
renv::restore()
```

`renv` will read `renv.lock`, compare it against your local library, and
install anything missing. Once this finishes, you have the same package
environment the project was built and tested with.

If you are starting a **new** project from this template (rather than
reproducing an existing analysis), you can instead run `renv::init()` to
start a fresh lockfile, then `renv::snapshot()` once you've installed the
packages your analysis actually needs.

## 3. Data Sensitivity: Why There Is No `data/` Folder

You'll notice this repository does **not** contain a `data/` folder, and
`.gitignore` is set up to keep it that way. This is intentional, not an
oversight.

Public health data is very often sensitive: patient-level records,
identifiable survey responses, or datasets covered by a data use
agreement that explicitly forbids redistribution. Committing such data to
Git, especially a **public** GitHub repository, can constitute a serious
and sometimes irreversible breach (once pushed, data can live in the
repository's history forever, even if you later delete the file). Git is
also simply not designed for large binary data files, every version is
stored in full forever, which bloats a repository's size indefinitely.

So how do you keep a project reproducible **without** putting the actual
data in Git? Two complementary approaches:

### 3.1 Store Data Externally, Track It With a Hash

Keep your raw data in an external, access-controlled location (a shared
drive, an institutional data repository, REDCap export, etc.), **not** in
this Git repository. To still let anyone with legitimate access confirm
they have the *correct, unmodified* version of that data, this project
tracks a **checksum (hash)** of each expected data file instead of the
data itself.

A hash is a short fingerprint computed from a file's exact contents; if
even a single byte changes, the hash changes completely. Two people with
"the same" file in the same external location can both verify they truly
have identical data, without ever uploading the file itself anywhere.

See `data_manifest.csv` in this repository for the list of expected files
and their hashes. Two companion scripts work with this manifest:

- `scripts/data/import/generate_data_hash.R` computes hashes for the files
  currently in your local `data/` folder and writes (or updates) them into
  `data_manifest.csv`. Run this once, when you first add data to the
  project, or deliberately whenever the underlying data legitimately
  changes:

  ```r
  source("scripts/data/import/generate_data_hash.R")
  ```

- `scripts/data/import/verify_data_hash.R` checks your local copy of the
  data against the hashes already recorded in `data_manifest.csv`, and
  flags a mismatch if anything differs. Run this any time you want to
  confirm you're working with the expected version of the data, for
  example after pulling the latest project code, or before running an
  analysis:

  ```r
  source("scripts/data/import/verify_data_hash.R")
  ```

In short: generate a hash once when the data is first placed or
intentionally updated, and verify it often, every time you want assurance
that your local `data/` folder still matches what the rest of the team
expects.

If a hash doesn't match, you do **not** have the same data others used,
and should not proceed with the analysis until you've sourced the correct
file.

### 3.2 Symlinking Data Into the Project

Rather than copying a large dataset into every project folder it's used
in (wasting disk space, and risking someone accidentally editing a "copy"
that's supposed to be read-only), it's common to keep one real copy of
the data somewhere central on your machine, and create a **symbolic
link** (symlink) named `data/` inside the project that points to it.
Your R code can then always refer to `data/...` as if the files were
really there, regardless of where they actually live on disk.

`.gitignore` already excludes `data/` itself, whether it's a real folder
or a symlink, so this is safe to set up without risking an accidental
commit.

**macOS / Linux**, in Terminal, from inside the project folder:

```bash
ln -s /absolute/path/to/your/real/data/folder data
```

**Windows**, in Command Prompt (run as Administrator) or PowerShell, from
inside the project folder:

```powershell
# Command Prompt:
mklink /D data "C:\absolute\path\to\your\real\data\folder"

# PowerShell:
New-Item -ItemType SymbolicLink -Path "data" -Target "C:\absolute\path\to\your\real\data\folder"
```

Afterward, `data/` will appear in your Files pane like a normal folder,
but it's really just a pointer. Deleting the symlink does **not** delete
your real data; it only removes the pointer.

## 4. Project Structure

```
sph5009-project-template/
├── project-template.Rproj
├── README.md                     <- you are here
├── .gitignore
├── .Rprofile
├── LICENSE
├── renv.lock
├── data_manifest.csv             <- expected data files + hashes (no actual data)
├── main.R                        <- single entry point; sources everything in order
└── scripts/
    ├── data/
    │   ├── import/      <- reading raw data in, hash verification
    │   ├── process/     <- cleaning, wrangling, joining
    │   └── explore/     <- exploratory summaries and plots
    └── analysis/        <- statistical analysis, final outputs
```

Each `scripts/` subfolder has its own short `README.md` explaining what
belongs there. Start by reading `main.R`, it's the single place that
shows, top to bottom, how the whole project runs.

## 5. License

This template is released under the MIT License (see `LICENSE`). You are
free to use, modify, and redistribute it, including for your own course
or research projects, with attribution.
