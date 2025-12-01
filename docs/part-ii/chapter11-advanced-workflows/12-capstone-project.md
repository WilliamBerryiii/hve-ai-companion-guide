---
title: Capstone Project - Complex Feature Implementation
description: Apply all Chapter 11 patterns in a comprehensive multi-tenant notification system requiring research, planning, TDD implementation, and advanced workflow integration
author: HVE Core Team
ms.date: 2025-11-19
ms.topic: tutorial
keywords:
  - capstone project
  - multi-tenant system
  - real-time notifications
  - comprehensive workflow
  - pattern integration
estimated_reading_time: 12
---

This capstone project brings together every pattern and technique from Chapter 11. You'll implement a multi-tenant notification system that requires strategic mode selection, iterative expansion, TDD discipline, and advanced workflow coordination.

## Project Overview

**Feature:** Multi-tenant notification system with real-time delivery, email fallback, and admin dashboard

**Complexity factors:**

* Multiple components (WebSocket server, email service, dashboard UI, API endpoints)
* Real-time and batch processing patterns
* Multi-tenancy requiring strict tenant isolation
* Five or more modes required across workflow phases
* Advanced patterns needed (D-RPI start, 1→3→All expansion, Edit+RPI for TDD)

**Estimated time:** 4-6 hours for experienced developers familiar with the technology stack

> [!NOTE]
> Time estimates assume proficiency with the full technology stack (Node.js, Express, MongoDB, Socket.IO, React) and prior experience with the RPI variations covered in earlier sections. First-time practitioners should expect 8-12 hours or consider completing individual techniques before attempting this capstone. The goal is demonstrating workflow integration—not racing a clock.

**Goal:** Demonstrate mastery of advanced workflows and RPI variations in production-quality implementation

## Functional Requirements

### 1. Real-Time Notifications

Implement WebSocket-based real-time notification delivery:

* WebSocket connection per tenant using Socket.IO rooms
* Push notifications to all connected clients within tenant
* Notification types: info, success, warning, error
* Persist all notifications in MongoDB for history
* Broadcast to multiple recipients within same tenant

### 2. Email Fallback

Provide email delivery when real-time delivery unavailable:

* Detect when recipient not connected to WebSocket
* Send email notification automatically as fallback
* Configurable per notification type (some might be real-time only)
* Email templates for each notification type
* Retry logic for email delivery failures

### 3. Admin Dashboard

Create React-based admin interface for notification management:

* View all notifications filtered by tenant
* Send test notifications to specific users or all users
* View delivery statistics (sent, delivered, failed, pending)
* Display notification history with search and filters
* Real-time updates as notifications are sent/delivered

### 4. Multi-Tenancy

Ensure complete tenant isolation throughout system:

* Tenant-specific WebSocket rooms (Tenant A never receives Tenant B notifications)
* Tenant-specific notification settings and templates
* Database queries scoped to tenant ID from JWT token
* Admin dashboard filtered to authenticated user's tenant

## Technical Requirements

**Technology Stack:**

* Backend: Node.js with Express framework
* Real-time: Socket.IO for WebSocket connections
* Database: MongoDB for notification persistence
* Email: SendGrid or similar service
* Frontend: React with TypeScript
* Testing: Jest for unit tests, integration test suite

**Quality Standards:**

* Test coverage minimum 80%
* All API endpoints documented
* Architecture decisions recorded in ADR
* README with setup and usage instructions
* No tenant isolation leaks (validated by integration tests)

## Suggested Workflow

### Phase 1: Discovery and Research (60 minutes)

#### Step 1: Discovery (Ask Mode - 20 minutes)

Before researching external solutions, understand your current codebase:

```text
Ask Mode queries:
1. "Does this codebase have real-time features? What libraries are used?"
2. "How is multi-tenancy currently handled in this application?"
3. "What email service is configured? Show me usage examples."
4. "Show me authentication and authorization patterns used here."
5. "What testing patterns are used for async or real-time features?"

Document findings:
- Real-time features: [Yes/No, libraries if present]
- Multi-tenancy approach: [JWT field, middleware, database patterns]
- Email service: [Service name, configuration location]
- Auth patterns: [JWT middleware, token structure]
- Testing examples: [Async test patterns found]
```

This discovery phase prevents researching solutions that don't fit your existing architecture.

#### Step 2: Research (Task Researcher - 40 minutes)

Use Task Researcher with context from discovery:

```text
Task Researcher prompt: "Research multi-tenant real-time notification system 
implementation. I discovered these codebase patterns: [summarize findings from Ask Mode].

Research areas:
1. Socket.IO multi-tenancy patterns (room-based isolation)
2. WebSocket authentication using JWT tokens
3. Notification persistence and delivery tracking strategies
4. Email fallback implementation patterns
5. Testing approaches for real-time features
6. Admin dashboard patterns for notification management
7. Performance considerations for multi-tenant Socket.IO at scale

For each area, provide examples and recommendations that fit discovered patterns."

Expected output: Comprehensive research document with architecture recommendations
```

#### Step 3: Architecture Decisions (ADR Creator - Optional, 20 minutes)

If you want to document key decisions:

```text
ADR Creator prompt: "Create ADR for notification system architecture. 
Reference research document at [path].

Document architectural decisions for:
1. Real-time technology choice (Socket.IO vs alternatives)
2. Tenant isolation implementation approach
3. Email service integration strategy
4. Notification persistence schema design
5. Dashboard architecture and state management

Context: Multi-tenant SaaS application, Node.js/Express backend, React frontend, 
MongoDB database."

Output: ADR documenting rationale for key architectural choices
```

### Phase 2: Planning with 1→3→All (30 minutes)

#### Create Implementation Plan (Task Planner)

Plan three cycles using 1→3→All pattern:

```text
Task Planner prompt: "Create implementation plan for multi-tenant notification 
system using 1→3→All pattern. Reference:
- Research document: [path to research]
- ADR (if created): [path to ADR]

Requirements: [paste functional and technical requirements from above]

Plan structure:
- Cycle 1: Validate core approach (basic notification send/receive)
- Cycle 2: Expand features (email fallback, types, admin APIs)
- Cycle 3: Polish and UI (admin dashboard, statistics, documentation)

For each cycle specify:
1. Scope (what will be built)
2. Implementation approach (Edit Mode with TDD for Cycles 1-2, Agent Mode for Cycle 3)
3. Success criteria (tests and manual validation)
4. Expected learnings

Include:
- File structure (models, services, routes, components)
- Testing strategy per cycle
- Integration points and dependencies
- Potential risks and mitigation strategies"

Output: Three planning documents (plan, details, changes tracking template)
```

The 1→3→All pattern reduces risk: Cycle 1 validates your approach with minimal investment, Cycle 2 refines patterns with expanded scope, Cycle 3 rolls out remaining features with confidence.

### Phase 3: Cycle 1 - Core Validation (90 minutes)

#### Implement Basic Notification Send/Receive (Edit Mode + TDD)

Cycle 1 scope:

* Notification model schema
* Socket.IO server with tenant-based rooms
* Send notification API endpoint
* React component to receive and display notifications
* Comprehensive tests for all components

**TDD Approach:**

```text
Edit Mode: "Implement Cycle 1 using TDD approach. Reference planning documents.

Start with RED test for Notification model."

Follow Red-Green-Refactor pattern:

1. Notification model (10 minutes):
   - RED: Test for model validation
   - GREEN: Create model with fields (tenantId, userId, type, message, sentAt, deliveredAt)
   - REFACTOR: Add indexes for tenant/user queries

2. Socket.IO server setup (15 minutes):
   - RED: Test for server initialization
   - GREEN: Create Socket.IO server with Express integration
   - REFACTOR: Extract configuration

3. Tenant room management (15 minutes):
   - RED: Test that user joins correct tenant room
   - GREEN: Implement JWT-based room assignment
   - REFACTOR: Extract room naming logic

4. Send notification endpoint (20 minutes):
   - RED: Test POST /api/notifications creates notification and emits to room
   - GREEN: Implement endpoint with database save and Socket.IO emit
   - REFACTOR: Extract notification service

5. React NotificationListener component (20 minutes):
   - RED: Test component connects to Socket.IO and displays notifications
   - GREEN: Implement component with socket connection and state
   - REFACTOR: Extract socket connection hook

6. Integration test (10 minutes):
   - Test end-to-end: Send notification → Stored in DB → Delivered via WebSocket → Displayed in UI
```

**Validate Cycle 1:**

* Unit tests pass (all components tested) ✅
* Integration test passes (end-to-end flow works) ✅
* Manual testing: Send notification via API, receive in browser UI ✅

**Learning from Cycle 1:**

* Socket.IO tenant room pattern successful? ✅
* JWT authentication in Socket.IO handshake working? ✅
* Notification persistence correct? ✅
* Real-time delivery functional? ✅

If any validation fails, revise approach before Cycle 2. Success in Cycle 1 means your core architecture is sound.

### Phase 4: Cycle 2 - Feature Expansion (90 minutes)

#### Add Email Fallback and Admin Features (Edit Mode)

Cycle 2 scope:

* Email service integration with SendGrid
* Email fallback logic (check connection status, send email if disconnected)
* Notification types and corresponding email templates
* Admin API endpoints (list notifications, send test, get statistics)
* Delivery tracking (update notification status on delivery)

```text
Edit Mode: "Implement Cycle 2 per planning documents. Reference Cycle 1 learnings.

Continue TDD approach for quality assurance."

Implementation order:

1. Email service (20 minutes):
   - Create email service module with SendGrid
   - Tests for email sending with templates

2. Fallback logic (15 minutes):
   - Add connection status tracking to Socket.IO rooms
   - Implement fallback: If user not in room, send email
   - Tests for fallback trigger conditions

3. Notification templates (15 minutes):
   - Create email templates for each notification type
   - Tests for template rendering with data

4. Admin endpoints (25 minutes):
   - GET /api/admin/notifications (list filtered by tenant)
   - POST /api/admin/notifications/test (send test notification)
   - GET /api/admin/notifications/statistics (delivery metrics)
   - Tests for all endpoints with tenant isolation verification

5. Delivery tracking (15 minutes):
   - Update notification status on WebSocket delivery
   - Update status on email send success/failure
   - Tests for status updates
```

#### Potential Challenge: Merge Conflict

During Cycle 2, a team member might push conflicting changes:

```bash
git pull origin main
CONFLICT in middleware/auth.js

[Apply merge conflict resolution pattern from Section 4]

Step 1 (Task Researcher): "Analyze merge conflict in middleware/auth.js.
My changes: Added Socket.IO authentication check.
Their changes: [examine their changes].
Research how to integrate both changes preserving all functionality."

Step 2 (Task Planner): "Create conflict resolution plan for auth.js that 
preserves Socket.IO authentication and their changes."

Step 3 (Edit Mode): "Resolve conflict following resolution plan."

Result: Conflict resolved systematically in 15-20 minutes
```

**Validate Cycle 2:**

* All tests pass (existing + new tests) ✅
* Email fallback functional (test by disconnecting client) ✅
* Admin endpoints working correctly ✅
* Delivery tracking accurate ✅
* Tenant isolation maintained (test with multiple tenants) ✅

**Patterns Refined in Cycle 2:**

* Document any patterns discovered (handling disconnected users, email template structure, admin filtering patterns)
* These patterns guide Cycle 3 implementation

### Phase 5: Cycle 3 - Polish and Dashboard (60 minutes)

#### Complete Admin Dashboard UI (Agent Mode + Ask Mode)

Cycle 3 scope:

* Admin dashboard React components
* Notification history view with filters
* Test notification sender interface
* Statistics visualization with charts
* API documentation for all endpoints
* README updates with setup and usage instructions

```text
Agent Mode: "Implement Cycle 3 per planning documents. Reference Cycles 1-2 patterns.

Scope:
- Admin dashboard React components (list, filters, test sender)
- Notification history view with search
- Statistics visualization using existing charting library
- Complete API documentation
- Update README with notification system usage

Execute following established patterns from Cycles 1-2."
```

**Mode Switching During Cycle 3:**

Midway through Agent Mode work, you might need clarification:

```text
[Agent implements dashboard components]

[Need clarification about charting library]

Switch to Ask Mode: "What charting library does this project use? 
Show me examples of chart components."

Ask Mode response: "Project uses Chart.js. See package.json line 45 
and examples in components/analytics/SalesChart.tsx"

Return to Agent Mode: "Continue dashboard implementation using Chart.js 
following patterns in components/analytics/SalesChart.tsx"

[Agent completes Cycle 3]
```

**Validate Cycle 3:**

* Dashboard renders without errors ✅
* All features accessible via UI ✅
* Statistics display accurate data ✅
* Test notification sender works ✅
* Documentation complete and accurate ✅

### Phase 6: Integration Testing and Documentation (30 minutes)

#### Complete System Validation

Run comprehensive integration tests:

```text
Test scenarios:
1. Tenant A sends notification to User 1 (connected):
   - User 1 receives notification in real-time ✅
   
2. Tenant A sends notification to User 2 (disconnected):
   - User 2 receives email notification ✅
   
3. Tenant B sends notification to User 3:
   - Tenant A users do NOT receive notification (isolation verified) ✅
   
4. Admin dashboard for Tenant A:
   - Shows only Tenant A notifications ✅
   - Statistics reflect Tenant A data only ✅
   
5. Send test notification from dashboard:
   - Notification sent successfully ✅
   - Appears in notification list immediately ✅
   
6. View statistics:
   - Counts accurate (sent, delivered, failed) ✅
   - Chart visualizations render correctly ✅

All scenarios pass ✅
```

**Finalize Documentation:**

```text
If using ADR Creator: "Update ADR with implementation details and any 
architectural decisions made during development that differed from initial plan."

Edit Mode: "Create comprehensive API documentation for all notification 
endpoints with request/response examples."

Edit Mode: "Update README with notification system overview, setup instructions, 
usage examples, and configuration options."
```

## Reflection and Self-Assessment

After completing the project, perform thorough self-assessment:

### Patterns Applied

**D-RPI Pattern:**

* Used discovery phase before research? [Yes/No]
* Effectiveness: [High/Medium/Low]
* Key learning: [What did discovery reveal that shaped research?]

**1→3→All Pattern:**

* Executed three distinct cycles? [Yes/No]
* Cycle 1 validated approach successfully? [Yes/No]
* Cycle 2 refined patterns? [Yes/No]
* Cycle 3 leveraged learnings? [Yes/No]
* Overall effectiveness: [High/Medium/Low]

**Edit+RPI with TDD:**

* Maintained TDD discipline in Cycles 1-2? [Yes/No]
* Test coverage achieved: [percentage]
* Quality impact: [How did TDD affect code quality?]

**Agent+Ask Combination:**

* Used Agent Mode for appropriate tasks? [Yes/No]
* Switched to Ask Mode when needed? [Yes/No]
* Mode switching smooth and effective? [Yes/No]

**Mode Switching Strategy:**

* Total mode switches during project: [count]
* Context preservation effectiveness: [High/Medium/Low]
* Most effective mode transition: [Which transition worked best?]

### Challenges and Resolutions

Document any challenges encountered:

```markdown
**Challenge 1:** [Description]
**Resolution:** [How you resolved it]
**Time impact:** [Extra time required]
**Pattern used:** [Which Chapter 11 pattern helped]

**Challenge 2:** [Description]
**Resolution:** [How you resolved it]
**Time impact:** [Extra time required]
**Pattern used:** [Which Chapter 11 pattern helped]
```

### Skills Demonstrated

Check off skills successfully applied:

* ☐ D-RPI pattern (Discovery before Research)
* ☐ 1→3→All iterative expansion
* ☐ TDD with AI assistance
* ☐ Strategic mode switching with context preservation
* ☐ Merge conflict resolution (if encountered)
* ☐ Agent Mode for appropriate tasks
* ☐ Research → Planning → Implementation cycle
* ☐ Architecture documentation (ADR)
* ☐ Comprehensive testing strategy
* ☐ Multi-tenant isolation verification

### Confidence Assessment

Rate your confidence applying these patterns to production work:

* Research and planning: [1-10]
* TDD implementation: [1-10]
* Mode switching: [1-10]
* Complex workflow handling: [1-10]
* Production readiness: [1-10]

**Overall confidence in AI-assisted development:** [1-10]

**Ready for production-level work with these patterns:** [Yes/No/With supervision]

## Completion Criteria

Project complete when ALL criteria met:

✅ All functional requirements implemented
✅ All technical requirements met
✅ Test coverage exceeds 80%
✅ Integration tests pass all scenarios
✅ Documentation complete (API docs, README, ADR if used)
✅ Reflection completed with honest self-assessment
✅ Confident applying patterns to production work

<details>
<summary><strong>Solution Approach (Expand After Attempting)</strong></summary>

## Recommended Implementation Path

This solution approach provides guidance without prescribing exact implementation. Your approach may differ based on your specific codebase and constraints.

### Discovery Phase Key Findings (Typical)

**Codebase patterns typically found:**

* Multi-tenancy via `tenantId` field in JWT payload
* Express middleware for tenant extraction and validation
* MongoDB queries scoped by tenant using middleware-injected `req.tenantId`
* Jest test patterns using `supertest` for API testing
* React components using hooks and context for shared state

**Research focus based on discovery:**

* Socket.IO room-based isolation (matches JWT-based tenancy)
* WebSocket authentication via JWT handshake
* SendGrid integration (if already configured) or Nodemailer alternative
* Testing real-time with socket.io-client in Jest
* React hooks for WebSocket connection management

### Planning Output Structure

**Cycle 1 Validation (30-40% of features, minimal risk):**

* Notification model with tenant scoping
* Basic Socket.IO server with room assignment based on JWT
* Single endpoint: POST /api/notifications
* React component: NotificationListener
* Tests validating tenant isolation at WebSocket level

**Cycle 2 Feature Expansion (40-50% of features, medium complexity):**

* Email service integration with templates
* Connection tracking for fallback logic
* Admin endpoints (list, test send, statistics)
* Delivery status tracking
* Enhanced tests for all pathways

**Cycle 3 Polish and UI (20-30% of features, low risk):**

* Admin dashboard components (notification list, filters, test UI)
* Statistics visualization
* API documentation generation
* README and setup guides
* Final integration testing

### Implementation Tips

**Socket.IO tenant isolation:**

```javascript
// On connection, join tenant-specific room
io.on('connection', (socket) => {
  const token = socket.handshake.auth.token;
  const decoded = jwt.verify(token, process.env.JWT_SECRET);
  const tenantRoom = `tenant-${decoded.tenantId}`;
  socket.join(tenantRoom);
});

// Emit to tenant room only
io.to(`tenant-${tenantId}`).emit('notification', notification);
```

**Email fallback check:**

```javascript
// Check if any sockets in tenant room
const socketsInRoom = await io.in(`tenant-${tenantId}`).fetchSockets();
if (socketsInRoom.length === 0) {
  // No connected clients, send email
  await emailService.sendNotification(notification);
}
```

**TDD Example for Notification Model:**

```javascript
// RED test
describe('Notification Model', () => {
  it('should require tenantId', async () => {
    const notification = new Notification({ message: 'Test' });
    await expect(notification.save()).rejects.toThrow();
  });
});

// GREEN implementation
const notificationSchema = new Schema({
  tenantId: { type: String, required: true, index: true },
  userId: { type: String, required: true },
  type: { type: String, enum: ['info', 'success', 'warning', 'error'] },
  message: { type: String, required: true },
  sentAt: { type: Date, default: Date.now },
  deliveredAt: { type: Date }
});

// REFACTOR
notificationSchema.index({ tenantId: 1, sentAt: -1 });
```

### Expected Time Distribution

* Phase 1 (Discovery + Research): 60 minutes
* Phase 2 (Planning): 30 minutes
* Phase 3 (Cycle 1): 90 minutes
* Phase 4 (Cycle 2): 90 minutes
* Phase 5 (Cycle 3): 60 minutes
* Phase 6 (Integration): 30 minutes

**Total: 6 hours** (within 4-6 hour estimate)

Actual time may vary based on codebase familiarity and complexity encountered.

</details>

---

**Previous:** [Measuring Workflow Effectiveness](./11-measuring-effectiveness.md) | **Next:** [Chapter Summary](./13-summary.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
