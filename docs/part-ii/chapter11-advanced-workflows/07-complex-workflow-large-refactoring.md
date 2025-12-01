---
title: Complex Workflow - Large Refactoring
description: Apply the 1→3→All pattern for large-scale refactoring projects while maintaining stability and reducing risk
author: HVE Core Team
ms.date: 2025-11-19
ms.topic: how-to
keywords:
  - large refactoring
  - 1→3→All pattern
  - progressive implementation
  - repository pattern
  - risk mitigation
estimated_reading_time: 8
---

Large refactoring projects present unique challenges. You might need to change 50 or more files while maintaining working functionality throughout. Breaking changes across many interconnected files creates risk and makes debugging difficult. These projects often require 12-20 hours or more depending on complexity and codebase familiarity.

The 1→3→All pattern addresses these challenges through progressive implementation. Start with one file to validate your approach. Expand to three files with varying complexity to refine the pattern. Then apply the proven approach to all remaining files with confidence.

This section demonstrates systematic large refactoring using the 1→3→All pattern.

## The Large Refactoring Challenge

Consider refactoring a legacy codebase that affects 50 or more files. These files have multiple interconnections and existing functionality you must preserve. Changes in one file ripple through others.

**Without a structured approach:** You make changes across many files simultaneously. You lose track of what changed and where. Functionality breaks in unexpected ways. Debugging becomes difficult because you changed too much at once. You risk giving up and reverting everything.

**With 1→3→All and RPI:** You validate your approach on a small scale first. You progressively roll out changes with confidence. You maintain working code at each step. You have clear rollback points if issues arise.

## Complete Example: Repository Pattern Refactoring

This example refactors direct database calls to the repository pattern across 50 files.

### The Refactoring Challenge

**Current state:** Fifty files contain direct MongoDB queries. Controllers have embedded database logic. Testing is difficult due to tight coupling between controllers and the database layer.

**Target state:** Repository classes abstract all database access. Controllers depend on repositories through dependency injection. Tests easily mock repositories. Clean separation of concerns emerges.

### Phase 1: Research with Task Researcher

Start by researching the repository pattern and migration strategies.

**Task Researcher prompt:**

```markdown
Research repository pattern implementation for Node.js/Express with MongoDB.

Current codebase has direct database calls in controllers across 50 files.

Research:

1. Repository pattern best practices and implementation
2. Progressive migration strategy for existing codebases
3. Testing approach during migration period
4. Handling existing code during transition
5. Common pitfalls and how to avoid them

Provide practical implementation guidance for large-scale migration.
```

**Research output:** Task Researcher produces a comprehensive guide covering repository pattern fundamentals, migration strategies, and testing approaches. Save this as `20251119-repository-pattern-research.md` for reference during implementation.

### Phase 2: Plan with 1→3→All Strategy

Create a three-cycle plan using the 1→3→All pattern.

**Task Planner prompt:**

```markdown
Create 1→3→All refactoring plan for repository pattern migration.

Reference research document: 20251119-repository-pattern-research.md

Current state: 50 files with direct database calls
Target state: Repository pattern with clean separation

Plan three progressive cycles:

1. Cycle 1: Refactor 1 simplest controller to validate approach
2. Cycle 2: Refactor 3 controllers (simple, medium, complex) to refine pattern
3. Cycle 3: Apply proven pattern to remaining 46 controllers

For each cycle specify implementation steps, testing approach, and rollback plan.
```

**Planning output:** Task Planner produces a detailed three-cycle plan. Each cycle has specific files to refactor, implementation steps, validation criteria, and rollback procedures.

### Cycle 1: Validate Approach with One Controller

Start with the simplest controller to validate the basic approach.

**Target:** `UserController.js` (simple CRUD operations only)

**Implementation with Edit Mode:**

```markdown
Edit Mode prompt: "Implement Cycle 1 of repository refactoring.

Reference documents:
- Plan: 20251119-repository-refactoring-plan.md
- Research: 20251119-repository-pattern-research.md

Refactor UserController.js:
1. Create UserRepository with CRUD methods
2. Refactor controller to use repository
3. Update tests to mock repository

Show me each step for review before proceeding.
```

#### Step 1: Create Repository

**AI proposes UserRepository:**

```javascript
// repositories/UserRepository.js
const User = require('../models/User');

class UserRepository {
  async findById(id) {
    return await User.findById(id);
  }
  
  async findAll() {
    return await User.find();
  }
  
  async create(userData) {
    const user = new User(userData);
    return await user.save();
  }
  
  async update(id, userData) {
    return await User.findByIdAndUpdate(id, userData, { new: true });
  }
  
  async delete(id) {
    return await User.findByIdAndDelete(id);
  }
}

module.exports = new UserRepository();
```

Review the repository implementation. It encapsulates all database operations cleanly. Apply the code.

#### Step 2: Refactor Controller

**Before refactoring (direct database calls):**

```javascript
// controllers/UserController.js
const User = require('../models/User');

exports.getUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
```

**AI proposes refactored controller:**

```javascript
// controllers/UserController.js
const userRepository = require('../repositories/UserRepository');

exports.getUser = async (req, res) => {
  try {
    const user = await userRepository.findById(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getUsers = async (req, res) => {
  try {
    const users = await userRepository.findAll();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.createUser = async (req, res) => {
  try {
    const user = await userRepository.create(req.body);
    res.status(201).json(user);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
```

Review the refactored controller. Database access now goes through the repository. Controller logic focuses on HTTP request handling. Apply the changes.

#### Step 3: Update Tests

**AI proposes updated tests:**

```javascript
// tests/controllers/UserController.test.js
const userRepository = require('../../repositories/UserRepository');
const userController = require('../../controllers/UserController');

jest.mock('../../repositories/UserRepository');

describe('UserController', () => {
  describe('getUser', () => {
    it('should return user by id', async () => {
      const mockUser = { _id: '123', username: 'testuser' };
      userRepository.findById.mockResolvedValue(mockUser);
      
      const req = { params: { id: '123' } };
      const res = { json: jest.fn() };
      
      await userController.getUser(req, res);
      
      expect(userRepository.findById).toHaveBeenCalledWith('123');
      expect(res.json).toHaveBeenCalledWith(mockUser);
    });
  });
});
```

Review the test updates. Mocking the repository makes tests faster and more focused. Apply the test changes.

#### Validate Cycle 1

Run the complete test suite and perform manual validation.

**Test results:**

* Unit tests: PASS
* Integration tests: PASS  
* Manual testing: All user operations work correctly

**Learnings from Cycle 1:**

* Repository pattern is straightforward for simple CRUD operations
* Testing becomes easier with mocked repositories
* Controller code is cleaner and more focused
* Approach is validated and ready to expand

### Cycle 2: Expand to Three Controllers

Refactor three controllers with varying complexity to refine the pattern.

**Targets:**

1. **ProductController:** Simple CRUD similar to UserController
2. **OrderController:** Medium complexity with relationships to User and Product
3. **ReportController:** Complex aggregations and joins

**Implementation with Edit Mode:**

```markdown
Edit Mode prompt: "Implement Cycle 2: Refactor 3 controllers using validated pattern.

Controllers:
1. ProductController (simple CRUD)
2. OrderController (has relations to User and Product)
3. ReportController (complex queries and aggregations)

For each controller, create repository and refactor controller.
Show me each for review.
```

#### ProductController Refactoring

ProductController follows the same pattern as UserController. The refactoring is straightforward and takes about 30 minutes.

#### OrderController Refactoring

OrderController presents a new challenge with its relationships.

**AI discovers enhanced pattern for relationships:**

```javascript
// repositories/OrderRepository.js
const Order = require('../models/Order');

class OrderRepository {
  async findById(id) {
    return await Order.findById(id)
      .populate('userId')
      .populate('items.productId');
  }
  
  async findByUser(userId) {
    return await Order.find({ userId })
      .populate('items.productId');
  }
  
  async create(orderData) {
    const order = new Order(orderData);
    return await order.save();
  }
  
  async updateStatus(id, status) {
    return await Order.findByIdAndUpdate(
      id, 
      { status }, 
      { new: true }
    ).populate('userId').populate('items.productId');
  }
}

module.exports = new OrderRepository();
```

**Learning:** Repositories should handle populate operations for relationships. Controllers remain unaware of relationship loading details.

#### ReportController Refactoring

ReportController uses complex aggregations.

**AI proposes pattern for complex queries:**

```javascript
// repositories/ReportRepository.js
const Order = require('../models/Order');

class ReportRepository {
  async getSalesReport(startDate, endDate) {
    return await Order.aggregate([
      {
        $match: {
          createdAt: { $gte: startDate, $lte: endDate },
          status: 'completed'
        }
      },
      {
        $group: {
          _id: '$userId',
          totalSales: { $sum: '$total' },
          orderCount: { $sum: 1 }
        }
      },
      {
        $lookup: {
          from: 'users',
          localField: '_id',
          foreignField: '_id',
          as: 'user'
        }
      }
    ]);
  }
}

module.exports = new ReportRepository();
```

**Learning:** Complex aggregation queries belong in repository methods. Controllers remain thin by delegating complexity to repositories.

#### Validate Cycle 2

Run comprehensive tests after all three controllers are refactored.

**Test results:**

* All unit tests: PASS
* Integration tests: PASS
* Manual testing: All features work correctly

**Patterns discovered and documented:**

1. Basic CRUD operations follow simple repository pattern
2. Repositories handle populate operations for relationships
3. Complex aggregations belong in repository methods
4. Controllers stay thin by calling repositories and handling responses
5. Tests mock repositories regardless of complexity

### Cycle 3: Rollout to Remaining 46 Controllers

With the pattern validated and refined, apply it to all remaining controllers.

**Strategy with Agent Mode:**

The pattern is well-documented and proven. Agent Mode provides speed for repetitive application.

```markdown
Agent Mode prompt: "Apply repository pattern to remaining 46 controllers.

Reference documentation:
- Pattern guide: 20251119-repository-pattern-guide.md
- Example implementations: UserRepository, OrderRepository, ReportRepository

For each controller:
1. Create repository following documented patterns
2. Refactor controller to use repository
3. Update tests to mock repository

Controllers: [list of 46 remaining controllers]

Apply documented patterns for edge cases:
- Relationships: use populate in repository methods
- Complex queries: implement aggregations in repository methods
- Simple CRUD: follow UserRepository pattern

Execute autonomously with progressive testing.
```

**Agent Mode execution:**

Agent Mode creates 46 repositories, refactors 46 controllers, and updates all tests. It follows the established patterns consistently and completes the work in approximately 3 hours.

**Progressive testing during Cycle 3:**

Test after every 10 controllers to catch issues early:

* Checkpoint 1 (10 controllers): Tests pass
* Checkpoint 2 (20 controllers): Tests pass
* Checkpoint 3 (30 controllers): Tests pass
* Checkpoint 4 (40 controllers): Tests pass
* Final (46 controllers): All tests pass

#### Final Validation

Run complete test suite and validation after all controllers are refactored.

**Validation results:**

* Unit tests: 100% pass
* Integration tests: 100% pass
* End-to-end tests: All scenarios work correctly
* Code review: Pattern applied consistently across all files

## 1→3→All Results

The progressive approach delivers substantial benefits in time, risk, and quality.

**Time investment breakdown** (for developers familiar with the technology stack):

* Cycle 1 (1 controller): 30 minutes
* Cycle 2 (3 controllers): 90 minutes  
* Cycle 3 (46 controllers): 3 hours
* **Total time: 5 hours**

> [!NOTE]
> These estimates assume familiarity with the codebase and technology stack. Your experience may vary based on project complexity, existing test coverage, and AI tool proficiency. The key benefit is the *relative* time savings compared to traditional approaches—often 50-70% reduction regardless of absolute times.

**Traditional approach risk:** Attempting to refactor all 50 files directly creates high risk of mistakes. Debugging becomes difficult when too much changes at once. False starts and rework are likely. Similar refactoring projects without progressive approaches typically require significantly more time plus extensive debugging.

**Benefits beyond time:**

**Risk mitigation:** Early validation in Cycle 1 confirms the approach works. Pattern refinement in Cycle 2 handles complexity variations. Confident rollout in Cycle 3 applies proven patterns. Clear rollback points exist at each cycle boundary.

**Quality improvements:** Consistent pattern application across all files. Comprehensive test coverage maintained throughout. Clean separation of concerns achieved. Maintainable codebase emerges systematically.

**Knowledge capture:** Pattern documentation improves during Cycles 1 and 2. Future similar refactorings can skip validation cycles. Team members learn the pattern through progressive examples.

---

**Previous:** [Complex Workflow: TDD with AI](./06-complex-workflow-tdd-with-ai.md) | **Next:** [Systematic Task Breakdown](./08-systematic-task-breakdown.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
