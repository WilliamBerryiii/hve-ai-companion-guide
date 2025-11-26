---
title: Exercise - Audit Your Codebase
description: Complete a hands-on 20-30 minute audit of your codebase using the assessment framework
author: HVE Core Team
ms.date: 2025-11-18
chapter: 1
part: I
keywords:
  - hands-on-exercise
  - codebase-audit
  - assessment-practice
  - improvement-planning
  - ai-readiness
---

You've seen the assessment framework. Now it's time to apply it to your own codebase.

Through this exercise, you'll discover exactly where your codebase stands and create a clear path forward. No judgment, no grading—just data that helps you make smart decisions about AI adoption.

Whatever you discover is valuable information. Ready? Let's find out what you're working with.

## What You'll Discover

**Through this exercise, you'll:**

* Assess your codebase across all four engineering pillars
* Calculate your AI-readiness score (1-20 scale)
* Identify your highest-leverage improvement opportunities
* Create a realistic 2-week improvement plan
* Make a confident decision about when to adopt AI assistance

**What You'll Need:**

* Access to a codebase (work project, personal project, or open source)
* Terminal access to run assessment commands
* Text editor for documenting findings
* Openness to honest self-assessment

## Preparation

### Select Your Codebase

#### Option 1: Work Project (Recommended)

* Choose a project you actively maintain
* Must have source code access
* Bonus: Can actually implement improvements

#### Option 2: Personal/Side Project

* Use a project you control
* Good for learning without organizational constraints

#### Option 3: Open Source Project (For learning)

* Choose a well-known OSS project (React, Vue, Express, etc.)
* Good for seeing high-quality examples
* Note: You won't implement improvements, just learn from assessment

#### Option 4: Starter Project (If no codebase available)

* We provide sample legacy codebase for assessment practice
* Download from: [github.com/hve-core/assessment-starter](https://github.com/hve-core/assessment-starter)

## Phase 1: Discover Your Baseline

You're about to take an honest look at your codebase's fundamentals. This takes courage. Most developers avoid this kind of honest assessment. Remember: you're not grading yourself, you're gathering data to make smart improvement decisions.

Whatever you discover is your starting point. No judgment here.

### Step 1: Testing Assessment

Let's start with tests. Take a deep breath and look at what's actually there, not what you wish was there.

**Check if tests exist:**

```bash
ls -la test/ tests/ __tests__/ spec/
```

**Run test coverage (if tests exist):**

```bash
# Use language-specific command from the Assessment Framework
# Example for JavaScript:
npm test -- --coverage
```

**What did you discover about your tests?**

**Score your testing (1-5):** _____

**Document what you found:**

```markdown
## Testing Assessment: Score X/5

**What I Discovered:**
* Test directory: [exists/does not exist]
* Test coverage: [XX%] (if available)
* CI integration: [yes/no]
* What surprised me: [observations about your testing reality]
* How this makes me feel: [honest reaction]
```

### Step 2: Linting Assessment

You're doing great. Now let's look at code consistency. This pillar is often the quickest to improve—many teams go from score 1 to score 4 in under two hours.

**Check for linter configuration:**

```bash
ls -la .eslintrc* .prettierrc* pylintrc .rubocop.yml
```

**Check for pre-commit hooks:**

```bash
ls -la .git/hooks/pre-commit .husky/
```

**Check CI for linting:**

```bash
cat .github/workflows/*.yml | grep lint
```

**What did you discover about code consistency?**

**Score your linting (1-5):** _____

**Document what you found:**

```markdown
## Linting Assessment: Score X/5

**What I Discovered:**
* Linter installed: [tool name or none]
* Configuration: [exists/missing]
* Pre-commit hooks: [yes/no]
* CI enforcement: [yes/no]
* What this reveals: [insights about your team's consistency practices]
```

### Step 3: Documentation Assessment

You're halfway through the assessment. Whatever you're discovering, you're building clarity about your starting point.

Now let's look at documentation. This pillar often gets neglected. If that's what you discover, you're not alone.

**Check README:**

```bash
wc -l README.md
cat README.md | head -50
```

**Check for ADRs:**

```bash
ls -la docs/adr/ docs/decisions/
```

**Spot-check inline comments:**

```bash
# Open 3-5 files, look for explanatory comments
```

**What did you discover about your documentation?**

**Score your documentation (1-5):** _____

**Document what you found:**

```markdown
## Documentation Assessment: Score X/5

**What I Discovered:**
* README length: [XXX lines]
* README sections: [what's included]
* ADRs: [X found / not found]
* Inline comments: [frequent/sparse/none]
* What this reveals about knowledge sharing: [your insights]
```

### Step 4: Source Control Assessment

Almost there—one more pillar to assess. You're doing the hard work of honest evaluation, and that takes real courage.

Let's look at your Git history. This pillar reveals how your team communicates through code.

**Check recent commit history:**

```bash
git log --oneline -20
```

**Evaluate message quality:**

```bash
git log --oneline -50 | grep -E "feat|fix|refactor"
```

**Check for PR template:**

```bash
ls -la .github/PULL_REQUEST_TEMPLATE.md
```

**What did you discover about your Git hygiene?**

**Score your source control (1-5):** _____

**Document what you found:**

```markdown
## Source Control Assessment: Score X/5

**What I Discovered:**
* Commit message quality: [descriptive/vague]
* Conventional commits: [yes/no]
* PR template: [exists/missing]
* Branch strategy: [feature branches/direct to main]
* What this reveals about team communication: [your insights]
```

## Phase 2: See What You've Discovered

**You did it!** You've completed the assessment. Whatever you discovered about your codebase is valuable information. Now let's see what your scores reveal.

**Add up pillar scores:**

```text
Testing:         ____ / 5
Linting:         ____ / 5
Documentation:   ____ / 5
Source Control:  ____ / 5
───────────────────────
TOTAL:           ____ / 20
```

**Determine your readiness tier** (see [Assessment Framework](04-assessment-framework.md#interpreting-your-score) for full details):

* 18-20: Excellent - AI-Ready
* 15-17: Good - Mostly Ready
* 11-14: Adequate - Proceed with Caution
* 6-10: Needs Work - High Risk
* 1-5: Not Ready

**How do you feel about your score?** Whatever tier you're in, you now have clarity about where you stand. That's valuable.

**Document your interpretation:**

```markdown
## Overall Assessment: XX/20 - [Tier Name]

**Interpretation:**
[Copy interpretation from Section 4 for your tier]

**AI Effectiveness Prediction:**
[Expected AI effectiveness level]

**Recommended Action:**
[Proceed to Ch 2 / Improve fundamentals first / etc.]
```

## Phase 3: Discover Your Opportunities

Now comes the exciting part: turning your assessment into an improvement roadmap. Every gap you identified is an opportunity to make AI assistance more effective.

Let's find your highest-leverage improvements: the changes that will have the biggest impact on AI effectiveness.

### 1. Identify Your Biggest Opportunity

**Which pillar scored lowest?** _____

(This is your highest-leverage improvement opportunity!)

**Why does this pillar score low?**

```markdown
**Pillar**: [name]
**Score**: X/5
**Why low**: [specific reasons - no tests, no linting config, etc.]
```

### 2. Identify Quick Wins

For each pillar scoring <4, identify ONE improvement taking <2 hours:

```markdown
## Quick Win Improvements (<2 hours each)

### [Pillar 1]: [Improvement name]
* **Current state**: [what exists now]
* **Target state**: [what you'll create]
* **Time estimate**: [hours]
* **Impact**: [score increase expected]

### [Pillar 2]: [Improvement name]
* **Current state**: [what exists now]
* **Target state**: [what you'll create]
* **Time estimate**: [hours]
* **Impact**: [score increase expected]
```

**Example Quick Wins:**

* **Testing**: Add test framework + 5 tests for critical function → +1 score
* **Linting**: Install ESLint + Prettier with defaults → +2 score
* **Documentation**: Write 50-line README with setup + architecture → +1 score
* **Source Control**: Add PR template with checklist → +1 score

### 3. Create Prioritized Action Plan

```markdown
## 2-Week Improvement Plan

**Goal**: Increase AI-readiness score from XX to YY

### Week 1
**Priority 1: [Lowest-scoring pillar]**
- [ ] [Action 1] - [X hours] - Due: [date]
- [ ] [Action 2] - [X hours] - Due: [date]

**Priority 2: [Second-lowest pillar]**
- [ ] [Action 3] - [X hours] - Due: [date]

### Week 2
**Priority 3: [Third improvement]**
- [ ] [Action 4] - [X hours] - Due: [date]

**Priority 4: [Fourth improvement]**
- [ ] [Action 5] - [X hours] - Due: [date]

**Total time investment**: [XX hours over 2 weeks]
**Expected score increase**: XX → YY (+Z points)
**New tier**: [Current tier] → [Target tier]
```

## Phase 4: Document Complete Assessment

**Save your assessment as:**

```text
ai-readiness-assessment-[YYYYMMDD].md
```

**Include:**

* All four pillar scores with evidence
* Total score and interpretation
* Priority improvements
* 2-week action plan

## You Did It

You've completed an honest assessment of your codebase's AI-readiness. That took courage and focus. Whatever you discovered, whether your score was 5 or 18, you now have something invaluable: **clarity**.

You know where you stand. You know where to focus your improvement efforts. You can make informed decisions about AI adoption timing.

Take a moment to appreciate what you've accomplished. This kind of honest self-assessment is rare and valuable.

## Self-Check Criteria

### ✅ Assessment Complete

* [ ] Scored all four pillars (1-5 each)
* [ ] Provided specific evidence for each score
* [ ] Calculated total score (1-20)
* [ ] Identified readiness tier
* [ ] Documented recommended action

### ✅ Improvement Plan Created

* [ ] Identified 3-5 specific improvement actions
* [ ] Each action has time estimate
* [ ] Actions prioritized by impact
* [ ] 2-week timeline with due dates
* [ ] Know which improvement to start first

### ✅ Honest Assessment

* [ ] My scores reflect reality (not what I wish was true)
* [ ] I have specific evidence supporting each score
* [ ] My improvement plan feels achievable given my constraints
* [ ] I'm confident in my next step (proceed to AI adoption or improve fundamentals first)
* [ ] I feel good about the clarity I've gained

## Example Completed Assessment

```markdown
# AI-Readiness Assessment: MyProject API
**Date**: 2024-11-17
**Assessor**: Jane Developer

## Pillar Scores

### Testing: 3/5 (Basic Coverage)
**Evidence:**
* Test directory exists: `tests/`
* Coverage: 28% (ran `npm test -- --coverage`)
* Tests run in CI (`.github/workflows/test.yml`)
* No integration tests (only unit tests)

### Linting: 4/5 (Automated CI Checks)
**Evidence:**
* ESLint + Prettier configured
* CI fails on violations
* No pre-commit hooks (violations found late)
* Current violations: 0

### Documentation: 2/5 (Basic README)
**Evidence:**
* README: 45 lines (basic setup only)
* No architecture overview
* No ADRs (project is 2 years old)
* Sparse inline comments

### Source Control: 4/5 (Conventional Commits + PRs)
**Evidence:**
* Conventional commits used (checked last 50)
* PR reviews required
* No PR template (manual checklist in reviews)
* Good commit message quality

## Total Score: 13/20 - Adequate (Proceed with Caution)

**Interpretation:**
Basic fundamentals in place but significant gaps. AI tools can provide moderate assistance but with notable limitations. Recommended action: Spend 1-2 weeks improving fundamentals before full AI adoption.

## Priority Improvements

### Priority 1: Documentation (Score 2 → 4)
**Quick Wins:**
1. Expand README to 100+ lines with architecture section (2 hours)
2. Create 3 ADRs for major decisions (3 hours)
3. Add inline comments to 10 most complex functions (2 hours)

### Priority 2: Testing (Score 3 → 4)
**Quick Wins:**
1. Add 10 integration tests for API endpoints (4 hours)
2. Increase coverage target from 28% to 35% (3 hours)

### Priority 3: Linting (Score 4 → 5)
**Quick Wins:**
1. Add Husky pre-commit hooks (1 hour)

## 2-Week Action Plan

### Week 1 (10 hours)
- [ ] Expand README - 2h - Due: Nov 19
- [ ] Create 3 ADRs - 3h - Due: Nov 21
- [ ] Add inline comments - 2h - Due: Nov 22
- [ ] Add Husky hooks - 1h - Due: Nov 22
- [ ] Integration tests (5 tests) - 2h - Due: Nov 23

### Week 2 (5 hours)
- [ ] Integration tests (5 more) - 2h - Due: Nov 26
- [ ] Increase test coverage - 3h - Due: Nov 27

**Total investment**: 15 hours over 2 weeks
**Expected outcome**: 13 → 16 points (Adequate → Good)
**Decision**: Proceed to Chapter 2 while executing this plan
```

## Troubleshooting

### ⚠️ Can't Determine Test Coverage

**Symptom:** No coverage tools installed, unsure how to check

**Solution:** Install language-specific coverage tool:

```bash
# JavaScript/TypeScript
npm install --save-dev jest
# Add to package.json: "test": "jest --coverage"

# Python
pip install pytest pytest-cov
# Run: pytest --cov=src

# Ruby
# Add to Gemfile: gem 'simplecov'
# Run: COVERAGE=true bundle exec rspec

# Go
# Built-in: go test -cover ./...
```

**Workaround if tools won't install:** Estimate coverage manually:

1. Count total functions in codebase
2. Count functions with tests
3. Calculate percentage: (tested / total) × 100

### ⚠️ Score is Discouraging (Low Score)

**Symptom:** Total score 1-5, feeling overwhelmed

**Mindset Shift:** This is GOOD NEWS. You discovered problems BEFORE adopting AI (not after).

**Action Steps:**

1. Don't panic - this is fixable
2. Focus on ONE pillar first (choose easiest: usually linting)
3. Get ONE quick win (install linter, see immediate benefit)
4. Build momentum with small improvements
5. Re-assess monthly to track progress

**Remember:** Even a score of 8-10 makes AI adoption worthwhile. You don't need 20/20.

### ⚠️ Uncertain Which Score to Assign

**Symptom:** Codebase between two score levels (e.g., Testing is between 2 and 3)

**Solution:** When uncertain, score DOWN (conservative). Example:

* "We have some tests but I'm not sure what coverage is" → Score 2 (not 3)
* "We have linting but it's not enforced everywhere" → Score 3 (not 4)

**Why:** Better to underestimate readiness and be pleasantly surprised than overestimate and hit obstacles.

### ⚠️ Team Disagrees on Scores

**Symptom:** Multiple people assess same codebase, get different scores

**Solution:** Use EVIDENCE-BASED scoring:

* Don't debate opinions ("I think our tests are good")
* Look at objective metrics (coverage percentage, violation counts)
* Use the documented criteria in the [Assessment Framework](04-assessment-framework.md) as tiebreaker

**Process:**

1. Each person scores independently
2. Compare scores
3. For disagreements, review evidence together
4. Use lowest score if still uncertain (conservative approach)

### ⚠️ Don't Know Where to Start Improvements

**Symptom:** Completed assessment, have low scores, unsure which pillar to tackle first

**Decision Framework:**

**Start with LINTING if:**

* You have no automated code quality checks
* Team debates style in PRs frequently
* Codebase style is inconsistent

**Start with TESTING if:**

* You have <10% test coverage
* Bugs frequently reach production
* You're scared to refactor anything

**Start with DOCUMENTATION if:**

* New developers struggle to onboard
* Architecture knowledge in people's heads only
* You find yourself explaining same things repeatedly

**Start with SOURCE CONTROL if:**

* Commit messages are useless ("fix", "update")
* No code review process exists
* Direct commits to main branch

**If still uncertain:** Start with linting (quickest wins, visible impact immediately)

---

**Previous:** [Assessment Framework: Evaluate Your Codebase](04-assessment-framework.md) | **Next:** [Chapter Summary](06-summary.md)

---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
