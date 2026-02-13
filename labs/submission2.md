# Lab 2 Submission

## Task 1: Git Object Model Exploration


### Command Outputs


**Commit object:**
git cat-file -p 49100d1
tree 2732f20536b9d25c17d9b3d87464215831337a3e
parent 620a09ce348668af735cb4734243cc66264b8596
author Borodum <batraz@dzesov.ru> 1770975162 +0300
committer Borodum <batraz@dzesov.ru> 1770975162 +0300
gpgsig -----BEGIN SSH SIGNATURE-----
 U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgJaz85H8mZfaOuHnezktV4YzOPs
 6c6SJjPp7dNOo5vZgAAAADZ2l0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5
 AAAAQFmwM67A8nZjHjew0n6YQKgxmOVgksfFiJOCL1QOqrLCgX1ZTIJ6B5FyGu1Cghs9Ay
 H5udU4oDATpZhXPSMXnwE=
 -----END SSH SIGNATURE-----

Add test file

**Tree object:**
git cat-file -p <tree_hash>
040000 tree 31b70523ef0f27ab0a32d735433905178c5f74a0    .github
100644 blob 6e60bebec0724892a7c82c52183d0a7b467cb6bb    README.md
040000 tree a1061247fd38ef2a568735939f86af7b1000f83c    app
040000 tree eb79e5a468ab89b024bd4f3ed867c6a3954fe1f0    labs
040000 tree d3fb3722b7a867a83efde73c57c49b5ab3e62c63    lectures
100644 blob 2eec599a1130d2ff231309bb776d1989b97c6ab2    test.txt

**Blob object:**
git cat-file -p <blob_hash>
Test content


### Object Type Explanations
- **Blob**: Stores file content (binary data). No metadata, just the raw file contents.
- **Tree**: Stores directory structure, filenames, and references to blobs/subtrees.
- **Commit**: Stores metadata (author, date, message) and points to a tree snapshot.

### Git Storage Analysis
Git stores data as a content-addressable filesystem. Each object has a SHA-1 hash based on its content. Blobs are file contents, trees are directories, and commits are snapshots pointing to trees.
## Task 2: Reset and Reflog Recovery

### Commands Used
```bash
# Created practice branch with 3 commits
git switch -c git-reset-practice
echo "First commit" > file.txt && git add file.txt && git commit -m "First commit"
echo "Second commit" >> file.txt && git add file.txt && git commit -m "Second commit"
echo "Third commit" >> file.txt && git add file.txt && git commit -m "Third commit"

# Soft reset - moves HEAD, keeps changes staged
git reset --soft HEAD~1
# Result: Third commit removed from history, changes still staged

# Hard reset - moves HEAD, discards all changes
git reset --hard HEAD~1
# Result: Moved to First commit, working directory matches that state

# Recovery using reflog
git reflog
git reset --hard <hash_of_Third_commit>
# Result: Successfully recovered Third commit

### Analysis
- **`--soft`**: Moves HEAD only, keeps index and working directory. Good for recommitting with different message.
- **`--hard`**: Moves HEAD, resets index AND working directory. Destructive but useful for complete undo.
- **`reflog`**: Records every HEAD movement. Essential for recovering "lost" commits (git's safety net).
## Task 3: Visualize Commit History

### Commands Used
```bash
git switch -c side-branch
echo "Branch commit" >> history.txt
git add history.txt && git commit -m "Side branch commit"
git log --oneline --graph --all

## Graph Output
 git log --oneline --graph --all
* 38a2a95 (HEAD -> side-branch) Side branch commit
| * 2ee7b59 (git-reset-practice) Third commit
| * 16e12da Second commit
| * 2a2a419 First commit
|/
* 49100d1 (feature/lab2) Add test file
* 620a09c (origin/main, origin/HEAD, main) docs: add PR template
| * 8aefa7d (origin/feature/lab1, feature/lab1) docs: complete lab1 submission with detailed answers
| * fbff5ea docs: add lab1 submission stub with commit signing setup
|/
* d6b6a03 Update lab2
* 87810a0 feat: remove old Exam Exemption Policy
* 1e1c32b feat: update structure
* 6c27ee7 feat: publish lecs 9 & 10
* 1826c36 feat: update lab7
* 3049f08 feat: publish lec8
* da8f635 feat: introduce all labs and revised structure
* 04b174e feat: publish lab and lec #5
* 67f12f1 feat: publish labs 4&5, revise others
* 82d1989 feat: publish lab3 and lec3
* 3f80c83 feat: publish lec2
* 499f2ba feat: publish lab2
* af0da89 feat: update lab1
* 74a8c27 Publish lab1
* f0485c0 Publish lec1
* 31dd11b Publish README.md

### Reflection
The graph visually shows branch relationships, making it easy to understand:
- Where branches diverged
- Commit order across branches
- Current HEAD position
This is invaluable for understanding complex repository history and debugging.
## Task 4: Tagging Commits

### Commands Used
```bash
git tag v1.0.0
git push origin v1.0.0

## Tag Information

- **Tag name:** v1.0.0  
- **Commit hash:** 49100d134942a52811ff204c58968873cb2d7543 refs/tags/v1.0.0 
- **Pushed to:** origin  

---

## Why Tags Matter

Tags are important for:

- **Versioning:** Marking release points (v1.0.0)  
- **CI/CD Triggers:** Many pipelines deploy when tags are pushed  
- **Release Notes:** Clear reference points for what changed between versions  
- **Historical Reference:** Easy way to checkout specific releases
## Task 5: git switch vs git checkout vs git restore

### Commands and Outputs

**git switch (branch operations only)**
$ git switch -c cmd-compare
$ git branch

*cmd-compare
feature/lab1
feature/lab2
git-reset-practice
main
side-branch

$ git switch -
Switched to branch 'feature/lab2'

**git restore (file operations)**
## Discard working directory changes
$ echo "new content" >> demo.txt
$ git restore demo.txt **'Discards changes'**

## Unstage files
$ git add stage.txt
$ git restore --staged stage.txt **'Unstages but keeps file'**

### When to Use Each Command
- **`git switch`**: Use for ALL branch switching operations (create, change branches). Clear, single-purpose.
- **`git restore`**: Use for ALL file restoration operations (discard changes, unstage). Clear, single-purpose.
- **`git checkout`**: Legacy command - avoid. It does too many things (branches + files), leading to confusion.
## Task 6: GitHub Community Engagement

### Actions Completed
- [x] Starred course repository (inno-devops-labs/DevOps-Intro)
- [x] Starred simple-container-com/api project
- [x] Followed professor @Cre-eD
- [x] Followed TA @marat-biriushev
- [x] Followed TA @pierrepicaud
- [x] Followed classmates: @NikitaMensh, @revlze, @arinapetukhova

### Why Stars Matter in Open Source
Stars serve as bookmarks for interesting projects and signal popularity to the community. They help projects gain visibility, attract contributors, and show appreciation to maintainers. On GitHub, starred repositories appear in your profile, showcasing your interests to potential employers.

### Why Following Developers Helps in Teams
Following developers lets you see their public activity, discover new projects they work on, and learn from their code. In team projects, following classmates helps build a supportive learning community, makes collaboration easier, and keeps you connected with their work.
